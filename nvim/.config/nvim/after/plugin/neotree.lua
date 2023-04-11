local status_ok, neotree = pcall(require, "neo-tree")
if not status_ok then
    return
end

local command = require("neo-tree.command")
local U = require("danielfrg.utils")

require("neo-tree").setup({
    filesystem = {
        filtered_items = {
          visible = true,
          hide_dotfiles = false,
          never_show = {
              ".git",
              ".DS_Store",
          },
        },
    }
})

U.keymap("n", "<leader>fe", function()
        command.execute({ toggle = true, position = "float" })
    end,
    { desc = "[F]ile [E]xplorer" })

U.keymap("n", "<leader>pv", function()
        command.execute({ toggle = true, position = "left" })
    end,
    { desc = "[F]ile [E]xplorer (left)" })
