return {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    event = "VeryLazy",
    opts = {},

    config = function()
        local map = vim.keymap.set
        local harpoon = require("harpoon")

        map("n", "<leader>a", function() harpoon:list():append() end, { desc = "Add file to harpoon" })
        map("n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = "Toggle UI" })
        map("n", "<C-h>", function() harpoon:list():select(1) end, { desc = "Go to file 1" })
        map("n", "<C-j>", function() harpoon:list():select(2) end, { desc = "Go to file 2" })
        map("n", "<C-k>", function() harpoon:list():select(3) end, { desc = "Go to file 3" })
        map("n", "<C-l>", function() harpoon:list():select(4) end, { desc = "Go to file 4" })
        map("n", "<leader>hh", function() harpoon:list():select(1) end, { desc = "Go to file 1" })
        map("n", "<leader>hj", function() harpoon:list():select(2) end, { desc = "Go to file 2" })
        map("n", "<leader>hk", function() harpoon:list():select(3) end, { desc = "Go to file 3" })
        map("n", "<leader>hl", function() harpoon:list():select(4) end, { desc = "Go to file 4" })
        map("n", "<C-S-P>", function() harpoon:list():prev() end, { desc = "Go to previous file" })
        map("n", "<C-S-N>", function() harpoon:list():next() end, { desc = "Go to file next file" })
    end
}
