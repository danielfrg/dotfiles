local M = {}
local projects = require("projects")
local sessions = require("sessions")

local function read(path)
  local file = io.open(path)
  if not file then return nil end
  local value = file:read("*a")
  file:close()
  return value
end

function M.open(home, cache_dir, ctx)
  if not ctx.client_id then error("Opening the palette needs a connected Rex client.", 0) end
  local token = os.tmpname()
  os.remove(token)
  local request = {
    token = token, server = ctx.server, session_id = ctx.session_id,
    block_id = ctx.block_id, client_id = ctx.client_id,
  }
  local marker = cache_dir .. "/palette-request"
  local file = io.open(marker .. ".tmp", "w")
  if not file then
    local result, err = rex.exec{ "/bin/mkdir", "-p", cache_dir }
    if not result or not result.ok then error(err or result.stderr, 0) end
    file = assert(io.open(marker .. ".tmp", "w"))
  end
  assert(file:write(token))
  assert(file:close())
  assert(os.rename(marker .. ".tmp", marker))
  local process, err = rex.exec.start({
    "/bin/zsh", "-f", home .. "/.local/scripts/project-session-rex.sh",
    "--refresh-palette", rex.json.encode(request),
  }, { detach = true, stdout = false, stderr = false })
  if not process then error(err, 0) end
  -- Capture keyboard focus before directory discovery or configuration reloads.
  rex.client.queue("client.palette.toggle")
end

function M.refresh(home, cache_dir, request)
  local marker = cache_dir .. "/palette-request"
  local function current() return read(marker) == request.token end
  if not current() then return false end
  local api = request.server and request.server ~= "" and rex.server(request.server) or rex
  -- Each worker writes privately until both lists are complete and still wanted.
  local staging = request.token
  local function cleanup()
    os.remove(staging .. "/project-actions.lua")
    os.remove(staging .. "/session-actions.lua")
    os.remove(staging)
  end
  local ok, result = pcall(function()
    projects.refresh(home, staging, request, api)
    sessions.refresh(staging, request, api)
    if not current() then return false end
    local changed = false
    for _, name in ipairs({ "project-actions.lua", "session-actions.lua" }) do
      if read(staging .. "/" .. name) ~= read(cache_dir .. "/" .. name) then changed = true end
    end
    if not changed then return false end
    for _, name in ipairs({ "project-actions.lua", "session-actions.lua" }) do
      assert(os.rename(staging .. "/" .. name, cache_dir .. "/" .. name))
    end
    local reloaded, err = rex.call("server.config_reload")
    if not reloaded then error(err, 0) end
    for _, diagnostic in ipairs(reloaded.diagnostics or {}) do
      if diagnostic.severity == "error" then error(diagnostic.message, 0) end
    end
    return true
  end)
  cleanup()
  if not ok then error(result, 0) end
  return result
end

return M
