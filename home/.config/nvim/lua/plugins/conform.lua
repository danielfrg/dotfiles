return {
  "stevearc/conform.nvim",
  opts = {
    formatters_by_ft = {
      lua = { "stylua" },
      javascript = { "prettier" },
      javascriptreact = { "prettier" },
      typescript = { "prettier" },
      typescriptreact = { "prettier" },
      json = { "prettier" },
      jsonc = { "prettier" },
      yaml = { "prettier" },
      markdown = { "prettier" },
      html = { "prettier" },
      css = { "prettier" },
    },
    formatters = {
      prettier = {
        command = "bunx",
        args = { "prettier", "--stdin-filepath", "$FILENAME" },
      },
    },
    format_on_save = {
      timeout_ms = 500,
      lsp_format = "never",
    },
  },
}
