return {
    -- undo tree
    {
        "mbbill/undotree",
        event = "VeryLazy",
        keys = {
            { "<leader>u", "<cmd>UndotreeToggle<CR>", desc = "Open undotree" },
        }
    },

    -- Detect tabstop and shiftwidth automatically
    { 'tpope/vim-sleuth' },
}
