require("options")

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
print(lazypath)
vim.opt.rtp:prepend(lazypath)

require("mappings")
require("autocmds")

require('lazy').setup("plugins",
    {
        defaults = {
            event = "VeryLazy",
            -- lazy = true
        }
    }
);

local lsp = vim.lsp

-- lsp.handlers["textDocument/hover"] = lsp.with(vim.lsp.handlers.hover, {
--     border = "rounded",
-- })
