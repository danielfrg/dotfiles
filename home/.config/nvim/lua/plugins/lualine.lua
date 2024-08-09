-- From: https://gist.github.com/Lamarcke/36e086dd3bb2cebc593d505e2f838e07
local function get_attached_clients()
    local buf_clients = vim.lsp.get_active_clients({ bufnr = 0 })
    if #buf_clients == 0 then
        return "NO LSP"
    end

    local buf_ft = vim.bo.filetype
    local buf_client_names = {}

    -- add client
    for _, client in pairs(buf_clients) do
        if client.name ~= "copilot" and client.name ~= "null-ls" then
            table.insert(buf_client_names, client.name)
        end
    end
    -- This needs to be a string only table so we can use concat below
    local unique_client_names = {}
    for _, client_name_target in ipairs(buf_client_names) do
        local is_duplicate = false
        for _, client_name_compare in ipairs(unique_client_names) do
            if client_name_target == client_name_compare then
                is_duplicate = true
            end
        end
        if not is_duplicate then
            table.insert(unique_client_names, client_name_target)
        end
    end

    local client_names_str = table.concat(unique_client_names, ", ")
    local language_servers = string.format("[%s]", client_names_str)

    return language_servers
end


return {
    {
        "nvim-lualine/lualine.nvim",

        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },

        opts = function()
            local attached_clients = {
                get_attached_clients,
                color = {
                    gui = "bold"
                }
            }

            return {
                options = {
                    icons_enabled = true,
                    theme = "auto",
                    globalstatus = true,
                    -- disabled_filetypes = { statusline = { "dashboard", "alpha", "starter" } },
                    component_separators = "",
                    section_separators = { left = "", right = "" },
                },
                sections = {
                    lualine_b = {},
                    lualine_c = {
                        {
                            "diff",
                            symbols = {
                                added = " ",
                                modified = " ",
                                removed = " ",
                            },
                            diff_color = {
                                added = { fg = "#777777" },
                                modified = { fg = "#777777" },
                                removed = { fg = "#777777" },
                            },
                            -- source = function()
                            --   local gitsigns = vim.b.gitsigns_status_dict
                            --   if gitsigns then
                            --     return {
                            --       added = " ",
                            --       modified = " ",
                            --       removed = " ",
                            --     }
                            --   end
                            -- end,
                        }
                    },
                    lualine_x = {
                        attached_clients,
                        {
                            function()
                                local schema = require("yaml-companion").get_buf_schema(0)
                                if schema.result[1].name == "none" then
                                    return ""
                                end
                                return "[schema: " .. schema.result[1].name .. "]"
                            end,
                        },
                    },
                    lualine_y = {
                        -- { "progress", separator = " ",                  padding = { left = 1, right = 0 } },
                        { "location", padding = { left = 0, right = 1 } },
                    },
                    lualine_z = { "branch" }
                }
            }
        end,
    },

    {
        "someone-stole-my-name/yaml-companion.nvim",
        lazy = true,

        ft = { "yaml" },
        dependencies = {
            { "neovim/nvim-lspconfig" },
            { "nvim-telescope/telescope.nvim" }
        },
        config = function(_, opts)
            local cfg = require("yaml-companion").setup(opts)
            require("lspconfig")["yamlls"].setup(cfg)
            require("telescope").load_extension("yaml_schema")
        end
    },
}
