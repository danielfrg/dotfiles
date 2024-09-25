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
            require("custom.lsp")
            require("custom.fmt")
        end,
    },
}
