local M = {}

M.telescope = {
    defaults = {
        file_ignore_patterns = { "node_modules", "^.git/" },
    },
}

M.treesitter = {
    ensure_installed = {
        "bash",
        "python",
        "html",
        "css",
        "javascript",
        "typescript",
        "tsx",
        "markdown",
        "markdown_inline",
        "terraform",
        "vim",
        "lua",
    },
    indent = {
        enable = true,
        -- disable = {
        --   "python"
        -- },
    },
}

M.mason = {
    ensure_installed = {
        -- Python
        -- "black",
        "mypy",
        "pyright",
        -- "python-lsp-server",
        "ruff",
        "ruff-lsp",

        -- Web
        "css-lsp",
        "eslint-lsp",
        "html-lsp",
        "prettier",
        "tailwindcss-language-server",
        "typescript-language-server",

        -- Other
        "terraform-ls",

        -- lua stuff
        "lua-language-server",
        "stylua",
    },
}

-- nvimtree
local HEIGHT_RATIO = 0.8 -- You can change this
local WIDTH_RATIO = 0.5  -- You can change this too

M.nvimtree = {
    filters = {
        dotfiles = false,
        custom = { "^.git$" },
    },

    view = {
        adaptive_size = false,
        -- side = "left",
        float = {
            enable = true,
            open_win_config = function()
                local screen_w = vim.opt.columns:get()
                local screen_h = vim.opt.lines:get() - vim.opt.cmdheight:get()
                local window_w = screen_w * WIDTH_RATIO
                local window_h = screen_h * HEIGHT_RATIO
                local window_w_int = math.floor(window_w)
                local window_h_int = math.floor(window_h)
                local center_x = (screen_w - window_w) / 2
                local center_y = ((vim.opt.lines:get() - window_h) / 2)
                    - vim.opt.cmdheight:get()
                return {
                    border = 'rounded',
                    relative = 'editor',
                    row = center_y,
                    col = center_x,
                    width = window_w_int,
                    height = window_h_int,
                }
            end,
        },
        width = function()
            return math.floor(vim.opt.columns:get() * WIDTH_RATIO)
        end,
    },
}

return M