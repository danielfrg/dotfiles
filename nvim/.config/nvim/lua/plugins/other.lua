return {
    {
        "nvim-tree/nvim-web-devicons",
        lazy = true
    },

    -- measure startuptime
    {
        "dstein64/vim-startuptime",
        cmd = "StartupTime",
        config = function()
            vim.g.startuptime_tries = 10
        end,
    },

    -- Detect tabstop and shiftwidth automatically
    {
        "tpope/vim-sleuth",
        event = "VeryLazy",
    },

    -- "gc" to comment visual regions/lines
    {
        "numToStr/Comment.nvim",
        event = "VeryLazy",
    },

    {
        "mbbill/undotree",
        event = "VeryLazy"
    },

    {
        "folke/todo-comments.nvim",
        event = "VeryLazy",
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = { signs = false }
    },

    {
        "famiu/bufdelete.nvim",
        event = "VeryLazy"
    },

    {
        "tpope/vim-fugitive",
        event = "VeryLazy",
    },

    { "tpope/vim-repeat" },

    {
        "tpope/vim-surround",
        event = "VeryLazy",
    },

    { "windwp/nvim-autopairs" }, -- autopairs
    {
        "andymass/vim-matchup",
        config = function()
            vim.api.nvim_set_hl(0, "OffScreenPopup",
                { fg = "#fe8019", bg = "#3c3836", italic = true })
            vim.g.matchup_matchparen_offscreen = {
                method = "popup",
                highlight = "OffScreenPopup"
            }
        end
    },
    { "wellle/targets.vim" }, -- adds more targets like [ or ,

    {
        "christoomey/vim-tmux-navigator",
        event = "VeryLazy"
    },

    {
        "ThePrimeagen/vim-be-good",
        event = "VeryLazy",
    },
}
