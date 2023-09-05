local M = {}

M.abc = {
    n = {
        ["<C-s>"] = { "<cmd>w!<cr><esc>", "Save file" },
        ["<leader>n"] = { "<cmd>enew<cr>", "[N]ew file" },
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
    },
    i = {
        ["<Esc>"] = { "<Esc>l" },
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
