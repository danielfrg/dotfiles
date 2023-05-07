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
if not status_ok then return end

local plugins = {
    -- Useful lua functions used ny lots of plugins
    { "nvim-lua/plenary.nvim",       lazy = true },
    { "nvim-tree/nvim-web-devicons", lazy = true },
    { "dstein64/vim-startuptime",    cmd = "StartupTime" },

    -- CORE
    -- { "max397574/better-escape.nvim",    event = "InsertCharPre", opts = { timeout = 300 } },

    -- NAVIGATION
    "mrjones2014/smart-splits.nvim",
    {
        "nvim-telescope/telescope.nvim",
        tag = "0.1.1",
        requires = { { "nvim-lua/plenary.nvim" } }
    },
    "theprimeagen/harpoon",
    "ggandor/leap.nvim",

    -- CODE
    "kylechui/nvim-surround",
    -- Autopairs, integrates with both cmp and treesitter
    "windwp/nvim-autopairs",
    -- Comment
    "numToStr/Comment.nvim",
    -- TS context aware comment strings
    "JoosepAlviste/nvim-ts-context-commentstring",
    -- Indent indicators
    "lukas-reineke/indent-blankline.nvim",
    -- Better indent
    "NMAC427/guess-indent.nvim",

    -- UI components
    -- { "nvim-neo-tree/neo-tree.nvim" },
    {
        "nvim-tree/nvim-tree.lua",
        version = "*",
        dependencies = {
            "nvim-tree/nvim-web-devicons",
        }
    },
    -- {
    --     "akinsho/bufferline.nvim",
    --     version = "*",
    --     dependencies = "nvim-tree/nvim-web-devicons"
    -- },
    "nvim-lualine/lualine.nvim",
    "folke/trouble.nvim",

    -- Which key
    {
        "folke/which-key.nvim",
        config = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 300
        end,
    },

    --------------------------------------------
    -- LSP, Diagnostics, Snippets, Completion --
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "neovim/nvim-lspconfig",
    "j-hui/fidget.nvim",

    -- LSP: Other formaters and Linters
    "jose-elias-alvarez/null-ls.nvim",

    -- LSP: YAML schema template selector and status line
    "someone-stole-my-name/yaml-companion.nvim",

    -- LSP: Completition
    "hrsh7th/nvim-cmp",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-cmdline",
    "saadparwaiz1/cmp_luasnip",
    "hrsh7th/cmp-nvim-lua",

    -- Snippets
    {
        "L3MON4D3/LuaSnip",
        dependencies = { "rafamadriz/friendly-snippets" },
    },

    -- Tree sitter (Syntax highlighting)
    { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
    "nvim-treesitter/nvim-treesitter-context",

    -- Git
    "lewis6991/gitsigns.nvim",

    -- THEMES
    { "catppuccin/nvim",      name = "catppuccin", dependencies = "nvim-lualine/lualine.nvim" },
    { "folke/tokyonight.nvim" },
    { "rebelot/kanagawa.nvim" },
    -- { "projekt0n/github-nvim-theme",     tag = "v0.0.7" },
    -- { "AstroNvim/astrotheme" },

    -- Other
    "github/copilot.vim",
    "famiu/bufdelete.nvim",
    "lewis6991/impatient.nvim",
    "goolord/alpha-nvim",
    {
        "iamcco/markdown-preview.nvim",
        config = function()
            vim.fn["mkdp#util#install"]()
        end
    }
}

local opts = {
    ui = {
        -- border = "rounded",
    }
}

lazy.setup(plugins, opts)


--------------------------------------------------------------------------------
-- Load configs

-- Load this first for other plugins to use
require("user.plugins.configs.colorscheme")

require("user.plugins.configs.alpha")
require("user.plugins.configs.autocmd")
require("user.plugins.configs.autopairs")
-- require("user.plugins.configs.bufferline")  -- Just using status line
require("user.plugins.configs.cmp")
require("user.plugins.configs.comment")
require("user.plugins.configs.fidget")
require("user.plugins.configs.gitsigns")
require("user.plugins.configs.guess-indent")
require("user.plugins.configs.harpoon")
require("user.plugins.configs.impatient")
require("user.plugins.configs.indent-blankline")
require("user.plugins.configs.leap")
require("user.plugins.configs.lsp")
require("user.plugins.configs.lualine")
require("user.plugins.configs.nvim-tree")
require("user.plugins.configs.nvim-surround")
-- require("user.plugins.configs.neotree")
require("user.plugins.configs.null-ls")
require("user.plugins.configs.telescope")
require("user.plugins.configs.treesitter")
require("user.plugins.configs.trouble")
require("user.plugins.configs.which-key")
