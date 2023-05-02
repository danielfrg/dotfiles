local U = require("user.utils")

-- Escape
U.keymap("i", "<Esc>", "<Esc>l")
U.keymap({ "n", "i" }, "<C-c>", "<Esc>l")
-- U.keymap("i", "jj", "<Esc>l")
-- U.keymap("i", "jk", "<Esc>l")

-- Remove search highlights
U.keymap("n", "<Esc>", ":noh<return><esc>")
U.keymap("n", "<C-c>", ":noh<return><esc>")

-- Manage Buffers
U.keymap("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
U.keymap("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next buffer" })
U.keymap("n", "[b", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
U.keymap("n", "]b", "<cmd>bnext<cr>", { desc = "Next buffer" })
U.keymap("n", "<leader>b", "<cmd>e #<cr>", { desc = "Switch to Last Buffer" })
U.keymap("n", "<leader>`", "<cmd>e #<cr>", { desc = "Switch to Last Buffer" })
U.keymap("n", "<S-x>", ":e #<CR>", { desc = "Switch to Last Buffer" })
U.keymap("n", "<leader>c", "<cmd>Bdelete<cr>", { desc = "Close buffer" })

-- Save file
U.keymap({ "i", "v", "n", "s" }, "<C-s>", "<cmd>w!<cr><esc>", { desc = "Save file" })

--  Save and close buffer
U.keymap("n", "QQ", "<cmd>write!|Bdelete!<cr>", { desc = "Save file and close buffer" })
U.keymap("n", "<C-w>", "<cmd>wq!<cr>", { desc = "Save file and close buffer" })
U.keymap("n", "<C-q>", "<cmd>q!<cr>", { desc = "Force quit" })

vim.cmd("command Wd write!|Bdelete!")
vim.cmd("command WD write!|Bdelete!")
vim.cmd("command D Bdelete!")
vim.cmd("command W write!")
vim.cmd("command Q qa!")

--------------------------------------------------------------------------------
-- Telescope
-- Combination of AstroVim and LunarVim

local status_ok, telescope = pcall(require, "telescope")
if not status_ok then return end

local themes = require("telescope.themes")
local builtin = require("telescope.builtin")

U.keymap("n", "<C-p>", function()
        builtin.find_files(themes.get_dropdown { previewer = false, })
    end,
    { desc = "[F]ind [F]ile (git)" })

U.keymap("n", "<leader>ff", function()
        builtin.find_files()
    end,
    { desc = "[F]ind [F]iles" })

U.keymap("n", "<leader>fF", function()
        builtin.find_files({ hidden = true, no_ignore = true })
    end,
    { desc = "[F]ind [F]iles (include hidden)" })

U.keymap("n", "<leader>fg", builtin.live_grep, { desc = "[F]ind [G]rep" })
U.keymap("n", "<leader>fG", function()
        require("telescope.builtin").live_grep {
            additional_args = function(args) return vim.list_extend(args, { "--hidden", "--no-ignore" }) end,
        }
    end,
    { desc = "[F]ind [G]rep (include hidden)" })

U.keymap("n", "<leader>fo", builtin.oldfiles, { desc = "[F]ind history" })
U.keymap("n", "<leader>fh", builtin.oldfiles, { desc = "[F]ind history" })
U.keymap("n", "<leader>fb", builtin.buffers, { desc = "[F]ind existing [B]uffers" })
U.keymap("n", "<leader>fc", builtin.grep_string, { desc = "[F]ind word at [c]ursor" })
U.keymap("n", "<leader>fC", builtin.commands, { desc = "[F]ind [C]ommands" })
U.keymap("n", "<leader>fk", builtin.keymaps, { desc = "[F]ind [K]eymaps" })

U.keymap("n", "<leader>/", function()
    builtin.current_buffer_fuzzy_find(themes.get_dropdown {
        winblend = 10,
        previewer = false,
    })
end, { desc = "[/] Fuzzily search in current buffer" })

--------------------------------------------------------------------------------
-- Split management

local status_ok, smart_splits = pcall(require, "smart-splits")
if not status_ok then return end

U.keymap("n", "|", "<cmd>vsplit<cr>", { desc = "Vertical Split" })
U.keymap("n", "\\", "<cmd>split<cr>", { desc = "Horizontal Split" })

-- One line above to give harpoon the middle row
U.keymap("n", "<C-y>", function() smart_splits.move_cursor_left() end, { desc = "Move to left split" })
U.keymap("n", "<C-u>", function() smart_splits.move_cursor_down() end, { desc = "Move to below split" })
U.keymap("n", "<C-i>", function() smart_splits.move_cursor_up() end, { desc = "Move to above split" })
U.keymap("n", "<C-o>", function() smart_splits.move_cursor_right() end, { desc = "Move to right split" })
U.keymap("n", "<C-Up>", function() smart_splits.resize_up() end, { desc = "Resize split up" })
U.keymap("n", "<C-Down>", function() smart_splits.resize_down() end, { desc = "Resize split down" })
U.keymap("n", "<C-Left>", function() smart_splits.resize_left() end, { desc = "Resize split left" })
U.keymap("n", "<C-Right>", function() smart_splits.resize_right() end, { desc = "Resize split right" })

-- Move to window using the <ctrl>+<h-j-k-l> keys
-- Using vim-tmux-navigator now
-- If <C-h> not working see:
-- https://github.com/neovim/neovim/wiki/FAQ#my-ctrl-h-mapping-doesnt-work
-- U.keymap("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
-- U.keymap("n", "<C-j>", "<C-w>j", { desc = "Go to lower window" })
-- U.keymap("n", "<C-k>", "<C-w>k", { desc = "Go to upper window" })
-- U.keymap("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })

-- Resize window using <ctrl> arrow keys
-- Using smart-splits
-- U.keymap("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase window height" })
-- U.keymap("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease window height" })
-- U.keymap("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease window width" })
-- U.keymap("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase window width" })

--------------------------------------------------------------------------------
-- Others

-- New file
U.keymap("n", "<leader>n", "<cmd>enew<cr>", { desc = "[N]ew file" })

-- Location list movement
-- U.keymap("n", "<leader>k", "<cmd>lnext<CR>zz", { desc = "Next Location" })
-- U.keymap("n", "<leader>j", "<cmd>lprev<CR>zz", { desc = "Prev Location" })

-- Quickfix movement
U.keymap("n", "<c-v>", "<cmd>cnext<cr>zz", { desc = "Next Quickfix" })
U.keymap("n", "<c-b>", "<cmd>cprev<cr>zz", { desc = "Prev Quickfix" })

-- Copy to system clipboard
U.keymap({ "n", "v" }, "<leader>y", [["+y]], { desc = "Copy to clipboard" })
-- U.keymap("n", "<leader>y", [["+Y]])

-- Disable this
U.keymap("n", "Q", "<nop>")

-- Project finder
U.keymap("n", "<C-t>", "<cmd>silent !tmux neww tmux-sessionizer<CR>", { desc = "Tmux Project finder" })

-- Explorer
U.keymap("n", "<leader>e", "<cmd>NvimTreeToggle<cr>", { desc = "Toggle File [E]xplorer" })

-- Comment
local status_ok, comment = pcall(require, "Comment.api")
if not status_ok then return end

U.keymap("n", "<leader>/", function()
        comment.toggle.linewise.count(vim.v.count > 0 and vim.v.count or 1)
    end,
    { desc = "Toggle comment line" })

U.keymap("v", "<leader>/", "<esc><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<cr>",
    { desc = "Toggle comment line" })

--------------------------------------------------------------------------------
-- Trouble

U.keymap("n", "<leader>xx", "<cmd>TroubleToggle<cr>", { desc = "Toggle Trouble" })
U.keymap("n", "<leader>xw", "<cmd>TroubleToggle workspace_diagnostics<cr>", { desc = "Workspace Trouble" })
U.keymap("n", "<leader>xd", "<cmd>TroubleToggle document_diagnostics<cr>", { desc = "Document Diagnostics" })
U.keymap("n", "<leader>xl", "<cmd>TroubleToggle loclist<cr>", { desc = "Trouble Loclist" })
U.keymap("n", "<leader>xq", "<cmd>TroubleToggle quickfix<cr>", { desc = "Trouble Quickfix" })
U.keymap("n", "gR", "<cmd>TroubleToggle lsp_references<cr>", { desc = "Trouble LSP References" })

--------------------------------------------------------------------------------
-- Visual Mode

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
