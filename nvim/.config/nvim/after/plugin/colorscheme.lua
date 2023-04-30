local status_ok, astrotheme = pcall(require, "astrotheme")
if not status_ok then
    return
end

astrotheme.setup({
    plugin_default = true,
})

local colorscheme = "astrodark"

local status_ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)
if not status_ok then
    return
end
