return {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    event = "VeryLazy",
    opts = {},

    config = function()
        local map = vim.keymap.set
        local harpoon = require("harpoon")

        map("n", "<leader>ha", function()
            harpoon:list():append()
        end, { desc = "[Harpoon] Add file to list" })
        map("n", "<C-e>", function()
            harpoon.ui:toggle_quick_menu(harpoon:list())
        end, { desc = "Toggle UI" })
        map("n", "<leader>h", function()
            harpoon:list():select(1)
        end, { desc = "[Harpoon] Go to file 1" })
        map("n", "<leader>j", function()
            harpoon:list():select(2)
        end, { desc = "[Harpoon] Go to file 2" })
        map("n", "<leader>k", function()
            harpoon:list():select(3)
        end, { desc = "[Harpoon] Go to file 3" })
        map("n", "<leader>l", function()
            harpoon:list():select(4)
        end, { desc = "[Harpoon] Go to file 4" })
        -- map("n", "<leader>hh", function()
        --   harpoon:list():select(1)
        -- end, { desc = "[Harpoon] Go to file 1" })
        -- map("n", "<leader>hj", function()
        --   harpoon:list():select(2)
        -- end, { desc = "[Harpoon] Go to file 2" })
        -- map("n", "<leader>hk", function()
        --   harpoon:list():select(3)
        -- end, { desc = "[Harpoon] Go to file 3" })
        -- map("n", "<leader>hl", function()
        --   harpoon:list():select(4)
        -- end, { desc = "[Harpoon] Go to file 4" })
        map("n", "<C-S-P>", function()
            harpoon:list():prev()
        end, { desc = "[Harpoon] Go to previous file" })
        map("n", "<C-S-N>", function()
            harpoon:list():next()
        end, { desc = "[Harpoon] Go to file next file" })
    end,
}
