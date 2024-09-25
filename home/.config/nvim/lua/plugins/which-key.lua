return {
    {
        "folke/which-key.nvim",
        event = "VimEnter",
        keys = { "<leader>", "<c-r>", "<c-w>", '"', "'", "`", "c", "v", "g" },
        cmd = "WhichKey",
        config = function(_, opts)
            local wk = require("which-key")
            wk.setup(opts)
            wk.add({
                { "<leader>c", group = "Code" },
                { "<leader>f", group = "Find" },
                { "<leader>g", group = "Git" },
                { "<leader>h", group = "Harpoon" },
                { "<leader>s", group = "Search" },
                { "<leader>x", group = "Trouble" },
                { "g",         group = "Goto" },
            })
        end,
    },
}
