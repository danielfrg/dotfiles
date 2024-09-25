--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
-- Try it with `yap` in normal mode
-- See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'Highlight when yanking (copying) text',
    group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
    callback = function()
        vim.highlight.on_yank()
    end,
})

-- Open the dashboard on the last buffer
-- vim.api.nvim_create_augroup("dashboard_on_empty", { clear = true })
-- vim.api.nvim_create_autocmd("User", {
--     pattern = "BDeletePre *",
--     group = "dashboard_on_empty",
--     callback = function()
--         local bufnr = vim.api.nvim_get_current_buf()
--         local name = vim.api.nvim_buf_get_name(bufnr)

--         if name == "" then
--             vim.cmd([[:Dashboard]])
--         end
--     end,
-- })
