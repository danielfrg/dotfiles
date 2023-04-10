installed = {
    "c",
    "lua",
    "javascript",
    "typescript",
    "python",
    "ruby",
    "vim"
}


local status_ok, configs = pcall(require, "nvim-treesitter.configs")
if not status_ok then
    return
end

configs.setup {
    -- A list of parser names, or "all" (the five listed parsers should always be installed)
    --   ensure_installed = "maintained",
    ensure_installed = installed,

    -- Install parsers synchronously (only applied to `ensure_installed`)
    sync_install = false,

    -- Automatically install missing parsers when entering buffer
    -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
    auto_install = false,

    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
    },

    indent = {
        enable = true,
        -- disable = { "yaml" }
    },

    autopairs = {
        enable = true,
    },

    context_commentstring = {
        enable = true,
        enable_autocmd = false,
    },
}
