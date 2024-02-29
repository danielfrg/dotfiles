--type conform.options
local options = {
    lsp_fallback = true,

    formatters_by_ft = {
        python = { "ruff_format" },

        javascript = { "prettier" },
        css = { "prettier" },
        html = { "prettier" },

        ["_"] = { "trim_whitespace" },
    },

    format_on_save = {
        -- These options will be passed to conform.format()
        timeout_ms = 500,
        lsp_fallback = true,
    },
}

require("conform").setup(options)
