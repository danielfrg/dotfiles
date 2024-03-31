return {
    "nvim-treesitter/nvim-treesitter",
    event = "VeryLazy",
    opts = {
        ensure_installed = {
            -- Python
            "python",
            "ninja",
            "rst",
            "toml",

            -- Web
            "html",
            "css",
            "javascript",
            "jsx",
            "typescript",
            "tsx",

            "markdown",
            "markdown_inline",
            "bash",
            "terraform",
            "yaml",

            -- nvim
            "vim",
            "lua",
        },
        indent = {
            enable = true,
            -- disable = {
            --   "python"
            -- },
        },
        highlight = {
            enable = true,
            use_languagetree = true,
        },
    },
}
