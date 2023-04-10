-- Automatically install packer if not installed
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- Autocommand that reloads neovim whenever you save the plugins.lua file
-- vim.cmd [[
--   augroup packer_user_config
--     autocmd!
--     autocmd BufWritePost plugins.lua source <afile> | PackerSync
--   augroup end
-- ]]

-- Use a protected call so we don"t error out on first use
local status_ok, lazy = pcall(require, "lazy")
if not status_ok then
    return
end

plugins = {
    -- Useful lua functions used ny lots of plugins
    "nvim-lua/plenary.nvim",

    -- -- An implementation of the Popup API from vim in Neovim
    "nvim-lua/popup.nvim",

    -- -- Themes
    { "projekt0n/github-nvim-theme",     tag = "v0.0.7" },

    -- -- Navigation
    {
        "nvim-telescope/telescope.nvim",
        tag = "0.1.1",
        requires = { { "nvim-lua/plenary.nvim" } }
    },
    -- -- use("theprimeagen/harpoon")

    -- Writting code
    -- Autopairs, integrates with both cmp and treesitter
    "windwp/nvim-autopairs",
    -- Toggle comments
    {
        "numToStr/Comment.nvim",
        config = function()
            require("Comment").setup()
        end
    },
    -- TS context aware comment strings
    'JoosepAlviste/nvim-ts-context-commentstring',

    -- UI things
    {
        "nvim-tree/nvim-tree.lua",
        requires = {
            "nvim-tree/nvim-web-devicons", -- optional
        },
        config = function()
            require("nvim-tree").setup {}
        end
    },
    {
        "nvim-lualine/lualine.nvim",
        requires = { "nvim-tree/nvim-web-devicons" }
    },

    --     -- LSP
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "neovim/nvim-lspconfig",

    -- CMP
    "hrsh7th/nvim-cmp",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-cmdline",
    "saadparwaiz1/cmp_luasnip",
    "hrsh7th/cmp-nvim-lua",

    -- Snippets
    "L3MON4D3/LuaSnip",

    -- Formaters and Linters
    "jose-elias-alvarez/null-ls  .nvim",

    -- YAML schema template selector and status line
    "someone-stole-my-name/yaml-companion.nvim",

    -- Tree sitter (Syntax highlighting)
    { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
    "nvim-treesitter/nvim-treesitter-context",

    --     -- Git
    "lewis6991/gitsigns.nvim",
    -- "tpope/vim-fugitive",

    -- Undo tree
    -- "mbbill/undotree",

    -- Other
    "github/copilot.vim"
}

opts = {}

lazy.setup(plugins, opts)
