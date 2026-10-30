local M = {}

-- Queued client actions use the configuration server's connection. When an
-- action is running for another host, switch through that host's app connection.
function M.for_context(ctx)
  ctx = ctx or {}
  if not ctx.server or ctx.server == "" then
    return function(session_id)
      rex.client.queue("session.select", { session_id = session_id })
    end
  end

  if not ctx.session_id then error("Remote session switching needs an active session.", 0) end
  local result, err = rex.call("client.list", { kinds = { "app" }, session_id = ctx.session_id })
  if not result then error(err, 0) end
  local clients, known = result.clients or {}, {}
  for _, client in ipairs(clients) do known[client.client_id] = true end
  local client_id = known[ctx.client_id] and ctx.client_id or nil
  if not client_id and #clients == 1 then client_id = clients[1].client_id end
  if not client_id and ctx.block_id then
    result, err = rex.session.list_blocks{}
    if not result then error(err, 0) end
    for _, block in ipairs(result.blocks or {}) do
      if block.block_id == ctx.block_id and known[block.owner] then
        client_id = block.owner
        break
      end
    end
  end
  if not client_id then error("Cannot identify the remote Rex window for this session.", 0) end

  return function(session_id)
    local performed, perform_err = rex.call("client.perform", {
      client_id = client_id,
      action = "session.select",
      args = { session_id = session_id },
      session_id = ctx.session_id,
      block_id = ctx.block_id,
    })
    if not performed then error(perform_err, 0) end
  end
end

return M
