-- Automatically install packer if not installed
local install_path = vim.fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
    PACKER_BOOTSTRAP = vim.fn.system {
        "git",
        "clone",
        "--depth",
        "1",
        "https://github.com/wbthomason/packer.nvim",
        install_path,
    }
    print "Installing packer close and reopen Neovim..."
    vim.cmd [[packadd packer.nvim]]
end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd [[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]]

-- Use a protected call so we don"t error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
    return
end

-- Have packer use a popup window
packer.init {
    display = {
        open_fn = function()
            return require("packer.util").float { border = "rounded" }
        end,
    },
}

return require("packer").startup(function(use)
    -- Packer can manage itself
    use "wbthomason/packer.nvim"

    -- Useful lua functions used ny lots of plugins
    use "nvim-lua/plenary.nvim"
    -- An implementation of the Popup API from vim in Neovim
    use "nvim-lua/popup.nvim"

    -- Themes
    use({ "projekt0n/github-nvim-theme", tag = "v0.0.7" })

    -- Navigation
    use({
        "nvim-telescope/telescope.nvim",
        tag = "0.1.1",
        requires = { { "nvim-lua/plenary.nvim" } }
    })
    use 'nvim-telescope/telescope-media-files.nvim'
    use("theprimeagen/harpoon")

    -- Custom tree navigation
    use {
        "nvim-tree/nvim-tree.lua",
        requires = {
            "nvim-tree/nvim-web-devicons", -- optional
        },
        config = function()
            require("nvim-tree").setup {}
        end
    }

    -- Status line
    use {
        "nvim-lualine/lualine.nvim",
        requires = { "nvim-tree/nvim-web-devicons" }
    }

    -- Toggle comments
    use {
        "numToStr/Comment.nvim",
        config = function()
            require("Comment").setup()
        end
    }

    -- use("mbbill/undotree")
    -- use("tpope/vim-fugitive")

    -- LSP
    use("williamboman/mason.nvim")
    use("williamboman/mason-lspconfig.nvim")
    use("neovim/nvim-lspconfig")

    -- CMP
    use("hrsh7th/nvim-cmp")
    use("hrsh7th/cmp-nvim-lsp")
    use("hrsh7th/cmp-buffer")
    use("hrsh7th/cmp-path")
    use("hrsh7th/cmp-cmdline")
    use("saadparwaiz1/cmp_luasnip")
    use("hrsh7th/cmp-nvim-lua")

    -- Snippets
    use("L3MON4D3/LuaSnip")

    -- Formaters and Linters
    use "jose-elias-alvarez/null-ls.nvim"

    -- YAML schema template selector and status line
    use {
        "someone-stole-my-name/yaml-companion.nvim",
        requires = {
            { "neovim/nvim-lspconfig" },
            { "nvim-lua/plenary.nvim" },
            { "nvim-telescope/telescope.nvim" },
        },
        config = function()
            require("telescope").load_extension("yaml_schema")
        end,
    }

    -- Tree sitter (Syntax highlighting)
    use("nvim-treesitter/nvim-treesitter", { run = ":TSUpdate" })
    use "nvim-treesitter/nvim-treesitter-context"

    -- Autopairs, integrates with both cmp and treesitter
    use "windwp/nvim-autopairs"

    -- Other
    use "github/copilot.vim"

    -- Automatically set up your configuration after cloning packer.nvim
    -- Put this at the end after all plugins
    if PACKER_BOOTSTRAP then
        require("packer").sync()
    end
end)
