-- Run from the repository root: luajit tests/rex-project-picker.lua
package.path = "home/.config/rex/?.lua;" .. package.path
local projects = require("projects")
local session_actions = require("sessions")
local root = os.tmpname()
os.remove(root)

local function quote(s) return "'" .. s:gsub("'", "'\\''") .. "'" end
local function exec(argv)
  local command = {}
  for _, value in ipairs(argv) do command[#command + 1] = quote(value) end
  local out, err = os.tmpname(), os.tmpname()
  local code = os.execute(table.concat(command, " ") .. " >" .. quote(out) .. " 2>" .. quote(err)) / 256
  local function read(path)
    local f = assert(io.open(path)); local s = f:read("*a"); f:close(); os.remove(path); return s
  end
  return { ok = code == 0, code = code, stdout = read(out), stderr = read(err) }
end
assert(exec({"mkdir", "-p", root .. "/local/.dotfiles", root .. "/local/code/danielfrg/local-only",
  root .. "/local/code/standalone", root .. "/local/code/.hidden"}).ok)
local home, cache = root .. "/local", root .. "/cache"
package.path = cache .. "/?.lua;" .. package.path
local remote = { server = "srv-nv-01", session_id = "session:remote", block_id = "block:remote", client_id = "app" }
local local_context = { client_id = "app" }
local actions, created, queued, sessions, listings, spawned, performed, remote_clients, encoded, reloads

local function directory(path, names)
  local entries = {}
  for _, name in ipairs(names) do entries[#entries + 1] = { name = name } end
  return { path = path, home = "/home/remote", status = "ok", entries = entries, truncated = false }
end
local function reset()
  package.loaded["project-actions"], package.loaded["session-actions"] = nil, nil
  actions, created, queued, sessions, spawned = {}, {}, {}, {}, {}
  performed, encoded, reloads = {}, nil, 0
  remote_clients = {{ client_id = "client:remote-app", info = { kind = "app" } }}
  listings = {
    ["~"] = directory("/home/remote", {".dotfiles", "code"}),
    ["/home/remote/code"] = directory("/home/remote/code", {"danielfrg", "nvidia", "standalone", ".hidden"}),
    ["/home/remote/code/danielfrg"] = directory("/home/remote/code/danielfrg", {"server-only", "quote'project"}),
    ["/home/remote/code/nvidia"] = directory("/home/remote/code/nvidia", {"cuda"}),
    ["/home/remote/code/inmatura"] = { path = "/home/remote/code/inmatura", home = "/home/remote", status = "missing", entries = {}, truncated = false },
  }
  _G.rex = {
    json = { encode = function(value) encoded = value; return "request-json" end },
    exec = setmetatable({ start = function(argv, options)
      spawned[#spawned + 1] = { argv = argv, options = options }
      return {}
    end }, { __call = function(_, argv) return exec(argv) end }),
    action = function(action) actions[action.title] = action end,
    bind = function() end,
    client = { queue = function(name, args) queued[#queued + 1] = { name = name, args = args } end },
    layout = { block = function(options) return options end },
    session = { list_blocks = function()
      return { blocks = {{ block_id = "block:remote", creator_name = "com.superlogical.terminal", owner = "client:remote-app" }} }
    end },
    block = { call = function(creator, method, args)
      assert(creator == "com.superlogical.terminal" and method == "list_dir")
      assert(args.block_id == "block:remote", "directory lookup must use the remote terminal")
      assert(args.session_id == "session:remote", "background directory calls need an explicit remote session")
      assert(listings[args.path], "unexpected remote path: " .. args.path)
      return listings[args.path]
    end },
    call = function(method, args)
      if method == "server.config_reload" then reloads = reloads + 1; return { diagnostics = {} } end
      if method == "session.list" then return { sessions = sessions } end
      if method == "client.list" then
        assert(args.session_id == "session:remote" and args.kinds[1] == "app")
        return { clients = remote_clients }
      end
      if method == "client.perform" then
        performed[#performed + 1] = args
        return { performed_by = args.client_id }
      end
      assert(method == "session.create")
      created[#created + 1] = args
      return { session_id = "session:new" }
    end,
  }
end

local function snapshot() return assert(loadfile(cache .. "/project-actions.lua"))() end
local function labels(list)
  local values = {}
  for _, project in ipairs(list) do values[#values + 1] = project.label end
  return table.concat(values, ",")
end
local failures = 0
local function test(name, fn)
  reset()
  local ok, err = pcall(fn)
  print((ok and "PASS " or "FAIL ") .. name .. (ok and "" or ": " .. tostring(err)))
  if not ok then failures = failures + 1 end
end

test("remote refresh discovers server paths and excludes local projects and root containers", function()
  projects.refresh(home, cache, remote)
  local data = snapshot()
  assert(data.server == "srv-nv-01")
  assert(labels(data.projects) == "danielfrg/quote'project,danielfrg/server-only,dotfiles,nvidia/cuda,standalone")
  for _, project in ipairs(data.projects) do assert(project.path:sub(1, 13) == "/home/remote/") end
end)

test("local refresh replaces the remote list with actual local directories", function()
  projects.refresh(home, cache, remote)
  projects.refresh(home, cache, local_context)
  projects.register(home, cache)
  assert(actions["Open Project: danielfrg/local-only"])
  assert(actions["Open Project: dotfiles"])
  assert(not actions["Open Project: danielfrg/server-only"])
  assert(not actions["Open Project: danielfrg"])
end)

test("remote project action creates its session in the remote project directory", function()
  projects.refresh(home, cache, remote)
  projects.register(home, cache)
  actions["Open Project: danielfrg/server-only"].run(remote, {})
  assert(#created == 1)
  assert(created[1].initial_windows[1].layout.options.cwd == "/home/remote/code/danielfrg/server-only")
  assert(#queued == 0)
  assert(performed[1].client_id == "client:remote-app")
  assert(performed[1].action == "session.select" and performed[1].args.session_id == "session:new")
end)

test("cached remote action refuses to create a session after switching hosts", function()
  projects.refresh(home, cache, remote)
  projects.register(home, cache)
  local action = actions["Open Project: danielfrg/server-only"]
  local ok = pcall(action.run, local_context, {})
  assert(not ok and #created == 0 and #queued == 0)
end)

test("quoted names survive cache serialization and open the literal directory", function()
  projects.refresh(home, cache, remote)
  projects.register(home, cache)
  actions["Open Project: danielfrg/quote'project"].run(remote, {})
  assert(created[1].initial_windows[1].layout.options.cwd == "/home/remote/code/danielfrg/quote'project")
end)

test("existing project session resumes without creating a duplicate", function()
  projects.refresh(home, cache, remote)
  projects.register(home, cache)
  sessions = {{ label = "DANIELFRG/SERVER-ONLY", session_id = "session:existing" }}
  actions["Open Project: danielfrg/server-only"].run(remote, {})
  assert(#created == 0 and performed[1].args.session_id == "session:existing")
end)

test("failed remote directory listing leaves the previous snapshot intact", function()
  projects.refresh(home, cache, local_context)
  listings["/home/remote/code/nvidia"].status = "permission_denied"
  assert(not pcall(projects.refresh, home, cache, remote))
  assert(snapshot().server == "")
end)

test("truncated remote list is rejected rather than silently hiding projects", function()
  projects.refresh(home, cache, remote)
  listings["/home/remote/code/nvidia"].truncated = true
  assert(not pcall(projects.refresh, home, cache, remote))
end)

test("remote picker finds a terminal when the focused block is another kind", function()
  local context = { server = "srv-nv-01", session_id = "session:remote", block_id = "block:image", client_id = "app" }
  projects.refresh(home, cache, context)
  assert(labels(snapshot().projects):find("danielfrg/server%-only"))
end)

test("writing the session snapshot never delays opening the palette", function()
  session_actions.refresh(cache, remote)
  assert(#queued == 0 and #spawned == 0)
end)

test("Ctrl+F opens without waiting for directory scans, remote calls, or a reload", function()
  local getenv = os.getenv
  os.getenv = function(name)
    if name == "HOME" then return home end
    if name == "XDG_CACHE_HOME" then return root end
    return getenv(name)
  end
  assert(exec({"mkdir", "-p", root .. "/rex"}).ok)
  local ok, err = pcall(function()
    dofile("home/.config/rex/init.lua")
    rex.call = function() error("the opening path must not wait for the server") end
    rex.session.list_blocks = function() error("the opening path must not scan remote directories") end
    getmetatable(rex.exec).__call = function() error("the opening path must not run synchronous shell commands") end
    actions["Open Command Palette (Refresh Sessions)"].run(remote, {})
    assert(#queued == 1 and queued[1].name == "client.palette.toggle")
    assert(#spawned == 1 and spawned[1].options.detach)
    assert(spawned[1].argv[2] == "-f" and spawned[1].argv[4] == "--refresh-palette")
    assert(encoded.server == "srv-nv-01" and encoded.session_id == "session:remote")
    assert(encoded.block_id == "block:remote" and encoded.client_id == "app")
  end)
  os.getenv = getenv
  assert(ok, err)
end)

test("background refresh routes discovery to the captured server and never toggles the palette", function()
  local palette = require("palette")
  palette.open(home, cache, remote)
  local request = encoded
  queued, spawned = {}, {}
  rex.server = function(label)
    assert(label == "srv-nv-01")
    return {
      session = { list_blocks = function(args)
        assert(args.session_id == "session:remote")
        return rex.session.list_blocks(args)
      end },
      block = rex.block,
      call = function(method)
        assert(method == "session.list", "only discovery belongs on the remote server")
        return { sessions = {{label = "server-existing", session_id = "session:existing"}} }
      end,
    }
  end
  assert(palette.refresh(home, cache, request))
  assert(snapshot().server == "srv-nv-01")
  assert(labels(snapshot().projects):find("danielfrg/server%-only"))
  assert(assert(loadfile(cache .. "/session-actions.lua"))()[1].label == "server-existing")
  assert(reloads == 1 and #queued == 0 and #spawned == 0)
  assert(not palette.refresh(home, cache, request), "unchanged lists should not reload config")
  assert(reloads == 1)
end)

test("an older refresh cannot overwrite the host chosen while it was scanning", function()
  local palette = require("palette")
  projects.refresh(home, cache, local_context)
  palette.open(home, cache, remote)
  local request = encoded
  rex.server = function()
    return {
      session = rex.session, block = rex.block,
      call = function(method)
        assert(method == "session.list")
        palette.open(home, cache, local_context)
        return { sessions = {} }
      end,
    }
  end
  assert(not palette.refresh(home, cache, request))
  assert(snapshot().server == "" and reloads == 0)
end)

test("local project selection still switches through the original app connection", function()
  projects.refresh(home, cache, local_context)
  projects.register(home, cache)
  actions["Open Project: danielfrg/local-only"].run(local_context, {})
  assert(#performed == 0 and queued[1].name == "session.select")
end)

test("remote selection chooses the focused block owner when several app windows are attached", function()
  remote_clients = {{client_id = "client:other-window"}, {client_id = "client:remote-app"}}
  projects.refresh(home, cache, remote)
  projects.register(home, cache)
  actions["Open Project: danielfrg/server-only"].run(remote, {})
  assert(performed[1].client_id == "client:remote-app")
end)

test("no remote app connection fails before creating an orphan project session", function()
  remote_clients = {}
  projects.refresh(home, cache, remote)
  projects.register(home, cache)
  assert(not pcall(actions["Open Project: danielfrg/server-only"].run, remote, {}))
  assert(#created == 0 and #queued == 0 and #performed == 0)
end)

test("existing remote session actions also switch through the remote app connection", function()
  sessions = {{label = "remote-existing", session_id = "session:existing"}}
  session_actions.refresh(cache, remote)
  session_actions.register(cache)
  queued = {}
  actions["Switch to Session: remote-existing"].run(remote, {})
  assert(#queued == 0 and performed[1].client_id == "client:remote-app")
  assert(performed[1].args.session_id == "session:existing")
end)

assert(exec({"rm", "-rf", root}).ok)
if failures > 0 then error(tostring(failures) .. " tests failed", 0) end
print("17 tests passed")
