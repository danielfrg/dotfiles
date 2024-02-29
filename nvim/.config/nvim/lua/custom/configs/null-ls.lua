local null_ls = require("null-ls")

local augroup = vim.api.nvim_create_augroup("LSPFormatting", {})

local opts = {
    sources = {
        -- Python
        -- null_ls.builtins.formatting.ruff,  -- Using conform now
        null_ls.builtins.diagnostics.mypy,
        null_ls.builtins.diagnostics.ruff,

        -- Go
        -- null_ls.builtins.formatting.gofmt,
        -- null_ls.builtins.formatting.golines,
        -- null_ls.builtins.formatting.goimports_reviser,
    },
}

return opts
