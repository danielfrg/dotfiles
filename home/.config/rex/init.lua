-- Project actions appear in Rex's native command palette.
local home = os.getenv("HOME")
require("projects").register(home)
local sessions = require("sessions")
local cache_dir = (os.getenv("XDG_CACHE_HOME") or home .. "/.cache") .. "/rex"
sessions.register(cache_dir)

rex.action{
  name = "session_palette",
  title = "Open Command Palette (Refresh Sessions)",
  description = "Refresh project and session commands, then open the native palette.",
  run = function(ctx, args)
    if not ctx.client_id then error("Opening the palette needs a connected Rex client.", 0) end
    sessions.refresh(cache_dir)
  end,
}

rex.action{
  name = "project_picker",
  title = "Open Project Picker (fzf fallback)",
  description = "Create or resume a project session using fzf.",
  run = function(ctx, args)
    if not ctx.client_id then error("The project picker needs a connected Rex client.", 0) end
    local layer, err = rex.session.new_layer{
      bounds = { x = 0.15, y = 0.15, w = 0.7, h = 0.7 },
      focus = true,
      layout = rex.layout.block{
        flavor = "com.superlogical.terminal.shell",
        options = {
          cwd = home,
          shell = "none",
          command = {
            "/usr/bin/env", "REX_CLIENT=" .. ctx.client_id,
            "/bin/zsh", "-l", home .. "/.local/scripts/project-session-rex.sh", "--layer",
          },
        },
      },
    }
    if err then error(err, 0) end
    return layer
  end,
}

rex.bind("cmd+k", "session_palette")
rex.bind("ctrl+f", "session_palette")
