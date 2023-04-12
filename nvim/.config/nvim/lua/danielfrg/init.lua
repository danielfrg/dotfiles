require("danielfrg.options")
require("danielfrg.keymap")

if vim.g.vscode then
    -- VSCode
    require("danielfrg.vscode")
else
    -- Regular Neovim
    require("danielfrg.plugins")
end
