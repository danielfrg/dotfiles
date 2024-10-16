-- Load the base config
require("options")
require("mappings")
require("autocmds")
require("config.colors")
require("config.statusline")

-- Load local.lua if found
local status, local_file = pcall(require, "local")

-- Load lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- empty setup
-- require("lazy").setup({})

require("lazy").setup("plugins",
    {
        change_detection = {
            notify = false,
        },
    }
);
