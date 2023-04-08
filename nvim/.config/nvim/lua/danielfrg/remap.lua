local opts = { noremap = true }

vim.g.mapleader = " "

-- Escape options
vim.keymap.set("i", "jj", "<Esc>", opts)
vim.keymap.set("i", "jk", "<Esc>", opts)
vim.keymap.set({ "n", "i" }, "<C-c>", "<Esc>")

-- Open Explorer
-- vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)
vim.keymap.set("n", "<leader>pv", vim.cmd.NvimTreeToggle)

-- Move in windows using vim movement keys
vim.keymap.set("n", "<C-h>", function()
    vim.cmd("wincmd h")
end)
vim.keymap.set("n", "<C-j>", function()
    vim.cmd("wincmd j")
end)
vim.keymap.set("n", "<C-k>", function()
    vim.cmd("wincmd k")
end)
vim.keymap.set("n", "<C-l>", function()
    vim.cmd("wincmd l")
end)

-- Quickfix movement
vim.keymap.set("n", "<c-k>", "<cmd>cnext<cr>zz")
vim.keymap.set("n", "<c-j>", "<cmd>cprev<cr>zz")

-- Location list movement
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

-- Remove search highlights
vim.keymap.set("n", "<esc>", ":noh<return><esc>", opts)

-- Move selected lines up or down
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- Copy to system clipboard
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
-- vim.keymap.set("n", "<leader>y", [["+Y]])

vim.keymap.set("n", "Q", "<nop>")

-- Project finder
vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")
-- Format files
vim.keymap.set("n", "<leader>f", vim.lsp.buf.format)

-- vim.keymap.set("n", "J", "mzJ`z")
-- vim.keymap.set("n", "<C-d>", "<C-d>zz")
-- vim.keymap.set("n", "<C-u>", "<C-u>zz")
-- vim.keymap.set("n", "n", "nzzzv")
-- vim.keymap.set("n", "N", "Nzzzv")
--
-- greatest remap ever
-- vim.keymap.set("x", "<leader>p", [["_dP]])

--
-- vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])
--
-- vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
-- vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })
--
-- vim.keymap.set("n", "<leader>vpp", "<cmd>e ~/.dotfiles/nvim/.config/nvim/lua/theprimeagen/packer.lua<CR>");
-- vim.keymap.set("n", "<leader>mr", "<cmd>CellularAutomaton make_it_rain<CR>");


vim.keymap.set("n", "<leader><leader>", function()
    vim.cmd("so")
end)
