return {
    {
        "nvim-telescope/telescope.nvim",
        event = "VeryLazy",

        cmd = "Telescope",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons",

            {
                "nvim-telescope/telescope-fzf-native.nvim",
                build = "make"
            },

            {
                "nvim-telescope/telescope-file-browser.nvim"
            },

            "nvim-telescope/telescope-smart-history.nvim",
            "nvim-telescope/telescope-ui-select.nvim",
            "kkharji/sqlite.lua",
        },

        config = function()
            require "custom.telescope"
        end,
    },
}
