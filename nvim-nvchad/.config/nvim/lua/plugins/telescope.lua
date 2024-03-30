return {
    {
        "nvim-telescope/telescope.nvim",
        dependencies = { "nvim-treesitter/nvim-treesitter" },
        event = "VeryLazy",
        cmd = "Telescope",
        init = function()
            local map = vim.keymap.set

            -- local builtin = require('telescope.builtin')
            map("n", "<leader><space>", "<cmd>Telescope find_files hidden=true<CR>", { desc = "Telescope Find files" })
            map("n", "<leader>ff", "<cmd>Telescope find_files hidden=true<CR>", { desc = "Find files" })
            map("n", "<leader>fF", "<cmd>Telescope find_files hidden=true cwd=false<CR>", { desc = "Find Files (cwd)" })
            -- map("n", "<leader>fb", "<cmd>Telescope buffers sort_mru=true sort_lastused=true<CR>", { desc = "Buffers" })
            map("n", "<leader>fg", "<cmd>Telescope git_files<CR>", { desc = "Find Files (git-files)" })
            map("n", "<leader>fo", "<cmd>Telescope oldfiles<CR>", { desc = "Recent/old Files" })
            map("n", "<leader>fr", "<cmd>Telescope oldfiles<CR>", { desc = "Recent/old Files" })
            map("n", "<leader>fc", "<cmd>Telescope<CR>", { desc = "Find Config File" })
            map("n", "<leader>:", "<cmd>Telescope command_history<CR>", { desc = "Command History" })

            -- File Browser
            map("n", "<space>fb", ":Telescope file_browser hidden=true<CR>", { desc = "Telescope File Browser" })
            map("n", "<space>fB", ":Telescope file_browser path=%:p:h select_buffer=true hidden=true<CR>",
                { desc = "Telescope File Browser (CWD)" })

            -- Search
            map("n", "<leader>sb", "<cmd>Telescope current_buffer_fuzzy_find<cr>", { desc = "Buffer" })
            map("n", "<leader>sc", "<cmd>Telescope command_history<cr>", { desc = "Command History" })
            map("n", "<leader>sC", "<cmd>Telescope commands<cr>", { desc = "Commands" })
            map("n", "<leader>sd", "<cmd>Telescope diagnostics bufnr=0<cr>", { desc = "Document Diagnostics" })
            map("n", "<leader>sD", "<cmd>Telescope diagnostics<cr>", { desc = "Workspace Diagnostics" })
            map("n", "<leader>sk", "<cmd>Telescope keymaps<cr>", { desc = "Key Maps" })

            -- Git
            map("n", "<leader>gc", "<cmd>Telescope git_commits<CR>", { desc = "Telescope Git commits" })
            map("n", "<leader>gs", "<cmd>Telescope git_status<CR>", { desc = "Telescope Git Status" })
        end,
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
                },
                extensions_list = {
                    "file_browser",
                },
            }
        end,
        config = function(_, opts)
            local telescope = require "telescope"
            telescope.setup(opts)

            -- load extensions
            for _, ext in ipairs(opts.extensions_list) do
                telescope.load_extension(ext)
            end
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
