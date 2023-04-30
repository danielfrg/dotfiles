local status_ok, neotree = pcall(require, "neo-tree")
if not status_ok then
    return
end

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
