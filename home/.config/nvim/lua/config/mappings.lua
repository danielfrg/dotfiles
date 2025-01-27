local map = vim.keymap.set
local nomap = vim.keymap.del

-- escape doesn't move cursor
map("i", "<Esc>", "<ESC>l")

-- Disable arrow keys in normal and insert modes
map("n", "<left>", '<cmd>echo "Use h to move!"<CR>')
map("n", "<right>", '<cmd>echo "Use l to move!"<CR>')
map("n", "<up>", '<cmd>echo "Use k to move!"<CR>')
map("n", "<down>", '<cmd>echo "Use j to move!"<CR>')
map("i", "<left>", '<cmd>echo "Use h to move!"<CR>')
map("i", "<right>", '<cmd>echo "Use l to move!"<CR>')
map("i", "<up>", '<cmd>echo "Use k to move!"<CR>')
map("i", "<down>", '<cmd>echo "Use j to move!"<CR>')

-- clear highlights on search when pressing <Esc> in normal mode
-- see `:help hlsearch`
map("n", "<Esc>", ":noh<return><esc>")
map("n", "<C-c>", ":noh<return><esc>")

-- better move page up and down: keep cursor in the middle
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")

-- keep cursor in the middle when searching
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")

-- replace the current word
map(
    "n",
    "<leader>rr",
    ":%s/<C-r><C-w>/<C-r><C-w>/gI<Left><Left><Left>",
    { desc = "Replace current word" }
)

-- yank to system clipboard
map("v", "<leader>y", '"+y', { desc = "Yank to clipboard" })
-- map("n", "<leader>y", '"+y', { desc = "Yank to clipboard" })

-- paste without changing current register
map("n", "<leader>p", '"*p', { desc = "Paste from clipboard" })

-- delete to void
map("v", "<leader>d", '"_d', { desc = "Delete to void" })

-- better intendation: stay in visual mode
map("v", ">", ">gv", { desc = "Indent up" })
map("v", "<", "<gv", { desc = "Indent down" })

-- move up or down selected lines
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move lines up" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move lines down" })

-- buffers
map("n", "<C-i>", "<cmd>e #<cr>", { desc = "Switch to alternate file" })
map("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
map("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next Buffer" })
map("n", "[b", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
map("n", "]b", "<cmd>bnext<cr>", { desc = "Next Buffer" })
map("n", "<leader>z", "<cmd>bdelete<cr>", { desc = "Close buffer" })

-- Split windows
map("n", "<leader>|", ":vsplit<CR>", { desc = "Vertical split" })
map("n", "<leader>-", ":split<CR>", { desc = "Horizontal split" })

-- Keybinds to make split navigation easier.
-- Use ALT+<hjkl> to switch between windows
--  See `:help wincmd` for a list of all window commands
map("n", "<M-h>", "<cmd>TmuxNavigateLeft<CR>", { desc = "window left" })
map("n", "<M-l>", "<cmd>TmuxNavigateRight<CR>", { desc = "window right" })
map("n", "<M-j>", "<cmd>TmuxNavigateDown<CR>", { desc = "window down" })
map("n", "<M-k>", "<cmd>TmuxNavigateUp<CR>", { desc = "window up" })

-- Resize window using <ctrl> arrow keys
map("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase Window Height" })
map("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease Window Height" })
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease Window Width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase Window Width" })

-- tmux sessionizer
map("n", "<C-f>", "<cmd> silent !tmux neww project-session.sh<CR>")

-- Diagnostic keymaps
map('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- new file
map("n", "<leader>n", "<cmd>enew<cr>", { desc = "New file" })

-- save
map("n", "<leader>s", "<cmd>w!<cr><esc>", { desc = "Save file" })

-- Open file explorer
-- map("n", "<leader>e", "<cmd>NvimTreeToggle<CR>")

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

vim.api.nvim_create_user_command("Q", function()
    vim.cmd("q!")
end, { nargs = 0 })

-- Run a command on the current file's directory
vim.keymap.set("n", "<leader>R", function()
    vim.ui.input({ prompt = "Command: " }, function(command)
        local dir = vim.fn.expand("%:p:h")
        if command then -- check for nil in case user cancels
            vim.cmd(string.format("!cd %s && %s", dir, command))
        end
    end)
end, opts)
