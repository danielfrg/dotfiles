return {
    {
        "neovim/nvim-lspconfig",
        event = "VimEnter",

        dependencies = {
            { "j-hui/fidget.nvim", opts = {} },

            -- Autoformatting
            "stevearc/conform.nvim",

            -- Schema information
            -- "b0o/SchemaStore.nvim",
        },
        config = function()
            require("config.lsp")
            require("config.fmt")
        end,
    },
}
