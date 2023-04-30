local status_ok, telescope = pcall(require, "telescope")
if not status_ok then
    return
end

local U = require("user.utils")

U.keymap("n", "<leader>xx", "<cmd>TroubleToggle<cr>", { desc = "Toggle Trouble" })
U.keymap("n", "<leader>xw", "<cmd>TroubleToggle workspace_diagnostics<cr>", { desc = "Workspace Trouble" })
U.keymap("n", "<leader>xd", "<cmd>TroubleToggle document_diagnostics<cr>", { desc = "Document Diagnostics" })
U.keymap("n", "<leader>xl", "<cmd>TroubleToggle loclist<cr>", { desc = "Trouble Loclist" })
U.keymap("n", "<leader>xq", "<cmd>TroubleToggle quickfix<cr>", { desc = "Trouble Quickfix" })
U.keymap("n", "gR", "<cmd>TroubleToggle lsp_references<cr>", { desc = "Trouble LSP References" })
