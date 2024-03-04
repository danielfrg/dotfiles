-- require "commands"
-- require "autocmds"

-- Remap space as leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.opt.cmdheight = 1

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.smartindent = true
vim.opt.expandtab = true

vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.cursorline = true
vim.opt.cursorlineopt = 'line,number'

vim.opt.wrap = false
-- vim.opt.guicursor = ""
vim.opt.mouse = "a" -- allow the mouse to be used in neovim

vim.opt.swapfile = false
vim.opt.backup = false
-- enable persistent undo
vim.opt.undofile = true
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"

-- unsync clipboard between OS and Neovim
vim.opt.clipboard = ""
-- Do this to sync them
-- vim.opt.clipboard = "unnamed"

-- vim.opt.breakindent = true

-- Case insensitive searching UNLESS /C or capital in search
vim.opt.ignorecase = true

-- Search
vim.opt.hlsearch = true
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50
vim.opt.colorcolumn = "80"

-- force all horizontal splits to go below current window
vim.opt.splitbelow = true
-- force all vertical splits to go to the right of current window
vim.opt.splitright = true

-- so that `` is visible in markdown files
vim.opt.conceallevel = 0

-- suppress ruff lsp warning:
-- https://github.com/nvimtools/none-ls.nvim/discussions/81
vim.g.nonels_suppress_issue58 = true

vim.opt.title = true

if vim.g.neovide then
    vim.o.guifont = "JetbrainsMono Nerd Font:h10"

    vim.g.neovide_refresh_rate = 75
    vim.g.neovide_cursor_vfx_mode = "railgun"

    vim.keymap.set("i", "<c-s-v>", "<c-r>+")
    vim.keymap.set("i", "<c-r>", "<c-s-v>")
end
