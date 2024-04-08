local wezterm = require 'wezterm'
local config = {}

config.color_scheme = 'Catppuccin Mocha'
config.font_size = 15.0
config.font = wezterm.font "JetBrainsMono Nerd Font"

config.enable_tab_bar = false
config.macos_window_background_blur = 30
config.window_background_opacity = 1
config.window_decorations = 'RESIZE'

config.mouse_bindings = {
    -- Ctrl-click will open the link under the mouse cursor
    {
        event = { Up = { streak = 1, button = 'Left' } },
        mods = 'CTRL',
        action = wezterm.action.OpenLinkAtMouseCursor,
    },
}

return config
