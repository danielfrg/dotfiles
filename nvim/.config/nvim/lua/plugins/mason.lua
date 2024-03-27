return {
    {
        "williamboman/mason.nvim",
        keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
        build = ":MasonUpdate",
        opts = {
            ensure_installed = {
                -- Python
                -- "black",
                "mypy",
                "pyright",
                -- "python-lsp-server",
                "ruff",
                "ruff-lsp",

                -- Web
                "css-lsp",
                "eslint-lsp",
                "html-lsp",
                "prettier",
                "tailwindcss-language-server",
                "typescript-language-server",

                -- Other
                "terraform-ls",

                -- Lua
                "lua-language-server",
                "stylua",
            },
        },
    }
}
