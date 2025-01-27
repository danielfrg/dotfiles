-- Load the base config
require("config.options")
require("config.mappings")
require("config.autocmds")
require("config.colors")
require("config.statusline")

-- Load local.lua if found
local status, local_file = pcall(require, "local")

require("config.lazy")
