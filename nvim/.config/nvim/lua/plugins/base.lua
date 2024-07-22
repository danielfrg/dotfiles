return {
  -- undo tree
  {
    "mbbill/undotree",
    event = "VeryLazy",
  },

  {
    "nomnivore/ollama.nvim",
    opts = {
      model = "codestral:latest",
      url = "http://10.0.0.69:11434",
    },
  },

  -- Detect tabstop and shiftwidth automatically
  {
    "tpope/vim-sleuth",
    event = "VeryLazy",
  },

  {
    "tpope/vim-repeat",
    event = "VeryLazy",
  },

  -- "gc" to comment visual regions/lines
  {
    "numToStr/Comment.nvim",
    event = "VeryLazy",
  },

  -- fancy TODO comments
  {
    "folke/todo-comments.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = { signs = false },
  },

  -- buffer delete event
  {
    "famiu/bufdelete.nvim",
    event = "VeryLazy",
  },

  -- tmux
  {
    "christoomey/vim-tmux-navigator",
    event = "VeryLazy",
  },

  -- learn vim
  {
    "ThePrimeagen/vim-be-good",
    cmd = "VimBeGood",
    lazy = true,
    -- event = "VeryLazy",
  },
}
