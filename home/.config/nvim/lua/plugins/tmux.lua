vim.g.tmux_navigator_no_mappings = 1


return {
    "christoomey/vim-tmux-navigator",
    event = "VeryLazy",
    cmd = {
        "TmuxNavigateLeft",
        "TmuxNavigateDown",
        "TmuxNavigateUp",
        "TmuxNavigateRight",
        "TmuxNavigatePrevious",
    },
    keys = {
        { "<M-h>", "<cmd>TmuxNavigateLeft<cr>" },
        { "<M-j>", "<cmd>TmuxNavigateDown<cr>" },
        { "<M-k>", "<cmd>TmuxNavigateUp<cr>" },
        { "<M-l>", "<cmd>TmuxNavigateRight<cr>" },
        -- { "<M-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
    },
}
