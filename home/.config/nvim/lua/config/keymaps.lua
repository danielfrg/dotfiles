local map = vim.keymap.set

-- Disable arrow keys in normal and insert mode
for _, mode in ipairs({ "n", "i" }) do
	map(mode, "<Left>", '<Cmd>echo "Use h to move!"<CR>')
	map(mode, "<Right>", '<Cmd>echo "Use l to move!"<CR>')
	map(mode, "<Up>", '<Cmd>echo "Use k to move!"<CR>')
	map(mode, "<Down>", '<Cmd>echo "Use j to move!"<CR>')
end

-- Search
map("n", "<Esc>", "<Cmd>nohlsearch<CR><Esc>", { desc = "Clear search highlight" })
map("n", "n", "nzzzv", { desc = "Next match (centered)" })
map("n", "N", "Nzzzv", { desc = "Previous match (centered)" })
map("n", "<leader>rr", ":%s/<C-r><C-w>/<C-r><C-w>/gI<Left><Left><Left>", { desc = "Replace word under cursor" })

-- Scrolling
map("n", "<C-d>", "<C-d>zz", { desc = "Half page down (centered)" })
map("n", "<C-u>", "<C-u>zz", { desc = "Half page up (centered)" })

-- Editing
map("v", ">", ">gv", { desc = "Indent" })
map("v", "<", "<gv", { desc = "Dedent" })
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move lines down" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move lines up" })
map("n", "<leader>o", "o<Esc>^Da", { desc = "Open line below without comment" })
map("n", "<leader>O", "O<Esc>^Da", { desc = "Open line above without comment" })

-- Registers and clipboard
map("v", "<leader>y", '"+y', { desc = "Yank to clipboard" })
map("n", "<leader>p", '"+p', { desc = "Paste from clipboard" })
map("v", "<leader>d", '"_d', { desc = "Delete without yanking" })

-- Files and buffers
map("n", "<leader>n", "<Cmd>enew<CR>", { desc = "New buffer" })
map("n", "<leader>z", "<Cmd>bdelete<CR>", { desc = "Close buffer" })
map("n", "<S-h>", "<Cmd>bprevious<CR>", { desc = "Previous buffer" })
map("n", "<S-l>", "<Cmd>bnext<CR>", { desc = "Next buffer" })
map("n", "<leader>bd", function()
	local visible = {}
	for _, win in ipairs(vim.api.nvim_list_wins()) do
		visible[vim.api.nvim_win_get_buf(win)] = true
	end
	for _, buf in ipairs(vim.api.nvim_list_bufs()) do
		if vim.bo[buf].buflisted and not visible[buf] and not vim.bo[buf].modified then
			vim.api.nvim_buf_delete(buf, {})
		end
	end
end, { desc = "Close hidden buffers" })

-- Windows
map("n", "<leader>|", "<Cmd>vsplit<CR>", { desc = "Vertical split" })
map("n", "<leader>-", "<Cmd>split<CR>", { desc = "Horizontal split" })
map("n", "<C-Up>", "<Cmd>resize +2<CR>", { desc = "Increase window height" })
map("n", "<C-Down>", "<Cmd>resize -2<CR>", { desc = "Decrease window height" })
map("n", "<C-Left>", "<Cmd>vertical resize -2<CR>", { desc = "Decrease window width" })
map("n", "<C-Right>", "<Cmd>vertical resize +2<CR>", { desc = "Increase window width" })

-- Diagnostics
map("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Diagnostics to location list" })

-- Rex handles Ctrl+F itself; this also opens its picker from other terminals
map("n", "<C-f>", function()
	vim.fn.jobstart({ vim.fn.expand("~/.local/scripts/project-session-rex.sh"), "--palette" })
end, { desc = "Rex project session" })
