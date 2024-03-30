return {
    {
        "kdheepak/lazygit.nvim",
        cmd = {
            "LazyGit",
            "LazyGitConfig",
            "LazyGitCurrentFile",
            "LazyGitFilter",
            "LazyGitFilterCurrentFile",
        },
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        init = function()
            local map = vim.keymap.set

            map("n", "<leader>gg", "<cmd>LazyGit<CR>", { desc = "Lazygit (root dir)" })
        end
    }
}
