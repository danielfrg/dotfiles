-- set <space> as the leader key
-- NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true

-- don't show the mode, since it's already in the status line
vim.opt.showmode = true

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

-- case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- highlight on search terms
vim.opt.hlsearch = true
-- highligh as you type
vim.opt.incsearch = true
-- preview substitutions as you type
vim.opt.inccommand = 'split'

-- For :command mode
-- Complete to longest then show list
vim.opt.wildignore:append({ "node_modules" })
vim.opt.wildignore:append({
    ".o", ".obj", ".dll", ".exe", ".so", ".a", ".lib", ".pyc", ".pyo", ".pyd",
    ".swp", ".swo", ".class", ".DS_Store", ".git", ".hg", ".orig"
})

-- sync clipboard between OS and Neovim
-- Comment to keep them separated
-- vim.opt.clipboard = ""
-- vim.opt.clipboard = "unnamedplus"

-- disable backups
vim.opt.backup = false
vim.opt.swapfile = false

-- save undo history
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

-- enable break indent
vim.opt.breakindent = true

-- Keep signcolumn on by default
vim.opt.signcolumn = 'yes'

-- Decrease update time
vim.opt.updatetime = 250

-- Decrease mapped sequence wait time
-- Displays which-key popup sooner
vim.opt.timeoutlen = 300

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Show which line your cursor is on
vim.opt.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 10
vim.opt.sidescrolloff = 10

vim.opt.colorcolumn = "80"

-- so that `` is visible in markdown files
vim.opt.conceallevel = 0

-- session: save this variables
vim.opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp", "folds" }

-- folding: use treesitter
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldlevel = 99
vim.opt.foldcolumn = "0" -- don't show fold column

-- no splash screen
vim.opt.shortmess:append "I"

-- Disables the Netrw banner. Press 'I' to toggle.
vim.g.netrw_banner = 0
-- netrw tree view
vim.g.netrw_liststyle = 3

-- suppress ruff lsp warning:
-- https://github.com/nvimtools/none-ls.nvim/discussions/81
-- vim.g.nonels_suppress_issue58 = true

-- Check if rg (ripgrep) exists
local rg_exists = vim.fn.executable("rg") > 0

if rg_exists then
  vim.o.grepprg = [[rg --glob "!.git" --no-heading --vimgrep --follow $*]]
end

vim.opt.grepformat = vim.opt.grepformat ^ { "%f:%l:%c:%m" }
