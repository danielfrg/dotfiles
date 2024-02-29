local M = {}

M.abc = {
    n = {
        ["<C-s>"] = { "<cmd>w!<cr><esc>", "Save file" },
        ["<leader>s"] = { "<cmd>w!<cr><esc>", "Save file" },
        ["<leader>n"] = { "<cmd>enew<cr>", "New file" },
        ["<leader>e"] = { "<cmd> NvimTreeToggle<CR>" },

        -- Remove search highlights
        ["<Esc>"] = { ":noh<return><esc>" },
        ["<C-c>"] = { ":noh<return><esc>" },

        -- Manage Buffers
        ["<S-h>"] = { "<cmd>bprevious<cr>", "Prev buffer" },
        ["<S-l>"] = { "<cmd>bnext<cr>", "Next buffer" },
        ["[b"] = { "<cmd>bprevious<cr>", "Prev buffer" },
        ["]b"] = { "<cmd>bnext<cr>", "Next buffer" },
        ["<leader>b"] = { "<cmd>e #<cr>", "Switch to Last Buffer" },
        ["<leader>`"] = { "<cmd>e #<cr>", "Switch to Last Buffer" },
        ["<S-x>"] = { ":e #<CR>", "Switch to Last Buffer" },
        ["<leader>c"] = { "<cmd>Bdelete<cr>", "Close buffer" },

        -- keep cursor in the middle when searching
        ["n"] = { "nzzzv" },
        ["N"] = { "Nzzzv" },

        ["<leader>rr"] = { ":%s/<C-r><C-w>/<C-r><C-w>/gI<Left><Left><Left>", "Replace current word" },

        -- better move page up and down (keep cursor in the middle)
        ["<C-d>"] = { "<C-d>zz" },
        ["<C-u>"] = { "<C-u>zz" },

        -- yank to system clipboard
        ["<leader>y"] = { "\"+y" },
        ["<leader>Y"] = { "\"+Y" },

        -- Delete to void
        ["<leader>d"] = { "\"_d" },

        -- tmux sessionizer
        ["<C-f>"] = { "<cmd> silent !tmux neww tmux-sessionizer<CR>" },
        -- tmux navigation
        ["<C-h>"] = { "<cmd> TmuxNavigateLeft<CR>", "window left" },
        ["<C-l>"] = { "<cmd> TmuxNavigateRight<CR>", "window right" },
        ["<C-j>"] = { "<cmd> TmuxNavigateDown<CR>", "window down" },
        ["<C-k>"] = { "<cmd> TmuxNavigateUp<CR>", "window up" },

        -- Telescope
        ["<leader>ff"] = { "<cmd> Telescope find_files hidden=true<CR>", "Find files" },
    },
    i = {
        ["<Esc>"] = { "<Esc>l" },
    },
    v = {
        -- Move up or down selected lines
        ["J"] = { ":m '>+1<CR>gv=gv" },
        ["K"] = { ":m '<-2<CR>gv=gv" },
        -- yank to system clipboard
        ["<leader>y"] = { "\"+y" },
        -- Delete to void
        ["<leader>d"] = { "\"_d" },
    },
    x = {
        -- paste without changing current register
        ["<leader>p"] = { "\"_dP" }
    }
}

M.harpoon = {
    n = {
        ["<leader>a"] = {
            function()
                require("harpoon.mark").add_file()
            end,
            "Mark file"
        },
        ["<C-e>"] = {
            function()
                require('harpoon.ui').toggle_quick_menu()
            end,
            "Toggle UI"
        },
        ["<C-y>"] = {
            function()
                require('harpoon.ui').nav_file(1)
            end,
            "Go to file 1"
        },
        ["<C-u>"] = {
            function()
                require('harpoon.ui').nav_file(2)
            end,
            "Go to file 2"
        },
        ["<C-i>"] = {
            function()
                require('harpoon.ui').nav_file(3)
            end,
            "Go to file 2"
        },
        ["<C-o>"] = {
            function()
                require('harpoon.ui').nav_file(4)
            end,
            "Go to file 2"
        },
    }
}

M.plugins = {
    n = {
        ["<leader>u"] = { "<cmd>UndotreeToggle<CR>" }
    }
}

M.gopher = {
    plugin = true,
    n = {
        ["<leader>ger"] = {
            "<cmd> GoIfErr <CR>",
            "Go: Add If Err block"
        },
        ["<leader>gsj"] = {
            "<cmd> GoTagAdd json <CR>",
            "Go: Add json struct tags"
        },
        ["<leader>gsy"] = {
            "<cmd> GoTagAdd yaml <CR>",
            "Go: Add yaml struct tags"
        }
    }
}

return M
