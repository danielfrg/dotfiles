return {
    {
        "williamboman/mason.nvim",
        -- event = "VeryLazy",
        cmd = { "Mason", "MasonInstall", "MasonUpdate" },
        keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
        build = ":MasonUpdate",

        config = function()
            require("mason").setup()
        end
    },
    {
        "williamboman/mason-lspconfig.nvim",
        event = "VeryLazy",
        dependencies = { "mason.nvim" },

        opts = function()
            return {
                -- https://github.com/williamboman/mason-lspconfig.nvim/blob/main/doc/server-mapping.md
                ensure_installed = {
                    -- Python
                    "pyright",
                    -- "pylsp",
                    "ruff_lsp",

                    -- Web
                    "astro",
                    "cssls",
                    "eslint",
                    "html",
                    "tailwindcss",
                    "tsserver",
                    "svelte",

                    -- Other
                    "terraformls",
                    "ansiblels",

                    -- Lua
                    "lua_ls",
                },
            }
        end,

        config = function(_, opts)
            require("mason-lspconfig").setup(opts)
        end
    }

}
