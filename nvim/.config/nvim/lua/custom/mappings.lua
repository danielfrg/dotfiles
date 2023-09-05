local M = {}

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
