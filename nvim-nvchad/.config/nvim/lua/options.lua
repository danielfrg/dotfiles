-- require "nvchad.options"

-- Remap space as leader key
vim.g.mapleader = " "

vim.opt.cmdheight = 1

-- make line numbers default
vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.cursorline = true
vim.opt.cursorlineopt = 'line,number'

-- tabs and spaces
vim.opt.tabstop = 4        -- A TAB character looks like 4 spaces
vim.opt.softtabstop = 4    -- Number of spaces inserted instead of a TAB character
vim.opt.shiftwidth = 4     -- Number of spaces inserted when indenting
vim.opt.smartindent = true -- Be smart when indenting
vim.opt.expandtab = true   -- Pressing the TAB key will insert spaces instead of a TAB character

-- disable line wrap
vim.opt.wrap = false

-- enable mouse mode
vim.opt.mouse = "a"

-- highlight on search terms
vim.opt.hlsearch = true
-- highligh as you type
vim.opt.incsearch = true

-- sync/nosync clipboard between OS and Neovim
vim.opt.clipboard = "" -- nosync
-- vim.opt.clipboard = "unnamedplus" -- sync

-- disable backups and let undotree handle history
vim.opt.backup = false
vim.opt.swapfile = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

-- enable break indent
vim.opt.breakindent = true

-- case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- good colors
vim.opt.termguicolors = true

-- scroll padding
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.colorcolumn = "80"

-- decrease update time
vim.o.updatetime = 50
vim.o.timeoutlen = 300

-- force all horizontal splits to go below current window
vim.opt.splitbelow = true
-- force all vertical splits to go to the right of current window
vim.opt.splitright = true

-- so that `` is visible in markdown files
vim.opt.conceallevel = 0

-- vim.opt.title = true

-- suppress ruff lsp warning:
-- https://github.com/nvimtools/none-ls.nvim/discussions/81
vim.g.nonels_suppress_issue58 = true

if vim.g.neovide then
    vim.o.guifont = "JetbrainsMono Nerd Font:h10"

    vim.g.neovide_refresh_rate = 75
    vim.g.neovide_cursor_vfx_mode = "railgun"

    vim.keymap.set("i", "<c-s-v>", "<c-r>+")
    vim.keymap.set("i", "<c-r>", "<c-s-v>")
end
