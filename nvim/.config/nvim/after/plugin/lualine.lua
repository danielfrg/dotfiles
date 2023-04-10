local status_ok, lualine = pcall(require, "lualine")
if not status_ok then
    return
end

local branch = {
    "branch",
    icons_enabled = true,
    icon = "",
}

local diagnostics = {
    "diagnostics",
    sources = { "nvim_diagnostic" },
    sections = { "error", "warn" },
    symbols = { error = " ", warn = " " },
    colored = false,
    update_in_insert = false,
    always_visible = true,
}

local mode = {
    "mode",
    fmt = function(str)
        return "-- " .. str .. " --"
    end,
}

local diff = {
    "diff",
    colored = false,
    symbols = { added = " ", modified = " ", removed = " " }, -- changes diff symbols
    -- cond = hide_in_width
}

local location = {
    "location",
    padding = 0,
}

local filetype = {
    "filetype",
    icons_enabled = false,
    icon = nil,
}

local spaces = function()
    return "spaces: " .. vim.api.nvim_buf_get_option(0, "shiftwidth")
end

local lsp = {
    -- Lsp server name .
    function()
        local msg = 'No Active Lsp'
        local buf_ft = vim.api.nvim_buf_get_option(0, 'filetype')
        local clients = vim.lsp.get_active_clients()
        if next(clients) == nil then
            return msg
        end
        for _, client in ipairs(clients) do
            local filetypes = client.config.filetypes
            if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
                return client.name
            end
        end
        return msg
    end,
    icon = ' LSP:',
    -- color = { fg = '#ffffff', gui = 'bold' },
}

local yaml_schema = {
    function()
        local schema = require("yaml-companion").get_buf_schema(0)
        if schema.result[1].name == "none" then
            return ""
        end
        return schema.result[1].name
    end,
    icon = ' Schema:',
}

local config = {
    options = {
        icons_enabled = true,
        theme = "auto",
        component_separators = { left = "|", right = "" },
        section_separators = { left = "", right = "" },
        disabled_filetypes = { "NvimTree", "Outline" },
        always_divide_middle = true,
    },
    sections = {
        lualine_a = { mode, "filename" },
        lualine_b = {},
        lualine_c = {},
        -- lualine_x = { "encoding", "fileformat", "filetype" },
        lualine_x = { diff, location },
        lualine_y = { diagnostics },
        lualine_z = { yaml_schema, lsp },
    },
    inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { "filename" },
        lualine_x = { "location" },
        lualine_y = {},
        lualine_z = {},
    },
    tabline = {},
    extensions = {},
}

-- Inserts a component in lualine_c at left section
-- local function ins_left(component)
--   table.insert(config.sections.lualine_c, component)
-- end

-- -- Inserts a component in lualine_x at right section
-- local function ins_right(component)
--   table.insert(config.sections.lualine_x, component)
-- end

-- ins_right {
--   -- Lsp server name .
--   function()
--     local msg = 'No Active Lsp'
--     local buf_ft = vim.api.nvim_buf_get_option(0, 'filetype')
--     local clients = vim.lsp.get_active_clients()
--     if next(clients) == nil then
--       return msg
--     end
--     for _, client in ipairs(clients) do
--       local filetypes = client.config.filetypes
--       if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
--         return client.name
--       end
--     end
--     return msg
--   end,
--   icon = ' LSP:',
--   color = { fg = '#ffffff', gui = 'bold' },
-- }

-- local function get_schema()
--   local schema = require("yaml-companion").get_buf_schema(0)
--   if schema.result[1].name == "none" then
--     return ""
--   end
--   return schema.result[1].name
-- end

-- ins_right {
--     get_schema,
--     icon = ' Schema:',
-- }

-- Configure lualine
lualine.setup(config)
