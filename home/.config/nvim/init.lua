-- Load all the configuration files
require("options")
require("mappings")
require("autocmds")

-- Load local.lua if found
local status, plugin = pcall(require, 'local')

-- Default lazy.nvim config
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

require('lazy').setup("plugins",
    {
        change_detection = {
            notify = false,
        },
    }
);


-- vim.api.nvim_set_hl(0, 'TelescopeNormal', { bg = '#ff0000' })
