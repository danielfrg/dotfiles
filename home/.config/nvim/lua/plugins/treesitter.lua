local ensure_installed = {
    -- Python
    "python",
    "ninja",

    -- C/C++
    "c",
    "cpp",

    -- Web
    "astro",
    "html",
    "css",
    "javascript",
    "typescript",
    "tsx",

    -- nvim
    "vim",
    "lua",

    -- general
    "bash",
    "just",
    "markdown",
    "markdown_inline",
    "rst",
    "toml",
    "terraform",
    "yaml",
}

return {
    {
        "nvim-treesitter/nvim-treesitter",
        branch = "main",
        lazy = false,
        -- event  = "VeryLazy",
        build  = ":TSUpdate",
        opts   = {
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
        -- config = function(_, opts)
        --     require("nvim-treesitter.configs").setup(opts)
        -- end
    },

    {
        "nvim-treesitter/nvim-treesitter-context",
        event = "VeryLazy",
    },

    {
        "MeanderingProgrammer/treesitter-modules.nvim",
        dependencies = { "nvim-treesitter/nvim-treesitter" },
        event = "VeryLazy",
        opts = {
            ensure_installed = ensure_installed,
            incremental_selection = {
                enable = true,
                keymaps = {
                    init_selection = "<A-o>",
                    node_incremental = "<A-o>",
                    scope_incremental = "<A-O>",
                    node_decremental = "<A-i>",
                },
            },
        },
    },
}
