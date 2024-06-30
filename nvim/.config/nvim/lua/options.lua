vim.loader.enable()

-- Remap space as leader key
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.g.have_nerd_font = true

vim.opt.cmdheight = 1

-- no splash screen
vim.opt.shortmess = vim.opt.shortmess + 'I'

-- don't show the mode, since it's already in the status line
vim.opt.showmode = false

-- make line numbers default
vim.opt.number = true
vim.opt.relativenumber = true

-- show which line your cursor is on
vim.opt.cursorline = true
vim.opt.cursorlineopt = 'line,number'

-- tabs and spaces
vim.opt.tabstop = 4        -- A TAB character looks like 4 spaces
vim.opt.softtabstop = 4    -- Number of spaces inserted instead of a TAB character
vim.opt.shiftwidth = 4     -- Number of spaces inserted when indenting
vim.opt.smartindent = true -- Be smart when indenting
vim.opt.expandtab = true   -- Pressing the TAB key will insert spaces instead of a TAB character

-- line wrap
vim.opt.wrap = true

-- enable mouse mode
vim.opt.mouse = "a"

-- highlight on search terms
vim.opt.hlsearch = true
-- highligh as you type
vim.opt.incsearch = true
-- preview substitutions as you type
vim.opt.inccommand = 'split'

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

-- sessions
vim.o.sessionoptions = "globals"

-- case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- good colors
vim.opt.termguicolors = true

-- scroll padding
vim.opt.scrolloff = 10
vim.opt.sidescrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.colorcolumn = "80"

-- decrease update time
vim.o.updatetime = 50
vim.o.timeoutlen = 300

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

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

local status, plugin = pcall(require, 'plugin_name')
-- if not status then
--     print('Something went wrong:', plugin)
-- else
--     plugin.setup()
-- end
