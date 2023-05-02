local status_ok, lualine = pcall(require, "lualine")
if not status_ok then return end

local U = require("user.utils")

local sep_icons = {
    default = { left = "", right = " " },
    triange = { left = "", right = " " },
    round = { left = "", right = "" },
    block = { left = "█", right = "█" },
    arrow = { left = "", right = "" },
}

local git_icons = {
    added = " ",
    modified = " ",
    removed = " ",
}

local M = {}

-- From AstroVim Heirline (lualine) utils
function lsp_clients()
    -- local buf_ft = vim.api.nvim_buf_get_option(0, "filetype")
    local buf_client_names = {}
    local clients = vim.lsp.get_active_clients()

    local len = 0

    for _, client in pairs(clients) do
        len = len + 1
        if client.name == "null-ls" then
            local null_ls_sources = {}
            for _, type in ipairs { "FORMATTING", "DIAGNOSTICS" } do
                for _, source in ipairs(M.null_ls_sources(vim.bo.filetype, type)) do
                    null_ls_sources[source] = true
                end
            end
            vim.list_extend(buf_client_names, vim.tbl_keys(null_ls_sources))
        else
            table.insert(buf_client_names, client.name)
        end
    end
    if len == 0 then
        return "No Active Lsp"
    end
    return table.concat(buf_client_names, ", ")
    -- for _, client in ipairs(clients) do
    --     local filetypes = client.config.filetypes
    --     if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
    --         return client.name
    --     end
    -- end
    -- return msg
end

-- From AstroVim Heirline (lualine) utils
function M.null_ls_providers(filetype)
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

-- From AstroVim Heirline (lualine) utils
function M.null_ls_sources(filetype, method)
    local methods_avail, methods = pcall(require, "null-ls.methods")
    return methods_avail and M.null_ls_providers(filetype)[methods.internal[method]] or {}
end

function yaml_schema()
    local status_ok, yaml_companion = pcall(require, "yaml-companion")
    if not status_ok then return end


    local schema = yaml_companion.get_buf_schema(0)
    if schema.result[1].name == "none" then
        return ""
    end
    return schema.result[1].name
end

lualine.setup({
    options = {
        -- theme = "catppuccin",
        icons_enabled = true,
        component_separators = { left = "", right = "" },
        section_separators = { left = sep_icons.default.right, right = sep_icons.default.left },
    },
    sections = {
        lualine_a = { "mode" },
        lualine_b = {
            {
                "",
                draw_empty = true,
            }
        },
        lualine_c = {
            { "filename" },
            {
                "diff",
                colored = false,
                color = { fg = "#6F737B" },
                -- symbols = { added = git_icons.added, modified = git_icons.modified, removed = git_icons.removed },
            },
            {
                "diagnostics"
            }
        },
        lualine_x = {
            {
                yaml_schema,
                icon = " ",
                color = { fg = "#6F737B" },
            },
            {
                lsp_clients,
                icon = " ",
                color = { fg = "#6F737B" },
            }
        },
        lualine_y = {},
        -- lualine_z = {}
    },
    tabline = {
        lualine_a = {{

            "buffers",
            -- section_separators = { left = "", right = "" },
        }
        },
        lualine_b = {},
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = {}
    }
})
