return {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = {
        "nvim-tree/nvim-web-devicons"
    },

    opts = {
        options = {
            close_command = function(n) require("mini.bufremove").delete(n, false) end,
            right_mouse_command = function(n) require("mini.bufremove").delete(n, false) end,
            always_show_bufferline = true,
            show_buffer_icons = false,
            separator_style = "thick" -- | "slope" | "thick" | "thin" | { "any", "any" },
            -- diagnostics = "nvim_lsp",
            -- indicator = {
            --     style = "underline"
            -- },
        },
        highlights = {
            -- buffline: [tab][sep][tab]fill-background
            -- [tab]: [indicator-buffer(visible|selected)-close(selected)]

            fill = {
                fg = "#7B7970",
                bg = "#16161E",
            },
            -- background = {
            --     fg = "#ff0000",
            --     bg = "#ff0000",
            -- },
            -- tab = {
            --     fg = "#ff0000",
            --     bg = "#ff0000",
            -- },
            -- tab_selected = {
            --     fg = "#ff0000",
            --     bg = "#ff0000",
            -- },
            -- tab_separator = {
            --     fg = "#ff0000",
            --     bg = "#ff0000",
            -- },
            -- tab_separator_selected = {
            --     fg = "#ff0000",
            --     bg = "#ff0000",
            --     sp = "#ff0000",
            --     underline = "#ff0000",
            -- },
            -- tab_close = {
            --     fg = "#ff0000",
            --     bg = "#ff0000",
            -- },
            close_button = {
                fg = "#7B7970",
                bg = "#16161E",
            },
            close_button_visible = {
                fg = "#7B7970",
                bg = "#16161E",
            },
            close_button_selected = {
                fg = "#DCD7BB",
                bg = "#363646",
            },
            buffer_visible = {
                fg = "#DCD7BB",
                bg = "#363646",
            },
            buffer_selected = {
                fg = "#DCD7BB",
                bg = "#363646",
                -- bold = true,
                -- italic = false,
            },
            -- numbers = {
            --     fg = "#ff0000",
            --     bg = "#ff0000",
            -- },
            -- numbers_visible = {
            --     fg = "#ff0000",
            --     bg = "#ff0000",
            -- },
            -- numbers_selected = {
            --     fg = "#ff0000",
            --     bg = "#ff0000",
            --     bold = true,
            --     italic = true,
            -- },
            -- diagnostic = {
            --     fg = "#ff0000",
            --     bg = "#ff0000",
            -- },
            -- diagnostic_visible = {
            --     fg = "#ff0000",
            --     bg = "#ff0000",
            -- },
            -- diagnostic_selected = {
            --     fg = "#ff0000",
            --     bg = "#ff0000",
            --     bold = true,
            --     italic = true,
            -- },
            -- hint = {
            --     fg = "#ff0000",
            --     sp = "#ff0000",
            --     bg = "#ff0000",
            -- },
            -- hint_visible = {
            --     fg = "#ff0000",
            --     bg = "#ff0000",
            -- },
            -- hint_selected = {
            --     fg = "#ff0000",
            --     bg = "#ff0000",
            --     sp = "#ff0000",
            --     bold = true,
            --     italic = true,
            -- },
            -- hint_diagnostic = {
            --     fg = "#ff0000",
            --     sp = "#ff0000",
            --     bg = "#ff0000",
            -- },
            -- hint_diagnostic_visible = {
            --     fg = "#ff0000",
            --     bg = "#ff0000",
            -- },
            -- hint_diagnostic_selected = {
            --     fg = "#ff0000",
            --     bg = "#ff0000",
            --     sp = "#ff0000",
            --     bold = true,
            --     italic = true,
            -- },
            -- info = {
            --     fg = "#ff0000",
            --     sp = "#ff0000",
            --     bg = "#ff0000",
            -- },
            -- info_visible = {
            --     fg = "#ff0000",
            --     bg = "#ff0000",
            -- },
            -- info_selected = {
            --     fg = "#ff0000",
            --     bg = "#ff0000",
            --     sp = "#ff0000",
            --     bold = true,
            --     italic = true,
            -- },
            -- info_diagnostic = {
            --     fg = "#ff0000",
            --     sp = "#ff0000",
            --     bg = "#ff0000",
            -- },
            -- info_diagnostic_visible = {
            --     fg = "#ff0000",
            --     bg = "#ff0000",
            -- },
            -- info_diagnostic_selected = {
            --     fg = "#ff0000",
            --     bg = "#ff0000",
            --     sp = "#ff0000",
            --     bold = true,
            --     italic = true,
            -- },
            -- warning = {
            --     fg = "#ff0000",
            --     sp = "#ff0000",
            --     bg = "#ff0000",
            -- },
            -- warning_visible = {
            --     fg = "#ff0000",
            --     bg = "#ff0000",
            -- },
            -- warning_selected = {
            --     fg = "#ff0000",
            --     bg = "#ff0000",
            --     sp = "#ff0000",
            --     bold = true,
            --     italic = true,
            -- },
            -- warning_diagnostic = {
            --     fg = "#ff0000",
            --     sp = "#ff0000",
            --     bg = "#ff0000",
            -- },
            -- warning_diagnostic_visible = {
            --     fg = "#ff0000",
            --     bg = "#ff0000",
            -- },
            -- warning_diagnostic_selected = {
            --     fg = "#ff0000",
            --     bg = "#ff0000",
            --     sp = "#ff0000",
            --     bold = true,
            --     italic = true,
            -- },
            -- error = {
            --     fg = "#ff0000",
            --     bg = "#ff0000",
            --     sp = "#ff0000",
            -- },
            -- error_visible = {
            --     fg = "#ff0000",
            --     bg = "#ff0000",
            -- },
            -- error_selected = {
            --     fg = "#ff0000",
            --     bg = "#ff0000",
            --     sp = "#ff0000",
            --     bold = true,
            --     italic = true,
            -- },
            -- error_diagnostic = {
            --     fg = "#ff0000",
            --     bg = "#ff0000",
            --     sp = "#ff0000",
            -- },
            -- error_diagnostic_visible = {
            --     fg = "#ff0000",
            --     bg = "#ff0000",
            -- },
            -- error_diagnostic_selected = {
            --     fg = "#ff0000",
            --     bg = "#ff0000",
            --     sp = "#ff0000",
            --     bold = true,
            --     italic = true,
            -- },
            modified = {
                -- fg = "#7B7970",
                bg = "#16161E",
            },
            modified_visible = {
                -- fg = "#7B7970",
                bg = "#16161E",
            },
            modified_selected = {
                -- fg = "#DCD7BB",
                bg = "#363646",
            },
            duplicate_selected = {
                fg = "#DCD7BB",
                bg = "#363646",
                italic = true,
            },
            duplicate_visible = {
                -- fg = "#DCD7BB",
                bg = "#16161E",
                italic = true,
            },
            duplicate = {
                -- fg = "#DCD7BB",
                bg = "#16161E",
                italic = true,
            },
            separator = {
                fg = "#16161E",
                bg = "#16161E",
            },
            -- separator_selected = {
            --     fg = "#ff0000",
            --     bg = "#ff0000",
            -- },
            -- separator_visible = {
            --     fg = "#ff0000",
            --     bg = "#ff0000",
            -- },
            indicator_visible = {
                fg = "#16161E",
                bg = "#16161E",
            },
            indicator_selected = {
                fg = "#363646",
                bg = "#363646",
            },

            -- In captpuccin this generates a border
            -- indicator_selected = {
            --     fg = "#1E1E2F",
            --     bg = "#1E1E2F",
            -- },

            -- pick_selected = {
            --     fg = "#ff0000",
            --     bg = "#ff0000",
            --     bold = true,
            --     italic = true,
            -- },
            -- pick_visible = {
            --     fg = "#ff0000",
            --     bg = "#ff0000",
            --     bold = true,
            --     italic = true,
            -- },
            -- pick = {
            --     fg = "#ff0000",
            --     bg = "#ff0000",
            --     bold = true,
            --     italic = true,
            -- },
            -- offset_separator = {
            --     fg = "#ff0000",
            --     bg = "#ff0000",
            -- },
            -- trunc_marker = {
            --     fg = "#ff0000",
            --     bg = "#ff0000",
            -- }
        }
    },

    config = function(_, opts)
        require("bufferline").setup(opts)
    end,
}
