-- It's important to do this in order so we keep mason and lspconfig in th
-- same file
-- Based on: https://github.com/VonHeikemen/lsp-zero.nvim/blob/v2.x/doc/md/lsp.md#you-might-not-need-lsp-zero

local servers = {
    'eslint',
    'jsonls',
    'lua_ls',
    'pyright',
    -- 'ruby_ls',
    'svelte',
    'tsserver',
    'yamlls',
}

local status_ok, lspconfig = pcall(require, "lspconfig")
if not status_ok then
    return
end

-- Lua
lspconfig.lua_ls.setup({
    settings = {
        Lua = {
            diagnostics = {
                globals = { 'vim' }
            }
        }
    }
})

-- YAML
function dump(o)
    if type(o) == 'table' then
       local s = '{ '
       for k,v in pairs(o) do
          if type(k) ~= 'number' then k = '"'..k..'"' end
          s = s .. '['..k..'] = ' .. dump(v) .. ','
       end
       return s .. '} '
    else
       return tostring(o)
    end
  end

------------------------------------------------
-- Mason Config

local mason = require("mason")
local mason_lspconfig = require("mason-lspconfig")
local settings = {
    ui = {
        border = "rounded",
        icons = {
            package_installed = "◍",
            package_pending = "◍",
            package_uninstalled = "◍",
        },
    },
    log_level = vim.log.levels.INFO,
    max_concurrent_installers = 4,
}

mason.setup(settings)
mason_lspconfig.setup({
    ensure_installed = servers,
    automatic_installation = false,
})

local lsp_attach = function(client, bufnr)
    -- Disable formatting for tsserver, we use null-ls (prettier) instead
    if client.name == "tsserver" then
        client.server_capabilities.document_formatting = false
    end

    local opts = { buffer = bufnr, remap = false }
    -- Default ones from lspconfig
    vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
    vim.keymap.set('n', '[d', vim.diagnostic.goto_next)
    vim.keymap.set('n', ']d', vim.diagnostic.goto_prev)
    vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)
    -- Extra
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
    vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
    vim.keymap.set("n", "gl", vim.diagnostic.open_float, opts)
    vim.keymap.set("n", "<leader>vws", vim.lsp.buf.workspace_symbol, opts)
    vim.keymap.set("n", "<leader>lj", vim.diagnostic.goto_next, opts)
    vim.keymap.set("n", "<leader>lk", vim.diagnostic.goto_prev, opts)
    vim.keymap.set("n", "<leader>la", vim.lsp.buf.code_action, opts)
    vim.keymap.set("n", "<leader>lr", vim.lsp.buf.rename, opts)
    vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help, opts)
end

local lsp_capabilities = require('cmp_nvim_lsp').default_capabilities()

local get_servers = mason_lspconfig.get_installed_servers

mason_lspconfig.setup_handlers({
    function(server_name)
        lspconfig[server_name].setup({
            on_attach = lsp_attach,
            capabilities = lsp_capabilities,
        })
    end,
})

-- This is a fallback for the setup_handlers in case it stops working
-- for _, server_name in ipairs(get_servers()) do
--     opts = {
--         on_attach = lsp_attach,
--         capabilities = lsp_capabilities,
--     }

--     -- Attach server specific config if exists
--     local require_ok, conf_opts = pcall(require, "danielfrg.lsp." .. server_name)
--     if require_ok then
--         opts = vim.tbl_deep_extend("force", conf_opts, opts)
--     end

--     lspconfig[server_name].setup(opts)
-- end

-- We have to attach this after the setup_handlers because
-- it has a custom on_attach
-- TODO: Figure out how to call my lsp_attach from inside plugin on_attach
local yamlconfig = require("yaml-companion").setup({})
lspconfig["yamlls"].setup(yamlconfig)


------------------------------------------------
-- LSP Configs

local signs = {
    { name = "DiagnosticSignError", text = "" },
    { name = "DiagnosticSignWarn",  text = "" },
    { name = "DiagnosticSignHint",  text = "" },
    { name = "DiagnosticSignInfo",  text = "" },
}

for _, sign in ipairs(signs) do
    vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
end

local config = {
    -- disable virtual text
    virtual_text = false,
    -- show signs
    signs = {
        active = signs,
    },
    update_in_insert = true,
    underline = true,
    severity_sort = true,
    float = {
        focusable = false,
        style = "minimal",
        border = "rounded",
        source = "always",
        header = "",
        prefix = "",
    },
}

vim.diagnostic.config(config)

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
    border = "rounded",
})

vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
    border = "rounded",
})
