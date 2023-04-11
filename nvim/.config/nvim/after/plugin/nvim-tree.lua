local status_ok, nvim_tree = pcall(require, "nvim-tree")
if not status_ok then
    return
end

local api = require("nvim-tree.api")

local M = {}

function M.on_attach(bufnr)
    api.config.mappings.default_on_attach(bufnr)

    -- your removals and mappings go here
    local opts = { buffer = bufnr, noremap = true, silent = true, nowait = true }

    vim.keymap.set('n', 'h', api.tree.toggle_help, opts)
    vim.keymap.set('n', '?', api.tree.toggle_help, opts)
    vim.keymap.set('n', 'p', M.print_node_path, opts)
end

function M.print_node_path()
    local node = api.tree.get_node_under_cursor()
end

nvim_tree.setup({
    on_attach = M.on_attach,
    disable_netrw = true,
    hijack_netrw = true,
    sort_by = "case_sensitive",
    renderer = {
        group_empty = true,
    },
    filters = {
        dotfiles = false,
        custom = { "^.git$" }
    },
    actions = {
        change_dir = {
            enable = false
        }
    },
    renderer = {
        highlight_git = true,
        root_folder_modifier = ":t",
        icons = {
            show = {
                file = true,
                folder = true,
                folder_arrow = true,
                git = true,
            },
            glyphs = {
                default = "",
                symlink = "",
                git = {
                    unstaged = "",
                    staged = "S",
                    unmerged = "",
                    renamed = "➜",
                    deleted = "",
                    untracked = "U",
                    ignored = "◌",
                },
                folder = {
                    default = "",
                    open = "",
                    empty = "",
                    empty_open = "",
                    symlink = "",
                },
            }
        }
    }
})

-- Open NvimTree on startup
-- local function open_nvim_tree()
--     api.tree.open()
-- end

-- vim.api.nvim_create_autocmd({ "VimEnter" }, { callback = open_nvim_tree })
