return {
  {
    "neovim/nvim-lspconfig",
    event = "VimEnter",

    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",

      { "j-hui/fidget.nvim", opts = {} },

      -- Autoformatting
      "stevearc/conform.nvim",

      -- Schema information
      "b0o/SchemaStore.nvim",
    },
    config = function()
      require("custom.lsp")
    end,
  },

  {
    "RRethy/vim-illuminate",
    event = "VimEnter",
    config = function()
      local illuminate = require("illuminate")
      illuminate.configure({
        -- providers: provider used to get references in the buffer, ordered by priority
        providers = {
          "lsp",
          "treesitter",
          "regex",
        },
      })
    end,
    -- keys = {
    --   { "n", "[[", '<cmd>lua require("illuminate").goto_prev_reference(true)<CR>' },
    --   { "n", "]]", '<cmd>lua require("illuminate").goto_next_reference(true)<CR>' },
    -- },

    -- init = function()
    --   local illuminate = require("illuminate")
    --   vim.keymap.set("n", "[[", function()
    --     illuminate.goto_previous_reference()
    --   end, {
    --     desc = "LSP: Previous reference",
    --   })
    --   -- vim.keymap.set("n", "]]", illuminate.goto_next_reference, {
    --   --   desc = "LSP: Next reference",
    --   -- })
    -- end,
  },
}
