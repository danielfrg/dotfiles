local ensure_installed = {
    -- Python
    "python",
    "ninja",
    "rst",
    "toml",

    -- Web
    "html",
    "css",
    "javascript",
    -- "jsx",
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
}

return {
    "nvim-treesitter/nvim-treesitter",
    event = "VeryLazy",
    build = ':TSUpdate',
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
        require('nvim-treesitter.configs').setup(opts)
    end
}
