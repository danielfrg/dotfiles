-- local status_ok, scheme = pcall(require, "catppuccin")
-- if not status_ok then return end

-- scheme.setup({
--     integrations = {
--         alpha = true,
--         fidget = true,
--         gitsigns = true,
--         harpoon = true,
--         leap = true,
--         mason = true,
--         neotree = true,
--         telescope = true,
--         lsp_trouble = true,
--         which_key = true,
--         indent_blankline = {
--             enabled = true,
--             colored_indent_levels = true,
--         },
--     }
-- })

local status_ok, scheme = pcall(require, "kanagawa")
if not status_ok then return end

scheme.setup({
    compile = false,
    theme = "wave",
    background = {
        dark = "dragon", -- wave / dragon
        light = "lotus"
    },
    colors = {
        theme = {
            all = {
                ui = {
                    bg_gutter = "#181616",
                }
            }
        }
    }
})

local colorscheme = "kanagawa"
-- local colorscheme = "catppuccin-macchiato"
-- local colorscheme = "tokyonight-storm"

local status_ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)
if not status_ok then return end
