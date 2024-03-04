local overrides = require("custom.configs.overrides")

---@type NvPluginSpec[]
local plugins = {
    -- Overwrite nvchad plugins
    {
        "williamboman/mason.nvim",
        opts = overrides.mason,
    },
    {
        "neovim/nvim-lspconfig",
        config = function()
            require "plugins.configs.lspconfig"
            require "custom.configs.lspconfig"
        end,
    },
    {
        "nvim-tree/nvim-tree.lua",
        opts = overrides.nvimtree,
    },
    {
        "nvim-treesitter/nvim-treesitter",
        opts = overrides.treesitter,
    },
    {
        "nvim-telescope/telescope.nvim",
        opts = overrides.telescope,
    },

    -- Other plugins

    {
        "nvimtools/none-ls.nvim",
        ft = { "python", "go" },
        opts = function()
            return require "custom.configs.null-ls"
        end
    },
    {
        "mfussenegger/nvim-lint",
        event = "VeryLazy",
        config = function()
            require "custom.configs.lint"
        end,
    },
    {
        "stevearc/conform.nvim",
        event = "BufWritePre",
        config = function()
            require "custom.configs.conform"
        end,
    },
    {
        "ThePrimeagen/harpoon",
        branch = "harpoon2",
        lazy = false,
        opts = {},
    },
    {
        "mbbill/undotree",
        lazy = false,
    },
    {
        "folke/flash.nvim",
        cond = vim.g.vscode,
        event = "VeryLazy",
        ---@type Flash.Config
        opts = {},
        keys = {
            {
                "s",
                mode = { "n", "o", "x" },
                function()
                    require("flash").jump(
                        {
                            search = {
                                mode = function(str)
                                    return "\\<" .. str
                                end,
                            },
                        }
                    )
                end,
                desc = "Flash"
            },
            { "S", mode = { "n", "o", "x" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
            { "r", mode = "o",               function() require("flash").remote() end,     desc = "Remote Flash" },
            {
                "R",
                mode = { "o", "x" },
                function() require("flash").treesitter_search() end,
                desc =
                "Treesitter Search"
            },
            {
                "<c-s>",
                mode = { "c" },
                function() require("flash").toggle() end,
                desc =
                "Toggle Flash Search"
            },
        },
    },
    {
        "christoomey/vim-tmux-navigator",
        lazy = false
    },
    {
        "ThePrimeagen/vim-be-good",
        lazy = false
    }
}

return plugins
