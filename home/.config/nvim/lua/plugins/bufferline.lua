return {
    "akinsho/bufferline.nvim",
    -- version = "*",
    dependencies = {
        "nvim-tree/nvim-web-devicons"
    },

    opts = {
        options = {
            -- close_command = function(n) require("mini.bufremove").delete(n, false) end,
            -- right_mouse_command = function(n) require("mini.bufremove").delete(n, false) end,
            always_show_bufferline = true,
            show_buffer_icons = false,
            color_icons = false,
            close_icon = "",
            modified_icon = "",
            separator_style = "thick" -- | "slope" | "thick" | "thin" | { "any", "any" },
            -- diagnostics = "nvim_lsp",
            -- indicator = {
            --     style = "underline"
            -- },
        },
        highlights = {
            -- buffline: [tab][sep][tab]fill-background
            -- [tab]: [indicator-buffer(visible|selected)-close(selected)]

            -- See colorscheme.lua for theme highlights

            fill = {
                fg = '#21242a',
                bg = '#21242a',
            },
            background = {
                -- Non selected buffer
                fg = '#AAAAAA',
                bg = '#21242a',
            },
            tab = {
                -- fg = '#FF0000',
                -- bg = '#FF0000',
            },
            tab_selected = {
                -- fg = '#FF0000',
                -- bg = '#2d3441',
            },
            tab_separator = {
                -- fg = '#FF0000',
                -- bg = '#FF0000',
            },
            tab_separator_selected = {
                -- fg = '#FF0000',
                -- bg = '#FF0000',
                -- sp = '#FF0000',
                -- underline = '#FF0000',
            },
            tab_close = {
                -- fg = '#FF0000',
                -- bg = '#FF0000',
            },
            close_button = {
                -- Non-selected buffer
                fg = '#AAAAAA',
                bg = '#21242a',
            },
            close_button_visible = {
                -- fg = '#FF0000',
                -- bg = '#FF0000',
            },
            close_button_selected = {
                -- Selected buffer
                fg = '#FFFFFF',
                bg = '#2d3441',
            },
            buffer_visible = {
                -- fg = '#FF0000',
                -- bg = '#FF0000',
            },
            buffer_selected = {
                fg = '#FFFFFF',
                bg = '#2d3441',
                bold = true,
                italic = true,
            },
            numbers = {
                -- fg = '#FF0000',
                -- bg = '#FF0000',
            },
            numbers_visible = {
                -- fg = '#FF0000',
                -- bg = '#FF0000',
            },
            numbers_selected = {
                -- fg = '#FF0000',
                -- bg = '#FF0000',
                -- bold = true,
                -- italic = true,
            },
            diagnostic = {
                -- fg = '#FF0000',
                -- bg = '#FF0000',
            },
            diagnostic_visible = {
                -- fg = '#FF0000',
                -- bg = '#FF0000',
            },
            diagnostic_selected = {
                -- fg = '#FF0000',
                -- bg = '#FF0000',
                bold = true,
                italic = true,
            },
            hint = {
                -- fg = '#FF0000',
                -- sp = '#FF0000',
                -- bg = '#FF0000',
            },
            hint_visible = {
                -- fg = '#FF0000',
                -- bg = '#FF0000',
            },
            hint_selected = {
                -- fg = '#FF0000',
                -- bg = '#FF0000',
                -- sp = '#FF0000',
                bold = true,
                italic = true,
            },
            hint_diagnostic = {
                -- fg = '#FF0000',
                -- sp = '#FF0000',
                -- bg = '#FF0000',
            },
            hint_diagnostic_visible = {
                -- fg = '#FF0000',
                -- bg = '#FF0000',
            },
            hint_diagnostic_selected = {
                -- fg = '#FF0000',
                -- bg = '#FF0000',
                -- sp = '#FF0000',
                bold = true,
                italic = true,
            },
            info = {
                -- fg = '#FF0000',
                -- sp = '#FF0000',
                -- bg = '#FF0000',
            },
            info_visible = {
                -- fg = '#FF0000',
                -- bg = '#FF0000',
            },
            info_selected = {
                -- fg = '#FF0000',
                -- bg = '#FF0000',
                -- sp = '#FF0000',
                bold = true,
                italic = true,
            },
            info_diagnostic = {
                -- fg = '#FF0000',
                -- sp = '#FF0000',
                -- bg = '#FF0000',
            },
            info_diagnostic_visible = {
                -- fg = '#FF0000',
                -- bg = '#FF0000',
            },
            info_diagnostic_selected = {
                -- fg = '#FF0000',
                -- bg = '#FF0000',
                -- sp = '#FF0000',
                bold = true,
                italic = true,
            },
            warning = {
                -- fg = '#FF0000',
                -- sp = '#FF0000',
                -- bg = '#FF0000',
            },
            warning_visible = {
                -- fg = '#FF0000',
                -- bg = '#FF0000',
            },
            warning_selected = {
                -- fg = '#FF0000',
                -- bg = '#FF0000',
                -- sp = '#FF0000',
                bold = true,
                italic = true,
            },
            warning_diagnostic = {
                -- fg = '#FF0000',
                -- sp = '#FF0000',
                -- bg = '#FF0000',
            },
            warning_diagnostic_visible = {
                -- fg = '#FF0000',
                -- bg = '#FF0000',
            },
            warning_diagnostic_selected = {
                -- fg = '#FF0000',
                -- bg = '#FF0000',
                -- sp = '#FF0000',
                bold = true,
                italic = true,
            },
            error = {
                -- fg = '#FF0000',
                -- bg = '#FF0000',
                -- sp = '#FF0000',
            },
            error_visible = {
                -- fg = '#FF0000',
                -- bg = '#FF0000',
            },
            error_selected = {
                -- fg = '#FF0000',
                -- bg = '#FF0000',
                -- sp = '#FF0000',
                bold = true,
                italic = true,
            },
            error_diagnostic = {
                -- fg = '#FF0000',
                -- bg = '#FF0000',
                -- sp = '#FF0000',
            },
            error_diagnostic_visible = {
                -- fg = '#FF0000',
                -- bg = '#FF0000',
            },
            error_diagnostic_selected = {
                -- fg = '#FF0000',
                -- bg = '#FF0000',
                -- sp = '#FF0000',
                bold = true,
                italic = true,
            },
            modified = {
                -- non-selected buffer
                -- fg = '#FF0000',
                bg = '#21242a',
            },
            modified_visible = {
                -- fg = '#FF0000',
                -- bg = '#FF0000',
            },
            modified_selected = {
                -- Save indicator
                -- fg = '#FF0000',
                bg = '#2d3441',
            },
            duplicate_selected = {
                -- fg = '#FF0000',
                -- bg = '#FF0000',
                italic = true,
            },
            duplicate_visible = {
                -- fg = '#FF0000',
                -- bg = '#FF0000',
                italic = true,
            },
            duplicate = {
                -- fg = '#FF0000',
                -- bg = '#FF0000',
                italic = true,
            },
            separator_selected = {
                -- fg = '#FF0000',
                -- bg = '#FF0000',
            },
            separator_visible = {
                -- fg = '#FF0000',
                -- bg = '#FF0000',
            },
            separator = {
                -- Same as background
                fg = '#21242a',
                bg = '#21242a',
            },
            indicator_visible = {
                -- fg = '#FF0000',
                -- bg = '#FF0000',
            },
            indicator_selected = {
                -- fg = '#FF0000',
                -- bg = '#FF0000',
            },
            pick_selected = {
                -- fg = '#FF0000',
                -- bg = '#FF0000',
                bold = true,
                italic = true,
            },
            pick_visible = {
                -- fg = '#FF0000',
                -- bg = '#FF0000',
                bold = true,
                italic = true,
            },
            pick = {
                -- fg = '#FF0000',
                -- bg = '#FF0000',
                bold = true,
                italic = true,
            },
            offset_separator = {
                -- fg = '#FF0000',
                -- bg = '#FF0000',
            },
            trunc_marker = {
                -- fg = '#FF0000',
                -- bg = '#FF0000',
            }
        }
    },

    config = function(_, opts)
        require("bufferline").setup(opts)
    end,
}
