local M = {}

local function action_name(id)
  return "session_" .. id:gsub(".", function(char)
    return string.format("%02x", char:byte())
  end)
end

local function list_sessions()
  local result, err = rex.call("session.list")
  if not result then error(err, 0) end
  return result.sessions or {}
end

function M.register(cache_dir)
  -- Actions must be declared at config load, when Rex API calls are unavailable.
  -- The palette-opening action saves a snapshot before reloading this config.
  local load = loadfile(cache_dir .. "/session-actions.lua")
  if not load then return end
  local sessions = load()
  local counts = {}
  for _, session in ipairs(sessions) do
    counts[session.label] = (counts[session.label] or 0) + 1
  end
  for _, session in ipairs(sessions) do
    local title = session.label ~= "" and session.label or "Unnamed session"
    if counts[session.label] > 1 or session.label == "" then
      title = title .. " (" .. session.session_id:sub(-8) .. ")"
    end
    rex.action{
      name = action_name(session.session_id),
      title = "Switch to Session: " .. title,
      category = "Sessions",
      keywords = session.label .. " " .. session.session_id,
      description = "Switch to the existing session " .. session.session_id,
      run = function(ctx, args)
        if not ctx.client_id then error("Switching sessions needs a connected Rex client.", 0) end
        for _, current in ipairs(list_sessions()) do
          if current.session_id == session.session_id then
            rex.client.queue("session.select", { session_id = session.session_id })
            return { session_id = session.session_id }
          end
        end
        error("This session no longer exists. Reopen the palette to refresh sessions.", 0)
      end,
    }
  end
end

function M.refresh(cache_dir)
  local sessions = list_sessions()
  table.sort(sessions, function(a, b)
    if a.label == b.label then return a.session_id < b.session_id end
    return a.label < b.label
  end)
  local directory, mkdir_err = rex.exec{ "/bin/mkdir", "-p", cache_dir }
  if not directory then error(mkdir_err, 0) end
  if not directory.ok then error(directory.stderr, 0) end
  local cache_path = cache_dir .. "/session-actions.lua"
  local file, err = io.open(cache_path .. ".tmp", "w")
  if not file then error(err, 0) end
  file:write("return {\n")
  for _, session in ipairs(sessions) do
    file:write(string.format("  { session_id = %q, label = %q },\n",
      session.session_id, session.label or ""))
  end
  file:write("}\n")
  local written, write_err = file:close()
  if not written then error(write_err, 0) end
  local renamed, rename_err = os.rename(cache_path .. ".tmp", cache_path)
  if not renamed then error(rename_err, 0) end
  -- Rex forbids a config callback from reloading itself. Ask the app to reload
  -- after this action returns, then open the palette in the same queue.
  rex.client.queue("client.config.reload")
  rex.client.queue("client.palette.toggle")
end

return M
