local status_ok, neotree = pcall(require, "neo-tree")
if not status_ok then
    return
end

local command = require("neo-tree.command")
local U = require("danielfrg.utils")

require("neo-tree").setup({
    window = {
        position = "float",
    },
    filesystem = {
        filtered_items = {
            visible = true,
            hide_dotfiles = false,
            never_show = {
                ".git",
                ".DS_Store",
            },
        },
        -- Do not open on startup
        hijack_netrw_behavior = "disabled"
    }
})

U.keymap("n", "<leader>fe", function()
        command.execute({ toggle = true, position = "float" })
    end,
    { desc = "Toggle [F]ile [E]xplorer" })

U.keymap("n", "<leader>pv", function()
        command.execute({ toggle = true, position = "float" })
    end,
    { desc = "Toggle [F]ile [E]xplorer" })
