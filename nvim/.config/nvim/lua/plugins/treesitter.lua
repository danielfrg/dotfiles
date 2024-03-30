return {
    "nvim-treesitter/nvim-treesitter",
    event = "VeryLazy",
    opts = {
        ensure_installed = {
            "bash",
            "python",
            "html",
            "css",
            "javascript",
            "typescript",
            "tsx",
            "markdown",
            "markdown_inline",
            "terraform",
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
