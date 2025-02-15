return {
    {
        "lewis6991/gitsigns.nvim",
        event = "VeryLazy",
        config = function()
            require('gitsigns').setup()
        end
    },

    {
        "tpope/vim-fugitive",
        event = "VeryLazy",
        config = function() end,
    }
}
