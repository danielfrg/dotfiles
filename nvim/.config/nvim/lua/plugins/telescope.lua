return {
    {
        "nvim-telescope/telescope.nvim",
        event = "VeryLazy",

        cmd = "Telescope",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons",

            {
                "nvim-telescope/telescope-fzf-native.nvim",
                build = "make"
            },

            {
                "nvim-telescope/telescope-file-browser.nvim"
            },

            "nvim-telescope/telescope-smart-history.nvim",
            "nvim-telescope/telescope-ui-select.nvim",
            "kkharji/sqlite.lua",
        },

        opts = function()
            return {
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
                    file_previewer = require "telescope.previewers".vim_buffer_cat.new,
                    grep_previewer = require "telescope.previewers".vim_buffer_vimgrep.new,
                    qflist_previewer = require "telescope.previewers".vim_buffer_qflist.new,
                },
                pickers = {
                    live_grep = {
                        additional_args = function(opts)
                            return { "--hidden" }
                        end
                    },
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

        config = function()
            require "custom.telescope"
        end,
    },
}
