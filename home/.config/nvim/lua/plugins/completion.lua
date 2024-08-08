return {
    {
        "hrsh7th/nvim-cmp",
        -- priority = 100,
        event = "VeryLazy",

        dependencies = {
            "onsails/lspkind.nvim",
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-cmdline",

            {
                "L3MON4D3/LuaSnip",
                build = "make install_jsregexp"
            },

            "saadparwaiz1/cmp_luasnip",

            {
                "zbirenbaum/copilot.lua",
                opts = {
                    suggestion = { enabled = false },
                    panel = { enabled = false },
                },
            },
            {
                "zbirenbaum/copilot-cmp",
                config = function()
                    require("copilot_cmp").setup()
                end,
            },

            {
                {
                    "CopilotC-Nvim/CopilotChat.nvim",
                    branch = "canary",
                    dependencies = {
                        { "zbirenbaum/copilot.lua" }, -- or github/copilot.vim
                        { "nvim-lua/plenary.nvim" },  -- for curl, log wrapper
                    },
                    config = function()
                        require("CopilotChat").setup(
                            {
                                debug = true,
                            }
                        )

                        vim.api.nvim_create_user_command("CopilotQuickChat", function()
                            local input = vim.fn.input("Quick Chat: ")
                            if input ~= "" then
                                require("CopilotChat").ask(input, { selection = require("CopilotChat.select").buffer })
                            end
                        end, {})
                    end,
                },
            }
        },
        config = function()
            require("custom.completion")
        end,
    },
}
