-- require "nvchad.mappings"

local map = vim.keymap.set
-- local nomap = vim.keymap.del

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")
map("i", "<Esc>", "<ESC>l")

-- File management
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
map("n", "<leader>y", '"+y', { desc = "Yank to clipboard" })
map("n", "<leader>Y", '"+Y', { desc = "Yank to clipboard" })

-- paste without changing current register
map("n", "<leader>p", '"*p', { desc = "Paste from clipboard" })

map("v", ">", ">gv", { desc = "Indent up" })
map("v", "<", "<gv", { desc = "Indent down" })

-- Move up or down selected lines
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move lines up" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move lines down" })

-- yank to system clipboard
map("v", "<leader>y", '"+y', { desc = "Yank to clipboard" })

-- delete to void
map("v", "<leader>d", '"_d', { desc = "Delete to void" })

-- buffers
map("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
map("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next Buffer" })
map("n", "[b", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
map("n", "]b", "<cmd>bnext<cr>", { desc = "Next Buffer" })
map("n", "<leader>bb", "<cmd>e #<cr>", { desc = "Switch to Last Buffer" })
map("n", "<leader>`", "<cmd>e #<cr>", { desc = "Switch to Last Buffer" })
map("n", "<S-x>", "<cmd>e #<cr>", { desc = "Switch to Last Buffer" })
map("n", "<leader>x", "<cmd>Bdelete<cr>", { desc = "Close buffer" })
map("n", "<leader>c", "<cmd>Bdelete<cr>", { desc = "Close buffer" })

-- tmux navigation
-- map("n", "<C-h>", "<cmd> TmuxNavigateLeft<CR>", { desc = "window left"})
-- map("n", "<C-l>", "<cmd> TmuxNavigateRight<CR>", { desc = "window right"})
-- map("n", "<C-j>", "<cmd> TmuxNavigateDown<CR>", { desc = "window down"})
-- map("n", "<C-k>", "<cmd> TmuxNavigateUp<CR>", { desc = "window up"})

-- tmux sessionizer
map("n", "<C-f>", "<cmd> silent !tmux neww tmux-sessionizer<CR>")

-- undotree
map("n", "<leader>u", "<cmd>UndotreeToggle<CR>", { desc = "Open undotree" })
