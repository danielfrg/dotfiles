local status_ok, bufferline = pcall(require, "bufferline")
if not status_ok then return end

-- Load bufferline AFTER colorscheme
bufferline.setup {
    highlights = require("catppuccin.groups.integrations.bufferline").get()
}
