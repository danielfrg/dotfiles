local status_ok, bufferline = pcall(require, "bufferline")
if not status_ok then return end

-- Load bufferline AFTER colorscheme
bufferline.setup({
    options = {
        close_command = "Bdelete! %d",
        right_mouse_command = "Bdelete! %d",
        indicator = nil,
        separator_style = nil,
    },
    highlights = {
        fill = { bg = "#282828" },
        -- separator = {fg = "#282828"},
        background = { bg = "#FFFFFF" },
        -- buffer_visible ={bg = "#FFFFFF"},
        buffer_selected = { bg = "#FFFFFF" },
    }
    -- highlights = require("catppuccin.groups.integrations.bufferline").get()
})
