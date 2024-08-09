local data = assert(vim.fn.stdpath("data")) --[[@as string]]

local actions = require("telescope.actions")
local open_with_trouble = require("trouble.sources.telescope").open

require("telescope").setup({
    defaults = {
        file_ignore_patterns = { ".git/" },
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
            n = { ["<c-t>"] = open_with_trouble },
        },
    },
    pickers = {
        live_grep = {
            additional_args = function(opts)
                return { "--hidden" }
            end,
        },
    },
    extensions = {
        wrap_results = true,

        file_browser = {
            -- theme = "dropdown",
            hijack_netrw = true,
        },

        -- native FZF support
        fzf = {
            fuzzy = true,             -- false will only do exact matching
            override_generic_sorter = true, -- override the generic sorter
            override_file_sorter = true, -- override the file sorter
            case_mode = "smart_case", -- "smart_case" or "ignore_case" or "respect_case"
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
-- pcall(require("telescope").load_extension, "smart_history")
pcall(require("telescope").load_extension, "ui-select")

local builtin = require("telescope.builtin")

vim.keymap.set(
    "n",
    "<leader><space>",
    "<cmd>Telescope find_files hidden=true<CR>",
    { desc = "Find Files" }
)
vim.keymap.set(
    "n",
    "<leader>ff",
    "<cmd>Telescope resume<CR>",
    { desc = "Find (resume) previous search" }
)
vim.keymap.set(
    "n",
    "<leader>ff",
    "<cmd>Telescope find_files hidden=true<CR>",
    { desc = "Find Files" }
)
vim.keymap.set(
    "n",
    "<leader>fF",
    "<cmd>Telescope find_files hidden=true cwd=false<CR>",
    { desc = "Find Files (cwd)" }
)
vim.keymap.set(
    "n",
    "<leader>fw",
    "<cmd>Telescope live_grep hidden=true<CR>",
    { desc = "Find grep" }
)
vim.keymap.set(
    "n",
    "<leader>fW",
    "<cmd>Telescope grep_string hidden=true cwd=false<CR>",
    { desc = "Find current [W]ord" }
)
-- vim.keymap.set("n", "<leader><leader>", <cmd>Telescope buffers sort_mru=true sort_lastused=true<CR>, { desc = "Find existing buffers" })
-- vim.keymap.set("n", "<leader>fb", "<cmd>Telescope buffers sort_mru=true sort_lastused=true<CR>", { desc = "Buffers" })
vim.keymap.set(
    "n",
    "<leader>fg",
    "<cmd>Telescope git_files<CR>",
    { desc = "Find Files (git-files)" }
)
vim.keymap.set("n", "<leader>fo", "<cmd>Telescope oldfiles<CR>", { desc = "Recent/old Files" })
vim.keymap.set("n", "<leader>fr", "<cmd>Telescope oldfiles<CR>", { desc = "Recent/old Files" })
vim.keymap.set("n", "<leader>fc", builtin.commands, { desc = "Find Command" })
vim.keymap.set("n", "<leader>:", "<cmd>Telescope command_history<CR>", { desc = "Command History" })
vim.keymap.set("n", "<leader>sk", builtin.keymaps, { desc = "Find Keymaps" })
vim.keymap.set("n", "<space>fh", builtin.help_tags, { desc = "Find Help tags" })

-- File Browser
vim.keymap.set(
    "n",
    "<space>fB",
    ":Telescope file_browser hidden=true<CR>",
    { desc = "File browser" }
)
vim.keymap.set(
    "n",
    "<space>fb",
    ":Telescope file_browser path=%:p:h select_buffer=true hidden=true<CR>",
    { desc = "File Browser (cwd)" }
)

-- Search
vim.keymap.set(
    "n",
    "<leader>sc",
    "<cmd>Telescope command_history<cr>",
    { desc = "Command History" }
)
vim.keymap.set("n", "<leader>sC", "<cmd>Telescope commands<cr>", { desc = "Commands" })
vim.keymap.set(
    "n",
    "<leader>sd",
    "<cmd>Telescope diagnostics bufnr=0<cr>",
    { desc = "Document Diagnostics" }
)
vim.keymap.set(
    "n",
    "<leader>sD",
    "<cmd>Telescope diagnostics<cr>",
    { desc = "Workspace Diagnostics" }
)
vim.keymap.set("n", "<leader>sk", "<cmd>Telescope keymaps<cr>", { desc = "Key Maps" })
vim.keymap.set("n", "<leader>/", function()
    -- You can pass additional configuration to Telescope to change the theme, layout, etc.
    builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
        winblend = 10,
        previewer = false,
    }))
end, { desc = "Fuzzily search in current buffer" })

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

-- -- load extensions
-- for _, ext in ipairs(opts.extensions_list) do
--     telescope.load_extension(ext)
-- end
