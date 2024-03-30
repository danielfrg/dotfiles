return {
    {
        "tpope/vim-fugitive",
        event = "User FilePost",
    },

    "tpope/vim-surround",

    { "nvim-tree/nvim-web-devicons", lazy = true },

    {
        "famiu/bufdelete.nvim",
        event = "VeryLazy"
    },

    {
        "christoomey/vim-tmux-navigator",
        event = "VeryLazy"
    },

    {
        "ThePrimeagen/harpoon",
        branch = "harpoon2",
        event = "VeryLazy",
        opts = {},
    },

    {
        "mbbill/undotree",
        event = "VeryLazy",
    },

    {
        "ThePrimeagen/vim-be-good",
        lazy = false
    },
}
