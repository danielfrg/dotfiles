-- Files types that will format on save
local autoformat_filetypes = {
    "python",
    "javascript",
    "javascriptreact",
    "typescript",
    "typescriptreact",
    -- "go"
}

require("conform").setup({
    formatters_by_ft = {
        python = { "ruff_format" },
        cpp = { "clang_format" },
        javascript = { "prettier" },
        javascriptreact = { "prettier" },
        typescript = { "prettier" },
        typescriptreact = { "prettier" },
        css = { "prettier" },
        html = { "prettier" },
        terraform = { "terraform_fmt" },
        lua = { "stylua" },

        -- go = { "gofmt" },

        json = { "jq" },
        yaml = { "yamlfmt" },
        ["_"] = { "trim_whitespace" },
    },
    format_on_save = function(bufnr)
        if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
            return
        end

        -- Only format on save these file types
        local ft = vim.api.nvim_buf_get_option(bufnr, "filetype")
        if vim.tbl_contains(autoformat_filetypes, ft) then
            return {
                timeout_ms = 2000,
                lsp_format = "fallback",
            }
        end

        -- Return nil for all other filetypes to skip autoformat on save
        return nil
    end,
})

-- Format keybinding from second file
vim.keymap.set("n", "<leader>cf", function()
    require("conform").format({ lsp_fallback = true })
end, { desc = "Format Files" })

-- Common format disable/enable commands
vim.api.nvim_create_user_command("FormatDisable", function(args)
    if args.bang then
        -- FormatDisable! will disable formatting just for this buffer
        vim.b.disable_autoformat = true
    else
        vim.g.disable_autoformat = true
    end
end, {
    desc = "Disable autoformat-on-save",
    bang = true,
})

vim.api.nvim_create_user_command("FormatEnable", function()
    vim.b.disable_autoformat = false
    vim.g.disable_autoformat = false
end, {
    desc = "Re-enable autoformat-on-save",
})

-- Format command with range support from second file
vim.api.nvim_create_user_command("Format", function(args)
    local range = nil
    if args.count ~= -1 then
        local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
        range = {
            start = { args.line1, 0 },
            ["end"] = { args.line2, end_line:len() },
        }
    end
    require("conform").format({ async = true, lsp_format = "fallback", range = range })
end, { range = true })
