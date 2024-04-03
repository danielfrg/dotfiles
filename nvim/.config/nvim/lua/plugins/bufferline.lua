return {
    "akinsho/bufferline.nvim",
    lazy = false,

    dependencies = { { 'echasnovski/mini.nvim', version = '*' } },

    opts = {
        options = {
            close_command = function(n) require("mini.bufremove").delete(n, false) end,
            right_mouse_command = function(n) require("mini.bufremove").delete(n, false) end,
            -- diagnostics = "nvim_lsp",
            always_show_bufferline = false,
            -- indicator = {
            --     style = "underline"
            -- },
            show_buffer_icons = false,
            separator_style = "thick" -- | "slope" | "thick" | "thin" | { 'any', 'any' },
        },
        highlights = {

            -- One tab : [indicator-buffer(visible|selected)-close(selected)]
            -- buffline: [tab][sep][tab]fill-background
            fill = {
                fg = '#7B7970',
                bg = '#16161E',
            },

            indicator_visible = {
                fg = '#16161E',
                bg = '#16161E',
            },
            indicator_selected = {
                fg = '#363646',
                bg = '#363646',
            },

            buffer_visible = {
                fg = '#DCD7BB',
                bg = '#363646',
            },
            buffer_selected = {
                fg = '#DCD7BB',
                bg = '#363646',
            },

            close_button = {
                fg = '#7B7970',
                bg = '#16161E',
            },
            close_button_visible = {
                fg = '#7B7970',
                bg = '#16161E',
            },
            close_button_selected = {
                fg = '#DCD7BB',
                bg = '#363646',
            },

            modified = {
                -- fg = '#7B7970',
                bg = '#16161E',
            },
            modified_visible = {
                -- fg = '#7B7970',
                bg = '#16161E',
            },
            modified_selected = {
                -- fg = '#DCD7BB',
                bg = '#363646',
            },

            separator = {
                fg = '#16161E',
                bg = '#16161E',
            },


        }
    },

    config = function(_, opts)
        require("bufferline").setup(opts)
    end,
}
