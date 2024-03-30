-- Open the dashboard on the last buffer
vim.api.nvim_create_augroup("dashboard_on_empty", { clear = true })
vim.api.nvim_create_autocmd("User", {
    pattern = "BDeletePre *",
    group = "dashboard_on_empty",
    callback = function()
        local bufnr = vim.api.nvim_get_current_buf()
        local name = vim.api.nvim_buf_get_name(bufnr)

        if name == "" then
            vim.cmd([[:Dashboard]])
        end
    end,
})
