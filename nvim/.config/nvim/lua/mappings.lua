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
map("n", "<leader>e", "<cmd> NvimTreeToggle<CR>")

-- Remove search highlights
map("n", "<Esc>", ":noh<return><esc>")
map("n", "<C-c>", ":noh<return><esc>")

-- Manage Buffers
map("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
map("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next buffer" })
map("n", "[b", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
map("n", "]b", "<cmd>bnext<cr>", { desc = "Next buffer" })
map("n", "<leader>b", "<cmd>e #<cr>", { desc = "Switch to Last Buffer" })
map("n", "<leader>`", "<cmd>e #<cr>", { desc = "Switch to Last Buffer" })
map("n", "<S-x>", ":e #<CR>", { desc = "Switch to Last Buffer" })
map("n", "<leader>c", "<cmd>Bdelete<cr>", { desc = "Close buffer" })

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

-- delete to void
map("n", "<leader>d", "\"_d", { desc = "Delete to void" })

-- tmux navigation
-- map("n", "<C-h>", "<cmd> TmuxNavigateLeft<CR>", { desc = "window left"})
-- map("n", "<C-l>", "<cmd> TmuxNavigateRight<CR>", { desc = "window right"})
-- map("n", "<C-j>", "<cmd> TmuxNavigateDown<CR>", { desc = "window down"})
-- map("n", "<C-k>", "<cmd> TmuxNavigateUp<CR>", { desc = "window up"})

-- Move up or down selected lines
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move lines up" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move lines down" })

-- yank to system clipboard
map("v", "<leader>y", "\"+y", { desc = "Yank to clipboard" })

-- delete to void
map("v", "<leader>d", "\"_d", { desc = "Delete to void" })

--------------------------------------------------------------------------------
-- PLUGINS

-- LSP
nomap("n", "<leader>q")

-- Telescope
map("n", "<leader>ff", "<cmd>Telescope find_files hidden=true<CR>", { desc = "Find files" })

-- Git
map("n", "<leader>gg", "<cmd>LazyGit<CR>", { desc = "Lazygit (root dir)" })
map("n", "<leader>gs", "<cmd>Telescope git_status<CR>", { desc = "Git Status" })

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
