local map = vim.keymap.set
-- local nomap = vim.keymap.del

-- map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")
map("i", "<Esc>", "<ESC>l")

--
map("n", "<C-s>", "<cmd>w!<cr><esc>", { desc = "Save file" })
map("n", "<leader>s", "<cmd>w!<cr><esc>", { desc = "Save file" })
map("n", "<leader>n", "<cmd>enew<cr>", { desc = "New file" })
-- map("n", "<leader>e", "<cmd>NvimTreeToggle<CR>")

-- Disable arrow keys in normal mode
map("n", "<left>", '<cmd>echo "Use h to move!"<CR>')
map("n", "<right>", '<cmd>echo "Use l to move!"<CR>')
map("n", "<up>", '<cmd>echo "Use k to move!"<CR>')
map("n", "<down>", '<cmd>echo "Use j to move!"<CR>')
-- And in insert mode
map("i", "<left>", '<cmd>echo "Use h to move!"<CR>')
map("i", "<right>", '<cmd>echo "Use l to move!"<CR>')
map("i", "<up>", '<cmd>echo "Use k to move!"<CR>')
map("i", "<down>", '<cmd>echo "Use j to move!"<CR>')

-- Remove search highlights
map("n", "<Esc>", ":noh<return><esc>")
map("n", "<C-c>", ":noh<return><esc>")

-- better move page up and down (keep cursor in the middle)
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")

-- keep cursor in the middle when searching
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")

-- rename
map(
  "n",
  "<leader>rr",
  ":%s/<C-r><C-w>/<C-r><C-w>/gI<Left><Left><Left>",
  { desc = "Replace current word" }
)

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
map("n", "<leader>z", "<cmd>Bdelete<cr>", { desc = "Close buffer" })

-- tmux navigation
map("n", "<C-h>", "<cmd>TmuxNavigateLeft<CR>", { desc = "window left" })
map("n", "<C-l>", "<cmd>TmuxNavigateRight<CR>", { desc = "window right" })
map("n", "<C-j>", "<cmd>TmuxNavigateDown<CR>", { desc = "window down" })
map("n", "<C-k>", "<cmd>TmuxNavigateUp<CR>", { desc = "window up" })

-- Split windows
map("n", "<leader>|", ":vsplit<CR>", { desc = "Vertical split" })
map("n", "<leader>-", ":split<CR>", { desc = "Horizontal split" })

-- Resize window using <ctrl> arrow keys
map("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase Window Height" })
map("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease Window Height" })
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease Window Width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase Window Width" })

-- tmux sessionizer
map("n", "<C-f>", "<cmd> silent !tmux neww tmux-sessionizer<CR>")

-- common typos
vim.api.nvim_create_user_command("W", function()
  vim.cmd("w")
end, { nargs = 0 })

vim.api.nvim_create_user_command("Wq", function()
  vim.cmd("wq")
end, { nargs = 0 })

vim.api.nvim_create_user_command("WQ", function()
  vim.cmd("wq")
end, { nargs = 0 })

--------------------------------------------------------------------------------
-- PLUGINS

-- undotree
map("n", "<leader>u", "<cmd>UndotreeToggle<CR>", { desc = "Open undotree" })

-- Save undo with other actions
map("i", ",", ",<C-g>U")
map("i", ".", ".<C-g>U")
map("i", "!", "!<C-g>U")
map("i", "?", "?<C-g>U")
