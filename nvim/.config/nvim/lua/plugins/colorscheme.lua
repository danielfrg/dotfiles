return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      vim.cmd([[colorscheme catppuccin-mocha]])
    end,
  },

  -- {
  --   "rebelot/kanagawa.nvim",
  --   priority = 1000,
  --
  --   config = function()
  --     require('kanagawa').setup({
  --       compile = true, -- enable compiling the colorscheme
  --
  --       theme = "wave", -- Load "wave" theme when 'background' option is not set
  --       keywordStyle = { italic = true },
  --
  --       colors = {
  --         theme = {
  --           all = {
  --             ui = {
  --               bg_gutter = "none"
  --             }
  --           }
  --         }
  --       }
  --     })
  --
  --     vim.cmd([[colorscheme kanagawa-wave]])
  --   end
  -- }
}
