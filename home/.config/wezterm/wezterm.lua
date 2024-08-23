local wezterm = require("wezterm")
local config = {}

config.color_scheme = "Tokyo Night"
-- config.color_scheme = "nord"
--
-- config.color_scheme = "OneDark (base16)"
-- config.colors = {
--     foreground = "#DDDDDD",
--     background = '#292c32',
-- }

config.font_size = 15.0
config.font = wezterm.font("JetBrainsMono Nerd Font")

config.enable_tab_bar = false
-- config.macos_window_background_blur = 30
-- config.window_background_opacity = 0.9
config.window_decorations = "RESIZE"

config.mouse_bindings = {
    -- Ctrl-click will open the link under the mouse cursor
    {
        event = { Up = { streak = 1, button = "Left" } },
        mods = "CTRL",
        action = wezterm.action.OpenLinkAtMouseCursor,
    },
}

-- Disable font-ligatures
config.harfbuzz_features = { "calt=0", "clig=0", "liga=0" }

config.keys = {
    -- Make Option-Left equivalent to Alt-b which many line editors interpret as backward-word
    { key = "LeftArrow",  mods = "OPT", action = wezterm.action({ SendString = "\x1bb" }) },
    -- { key = "LeftArrow", mods = "CTRL", action = wezterm.action({ SendString = "\x1bb" }) },
    -- Make Option-Right equivalent to Alt-f; forward-word
    { key = "RightArrow", mods = "OPT", action = wezterm.action({ SendString = "\x1bf" }) },
    -- { key = "RightArrow", mods = "CTRL", action = wezterm.action({ SendString = "\x1bf" }) },
}

return config
