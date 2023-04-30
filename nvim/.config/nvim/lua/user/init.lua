require("user.options")
-- require("user.keymap")

if vim.g.vscode then
    -- VSCode
    require("user.vscode")
else
    -- Regular Neovim
    if vim.g.neovide then
        require("user.neovide")
    end
    require("user.plugins")
end
