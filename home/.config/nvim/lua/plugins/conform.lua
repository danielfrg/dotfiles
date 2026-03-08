local function has_oxfmt_in_project(ctx)
  local file = ctx and ctx.filename or vim.api.nvim_buf_get_name(0)
  local package_files = vim.fs.find("package.json", { path = file, upward = true })
  local package_json = package_files[1]

  if not package_json then
    return false
  end

  local lines = vim.fn.readfile(package_json)
  local content = table.concat(lines, "\n")

  return content:find('"oxfmt"', 1, true) ~= nil
end

return {
  "stevearc/conform.nvim",
  opts = {
    formatters_by_ft = {
      lua = { "stylua" },
      javascript = { "oxfmt", "prettier", stop_after_first = true },
      javascriptreact = { "oxfmt", "prettier", stop_after_first = true },
      typescript = { "oxfmt", "prettier", stop_after_first = true },
      typescriptreact = { "oxfmt", "prettier", stop_after_first = true },
      json = { "oxfmt", "prettier", stop_after_first = true },
      jsonc = { "oxfmt", "prettier", stop_after_first = true },
      yaml = { "oxfmt", "prettier", stop_after_first = true },
      markdown = { "oxfmt", "prettier", stop_after_first = true },
      html = { "oxfmt", "prettier", stop_after_first = true },
      css = { "oxfmt", "prettier", stop_after_first = true },
    },
    formatters = {
      oxfmt = {
        command = "bunx",
        args = { "oxfmt", "--stdin-filepath", "$FILENAME" },
        condition = has_oxfmt_in_project,
      },
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
