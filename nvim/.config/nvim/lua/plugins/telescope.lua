return {
    {
        "nvim-telescope/telescope.nvim",
        event = 'VimEnter',
        cmd = "Telescope",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope-fzf-native.nvim",
            "nvim-treesitter/nvim-treesitter",
            "nvim-tree/nvim-web-devicons",
            enabled = vim.g.have_nerd_font
        },
        opts = function()
            return {
                defaults = {
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
                    file_previewer = require 'telescope.previewers'.vim_buffer_cat.new,
                    grep_previewer = require 'telescope.previewers'.vim_buffer_vimgrep.new,
                    qflist_previewer = require 'telescope.previewers'.vim_buffer_qflist.new,
                },
                extensions = {
                    file_browser = {
                        -- theme = "dropdown",
                        hijack_netrw = true,
                    },

                    -- native FZF support
                    fzf = {
                        fuzzy = true,                   -- false will only do exact matching
                        override_generic_sorter = true, -- override the generic sorter
                        override_file_sorter = true,    -- override the file sorter
                        case_mode = "smart_case",       -- "smart_case" or "ignore_case" or "respect_case"
                    }

                },
                extensions_list = {
                    "file_browser",
                    "fzf",
                },
            }
        end,
        config = function(_, opts)
            local telescope = require("telescope")
            telescope.setup(opts)

            local map = vim.keymap.set
            local builtin = require('telescope.builtin')

            map("n", "<leader><space>", "<cmd>Telescope find_files hidden=true<CR>", { desc = "Find Files" })
            map("n", "<leader>ff", "<cmd>Telescope find_files hidden=true<CR>", { desc = "Find Files" })
            map("n", "<leader>fF", "<cmd>Telescope find_files hidden=true cwd=false<CR>", { desc = "Find Files (cwd)" })
            map('n', '<leader>fw', builtin.grep_string, { desc = 'Find current [W]ord' })
            map('n', '<leader>fW', builtin.live_grep, { desc = 'Find current [W]ord' })
            -- map("n", '<leader><leader>', <cmd>Telescope buffers sort_mru=true sort_lastused=true<CR>, { desc = 'Find existing buffers' })
            map("n", "<leader>fb", "<cmd>Telescope buffers sort_mru=true sort_lastused=true<CR>", { desc = "Buffers" })
            map("n", "<leader>fg", "<cmd>Telescope git_files<CR>", { desc = "Find Files (git-files)" })
            map("n", "<leader>fo", "<cmd>Telescope oldfiles<CR>", { desc = "Recent/old Files" })
            map("n", "<leader>fr", "<cmd>Telescope oldfiles<CR>", { desc = "Recent/old Files" })
            map("n", "<leader>fc", "<cmd>Telescope<CR>", { desc = "Find Config File" })
            map("n", "<leader>:", "<cmd>Telescope command_history<CR>", { desc = "Command History" })
            map('n', '<leader>sk', builtin.keymaps, { desc = 'Find Keymaps' })

            -- File Browser
            map("n", "<space>fb", ":Telescope file_browser hidden=true<CR>")
            map("n", "<space>fB", ":Telescope file_browser path=%:p:h select_buffer=true hidden=true<CR>")

            -- Search
            map("n", "<leader>sc", "<cmd>Telescope command_history<cr>", { desc = "Command History" })
            map("n", "<leader>sC", "<cmd>Telescope commands<cr>", { desc = "Commands" })
            map("n", "<leader>sd", "<cmd>Telescope diagnostics bufnr=0<cr>", { desc = "Document Diagnostics" })
            map("n", "<leader>sD", "<cmd>Telescope diagnostics<cr>", { desc = "Workspace Diagnostics" })
            map("n", "<leader>sk", "<cmd>Telescope keymaps<cr>", { desc = "Key Maps" })
            -- map("n", "<leader>sb", "<cmd>Telescope current_buffer_fuzzy_find<cr>", { desc = "Buffer" })
            map('n', '<leader>/', function()
                -- You can pass additional configuration to Telescope to change the theme, layout, etc.
                builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
                    winblend = 10,
                    previewer = false,
                })
            end, { desc = '[/] Fuzzily search in current buffer' })

            -- Git
            map("n", "<leader>gc", "<cmd>Telescope git_commits<CR>", { desc = "Telescope Git commits" })
            map("n", "<leader>gs", "<cmd>Telescope git_status<CR>", { desc = "Telescope Git Status" })

            -- load extensions
            for _, ext in ipairs(opts.extensions_list) do
                telescope.load_extension(ext)
            end
        end,
    },

    {
        'nvim-telescope/telescope-fzf-native.nvim',

        -- `build` is used to run some command when the plugin is installed/updated.
        -- This is only run then, not every time Neovim starts up.
        build = 'make',

        -- `cond` is a condition used to determine whether this plugin should be
        -- installed and loaded.
        cond = function()
            return vim.fn.executable 'make' == 1
        end,
    },

    {
        "nvim-telescope/telescope-file-browser.nvim",
        event = "VeryLazy",
        dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" }
    },

    {
        'nvim-telescope/telescope-ui-select.nvim',
        event = "VeryLazy",
        dependencies = { "nvim-telescope/telescope.nvim" },
        config = function()
            require("telescope").setup {
                extensions = {
                    ["ui-select"] = {
                        require("telescope.themes").get_dropdown {}
                    }
                }
            }

            -- To get ui-select loaded and working with telescope, you need to call
            -- load_extension, somewhere after setup function:
            require("telescope").load_extension("ui-select")
        end
    }
}
