vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Fix vscode issues
vim.opt.colorcolumn = ""

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
keymap('n', '<leader>b', notify('extension.goto-previous-buffer'), opts)
keymap('n', '<leader>`', notify('extension.goto-previous-buffer'), opts)
keymap('n', '<S-l>', ":bprevious", opts)
keymap('n', '<S-h>', ":bnext", opts)
keymap('n', '<S-x>', notify('extension.goto-previous-buffer'), opts)

-- Window Management
keymap('n', '<C-h>', notify('workbench.action.focusLeftGroup'), opts)
keymap('n', '<C-j>', notify('workbench.action.focusBelowGroup'), opts)
keymap('n', '<C-k>', notify('workbench.action.focusAboveGroup'), opts)
keymap('n', '<C-l>', notify('workbench.action.focusRightGroup'), opts)

-- Filetree
-- This is not focusing the explorer from this setting so we have it on vscode bindings
-- keymap('n', '<leader>e', notify('workbench.action.toggleSidebarVisibility'), opts)

-- Terminal
keymap('n', '<M-h>', notify('workbench.action.togglePanel'), opts)
keymap('n', '<leader>h', notify('workbench.action.terminal.new'), opts)

-- LSP
keymap('n', 'K', notify('editor.action.showHover'), opts)
keymap('n', '<leader>la', notify('editor.action.quickFix'), opts)
keymap('n', '<leader>lf', notify('editor.action.formatDocument'), opts)
keymap('n', '<leadr>lr', notify('editor.action.rename'), opts)

keymap('n', 'gd', notify('editor.action.revealDefinition'), opts)
keymap('n', 'gD', notify('editor.action.revealDeclaration'), opts)
keymap('n', 'gr', notify('references-view.findReferences'), opts)
keymap('n', 'gi', notify('editor.action.goToImplementation'), opts)
keymap('n', 'gt', notify('editor.action.goToTypeDefinition'), opts)
keymap("n", "[d", notify('editor.action.marker.next'), opts)
keymap("n", "]d", notify('editor.action.marker.prev'), opts)

-- Harpoon
keymap('n', '<leader>a', notify('vscode-harpoon.addEditor'), opts)
keymap('n', '<leader>m', notify('vscode-harpoon.editorQuickPick'), opts)
-- keymap('n', '<C-h>', notify('vscode-harpoon.gotoEditor1'), opts)
-- keymap('n', '<C-j>', notify('vscode-harpoon.gotoEditor2'), opts)
-- keymap('n', '<C-k', notify('vscode-harpoon.gotoEditor3'), opts)
-- keymap('n', '<C-l>', notify('vscode-harpoon.gotoEditor4'), opts)
-- keymap('i', '<C-h>', notify('vscode-harpoon.gotoEditor1'), opts)
-- keymap('i', '<C-j>', notify('vscode-harpoon.gotoEditor2'), opts)
-- keymap('i', '<C-k>', notify('vscode-harpoon.gotoEditor3'), opts)
-- keymap('i', '<C-l>', notify('vscode-harpoon.gotoEditor4'), opts)

-- Marks (Bookmarks)
keymap('n', 'mm', notify('bookmarks.toggle'), opts)
keymap('n', 'mp', notify('bookmarks.jumpToPrevious'), opts)
keymap('n', 'mn', notify('bookmarks.jumpToNext'), opts)

-- Flash/Leap
keymap('n', 's', notify 'leap.find', opts)

-- Trouble (Problems)
keymap('n', '<leader>xd', notify('workbench.actions.view.problems'), opts)

-- Telescope(ish)
keymap('n', '<C-p>', notify('workbench.action.quickOpen'), opts)
keymap('n', '<leader>ff', notify('find-it-faster.findFiles'), opts)
keymap('n', '<leader>fg', notify('find-it-faster.findWithinFiles'), opts)
keymap('n', '<leader>fc', notify('workbench.action.showCommands'), opts)
