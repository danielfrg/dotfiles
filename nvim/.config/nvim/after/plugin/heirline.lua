-- Based on how AstroVim looks but mostly uses the Heirline Cookbook
-- https://github.com/AstroNvim/AstroNvim/blob/main/lua/plugins/heirline.lua
-- https://github.com/rebelot/heirline.nvim/blob/master/cookbook.md

local status_ok, heirline = pcall(require, "heirline")
if not status_ok then
    return
end

local conditions = require("heirline.conditions")
local utils = require("heirline.utils")

local yaml_companion = require("yaml-companion")

local status_ok, astrotheme = pcall(require, "astrotheme")
if not status_ok then
    return
end

local U = require("user.utils")

local colors = {
    bg = utils.get_highlight("StatusLine").bg,
    fg = utils.get_highlight("StatusLine").fg,
    red = utils.get_highlight("DiagnosticError").fg,
    green = utils.get_highlight("String").fg,
    blue = utils.get_highlight("Function").fg,
    gray = utils.get_highlight("NonText").fg,
    orange = utils.get_highlight("Constant").fg,
    purple = utils.get_highlight("Statement").fg,
    cyan = utils.get_highlight("Special").fg,
    tab_fg = utils.get_highlight("TabLine").fg,
    tab_bg = "None",
    tab_active_fg = utils.get_highlight("TabLineSel").fg,
    tab_active_bg = utils.get_highlight("TabLineSel").bg,
}

local mode_names = {
    ["n"] = "NORMAL",
    ["no"] = "OP",
    ["nov"] = "OP",
    ["noV"] = "OP",
    ["no"] = "OP",
    ["niI"] = "NORMAL",
    ["niR"] = "NORMAL",
    ["niV"] = "NORMAL",
    ["i"] = "INSERT",
    ["ic"] = "INSERT",
    ["ix"] = "INSERT",
    ["t"] = "TERM",
    ["nt"] = "TERM",
    ["v"] = "VISUAL",
    ["vs"] = "VISUAL",
    ["V"] = "VISUAL",
    ["Vs"] = "VISUAL",
    [""] = "V-BLOCK",
    ["s"] = "V-BLOCK",
    ["R"] = "REPLACE",
    ["Rc"] = "REPLACE",
    ["Rx"] = "REPLACE",
    ["Rv"] = "V-REPLACE",
    ["s"] = "SELECT",
    ["S"] = "SELECT",
    [""] = "BLOCK",
    ["c"] = "COMMAND",
    ["cv"] = "COMMAND",
    ["ce"] = "COMMAND",
    ["r"] = "PROMPT",
    ["rm"] = "MORE",
    ["r?"] = "CONFIRM",
    ["!"] = "SHELL",
    ["null"] = "NULL",
}

local mode_colors = {
    n = { "blue", "white" },
    i = { "green", "white" },
    v = { "yellow", "black" },
    V = { "yellow", "black" },
    ["\22"] = { "yellow", "black" },
    c = { "orange", "black" },
    s = { "purple", "white" },
    S = { "purple", "white" },
    ["\19"] = { "purple", "white" },
    R = { "orange", "white" },
    r = { "orange", "white" },
    ["!"] = { "red", "white" },
    t = { "red", "white" },
}

local M = { utils = {} }

-- From AstroVim Heirline Utils
function M.utils.null_ls_providers(filetype)
    local registered = {}
    -- try to load null-ls
    local sources_avail, sources = pcall(require, "null-ls.sources")
    if sources_avail then
        -- get the available sources of a given filetype
        for _, source in ipairs(sources.get_available(filetype)) do
            -- get each source name
            for method in pairs(source.methods) do
                registered[method] = registered[method] or {}
                table.insert(registered[method], source.name)
            end
        end
    end
    -- return the found null-ls sources
    return registered
end

-- From AstroVim Heirline Utils
function M.utils.null_ls_sources(filetype, method)
    local methods_avail, methods = pcall(require, "null-ls.methods")
    return methods_avail and M.utils.null_ls_providers(filetype)[methods.internal[method]] or {}
end

local Align = { provider = "%=" }
local StatusSpace = { provider = " "}
local TabLineSpace = { provider = " ", hl = { bg = "none" } }

local ViMode = {
    -- get vim current mode, this information will be required by the provider
    -- and the highlight functions, so we compute it only once per component
    -- evaluation and store it as a component attribute
    init = function(self)
        self.mode = vim.fn.mode(1) -- :h mode()
    end,
    provider = function(self)
        return "  " .. mode_names[self.mode] .. "  "
    end,
    -- Change colors based on the mode
    hl = function(self)
        local mode = self.mode:sub(1, 1) -- get only the first mode character
        return { bg = mode_colors[mode][1], fg = mode_colors[mode][2], bold = true }
    end,
    -- Re-evaluate the component only on ModeChanged event!
    -- Also allows the statusline to be re-evaluated when entering operator-pending mode
    update = {
        "ModeChanged",
        pattern = "*:*",
        callback = vim.schedule_wrap(function()
            vim.cmd("redrawstatus")
        end),
    },
}

local ViModeBGColor = {
    init = function(self)
        self.mode = vim.fn.mode(1) -- :h mode()
    end,
    provider = function(self)
        return "  "
    end,

    hl = function(self)
        local mode = self.mode:sub(1, 1) -- get only the first mode character
        return { bg = mode_colors[mode][1], fg = mode_colors[mode][2], bold = true }
    end,
    update = {
        "ModeChanged",
        pattern = "*:*",
        callback = vim.schedule_wrap(function()
            vim.cmd("redrawstatus")
        end),
    },
}

local FileNameBlock = {
    -- let's first set up some attributes needed by this component and it's children
    init = function(self)
        self.filename = vim.api.nvim_buf_get_name(0)
    end,
}

-- We can now define some children separately and add them later
local FileIcon = {
    init = function(self)
        local filename = self.filename
        local extension = vim.fn.fnamemodify(filename, ":e")
        self.icon, self.icon_color = require("nvim-web-devicons").get_icon_color(filename, extension, { default = true })
    end,
    provider = function(self)
        return self.icon and (self.icon .. " ")
    end,
    hl = function(self)
        return { bg = "none", fg = self.icon_color }
    end
}

local FileName = {
    provider = function(self)
        -- first, trim the pattern relative to the current directory. For other
        -- options, see :h filename-modifers
        local filename = vim.fn.fnamemodify(self.filename, ":.")
        if filename == "" then return "[No Name]" end
        -- now, if the filename would occupy more than 1/4th of the available
        -- space, we trim the file path to its initials
        -- See Flexible Components section below for dynamic truncation
        if not conditions.width_percent_below(#filename, 0.25) then
            filename = vim.fn.pathshorten(filename)
        end
        return filename
    end,
    -- hl = { fg = utils.get_highlight("Directory").fg },
}

local FileFlags = {
    {
        condition = function()
            return vim.bo.modified
        end,
        provider = "[+]",
        hl = { fg = "green" },
    },
    {
        condition = function()
            return not vim.bo.modifiable or vim.bo.readonly
        end,
        provider = "",
        hl = { fg = "orange" },
    },
}

-- Add the children to our FileNameBlock component
FileNameBlock = utils.insert(FileNameBlock,
    FileIcon,
    FileName,
    FileFlags,
    { provider = '%<' } -- this means that the statusline is cut here when there's not enough space
)

local GitBranch = {
    condition = conditions.is_git_repo,
    init = function(self)
        self.status_dict = vim.b.gitsigns_status_dict
        self.has_changes = self.status_dict.added ~= 0 or self.status_dict.removed ~= 0 or self.status_dict.changed ~= 0
    end,
    provider = function(self)
        return " " .. self.status_dict.head
    end,
    hl = { bg = "bg", fg = "blue" }
}

local GitDiff = {
    condition = conditions.is_git_repo,

    init = function(self)
        self.status_dict = vim.b.gitsigns_status_dict
        self.has_changes = self.status_dict.added ~= 0 or self.status_dict.removed ~= 0 or self.status_dict.changed ~= 0
    end,

    {
        provider = function(self)
            local count = self.status_dict.added or 0
            return count > 0 and (" " .. count .. " ")
        end,
        hl = { bg = "bg", fg = "green" },
    },
    {
        provider = function(self)
            local count = self.status_dict.removed or 0
            return count > 0 and (" " .. count .. " ")
        end,
        hl = { bg = "bg", fg = "red" },
    },
    {
        provider = function(self)
            local count = self.status_dict.changed or 0
            return count > 0 and (" " .. count .. " ")
        end,
        hl = { bg = "bg", fg = "orange" },
    },
}

local Diagnostics = {
    condition = conditions.has_diagnostics,
    update = { "DiagnosticChanged", "BufEnter" },
    on_click = {
        callback = function()
            require("trouble").toggle({ mode = "document_diagnostics" })
        end,
        name = "heirline_diagnostics",
    },
    static = {
        error_icon = " ",
        warn_icon = " ",
        info_icon = " ",
        hint_icon = " ",
    },
    init = function(self)
        self.errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
        self.warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
        self.hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
        self.info = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
    end,
    {
        provider = function(self)
            return self.errors > 0 and (self.error_icon .. self.errors .. " ")
        end,
        hl = { bg = "bg", fg = "red" },
    },
    {
        provider = function(self)
            return self.warnings > 0 and (self.warn_icon .. self.warnings .. " ")
        end,
        hl = { bg = "bg", fg = "orange" },
    },
    {
        provider = function(self)
            return self.info > 0 and (self.info_icon .. self.info .. " ")
        end,
        hl = { bg = "bg", fg = "blue" },
    },
    {
        provider = function(self)
            return self.hints > 0 and (self.hint_icon .. self.hints)
        end,
        hl = { bg = "bg", fg = "yellow" },
    },
    -- StatusSpace
}

local YAMLSchema = {
    condition = conditions.lsp_attached,
    update    = { 'LspAttach', 'LspDetach', "BufEnter" },
    provider  = function(self)
        local schema = yaml_companion.get_buf_schema(0)
        if schema.result[1].name == "none" then
            return ""
        end
        return " Schema: " .. schema.result[1].name
    end,
    on_click = {
        callback = function()
            vim.cmd("Telescope yaml_schema")
        end,
        name = "heirline_yaml_shema_callback",
    },
    hl        = { bg = "bg", fg = "white" },
    StatusSpace
}

local LSPActive = {
    condition = conditions.lsp_attached,
    update    = { 'LspAttach', 'LspDetach', "BufEnter" },

    -- Get the name of the servers attached to the current buffer
    provider  = function(self)
        local buf_client_names = {}
        for _, client in pairs(vim.lsp.get_active_clients { bufnr = self and self.bufnr or 0 }) do
            if client.name == "null-ls" then
                local null_ls_sources = {}
                for _, type in ipairs { "FORMATTING", "DIAGNOSTICS" } do
                    for _, source in ipairs(M.utils.null_ls_sources(vim.bo.filetype, type)) do
                        null_ls_sources[source] = true
                    end
                end
                vim.list_extend(buf_client_names, vim.tbl_keys(null_ls_sources))
            else
                table.insert(buf_client_names, client.name)
            end
        end
        local str = table.concat(buf_client_names, ", ")
        return "  " .. str .. ""
    end,
    hl        = { bg = "bg", fg = "white" },
    StatusSpace
}

local StatusLine = {
    ViMode,
    Align,
    YAMLSchema, LSPActive, Diagnostics, GitDiff, ViModeBGColor
}

--------------------------------------------------------------------------------
-- TabLine

local TablineBufNumber = {
    provider = function(self)
        return tostring(self.bufnr) .. ". "
    end,
    hl = "Comment",
}

-- we redefine the filename component, as we probably only want the tail and not the relative path
local TablineFileName = {
    provider = function(self)
        -- self.filename will be defined later, just keep looking at the example!
        local filename = self.filename
        filename = filename == "" and "[No Name]" or vim.fn.fnamemodify(filename, ":t")
        return filename
    end,
    hl = function(self)
        return { bg = "tab_bg", fg = "" .. (self.is_active and "white" or "grey"), bold = self.is_active or self.is_visible }
    end,
}

local TablineFileFlags = {
    {
        condition = function(self)
            return vim.api.nvim_buf_get_option(self.bufnr, "modified")
        end,
        provider = "[+]",
        hl = { bg = "tab_bg", fg = "green" },
    },
    {
        condition = function(self)
            return not vim.api.nvim_buf_get_option(self.bufnr, "modifiable")
                or vim.api.nvim_buf_get_option(self.bufnr, "readonly")
        end,
        provider = function(self)
            if vim.api.nvim_buf_get_option(self.bufnr, "buftype") == "terminal" then
                return "  "
            else
                return ""
            end
        end,
        hl = { bg = "tab_bg", fg = "orange" },
    },
}

-- Here the filename block finally comes together
local TablineFileNameBlock = {
    init = function(self)
        self.filename = vim.api.nvim_buf_get_name(self.bufnr)
    end,
    hl = function(self)
        if self.is_active then
            return "TabLineSel"
        else
            return "TabLine"
        end
    end,
    on_click = {
        callback = function(_, minwid, _, button)
            if (button == "m") then -- close on mouse middle click
                vim.schedule(function()
                    vim.api.nvim_buf_delete(minwid, { force = false })
                end)
            else
                vim.api.nvim_win_set_buf(0, minwid)
            end
        end,
        minwid = function(self)
            return self.bufnr
        end,
        name = "heirline_tabline_buffer_callback",
    },
    -- TablineBufNumber,
    FileIcon,
    TablineFileName,
    TablineFileFlags,
}

-- a nice "x" button to close the buffer
local TablineCloseButton = {
    condition = function(self)
        return not vim.api.nvim_buf_get_option(self.bufnr, "modified")
    end,
    {
        provider = "  ",
        hl = { bg = "tab_bg", fg = "grey" },
        on_click = {
            callback = function(_, minwid)
                vim.schedule(function()
                    vim.api.nvim_buf_delete(minwid, { force = false })
                    vim.cmd.redrawtabline()
                end)
            end,
            minwid = function(self)
                return self.bufnr
            end,
            name = "heirline_tabline_close_buffer_callback",
        },
    },
}

-- The final touch: Space between the tabs
local TablineBufferBlock = utils.surround({ "", " " }, function(self)
    if self.is_active then
        return utils.get_highlight("TabLineSel").bg
    else
        return utils.get_highlight("TabLine").bg
    end
end, { TabLineSpace, TabLineSpace, TabLineSpace, TablineFileNameBlock, TabLineSpace, TablineCloseButton, TabLineSpace })

-- Create the list of buffers
local BufferLine = utils.make_buflist(
    TablineBufferBlock,
    { provider = "", hl = { fg = "white" } }, -- left truncation
    { provider = "", hl = { fg = "white" } } -- right trunctation
)

heirline.setup({
    statusline = StatusLine,
    tabline = BufferLine,
    opts = {
        colors = colors,
    }
})
