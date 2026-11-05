vim.loader.enable()

Utils = require("utils")

require("config.options")
require("config.keymaps")
require("config.autocmds")
require("config.commands")
require("config.lsp")

require("plugins")
