local U = require("user.utils")

-- Based on LazyVim and LunarVim

-- Disable Space
U.keymap({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Escape options
U.keymap("i", "<Esc>", "<Esc>l")
U.keymap({ "n", "i" }, "<C-c>", "<Esc>l")
-- U.keymap("i", "jj", "<Esc>l")
-- U.keymap("i", "jk", "<Esc>l")

-- Save file
U.keymap({ "i", "v", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save file" })
--  Save and close buffer
U.keymap({ "n" }, "QQ", "<cmd>w|Bdelete<cr>", { desc = "Save file and close" })

vim.cmd("command Wd write|Bdelete")
vim.cmd("command WD write|Bdelete")
vim.cmd("command D Bdelete")
vim.cmd("command W write")
vim.cmd("command Q qa")

-- Open Explorer
-- U.keymap("n", "<leader>pv", vim.cmd.Ex)

-- Move to window using the <ctrl>+<h-j-k-l> keys
-- If <C-h> not working see:
-- https://github.com/neovim/neovim/wiki/FAQ#my-ctrl-h-mapping-doesnt-work
U.keymap("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
U.keymap("n", "<C-j>", "<C-w>j", { desc = "Go to lower window" })
U.keymap("n", "<C-k>", "<C-w>k", { desc = "Go to upper window" })
U.keymap("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })

-- Resize window using <ctrl> arrow keys
U.keymap("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase window height" })
U.keymap("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease window height" })
U.keymap("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease window width" })
U.keymap("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase window width" })

-- Navigate buffers
-- Edit the alternate (previous) file: <C-^>
U.keymap("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
U.keymap("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next buffer" })
U.keymap("n", "[b", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
U.keymap("n", "]b", "<cmd>bnext<cr>", { desc = "Next buffer" })
U.keymap("n", "<leader>b", "<cmd>e #<cr>", { desc = "Switch to Last Buffer" })
U.keymap("n", "<leader>`", "<cmd>e #<cr>", { desc = "Switch to Last Buffer" })
U.keymap("n", "<S-x>", ":e #<CR>", { desc = "Switch to Last Buffer" })

-- New file
U.keymap("n", "<leader>fn", "<cmd>enew<cr>", { desc = "[F]ile [N]ew" })

-- Location list movement
U.keymap("n", "<leader>k", "<cmd>lnext<CR>zz", { desc = "Next Location" })
U.keymap("n", "<leader>j", "<cmd>lprev<CR>zz", { desc = "Prev Location" })

-- Quickfix movement
U.keymap("n", "<c-v>", "<cmd>cnext<cr>zz", { desc = "Next Quickfix" })
U.keymap("n", "<c-b>", "<cmd>cprev<cr>zz", { desc = "Prev Quickfix" })

-- Remove search highlights
U.keymap("n", "<Esc>", ":noh<return><esc>")
U.keymap("n", "<C-c>", ":noh<return><esc>")

-- Copy to system clipboard
U.keymap({ "n", "v" }, "<leader>y", [["+y]], { desc = "Copy to clipboard" })
-- U.keymap("n", "<leader>y", [["+Y]])

-- Disable this
U.keymap("n", "Q", "<nop>")

-- Project finder
U.keymap("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>", { desc = "Tmux Project finder" })

-- Insert blank lines
U.keymap("n", "<leader>o", "m`o<Esc>``", { desc = "Insert line below" })
U.keymap("n", "<leader>O", "m`O<Esc>``", { desc = "Insert line above" })

-----------------
-- Visual Mode --

-- Better intenting
U.keymap("v", "<", "<gv")
U.keymap("v", ">", ">gv")

-- Move selected lines up or down
U.keymap("v", "J", ":m '>+1<CR>gv=gv")
U.keymap("v", "K", ":m '<-2<CR>gv=gv")

-- Don't yank when pasting
U.keymap("v", "p", '"_dP')

-- greatest remap ever
U.keymap("x", "<leader>p", [["_dP]])

-- Visual Block --
-- Move text up and down
U.keymap("x", "J", ":move '>+1<CR>gv-gv")
U.keymap("x", "K", ":move '<-2<CR>gv-gv")
U.keymap("x", "<A-j>", ":move '>+1<CR>gv-gv")
U.keymap("x", "<A-k>", ":move '<-2<CR>gv-gv")
