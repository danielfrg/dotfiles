local plugins = {
    {
        "williamboman/mason.nvim",
        opts = {
            ensure_installed = {
                -- Python
                -- "black",
                "mypy",
                "pyright",
                -- "python-lsp-server",
                "ruff",
                "ruff-lsp",
                -- Javascript
                "eslint-lsp",
                "prettier",
                "typescript-language-server",
                "tailwindcss-language-server",
                "html-lsp",
                -- Other
                "terraform-ls",
            }

        }
    },
    {
        "neovim/nvim-lspconfig",
        config = function()
            require "plugins.configs.lspconfig"
            require "custom.configs.lspconfig"
        end,
    },
    {
        "mfussenegger/nvim-lint",
        event = "VeryLazy",
        config = function()
            require "custom.configs.lint"
        end,
    },
    {
        "mhartington/formatter.nvim",
        event = "VeryLazy",
        opts = function()
            return require "custom.configs.formatter"
        end
    },
    {
        "nvimtools/none-ls.nvim",
        ft = { "python", "go" },
        opts = function()
            return require "custom.configs.null-ls"
        end
    },
    {
        "nvim-treesitter/nvim-treesitter",
        opts = {
            ensure_installed = { "html", "css", "bash", "python" },
        },
    },
    {
        "ThePrimeagen/harpoon",
        branch = "harpoon2",
        event = "VeryLazy",
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
    -- Copied from NVChad and changed to point to cusotm configs
    {
        "nvim-tree/nvim-tree.lua",
        cmd = { "NvimTreeToggle", "NvimTreeFocus" },
        init = function()
            require("core.utils").load_mappings "nvimtree"
        end,
        opts = function()
            return require "custom.configs.nvimtree"
        end,
        config = function(_, opts)
            dofile(vim.g.base46_cache .. "nvimtree")
            require("nvim-tree").setup(opts)
        end,
    },
    -- {
    --     "olexsmir/gopher.nvim",
    --     ft = { "go" },
    --     config = function(_, opts)
    --         require("gopher").setup(opts)
    --         require("core.utils").load_mappings("gopher")
    --     end,
    --     build = function()
    --         vim.cmd [[silent! GoInstallDeps]]
    --     end,
    -- },
}

return plugins
