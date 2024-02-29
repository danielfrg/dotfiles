---@type ChadrcConfig
local M = {}

local HEIGHT_RATIO = 0.8  -- You can change this
local WIDTH_RATIO = 0.5   -- You can change this too

M.ui = {
    theme = 'catppuccin',
    nvdash = {
        load_on_startup = true,
        header = { "                                 " }
    },
}
M.plugins = "custom.plugins"
M.mappings = require "custom.mappings"

return M
