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

-- LSP related keymaps
keymap('n', 'K', notify 'editor.action.showHover', opts)
keymap('n', '<leader>gd', notify 'editor.action.revealDefinition', opts)
keymap('n', '<leader>gD', notify 'editor.action.revealDeclaration', opts)
keymap('n', '<leader>gr', notify 'references-view.findReferences', opts)
keymap('n', '<leader>gi', notify 'editor.action.goToImplementation', opts)
keymap('n', '<leader>gt', notify 'editor.action.goToTypeDefinition', opts)
keymap("n", "[d", notify 'editor.action.marker.next', opts)
keymap("n", "]d", notify 'editor.action.marker.prev', opts)
keymap('n', '<leader>ca', notify 'editor.action.quickFix', opts)
keymap('n', '<leader>cf', notify 'editor.action.formatDocument', opts)
keymap('n', '<leader>cr', notify 'editor.action.rename', opts)

-- Telescope: search/find related keymaps
keymap('n', '<leader>fs', notify 'workbench.action.findInFiles', opts) -- Fuzzy search
keymap('n', '<leader>fc', notify 'workbench.action.showCommands', opts) -- Find commands
keymap('n', '<leader>ff', notify 'workbench.action.quickOpen', opts) -- Find files

-- Trouble / Problems
keymap('n', '<leader>xd', notify 'workbench.actions.view.problems', opts)

-- UI
keymap('n', '<leader>fe', notify 'workbench.action.toggleSidebarVisibility', opts)
keymap('n', '<leader>tp', notify 'workbench.action.togglePanel', opts)
