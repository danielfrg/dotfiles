return {
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            {
                "folke/lazydev.nvim",
                ft = "lua", -- only load on lua files
                opts = {
                  library = {
                    -- See the configuration section for more details
                    -- Load luvit types when the `vim.uv` word is found
                    { path = "${3rd}/luv/library", words = { "vim%.uv" } },
                  },
                },
              },
        },

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
