return {
    {
        "stevearc/conform.nvim",
        event = 'VeryLazy',

        opts = function()
            return {
                formatters_by_ft = {
                    python = { "ruff_format" },

                    javascript = { "prettier" },
                    javascriptreact = { "prettier" },
                    typescript = { "prettier" },
                    typescriptreact = { "prettier" },
                    css = { "prettier" },
                    html = { "prettier" },

                    terraform = { "terraform_fmt" },

                    lua = { "stylua" },

                    ["_"] = { "trim_whitespace" },
                },

                format_on_save = {
                    -- These options will be passed to conform.format()
                    timeout_ms = 500,
                    format_after_save = true,
                    lsp_fallback = true,
                },
            }
        end,

        config = function(_, opts)
            require("conform").setup(opts)

            local map = vim.keymap.set
            map("n", "<leader>cf", function()
                require("conform").format { lsp_fallback = true }
            end, { desc = "Format Files" })
        end,
    },
}
