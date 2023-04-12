local keymap = vim.api.nvim_set_keymap

local function notify(cmd)
    return string.format("<cmd>call VSCodeNotify('%s')<CR>", cmd)
end

local function v_notify(cmd)
    return string.format("<cmd>call VSCodeNotifyVisual('%s', 1)<CR>", cmd)
end

local opts = { silent = true }

-- LSP related keymaps
keymap('n', '<Leader>gr', notify 'references-view.findReferences', opts) -- language references
keymap('n', '<Leader>xd', notify 'workbench.actions.view.problems', opts) -- language diagnostics
keymap('n', '<Leader>cf', notify 'editor.action.formatDocument', opts)
keymap('n', '<Leader>cr', notify 'editor.action.rename', opts)
keymap('n', '<Leader>xd', notify 'workbench.actions.view.problems', opts) -- language diagnostics

-- Telescope: search/find related keymaps
keymap('n', '<Leader>fs', notify 'workbench.action.findInFiles', opts) -- Fuzzy search
keymap('n', '<Leader>fc', notify 'workbench.action.showCommands', opts) -- find commands
keymap('n', '<Leader>ff', notify 'workbench.action.quickOpen', opts) -- find files

-- UI
keymap('n', '<Leader>fe', notify 'workbench.action.togglePanel', opts)
