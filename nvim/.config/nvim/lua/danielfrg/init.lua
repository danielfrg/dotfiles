require("danielfrg.options")
require("danielfrg.keymap")

if vim.g.vscode then
    -- VSCode
    require("danielfrg.vscode")
else
    -- Regular Neovim
    if vim.g.neovide then
        require("danielfrg.neovide")
    end
    require("danielfrg.plugins")
end
