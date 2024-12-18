-- Function to get current mode with custom labels
local function mode_info()
    local modes = {
        ['n']  = { label = 'N', hl = 'StatusModeNormal' },
        ['no'] = { label = 'NORMAL·OPERATOR PENDING', hl = 'StatusModeNormal' },
        ['v']  = { label = 'V', hl = 'StatusModeVisual' },
        ['V']  = { label = 'V', hl = 'StatusModeVisual' },
        [''] = { label = 'V', hl = 'StatusModeVisual' },
        ['s']  = { label = 'SELECT', hl = 'StatusModeVisual' },
        ['S']  = { label = 'S·LINE', hl = 'StatusModeVisual' },
        [''] = { label = 'S·BLOCK', hl = 'StatusModeVisual' },
        ['i']  = { label = 'I', hl = 'StatusModeInsert' },
        ['R']  = { label = 'REPLACE', hl = 'StatusModeInsert' },
        ['Rv'] = { label = 'V·REPLACE', hl = 'StatusModeInsert' },
        ['c']  = { label = 'C', hl = 'StatusModeCommand' },
        ['cv'] = { label = 'VIM EX', hl = 'StatusModeCommand' },
        ['ce'] = { label = 'EX', hl = 'StatusModeCommand' },
        ['r']  = { label = 'PROMPT', hl = 'StatusModeCommand' },
        ['rm'] = { label = 'MORE', hl = 'StatusModeCommand' },
        ['r?'] = { label = 'CONFIRM', hl = 'StatusModeCommand' },
        ['!']  = { label = 'SHELL', hl = 'StatusModeCommand' },
        ['t']  = { label = 'T', hl = 'StatusModeInsert' }
    }
    local current_mode = vim.api.nvim_get_mode().mode
    return modes[current_mode] or { label = current_mode, hl = 'StatusModeNormal' }
end

-- Highlight colors for mode indicator
vim.cmd([[
    highlight StatusModeNormal guibg=#718EC9 guifg=#282828 gui=bold
    highlight StatusModeInsert guibg=#A3BC7B guifg=#282828 gui=bold
    highlight StatusModeVisual guibg=#9A83CB guifg=#282828 gui=bold
    highlight StatusModeCommand guibg=#C9A569 guifg=#282828 gui=bold
]])

---Show attached LSP clients in `[name1, name2]` format.
---Long server names will be modified. For example, `lua-language-server` will be shorten to `lua-ls`
---Returns an empty string if there aren't any attached LSP clients.
---@return string
local function lsp_status()
    local attached_clients = vim.lsp.get_clients({ bufnr = 0 })
    if #attached_clients == 0 then
        return ""
    end
    local it = vim.iter(attached_clients)
    it:map(function(client)
        local name = client.name:gsub("language.server", "ls")
        return name
    end)
    local names = it:totable()
    return "[" .. table.concat(names, ", ") .. "]"
end

function _G.statusline()
    local mode = mode_info()
    return table.concat({
        "%#" .. mode.hl .. "#",  -- Dynamic highlight group for mode
        "  ",                    -- Space
        mode.label,              -- Display mode label (e.g., "NORMAL", "INSERT")
        "  ",                    -- Space
        "%#StatusLine#",         -- Reset highlight group back to default statusline
        " %f",                   -- Current file path relative to working directory
        "%h%w%m%r",              -- File flags: help, preview window, modified, readonly
        "%=",                    -- Right-align the following items
        lsp_status(),            -- Show LSP diagnostics/status from custom function
        " %y",                   -- Filetype
        " %-14(%l,%c%V%)",       -- Line number, column number, virtual column (padded to 14 chars, left-aligned)
        "%P",                    -- Percentage through file (Top/Bot/nn%)
    }, "")
end

vim.o.statusline = "%{%v:lua._G.statusline()%}"
