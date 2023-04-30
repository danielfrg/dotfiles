-- Automatically install lazy.nvim if not installed
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

-- Use a protected call so we don"t error out on first use
local status_ok, lazy = pcall(require, "lazy")
if not status_ok then
    return
end

local plugins = {
    -- Useful lua functions used ny lots of plugins
    "nvim-lua/plenary.nvim",       -- Utils
    "MunifTanjim/nui.nvim",        -- UI components
    "nvim-tree/nvim-web-devicons", -- Icons

    -- CORE
    { "max397574/better-escape.nvim", event = "InsertCharPre", opts = { timeout = 300 } },

    -- NAVIGATION
    {
        "nvim-telescope/telescope.nvim",
        tag = "0.1.1",
        requires = { { "nvim-lua/plenary.nvim" } }
    },
    "mrjones2014/smart-splits.nvim",
    "ggandor/leap.nvim",
    -- "justinmk/vim-sneak",
    -- "theprimeagen/harpoon",
    -- "christoomey/vim-tmux-navigator",

    -- CODE
    -- Autopairs, integrates with both cmp and treesitter
    "windwp/nvim-autopairs",
    -- Commens
    "numToStr/Comment.nvim",
    -- TS context aware comment strings
    "JoosepAlviste/nvim-ts-context-commentstring",
    "lukas-reineke/indent-blankline.nvim",

    -- Better indent
    "NMAC427/guess-indent.nvim",

    -- UI components
    { "nvim-neo-tree/neo-tree.nvim" },
    { "akinsho/bufferline.nvim",      version = "*",           dependencies = "nvim-tree/nvim-web-devicons" },
    "rebelot/heirline.nvim", -- Status line
    {
        "folke/trouble.nvim",
        config = function()
            require("trouble").setup {
                -- your configuration comes here
                -- or leave it empty to use the default settings
                -- refer to the configuration section below
            }
        end
    },

    -- An implementation of the Popup API from vim in Neovim
    "nvim-lua/popup.nvim",

    -- Which key
    {
        "folke/which-key.nvim",
        config = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 300
        end,
    },

    -- LSP
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "neovim/nvim-lspconfig",
    "j-hui/fidget.nvim",

    -- CMP
    "hrsh7th/nvim-cmp",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-cmdline",
    "saadparwaiz1/cmp_luasnip",
    "hrsh7th/cmp-nvim-lua",

    -- Formaters and Linters
    "jose-elias-alvarez/null-ls.nvim",

    -- YAML schema template selector and status line
    "someone-stole-my-name/yaml-companion.nvim",

    -- Snippets
    "L3MON4D3/LuaSnip",

    -- Tree sitter (Syntax highlighting)
    { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
    "nvim-treesitter/nvim-treesitter-context",

    -- Git
    "lewis6991/gitsigns.nvim",
    -- "tpope/vim-fugitive",

    -- THEMES
    { "projekt0n/github-nvim-theme",     tag = "v0.0.7" },
    { "AstroNvim/astrotheme" },
    { "folke/tokyonight.nvim" },
    { "catppuccin/nvim",                 name = "catppuccin" },

    -- Undo tree
    -- "mbbill/undotree",

    -- Other
    "github/copilot.vim",
    "lewis6991/impatient.nvim",
    "famiu/bufdelete.nvim",
    {
        "goolord/alpha-nvim",
        config = function()
            require "alpha".setup(require "alpha.themes.dashboard".config)
        end
    },
    {
        "iamcco/markdown-preview.nvim",
        config = function()
            vim.fn["mkdp#util#install"]()
        end
    }
}

local opts = {
    ui = {
        -- The border to use for the UI window. Accepts same border values as |nvim_open_win()|.
        border = "rounded",
    }
}

lazy.setup(plugins, opts)
