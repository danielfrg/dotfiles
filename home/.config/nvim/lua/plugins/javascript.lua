return {
    {
        "brenoprata10/nvim-highlight-colors",
        event = "VeryLazy",
        config = function()
            require 'nvim-highlight-colors'.setup({
                render = 'virtual',
                enable_tailwind = true
            })
        end
    }
}
