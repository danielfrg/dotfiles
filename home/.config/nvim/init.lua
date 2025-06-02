-- options first
require("core.options")

-- them other core config
require("core.autocmds")
require("core.lsp")
require("core.mappings")
require("core.statusline")
require("core.theme")

-- load local.lua if found
local status, local_file = pcall(require, "local")

-- load plugins
require("core.lazy")
