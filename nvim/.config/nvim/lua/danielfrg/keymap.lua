local opts = { noremap = true, silent = true }
local term_opts = { silent = true }

-- Remap space as leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Modes:
-- n: Normal
-- i: Insert
-- v: Visual
-- x: Visual Block
-- t: Term mode
-- c: Command mode

-- Escape options
vim.keymap.set("i", "<Esc>", "<Esc>l", opts)
vim.keymap.set("i", "jj", "<Esc>l", opts)
vim.keymap.set("i", "jk", "<Esc>l", opts)
vim.keymap.set({ "n", "i" }, "<C-c>", "<Esc>l", opts)

-- Open Explorer
-- vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)
vim.keymap.set("n", "<leader>e", vim.cmd.NvimTreeToggle, opts)
vim.keymap.set("n", "<leader>pv", vim.cmd.NvimTreeToggle, opts)

-- Move in windows using vim movement keys
-- For C-h see:
-- https://github.com/neovim/neovim/wiki/FAQ#my-ctrl-h-mapping-doesnt-work
vim.keymap.set("n", "<C-h>", "<C-w>h", opts)
vim.keymap.set("n", "<C-j>", "<C-w>j", opts)
vim.keymap.set("n", "<C-k>", "<C-w>k", opts)
vim.keymap.set("n", "<C-l>", "<C-w>l", opts)
-- vim.keymap.set("n", "<C-h>", function()
--   vim.cmd("wincmd h")
-- end)
-- vim.keymap.set("n", "<C-j>", function()
--   vim.cmd("wincmd j")
-- end)
-- vim.keymap.set("n", "<C-k>", function()
--   vim.cmd("wincmd k")
-- end)
-- vim.keymap.set("n", "<C-l>", function()
--   vim.cmd("wincmd l")
-- end)

-- Resize splits with arrows
-- Disable default hotkeys in Mac Preferences > Keyboard > Shortcuts > App Shortcuts
vim.keymap.set("n", "<C-Up>", ":resize +2<CR>", opts)
vim.keymap.set("n", "<C-Down>", ":resize -2<CR>", opts)
vim.keymap.set("n", "<C-Left>", ":vertical resize -2<CR>", opts)
vim.keymap.set("n", "<C-Right>", ":vertical resize +2<CR>", opts)

-- Navigate buffers
-- Edit the alternate (previous) file: <C-^>
vim.keymap.set("n", "<S-x>", ":e #<CR>", opts)
vim.keymap.set("n", "<S-l>", ":bnext<CR>", opts)
vim.keymap.set("n", "<S-h>", ":bprevious<CR>", opts)

-- Quickfix movement
vim.keymap.set("n", "<c-v>", "<cmd>cnext<cr>zz")
vim.keymap.set("n", "<c-b>", "<cmd>cprev<cr>zz")

-- Location list movement
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

-- Remove search highlights
vim.keymap.set("n", "<Esc>", ":noh<return><esc>", opts)
vim.keymap.set("n", "<C-c>", ":noh<return><esc>", opts)

-- Copy to system clipboard
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
-- vim.keymap.set("n", "<leader>y", [["+Y]])

-- Disable this
vim.keymap.set("n", "Q", "<nop>")

-- Project finder
vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")

-- Format files
vim.keymap.set("n", "<leader>f", vim.lsp.buf.format)

-- Insert black lines
vim.keymap.set("n", "<leader>o", "m`o<Esc>``")
vim.keymap.set("n", "<leader>O", "m`O<Esc>``")

-- vim.keymap.set("n", "J", "mzJ`z")
-- vim.keymap.set("n", "<C-d>", "<C-d>zz")
-- vim.keymap.set("n", "<C-u>", "<C-u>zz")
-- vim.keymap.set("n", "n", "nzzzv")
-- vim.keymap.set("n", "N", "Nzzzv")

-- vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])

-- vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
-- vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

-- vim.keymap.set("n", "<leader>vpp", "<cmd>e ~/.dotfiles/nvim/.config/nvim/lua/theprimeagen/packer.lua<CR>");
-- vim.keymap.set("n", "<leader>mr", "<cmd>CellularAutomaton make_it_rain<CR>");


-- Visual Mode --

-- Stay in indent mode
vim.keymap.set("v", "<", "<gv", opts)
vim.keymap.set("v", ">", ">gv", opts)

-- Move selected lines up or down
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- Don't yank when pasting
vim.keymap.set("v", "p", '"_dP')

-- greatest remap ever
vim.keymap.set("x", "<leader>p", [["_dP]])

-- Visual Block --
-- Move text up and down
vim.keymap.set("x", "J", ":move '>+1<CR>gv-gv", opts)
vim.keymap.set("x", "K", ":move '<-2<CR>gv-gv", opts)
vim.keymap.set("x", "<A-j>", ":move '>+1<CR>gv-gv", opts)
vim.keymap.set("x", "<A-k>", ":move '<-2<CR>gv-gv", opts)

-- Terminal --
-- Better terminal navigation
vim.keymap.set("t", "<C-h>", "<C-\\><C-N><C-w>h", term_opts)
vim.keymap.set("t", "<C-j>", "<C-\\><C-N><C-w>j", term_opts)
vim.keymap.set("t", "<C-k>", "<C-\\><C-N><C-w>k", term_opts)
vim.keymap.set("t", "<C-l>", "<C-\\><C-N><C-w>l", term_opts)


vim.keymap.set("n", "<leader><leader>", function()
  vim.cmd("so")
end)
