return {
    {
        'echasnovski/mini.nvim',
        event = "VeryLazy",
        version = '*',
        config = function()
            require('mini.pairs').setup()

            -- Add/delete/replace surroundings (brackets, quotes, etc.)
            --
            -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
            -- - sd"   - [S]urround [D]elete ["]quotes
            -- - sr)"  - [S]urround [R]eplace [)] ["]
            require('mini.surround').setup()

            require('mini.bracketed').setup()
            require("mini.comment").setup()
        end,
    },
}
