require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set
local nomap = vim.keymap.del

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")
map("i", "<Esc>", "<ESC>l")

--
map("n", "<C-s>", "<cmd>w!<cr><esc>", { desc = "Save file" })
map("n", "<leader>s", "<cmd>w!<cr><esc>", { desc = "Save file" })
map("n", "<leader>n", "<cmd>enew<cr>", { desc = "New file" })
map("n", "<leader>e", "<cmd>NvimTreeToggle<CR>")

-- Remove search highlights
map("n", "<Esc>", ":noh<return><esc>")
map("n", "<C-c>", ":noh<return><esc>")

-- keep cursor in the middle when searching
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")

-- rename
map("n", "<leader>rr", ":%s/<C-r><C-w>/<C-r><C-w>/gI<Left><Left><Left>", { desc = "Replace current word" })

-- better move page up and down (keep cursor in the middle)
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")

-- yank to system clipboard
map("n", "<leader>y", "\"+y", { desc = "Yank to clipboard" })
map("n", "<leader>Y", "\"+Y", { desc = "Yank to clipboard" })

-- paste without changing current register
map("n", "<leader>p", "\"*p", { desc = "Paste from clipboard" })

-- Move up or down selected lines
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move lines up" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move lines down" })

-- yank to system clipboard
map("v", "<leader>y", "\"+y", { desc = "Yank to clipboard" })

-- delete to void
map("v", "<leader>d", "\"_d", { desc = "Delete to void" })

-- buffers
map("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
map("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next Buffer" })
map("n", "[b", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
map("n", "]b", "<cmd>bnext<cr>", { desc = "Next Buffer" })
map("n", "<leader>bb", "<cmd>e #<cr>", { desc = "Switch to Last Buffer" })
map("n", "<leader>`", "<cmd>e #<cr>", { desc = "Switch to Last Buffer" })
map("n", "<S-x>", "<cmd>e #<cr>", { desc = "Switch to Last Buffer" })
map("n", "<leader>c", "<cmd>Bdelete<cr>", { desc = "Close buffer" })

-- tmux navigation
-- map("n", "<C-h>", "<cmd> TmuxNavigateLeft<CR>", { desc = "window left"})
-- map("n", "<C-l>", "<cmd> TmuxNavigateRight<CR>", { desc = "window right"})
-- map("n", "<C-j>", "<cmd> TmuxNavigateDown<CR>", { desc = "window down"})
-- map("n", "<C-k>", "<cmd> TmuxNavigateUp<CR>", { desc = "window up"})

--------------------------------------------------------------------------------
-- PLUGINS

-- LSP
-- See other maps in lspconfig.lua
nomap("n", "<leader>q")

-- Lazy
map("n", "<leader>cl", "<cmd>Lazy<cr>", { desc = "Lazy" })

-- conform
nomap("n", "<leader>fm")
map("n", "<leader>cf", function()
    require("conform").format { lsp_fallback = true }
end, { desc = "Format Files" })

-- telescope - find
map("n", "<leader>ff", "<cmd>Telescope find_files hidden=true<CR>", { desc = "Telescope Find files" })
map("n", "<leader>:", "<cmd>Telescope command_history<cr>", { desc = "Command History" })
map("n", "<leader>fb", "<cmd>Telescope buffers sort_mru=true sort_lastused=true<cr>", { desc = "Buffers" })
map("n", "<leader>fc", "<cmd>Telescope<cr>", { desc = "Find Config File" })
map("n", "<leader>ff", "<cmd>Telescope find_files hidden=true<CR>", { desc = "Find Files (Root Dir)" })
map("n", "<leader>fF", "<cmd>Telescope find_files hidden=true cwd=false<CR>", { desc = "Find Files (cwd)" })
map("n", "<leader>fg", "<cmd>Telescope git_files<cr>", { desc = "Find Files (git-files)" })
map("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>", { desc = "Recent Files" })

-- telescope - search
map("n", "<leader>sb", "<cmd>Telescope current_buffer_fuzzy_find<cr>", { desc = "Buffer" })
map("n", "<leader>sc", "<cmd>Telescope command_history<cr>", { desc = "Command History" })
map("n", "<leader>sC", "<cmd>Telescope commands<cr>", { desc = "Commands" })
map("n", "<leader>sd", "<cmd>Telescope diagnostics bufnr=0<cr>", { desc = "Document Diagnostics" })
map("n", "<leader>sD", "<cmd>Telescope diagnostics<cr>", { desc = "Workspace Diagnostics" })
map("n", "<leader>sk", "<cmd>Telescope keymaps<cr>", { desc = "Key Maps" })

-- git
map("n", "<leader>gg", "<cmd>LazyGit<CR>", { desc = "Lazygit (root dir)" })
nomap("n", "<leader>cm")
map("n", "<leader>gc", "<cmd>Telescope git_commits<CR>", { desc = "Telescope Git commits" })
nomap("n", "<leader>gt")
map("n", "<leader>gs", "<cmd>Telescope git_status<CR>", { desc = "Telescope Git Status" })

-- Harpoon
map("n", "<leader>a",
    function()
        local harpoon = require "harpoon"
        harpoon:list():append()
    end,
    { desc = "Add file to harpoon", })

map("n", "<C-e>",
    function()
        local harpoon = require "harpoon"
        harpoon.ui:toggle_quick_menu(harpoon:list())
    end,
    { desc = "Toggle UI" })

map("n", "<C-h>",
    function()
        local harpoon = require "harpoon"
        harpoon:list():select(1)
    end,
    { desc = "Go to file 1" })

map("n", "<C-j>",
    function()
        local harpoon = require "harpoon"
        harpoon:list():select(2)
    end,
    { desc = "Go to file 2" })

map("n", "<C-k>",
    function()
        local harpoon = require "harpoon"
        harpoon:list():select(3)
    end,
    { desc = "Go to file 3" })

map("n", "<C-l>",
    function()
        local harpoon = require "harpoon"
        harpoon:list():select(4)
    end,
    { desc = "Go to file 4" })

map("n", "<C-S-P>",
    function()
        local harpoon = require "harpoon"
        harpoon:list():prev()
    end,
    { desc = "Go to previous file" })

map("n", "<C-S-N>",
    function()
        local harpoon = require "harpoon"
        harpoon:list():next()
    end,
    { desc = "Go to file next file" })

-- tmux sessionizer
map("n", "<C-f>", "<cmd> silent !tmux neww tmux-sessionizer<CR>")

-- undotree
map("n", "<leader>u", "<cmd>UndotreeToggle<CR>", { desc = "Open undotree" })
