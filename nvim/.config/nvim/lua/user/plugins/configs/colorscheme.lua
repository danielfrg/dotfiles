local status_ok, scheme = pcall(require, "catppuccin")
if not status_ok then return end

scheme.setup({
    integrations = {
        alpha = true,
        fidget = true,
        gitsigns = true,
        harpoon = true,
        leap = true,
        mason = true,
        neotree = true,
        telescope = true,
        lsp_trouble = true,
        which_key = true,
        indent_blankline = {
            enabled = true,
            colored_indent_levels = true,
        },
    }
})

local colorscheme = "catppuccin-macchiato"
-- local colorscheme = "tokyonight-storm"

local status_ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)
if not status_ok then return end
