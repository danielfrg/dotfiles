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
        ["<leader>y"] = { "\"+y", "Yank to clipboard" },
        ["<leader>Y"] = { "\"+Y", "Yank to clipboard" },

        -- paste without changing current register
        ["<leader>p"] = { "\"*p", "Paste from clipboard" },

        -- delete to void
        ["<leader>d"] = { "\"_d", "Delete to void" },

        -- tmux navigation
        -- ["<C-h>"] = { "<cmd> TmuxNavigateLeft<CR>", "window left" },
        -- ["<C-l>"] = { "<cmd> TmuxNavigateRight<CR>", "window right" },
        -- ["<C-j>"] = { "<cmd> TmuxNavigateDown<CR>", "window down" },
        -- ["<C-k>"] = { "<cmd> TmuxNavigateUp<CR>", "window up" },

        -- tmux sessionizer
        ["<C-f>"] = { "<cmd> silent !tmux neww tmux-sessionizer<CR>" },

        -- Telescope
        ["<leader>ff"] = { "<cmd> Telescope find_files hidden=true<CR>", "Find files" },

        -- LazyGit
        ["<leader>gg"] = { "<cmd>LazyGit<CR>", "Lazygit (root dir)" },
    },
    i = {
        ["<Esc>"] = { "<Esc>l" },
    },
    v = {
        -- Move up or down selected lines
        ["J"] = { ":m '>+1<CR>gv=gv", "Move lines up" },
        ["K"] = { ":m '<-2<CR>gv=gv", "Move lines down" },

        -- yank to system clipboard
        ["<leader>y"] = { "\"+y", "Yank to clipboard" },

        -- delete to void
        ["<leader>d"] = { "\"_d", "Delete to void" },
    },
}

M.harpoon = {
    n = {
        ["<leader>a"] = {
            function()
                local harpoon = require "harpoon"
                harpoon:list():append()
            end,
            "Add file to harpoon",
        },
        ["<C-e>"] = {
            function()
                local harpoon = require "harpoon"
                harpoon.ui:toggle_quick_menu(harpoon:list())
            end,
            "Toggle UI"
        },
        ["<C-h>"] = {
            function()
                local harpoon = require "harpoon"
                harpoon:list():select(1)
            end,
            "Go to file 1"
        },
        ["<C-j>"] = {
            function()
                local harpoon = require "harpoon"
                harpoon:list():select(2)
            end,
            "Go to file 2"
        },
        ["<C-k>"] = {
            function()
                local harpoon = require "harpoon"
                harpoon:list():select(3)
            end,
            "Go to file 3"
        },
        ["<C-l>"] = {
            function()
                local harpoon = require "harpoon"
                harpoon:list():select(4)
            end,
            "Go to file 4"
        },
        ["<C-S-P>"] = {
            function()
                local harpoon = require "harpoon"
                harpoon:list():prev()
            end,
            "Go to previous file"
        },
        ["<C-S-N>"] = {
            function()
                local harpoon = require "harpoon"
                harpoon:list():next()
            end,
            "Go to file next file"
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
