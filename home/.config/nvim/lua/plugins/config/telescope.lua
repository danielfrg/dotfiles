local open_with_trouble = false
local trouble_loaded, trouble = pcall(require, "trouble.sources.telescope")
if trouble_loaded then
    open_with_trouble = trouble.open
end

local actions = require("telescope.actions")

local border_chars_none = { " ", " ", " ", " ", " ", " ", " ", " " }

require("telescope").setup({
    defaults = {
        file_ignore_patterns = { "^.git/", "node_modules/*", },
        vimgrep_arguments = {
            "rg",
            "-L",
            "--color=never",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
            "--smart-case",
        },
        previewer = true,
        file_previewer = require("telescope.previewers").vim_buffer_cat.new,
        grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
        qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
        mappings = {
            i = { ["<c-t>"] = open_with_trouble },
            n = {
                ["d"] = require('telescope.actions').delete_buffer,
                ["q"] = require("telescope.actions").close,
                ["<c-t>"] = open_with_trouble
            },

        },
        -- borderchars = {
        --     prompt = border_chars_none,
        --     results = border_chars_none,
        --     preview = border_chars_none,
        -- },
    },

    pickers = {
        find_files = {
            hidden = true,
        },
        git_files = {
            hidden = true,
        },
    },

    extensions = {
        wrap_results = true,

        file_browser = {
            -- theme = "dropdown",
            -- hijack_netrw = true,
        },

        -- native FZF support
        fzf = {
            fuzzy = true,                   -- false will only do exact matching
            override_generic_sorter = true, -- override the generic sorter
            override_file_sorter = true,    -- override the file sorter
            case_mode = "smart_case",       -- "smart_case" or "ignore_case" or "respect_case"
        },

        ["ui-select"] = {
            require("telescope.themes").get_dropdown({}),
        },
    },
    extensions_list = {
        "file_browser",
        "fzf",
    },
})

pcall(require("telescope").load_extension, "fzf")
pcall(require("telescope").load_extension, "ui-select")
pcall(require("telescope").load_extension("git_file_history"))

local builtin = require("telescope.builtin")

vim.keymap.set('n', '<leader><leader>', builtin.find_files, { desc = '[ ] Search Files' })
vim.keymap.set('n', '<leader>sb', builtin.buffers, { desc = 'Seach [B]uffers' })
vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })

vim.keymap.set("n", "<leader>/", function()
    -- You can pass additional configuration to Telescope to change the theme, layout, etc.
    builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
        winblend = 10,
        previewer = false,
    }))
end, { desc = "Fuzzily search in current buffer" })

-- File Browser
-- vim.keymap.set(
--     "n",
--     "<space>fB",
--     ":Telescope file_browser hidden=true<CR>",
--     { desc = "File browser" }
-- )
-- vim.keymap.set(
--     "n",
--     "<space>fb",
--     ":Telescope file_browser path=%:p:h select_buffer=true hidden=true<CR>",
--     { desc = "File Browser (cwd)" }
-- )

-- Git
vim.keymap.set(
    "n",
    "<leader>gc",
    "<cmd>Telescope git_commits<CR>",
    { desc = "Telescope Git commits" }
)
vim.keymap.set(
    "n",
    "<leader>gs",
    "<cmd>Telescope git_status<CR>",
    { desc = "Telescope Git Status" }
)
