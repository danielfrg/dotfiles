vim.g.neovide_input_use_logo = 1         -- enable use of the logo (cmd) key
vim.keymap.set('n', '<D-s>', ':w<CR>')   -- Save
vim.keymap.set('v', '<D-c>', '"+y')      -- Copy
vim.keymap.set('n', '<D-v>', '"+P')      -- Paste normal mode
vim.keymap.set('i', '<D-v>', '<ESC>+Pi') -- Paste insert mode
vim.keymap.set('v', '<D-v>', '"+P')      -- Paste visual mode
vim.keymap.set('c', '<D-v>', '<C-R>+')   -- Paste command mode

vim.o.guifont = "Hack Nerd Font:h17"
