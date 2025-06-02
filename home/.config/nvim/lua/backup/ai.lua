local function has_node()
    return vim.fn.executable("node") == 1
end

return {
    -- {
    --     "zbirenbaum/copilot.lua",
    --     cmd = "Copilot",
    --     event = "VeryLazy",
    --     cond = has_node, -- Only load if node is available
    --     config = function()
    --         require("copilot").setup({
    --             suggestion = { enabled = false },
    --             panel = { enabled = false },
    --         })
    --     end,
    -- },

    -- {
    --     "olimorris/codecompanion.nvim",
    --     dependencies = {
    --         "nvim-lua/plenary.nvim",
    --         "nvim-treesitter/nvim-treesitter",
    --     },
    --     config = function()
    --         require("config.ai")
    --     end,
    -- },
}
