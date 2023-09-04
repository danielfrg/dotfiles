local status_ok, blankline = pcall(require, "indent_blankline")
if not status_ok then return end

vim.cmd [[highlight IndentBlanklineNoCurrent guifg=#282828 gui=nocombine ]]
vim.cmd [[highlight IndentBlanklineContext guifg=#494949 gui=nocombine ]]

blankline.setup({
    char = "▏",
    context_char = "▏",
    use_treesitter = true,
    show_current_context = true,
    show_current_context_start = true,
    show_trailing_blankline_indent = false,
    show_first_indent_level = false,
    filetype_exclude = {
        "help",
        "startify",
        "aerial",
        "alpha",
        "dashboard",
        "lazy",
        "neogitstatus",
        "NvimTree",
        "neo-tree",
        "Trouble",
    },
    char_highlight_list = { "IndentBlanklineNoCurrent" },
    context_highlight_list = { "IndentBlanklineContext" }
})
