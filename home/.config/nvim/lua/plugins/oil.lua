return {
    {
        "stevearc/oil.nvim",
        event = "VeryLazy",

        dependencies = { "nvim-tree/nvim-web-devicons" },

        config = function()
            require("oil").setup({
                columns = { "icon" },
                delete_to_trash = false,
                -- Skip the confirmation popup for simple operations (:help oil.skip_confirm_for_simple_edits)
                skip_confirm_for_simple_edits = false,
                keymaps = {
                    ["<C-h>"] = false,
                    ["<M-h>"] = "actions.select_split",
                },
                view_options = {
                    show_hidden = true,
                },
                float = {
                    -- Padding around the floating window
                    padding = 10,
                }
            })

            -- Open parent directory in current window
            -- vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "[Oil] Open parent directory" })
            -- vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "[Oil] Open parent directory" })

            -- Open parent directory in floating window
            vim.keymap.set("n", "-", require("oil").toggle_float, { desc = "[Oil] Open parent directory" })
            -- vim.keymap.set("n", "<space>-", require("oil").toggle_float)
        end,
    },
}
