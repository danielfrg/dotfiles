-- Function to get current mode with custom labels
local function mode_info()
    local modes = {
        ['n']  = { label = 'NOR', hl = 'StatusModeNormal' },
        ['no'] = { label = 'NORMAL·OPERATOR PENDING', hl = 'StatusModeNormal' },
        ['v']  = { label = 'VIS', hl = 'StatusModeVisual' },
        ['V']  = { label = 'VIS', hl = 'StatusModeVisual' },
        ['']   = { label = 'VIS', hl = 'StatusModeVisual' },
        ['s']  = { label = 'SELECT', hl = 'StatusModeVisual' },
        ['S']  = { label = 'S·LINE', hl = 'StatusModeVisual' },
        ['']   = { label = 'S·BLOCK', hl = 'StatusModeVisual' },
        ['i']  = { label = 'INS', hl = 'StatusModeInsert' },
        ['R']  = { label = 'REPLACE', hl = 'StatusModeInsert' },
        ['Rv'] = { label = 'V·REPLACE', hl = 'StatusModeInsert' },
        ['c']  = { label = 'COM', hl = 'StatusModeCommand' },
        ['cv'] = { label = 'VIM EX', hl = 'StatusModeCommand' },
        ['ce'] = { label = 'EX', hl = 'StatusModeCommand' },
        ['r']  = { label = 'PROMPT', hl = 'StatusModeCommand' },
        ['rm'] = { label = 'MORE', hl = 'StatusModeCommand' },
        ['r?'] = { label = 'CONFIRM', hl = 'StatusModeCommand' },
        ['!']  = { label = 'SHELL', hl = 'StatusModeCommand' },
        ['t']  = { label = 'TER', hl = 'StatusModeInsert' }
    }
    local current_mode = vim.api.nvim_get_mode().mode
    return modes[current_mode] or { label = current_mode, hl = 'StatusModeNormal' }
end

-- Highlight colors for mode indicator
-- vim.cmd([[
--     highlight StatusModeNormal guibg=#718EC9 guifg=#282828 gui=bold
--     highlight StatusModeInsert guibg=#A3BC7B guifg=#282828 gui=bold
--     highlight StatusModeVisual guibg=#9A83CB guifg=#282828 gui=bold
--     highlight StatusModeCommand guibg=#C9A569 guifg=#282828 gui=bold
-- ]])

---Show attached LSP clients in `[name1, name2]` format.
---Long server names will be modified. For example, `lua-language-server` will be shorten to `lua-ls`
---Returns an empty string if there aren't any attached LSP clients.
---@return string
local function lsp_status()
    local bufnr = vim.api.nvim_get_current_buf()
    local clients = vim.lsp.get_clients and vim.lsp.get_clients({ bufnr = bufnr }) or
        vim.lsp.get_active_clients({ bufnr = bufnr })

    if #clients == 0 then
        return ""
    end

    local names = {}
    for _, client in ipairs(clients) do
        table.insert(names, client.name)
    end

    return "[" .. table.concat(names, ", ") .. "]"
end

function _G.statusline()
    local mode = mode_info()
    return table.concat({
        "%#" .. mode.hl .. "#", -- Dynamic highlight group for mode
        "  ",                   -- Space
        mode.label,             -- Display mode label (e.g., "NORMAL", "INSERT")
        "  ",                   -- Space
        "%#StatusLine#",        -- Reset highlight group back to default statusline
        " %f",                  -- Current file path relative to working directory
        "%h%w%m%r",             -- File flags: help, preview window, modified, readonly
        "%=",                   -- Right-align the following items
        lsp_status(),           -- Show LSP diagnostics/status from custom function
        " %l:%c%V",             -- Line number, column number, virtual column
    }, "")
end

vim.o.statusline = "%{%v:lua._G.statusline()%}"
