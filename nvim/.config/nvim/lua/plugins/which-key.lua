return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    keys = { "<leader>", "<c-r>", "<c-w>", '"', "'", "`", "c", "v", "g" },
    cmd = "WhichKey",
    config = function(_, opts)
      local wk = require('which-key')
      wk.setup(opts)
      wk.register({
        ['<leader>c'] = { name = "Code" },
        ['<leader>f'] = { name = "Find" },
        ['<leader>g'] = { name = "Git" },
        ['g'] = { name = "Goto" },
        ['<leader>h'] = { name = "Harpoon" },
        ['<leader>s'] = { name = "Search" },
        ['<leader>x'] = { name = "Trouble" },
      })
    end,
  },
}
