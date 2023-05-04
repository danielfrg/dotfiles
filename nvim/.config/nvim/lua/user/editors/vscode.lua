local keymap = vim.api.nvim_set_keymap
local function notify(cmd)
    return string.format("<cmd>call VSCodeNotify('%s')<CR>", cmd)
end

local function v_notify(cmd)
    return string.format("<cmd>call VSCodeNotifyVisual('%s', 1)<CR>", cmd)
end

local opts = { silent = true }

-- Remove this
keymap('n', '<S-j>', "<Nop>", opts)

-- Buffers
keymap('n', '<leader>b', notify 'extension.goto-previous-buffer', opts)
keymap('n', '<leader>`', notify 'extension.goto-previous-buffer', opts)
keymap('n', '<S-x>', notify 'extension.goto-previous-buffer', opts)
keymap('n', '<C-x>', notify 'extension.goto-previous-buffer', opts)

-- LSP
keymap('n', 'K', notify 'editor.action.showHover', opts)
keymap('n', '<leader>la', notify 'editor.action.quickFix', opts)
keymap('n', '<leader>lf', notify 'editor.action.formatDocument', opts)
keymap('n', '<leader>lr', notify 'editor.action.rename', opts)

keymap('n', 'gd', notify 'editor.action.revealDefinition', opts)
keymap('n', 'gD', notify 'editor.action.revealDeclaration', opts)
keymap('n', 'gr', notify 'references-view.findReferences', opts)
keymap('n', 'gi', notify 'editor.action.goToImplementation', opts)
keymap('n', 'gt', notify 'editor.action.goToTypeDefinition', opts)
keymap("n", "[d", notify 'editor.action.marker.next', opts)
keymap("n", "]d", notify 'editor.action.marker.prev', opts)

-- Telescope(ish)
keymap('n', '<C-p>', notify 'workbench.action.quickOpen', opts)
keymap('n', '<leader>ff', notify 'find-it-faster.findFiles', opts)
keymap('n', '<leader>fg', notify 'find-it-faster.findWithinFiles', opts)
keymap('n', '<leader>fc', notify 'workbench.action.showCommands', opts)

-- Harpoon
keymap('n', '<leader>a', notify 'vscode-harpoon.addEditor', opts)
keymap('n', '<leader>h', notify 'vscode-harpoon.editorQuickPick', opts)
keymap('n', '<C-h>', notify 'vscode-harpoon.gotoEditor1', opts)
keymap('n', '<C-j>', notify 'vscode-harpoon.gotoEditor2', opts)
keymap('n', '<C-k>', notify 'vscode-harpoon.gotoEditor3', opts)
keymap('n', '<C-l>', notify 'vscode-harpoon.gotoEditor4', opts)
keymap('i', '<C-h>', notify 'vscode-harpoon.gotoEditor1', opts)
keymap('i', '<C-j>', notify 'vscode-harpoon.gotoEditor2', opts)
keymap('i', '<C-k>', notify 'vscode-harpoon.gotoEditor3', opts)
keymap('i', '<C-l>', notify 'vscode-harpoon.gotoEditor4', opts)

-- Marks (Bookmarks)
keymap('n', 'mm', notify 'bookmarks.toggle', opts)
keymap('n', '\'\'', notify 'bookmarks.jumpToPrevious', opts)
keymap('n', 'mp', notify 'bookmarks.jumpToPrevious', opts)
keymap('n', 'mn', notify 'bookmarks.jumpToNext', opts)

-- Trouble (Problems)
keymap('n', '<leader>xd', notify 'workbench.actions.view.problems', opts)

-- UI
keymap('n', '<leader>e', notify 'workbench.action.toggleSidebarVisibility', opts)
-- keymap('n', '<leader>tp', notify 'workbench.action.togglePanel', opts)

-- Leap
keymap('n', 's', notify 'leap.find', opts)

