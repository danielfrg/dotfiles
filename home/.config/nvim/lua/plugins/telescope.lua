return {
    {
        "nvim-telescope/telescope.nvim",
        event = "VeryLazy",
        lazy = false,

        cmd = "Telescope",

        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons",

            {
                "nvim-telescope/telescope-fzf-native.nvim",
                build = "make"
            },

            "nvim-telescope/telescope-smart-history.nvim",
            "nvim-telescope/telescope-ui-select.nvim",
            "kkharji/sqlite.lua",

            "isak102/telescope-git-file-history.nvim",
        },

        config = function()
            require "config.telescope"
        end,
    },
    {
        "nvim-telescope/telescope-file-browser.nvim",
        dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" }
    }
}
