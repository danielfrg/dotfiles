vim.lsp.enable({
    "ruff",
    "pyright",
    "ts",
    "gopls",
})

vim.diagnostic.config({
    virtual_text = true,
    underline = true,
    update_in_insert = false,
    severity_sort = true,
    float = {
        border = "rounded",
        source = true,
    },
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = "󰅚 ",
            [vim.diagnostic.severity.WARN] = "󰀪 ",
            [vim.diagnostic.severity.INFO] = "󰋽 ",
            [vim.diagnostic.severity.HINT] = "󰌶 ",
        },
        numhl = {
            [vim.diagnostic.severity.ERROR] = "ErrorMsg",
            [vim.diagnostic.severity.WARN] = "WarningMsg",
        },
    },
})


vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('my.lsp', {}),
    callback = function(args)
        local map = vim.keymap.set

        -- defaults:
        -- https://neovim.io/doc/user/news-0.11.html#_defaults
        map("n", "gl", vim.diagnostic.open_float, { desc = "Open Diagnostic Float" })
        -- map("K", vim.lsp.buf.hover, "Hover Documentation")
        -- map("gs", vim.lsp.buf.signature_help, "Signature Documentation")
        -- map("gD", vim.lsp.buf.declaration, "Goto Declaration")
        -- map("<leader>la", vim.lsp.buf.code_action, "Code Action")
        -- map("<leader>lr", vim.lsp.buf.rename, "Rename all references")
        -- map("<leader>lf", vim.lsp.buf.format, "Format")
        -- map("<leader>v", "<cmd>vsplit | lua vim.lsp.buf.definition()<cr>", "Goto Definition in Vertical Split")

        local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
        if client:supports_method('textDocument/implementation') then
            -- Create a keymap for vim.lsp.buf.implementation ...
        end

        -- Auto-format ("lint") on save.
        -- Usually not needed if server supports "textDocument/willSaveWaitUntil".
        if not client:supports_method('textDocument/willSaveWaitUntil')
            and client:supports_method('textDocument/formatting') then
            vim.api.nvim_create_autocmd('BufWritePre', {
                group = vim.api.nvim_create_augroup('my.lsp', { clear = false }),
                buffer = args.buf,
                callback = function()
                    vim.lsp.buf.format({ bufnr = args.buf, id = client.id, timeout_ms = 1000 })
                end,
            })
        end
    end,
})
