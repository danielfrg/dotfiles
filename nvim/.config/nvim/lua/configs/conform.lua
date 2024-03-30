-- Overwrite the nvchad defaults

local options = {
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
        async = true,
        lsp_fallback = true,
    },
}

require("conform").setup(options)
