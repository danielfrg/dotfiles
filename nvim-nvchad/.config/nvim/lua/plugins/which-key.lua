return {
  {
    "folke/which-key.nvim",
    keys = { "<leader>", "<c-r>", "<c-w>", '"', "'", "`", "c", "v", "g" },
    cmd = "WhichKey",
    config = function(_, opts)
      local wk = require('which-key')
      wk.setup(opts)
      wk.register({
        ['f'] = { name = "Find" },
        ['g'] = { name = "Git" },
        ['s'] = { name = "Search" },
      }, { prefix = "<leader>" })
    end,
  },
}
