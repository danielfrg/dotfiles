local M = {}

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

function M.open(project)
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
  rex.client.queue("session.select", { session_id = session_id })
  return { session_id = session_id }
end

function M.register(home)
  for _, project in ipairs(M.discover(home)) do
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
        return M.open(project)
      end,
    }
  end
end

return M
