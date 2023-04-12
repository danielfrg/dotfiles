local status_ok, alpha = pcall(require, "alpha")
if not status_ok then
    return
end

local dashboard = require("alpha.themes.dashboard")
dashboard.section.header.val = {
    [[                                                                ]],
    [[ ________  ________  ________  ________  ___       _______      ]],
    [[|\   ____\|\   __  \|\   __  \|\   ____\|\  \     |\  ___ \     ]],
    [[\ \  \___|\ \  \|\  \ \  \|\  \ \  \___|\ \  \    \ \   __/|    ]],
    [[ \ \  \  __\ \  \\\  \ \  \\\  \ \  \  __\ \  \    \ \  \_|/__  ]],
    [[  \ \  \|\  \ \  \\\  \ \  \\\  \ \  \|\  \ \  \____\ \  \_|\ \ ]],
    [[   \ \_______\ \_______\ \_______\ \_______\ \_______\ \_______\]],
    [[    \|_______|\|_______|\|_______|\|_______|\|_______|\|_______|]],
}
dashboard.section.buttons.val = {
    dashboard.button("f", "  Find file", ":lua require'telescope.builtin'.git_files(require('telescope.themes').get_dropdown({ previewer = false })) <CR>"),
    dashboard.button("e", "  New file", ":ene <BAR> startinsert <CR>"),
    dashboard.button("r", "  Recently used files", ":Telescope oldfiles <CR>"),
    dashboard.button("t", "  Find text", ":Telescope live_grep <CR>"),
    dashboard.button("c", "  Configuration", ":e ~/.config/nvim/init.lua <CR>"),
    dashboard.button("q", "  Quit Neovim", ":qa<CR>"),
}

local function footer()
    return "danielfrg"
end

dashboard.section.footer.val = footer()

dashboard.section.footer.opts.hl = "Type"
dashboard.section.header.opts.hl = "Include"
dashboard.section.buttons.opts.hl = "Keyword"

dashboard.opts.opts.noautocmd = true
-- vim.cmd([[autocmd User AlphaReady echo 'ready']])
alpha.setup(dashboard.opts)
