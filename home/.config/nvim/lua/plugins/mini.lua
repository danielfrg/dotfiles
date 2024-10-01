return {
    {
        'echasnovski/mini.nvim',
        version = '*',
        config = function()
            require('mini.align').setup()
            require('mini.pairs').setup()
            require('mini.surround').setup()
            require('mini.bracketed').setup()
        end,
    },
}
