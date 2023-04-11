-- It"s important to do this in order so we keep mason and lspconfig in th
-- same file
-- Based on: https://github.com/VonHeikemen/lsp-zero.nvim/blob/v2.x/doc/md/lsp.md#you-might-not-need-lsp-zero

local servers = {
    "astro",
    "eslint",
    "gopls",
    "jsonls",
    "html",
    "lua_ls",
    "marksman",
    "pyright",
    "ruby_ls",
    "svelte",
    "tailwindcss",
    "taplo",  --toml
    "terraformls",
    "tsserver",
    "yamlls",
}

local status_ok, lspconfig = pcall(require, "lspconfig")
if not status_ok then
    return
end

require('lspconfig.ui.windows').default_options.border = 'rounded'

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
    print("LSP attached")
    -- Disable formatting for tsserver, we use null-ls (prettier) instead
    if client.name == "tsserver" then
        client.server_capabilities.document_formatting = false
    end

    function diagnostic_goto(next, severity)
        local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
        severity = severity and vim.diagnostic.severity[severity] or nil
        return function()
            go({ severity = severity })
        end
    end

    -- Default ones from lspconfig
    vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = bufnr, buffer = bufnr, desc = "LSP: Hover" })
    -- vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = bufnr, desc = "LSP: Goto definition" })
    vim.keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<cr>", { buffer = bufnr, desc = "LSP: Goto [D]efinition" })
    vim.keymap.set("n", "gr", "<cmd>Telescope lsp_references<cr>", { buffer = bufnr, desc = "LSP: Telescope [R]eferences" })
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { buffer = bufnr, desc = "LSP: [G]oto [D]eclaration" })
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { buffer = bufnr, desc = "LSP: [G]oto [I]mplementation" })
    vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, { buffer = bufnr, desc = "LSP: [G]oto [T]ype definition" })
    vim.keymap.set("i", "gk", vim.lsp.buf.signature_help, { buffer = bufnr, desc = "LSP: Signature definition" })
    vim.keymap.set("n", "[d", vim.diagnostic.goto_next, { buffer = bufnr, desc = "LSP: Next diagnostic" })
    vim.keymap.set("n", "]d", vim.diagnostic.goto_prev, { buffer = bufnr, desc = "LSP: Prev diagnostic" })
    vim.keymap.set("n", "[e", diagnostic_goto(true, "ERROR"), { buffer = bufnr, desc = "LSP: Next [E]rror" })
    vim.keymap.set("n", "]e", diagnostic_goto(false, "ERROR"), { buffer = bufnr, desc = "LSP: Prev [E]rror" })
    vim.keymap.set("n", "[w", diagnostic_goto(true, "WARN"), { buffer = bufnr, desc = "LSP: Next [W]arning" })
    vim.keymap.set("n", "]w", diagnostic_goto(false, "WARN"), { buffer = bufnr, desc = "LSP: Prev [W]arning" })
    vim.keymap.set("n", "<leader>cd", vim.diagnostic.open_float, { buffer = bufnr, desc = "LSP: Line diagnostics" })
    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { buffer = bufnr, desc = "LSP: [C]ode [A]ctions" })
    vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, { buffer = bufnr, desc = "LSP: [R]ename" })
    vim.keymap.set("n", "<leader>cf", vim.lsp.buf.format, { buffer = bufnr, desc = "LSP: [F]ormat File" })
    -- vim.keymap.set("n", "<leader>vws", vim.lsp.buf.workspace_symbol, opts)

    -- Create a command `:Format` local to the LSP buffer
    vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
        vim.lsp.buf.format()
    end, { desc = 'LSP: Format current buffer' })
end

local lsp_capabilities = require("cmp_nvim_lsp").default_capabilities()

local get_servers = mason_lspconfig.get_installed_servers

mason_lspconfig.setup_handlers({
    function(server_name)
        lspconfig[server_name].setup({
            on_attach = lsp_attach,
            capabilities = lsp_capabilities,
        })
    end,
    -- Lua
    ["lua_ls"] = function()
        lspconfig.lua_ls.setup {
            settings = {
                Lua = {
                    diagnostics = {
                        globals = { "vim" }
                    }
                }
            },
            on_attach = lsp_attach,
            capabilities = lsp_capabilities,
        }
    end,
    -- YAML
    ["yamlls"] = function()
        -- TODO: Figure out how to call my lsp_attach from inside plugin on_attach
        local yamlconfig = require("yaml-companion").setup({})
        lspconfig["yamlls"].setup(yamlconfig)
    end
})

-- This is a fallback function for the setup_handlers in case it stops working
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
