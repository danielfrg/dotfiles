local keymap = vim.api.nvim_set_keymap

local function notify(cmd)
    return string.format("<cmd>call VSCodeNotify('%s')<CR>", cmd)
end

local function v_notify(cmd)
    return string.format("<cmd>call VSCodeNotifyVisual('%s', 1)<CR>", cmd)
end

local opts = { silent = true }

-- Keymaps
keymap('n', '<leader>b', notify 'extension.goto-previous-buffer', opts)
keymap('n', '<leader>`', notify 'extension.goto-previous-buffer', opts)
keymap('n', '<S-x>', notify 'extension.goto-previous-buffer', opts)

keymap('n', '<leader>la', notify 'editor.action.quickFix', opts)
keymap('n', '<leader>lf', notify 'editor.action.formatDocument', opts)
keymap('n', '<leader>lr', notify 'editor.action.rename', opts)

-- LSP related keymaps
keymap('n', 'K', notify 'editor.action.showHover', opts)
keymap('n', 'gd', notify 'editor.action.revealDefinition', opts)
keymap('n', 'gD', notify 'editor.action.revealDeclaration', opts)
keymap('n', 'gr', notify 'references-view.findReferences', opts)
keymap('n', 'gi', notify 'editor.action.goToImplementation', opts)
keymap('n', 'gt', notify 'editor.action.goToTypeDefinition', opts)
keymap("n", "[d", notify 'editor.action.marker.next', opts)
keymap("n", "]d", notify 'editor.action.marker.prev', opts)

-- Telescope: search/find related keymaps
keymap('n', '<leader>fg', notify 'workbench.action.findInFiles', opts) -- Fuzzy search
keymap('n', '<leader>fc', notify 'workbench.action.showCommands', opts) -- Find commands
keymap('n', '<leader>ff', notify 'workbench.action.quickOpen', opts) -- Find files

-- Trouble / Problems
keymap('n', '<leader>xd', notify 'workbench.actions.view.problems', opts)

-- UI
keymap('n', '<leader>e', notify 'workbench.action.toggleSidebarVisibility', opts)
-- keymap('n', '<leader>tp', notify 'workbench.action.togglePanel', opts)