return {
    "nvimdev/dashboard-nvim",
    event = 'VimEnter',
    dependencies = {
        "nvim-tree/nvim-web-devicons",
    },

    opts = function()
        return {
            shortcut_type = "number",

            config = {
                header = {},
                shortcut = {
                    { desc = "new file ", key = 'n', action = function(path) vim.cmd('enew') end },
                    { desc = "quit ",     key = 'q', action = function(path) vim.cmd('q') end },
                },
                packages = { enable = false },
                project = { enable = false },
                mru = { limit = 15, cwd_only = true },
                footer = {},
                -- disable_move = true,
            }
        }
    end,

    config = function(_, opts)
        require('dashboard').setup(opts)
    end,
}
