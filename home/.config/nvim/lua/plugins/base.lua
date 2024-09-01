return {
    -- undo tree
    {
        "mbbill/undotree",
        event = "VeryLazy",
    },

    {
        "folke/persistence.nvim",
        event = "BufReadPre",
        opts = {},
        -- stylua: ignore
        keys = {
            { "<leader>qs", function() require("persistence").load() end,                desc = "Restore Session" },
            { "<leader>ql", function() require("persistence").load({ last = true }) end, desc = "Restore Last Session" },
            { "<leader>qd", function() require("persistence").stop() end,                desc = "Don't Save Current Session" },
        },
    },

    -- {
    --     "folke/persistence.nvim",
    --     event = "VeryLazy",
    --     -- event = "BufReadPre", -- this will only start session saving when an actual file was opened
    --     config = function()
    --         require("persistence").setup({
    --             dir = vim.fn.stdpath("state") .. "/sessions/", -- directory where session files are saved
    --             -- minimum number of file buffers that need to be open to save
    --             -- Set to 0 to always save
    --             need = 1,
    --             branch = true, -- use git branch to save session
    --         })

    --         -- load the session for the current directory
    --         vim.keymap.set("n", "<leader>qs", function() require("persistence").load() end)

    --         -- select a session to load
    --         vim.keymap.set("n", "<leader>qS", function() require("persistence").select() end)

    --         -- load the last session
    --         vim.keymap.set("n", "<leader>ql", function() require("persistence").load({ last = true }) end)

    --         -- stop Persistence => session won't be saved on exit
    --         vim.keymap.set("n", "<leader>qd", function() require("persistence").stop() end)
    --     end
    -- },

    -- {
    --     "nomnivore/ollama.nvim",
    --     opts = {
    --         model = "codestral:latest",
    --         url = "http://10.0.0.69:11434",
    --     },
    -- },

    -- Detect tabstop and shiftwidth automatically
    {
        "tpope/vim-sleuth",
        event = "VeryLazy",
    },

    {
        "tpope/vim-repeat",
        event = "VeryLazy",
    },

    {
        "tpope/vim-unimpaired",
        event = "VeryLazy",
    },

    -- fancy TODO comments
    {
        "folke/todo-comments.nvim",
        event = "VeryLazy",
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = { signs = false },
    },

    -- buffer delete event
    {
        "famiu/bufdelete.nvim",
        event = "VeryLazy",
    },

    -- tmux
    {
        "christoomey/vim-tmux-navigator",
        event = "VeryLazy",
    },

    -- learn vim
    {
        "ThePrimeagen/vim-be-good",
        cmd = "VimBeGood",
        lazy = true,
        -- event = "VeryLazy",
    },

    { "norcalli/nvim-colorizer.lua" },
}
