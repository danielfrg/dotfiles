vim.lsp.enable({
    "ruff",
    "pyright",
    "ts",
    "biome",
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
        map("n", "gl", vim.diagnostic.open_float, { desc = "LSP: Open Diagnostic Float" })
        map("n", "K", vim.lsp.buf.hover, { desc = "LSP: Hover Documentation" })
        map("n", "gD", vim.lsp.buf.definition, { desc = "Goto Declaration" })
        -- map("gs", vim.lsp.buf.signature_help, "Signature Documentation")
        -- map("<leader>la", vim.lsp.buf.code_action, "Code Action")
        map("n", "<leader>lr", vim.lsp.buf.rename, { desc = "LSP: Rename all references" })
        map("n", "<leader>lf", vim.lsp.buf.format, { desc = "LSP: Format" })
        -- map("<leader>v", "<cmd>vsplit | lua vim.lsp.buf.definition()<cr>", "Goto Definition in Vertical Split")

        local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
        if client:supports_method('textDocument/implementation') then
            -- Create a keymap for vim.lsp.buf.implementation ...
        end

        -- Auto-format on save
        local bufnr = args.buf
        if client.supports_method('textDocument/formatting') then
            vim.api.nvim_create_autocmd('BufWritePre', {
                group = vim.api.nvim_create_augroup('my.lsp.format_on_save', { clear = false }),
                buffer = bufnr,
                callback = function()
                    local format_logic = {
                        -- For typescript and javascript, prefer biome
                        typescript = 'biome',
                        typescriptreact = 'biome',
                        javascript = 'biome',
                        javascriptreact = 'biome',
                        -- For python, prefer ruff
                        python = 'ruff',
                    }

                    local filetype = vim.bo[bufnr].filetype
                    local preferred_formatter = format_logic[filetype]

                    vim.lsp.buf.format({
                        bufnr = bufnr,
                        filter = function(c)
                            if preferred_formatter then
                                return c.name == preferred_formatter
                            end
                            return true
                        end,
                        timeout_ms = 2000,
                    })
                end,
            })
        end
    end,
})
