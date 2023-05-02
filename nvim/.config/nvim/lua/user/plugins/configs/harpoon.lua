local status_ok, harpoon = pcall(require, "harpoon")
if not status_ok then return end

local mark = require("harpoon.mark")
local ui = require("harpoon.ui")

local U = require("user.utils")

U.keymap("n", "<leader>a", mark.add_file, { desc = "Harpoon: Add file to list" })
U.keymap("n", "<leader>h", ui.toggle_quick_menu, { desc = "Harpoon: Toogle menu" })

U.keymap("n", "<leader>j", function() ui.nav_prev() end, { desc = "Harpoon: Nav to next" })
U.keymap("n", "<leader>k", function() ui.nav_next() end, { desc = "Harpoon: Nav to prev" })
U.keymap("n", "<C-h>", function() ui.nav_file(1) end, { desc = "Harpoon: Nav to 1" })
U.keymap("n", "<C-j>", function() ui.nav_file(2) end, { desc = "Harpoon: Nav to 2" })
U.keymap("n", "<C-k>", function() ui.nav_file(3) end, { desc = "Harpoon: Nav to 3" })
U.keymap("n", "<C-l>", function() ui.nav_file(4) end, { desc = "Harpoon: Nav to 4" })
