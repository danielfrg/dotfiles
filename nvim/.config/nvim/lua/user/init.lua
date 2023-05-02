require("user.options")

if vim.g.vscode then
    require("user.editors.vscode")
else
    if vim.g.neovide then
        require("user.editors.neovide")
    end

    require("user.plugins")
    require("user.keymaps")
end
