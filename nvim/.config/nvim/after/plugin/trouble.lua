local status_ok, telescope = pcall(require, "telescope")
if not status_ok then
    return
end

local status_ok, trouble_telescope = pcall(require, "trouble.providers.telescope")
if not status_ok then
    return
end

local actions = require("telescope.actions")

local opts = {silent = true, noremap = true}
vim.keymap.set("n", "<leader>xx", "<cmd>TroubleToggle<cr>", opts)
vim.keymap.set("n", "<leader>xw", "<cmd>TroubleToggle workspace_diagnostics<cr>", opts)
vim.keymap.set("n", "<leader>xd", "<cmd>TroubleToggle document_diagnostics<cr>", opts)
vim.keymap.set("n", "<leader>xl", "<cmd>TroubleToggle loclist<cr>", opts)
vim.keymap.set("n", "<leader>xq", "<cmd>TroubleToggle quickfix<cr>", opts)
vim.keymap.set("n", "gR", "<cmd>TroubleToggle lsp_references<cr>", opts)

telescope.setup {
  defaults = {
    mappings = {
      i = { ["<c-t>"] = trouble_telescope.open_with_trouble },
      n = { ["<c-t>"] = trouble_telescope.open_with_trouble },
    },
  },
}
