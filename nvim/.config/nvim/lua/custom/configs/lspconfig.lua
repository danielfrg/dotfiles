local config = require("plugins.configs.lspconfig")
local on_attach = config.on_attach
local capabilities = config.capabilities

local lspconfig = require("lspconfig")
local util = require("lspconfig.util")

lspconfig.pyright.setup({
    filetypes = { "python" },
    capabilities = capabilities,
    settings = {
        pyright = {
            -- Using Ruff's import organizer
            disableOrganizeImports = true,
        },
        python = {
            analysis = {
                -- Ignore all files for analysis to exclusively use Ruff for linting
                ignore = { '*' },
            },
        },
    },
})

lspconfig.ruff_lsp.setup {
    filetypes = { "python" },
    init_options = {
        settings = {
            -- Any extra CLI arguments for `ruff` go here.
            args = {},
        }
    },
    -- on_attach = on_attach,
    on_attach = function(client, bufnr)
        if client.name == 'ruff_lsp' then
            -- Disable hover in favor of Pyright
            client.server_capabilities.hoverProvider = false
        end
    end
}

lspconfig.tsserver.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    init_options = {
        preferences = {
            disableSuggestions = true,
        }
    }
}

lspconfig.gopls.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    cmd = { "gopls" },
    filetypes = { "go", "gomod", "gowork", "gotmpl" },
    root_dir = util.root_pattern("go.work", "go.mod", ".git"),
    settings = {
        gopls = {
            completeUnimported = true,
            usePlaceholders = true,
            analyses = {
                unsuedparams = true,
            }
        }
    }
}

-- Automatically run format on save
vim.api.nvim_create_autocmd({ "BufWritePost" }, {
    command = "FormatWriteLock"
})
