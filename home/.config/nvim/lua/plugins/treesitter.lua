local ensure_installed = {
    -- Python
    "python",
    "ninja",
    "rst",
    "toml",

    -- C/C++
    "c",
    "cpp",

    -- Web
    "astro",
    "html",
    "css",
    "javascript",
    -- "jsx",
    "typescript",
    "tsx",

    "bash",
    "just",
    "markdown",
    "markdown_inline",
    "terraform",
    "yaml",

    -- nvim
    "vim",
    "lua",
}

return {
    {
        "nvim-treesitter/nvim-treesitter",
        event = "VimEnter",
        build = ":TSUpdate",
        opts = {
            ensure_installed = ensure_installed,
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

        config = function(_, opts)
            require("nvim-treesitter.configs").setup(opts)
        end
    },

    {
        "nvim-treesitter/nvim-treesitter-context",
        event = "VeryLazy",
    },
}
