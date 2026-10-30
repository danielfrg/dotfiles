local M = {}
local navigation = require("navigation")

function M.discover(home)
  local projects, seen = {}, {}
  local roots = {
    home .. "/code",
    home .. "/code/danielfrg",
    home .. "/code/inmatura",
    home .. "/code/nvidia",
  }
  local containers = {}
  for i = 2, #roots do containers[roots[i]] = true end

  local function scan(root, depth)
    local directory, err = rex.exec{ "/bin/test", "-d", root }
    if not directory then error(err, 0) end
    if not directory.ok then
      if directory.code == 1 then return end -- An optional project root is absent.
      error(directory.stderr, 0)
    end
    local result
    result, err = rex.exec{
      "/usr/bin/find", root, "-mindepth", tostring(depth),
      "-maxdepth", tostring(depth), "-type", "d", "-print0",
    }
    if not result then error(err, 0) end
    if not result.ok then error(result.stderr, 0) end
    for path in result.stdout:gmatch("([^%z]+)%z") do
      local basename = path:match("([^/]+)$")
      if not seen[path] and not containers[path]
        and (depth == 0 or basename:sub(1, 1) ~= ".") then
        local label = path == home .. "/.dotfiles" and "dotfiles"
          or path:sub(#home + #"/code/" + 1)
        projects[#projects + 1] = { path = path, label = label }
        seen[path] = true
      end
    end
  end

  scan(home .. "/.dotfiles", 0)
  for _, root in ipairs(roots) do scan(root, 1) end
  table.sort(projects, function(a, b) return a.label < b.label end)
  return projects
end

local function discover_remote(ctx)
  if not ctx.session_id then error("Open the project picker from a remote session.", 0) end
  local result, err = rex.session.list_blocks{}
  if not result then error(err, 0) end
  local block_id
  for _, block in ipairs(result.blocks or {}) do
    if block.creator_name == "com.superlogical.terminal" then
      block_id = block_id or block.block_id
      if block.block_id == ctx.block_id then block_id = block.block_id; break end
    end
  end
  if not block_id then error("The remote project picker needs a terminal in this session.", 0) end

  local function list(path, optional)
    local listing, list_err = rex.block.call("com.superlogical.terminal", "list_dir", {
      block_id = block_id, path = path,
    })
    if not listing then error(list_err, 0) end
    if listing.status == "missing" and optional then return nil end
    if listing.status ~= "ok" then
      error("Cannot list remote directory '" .. path .. "': " .. tostring(listing.status), 0)
    end
    if listing.truncated then error("Remote directory listing is too large: " .. path, 0) end
    return listing
  end

  local base = list("~")
  local home = base.home or base.path
  local projects, seen = {}, {}
  local roots = { home .. "/code", home .. "/code/danielfrg", home .. "/code/inmatura", home .. "/code/nvidia" }
  local containers = {}
  for i = 2, #roots do containers[roots[i]] = true end
  local function add(path, label)
    if not seen[path] then
      projects[#projects + 1] = { path = path, label = label }
      seen[path] = true
    end
  end
  for _, entry in ipairs(base.entries or {}) do
    if entry.name == ".dotfiles" then add(home .. "/.dotfiles", "dotfiles") end
  end
  for _, root in ipairs(roots) do
    local listing = list(root, true)
    for _, entry in ipairs(listing and listing.entries or {}) do
      local path = root .. "/" .. entry.name
      if entry.name:sub(1, 1) ~= "." and not containers[path] then
        add(path, path:sub(#home + #"/code/" + 1))
      end
    end
  end
  table.sort(projects, function(a, b) return a.label < b.label end)
  return projects
end

function M.refresh(home, cache_dir, ctx)
  local server = ctx.server or ""
  local projects = server ~= "" and discover_remote(ctx) or M.discover(home)
  local directory, err = rex.exec{ "/bin/mkdir", "-p", cache_dir }
  if not directory then error(err, 0) end
  if not directory.ok then error(directory.stderr, 0) end
  local path = cache_dir .. "/project-actions.lua"
  local file, open_err = io.open(path .. ".tmp", "w")
  if not file then error(open_err, 0) end
  file:write(string.format("return { server = %q, projects = {\n", server))
  for _, project in ipairs(projects) do
    file:write(string.format("  { path = %q, label = %q },\n", project.path, project.label))
  end
  file:write("} }\n")
  local closed, close_err = file:close()
  if not closed then error(close_err, 0) end
  local renamed, rename_err = os.rename(path .. ".tmp", path)
  if not renamed then error(rename_err, 0) end
end

function M.open(project, ctx)
  local select_session = navigation.for_context(ctx)
  local result, err = rex.call("session.list")
  if not result then error(err, 0) end
  local session_id
  for _, session in ipairs(result.sessions or {}) do
    if (session.label or ""):lower() == project.label:lower() then
      if session_id then
        error("Multiple Rex sessions named '" .. project.label .. "'; rename one before retrying.", 0)
      end
      session_id = session.session_id
    end
  end
  if not session_id then
    result, err = rex.call("session.create", {
      label = project.label,
      initial_windows = {{
        window_label = "shell",
        layout = rex.layout.block{
          flavor = "com.superlogical.terminal.shell",
          options = { cwd = project.path },
        },
      }},
    })
    if not result then error(err, 0) end
    session_id = result.session_id
  end
  select_session(session_id)
  return { session_id = session_id }
end

function M.register(home, cache_dir)
  local load = loadfile(cache_dir .. "/project-actions.lua")
  local snapshot = load and load() or { server = "", projects = M.discover(home) }
  for _, project in ipairs(snapshot.projects) do
    -- Encode the full label for a stable, unique Lua action name.
    local name = "project_" .. project.label:gsub(".", function(char)
      return string.format("%02x", char:byte())
    end)
    rex.action{
      name = name,
      title = "Open Project: " .. project.label,
      category = "Projects",
      description = "Create or resume a session in " .. project.path,
      keywords = project.label .. " " .. project.path,
      run = function(ctx, args)
        if not ctx.client_id then error("Opening a project needs a connected Rex client.", 0) end
        if (ctx.server or "") ~= snapshot.server then
          error("This project list belongs to another host. Reopen Ctrl+F to refresh projects.", 0)
        end
        return M.open(project, ctx)
      end,
    }
  end
end

return M
