return {
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      "linrongbin16/lsp-progress.nvim",
      "someone-stole-my-name/yaml-companion.nvim"
    },

    opts = function()
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
            require("lsp-progress").progress,
            {
              function()
                local schema = require("yaml-companion").get_buf_schema(0)
                if schema.result[1].name == "none" then
                  return ""
                end
                return "[" .. schema.result[1].name .. "]"
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

    config = function(_, opts)
      require("lualine").setup(opts)

      vim.api.nvim_create_augroup("lualine_augroup", { clear = true })
      vim.api.nvim_create_autocmd("User", {
        group = "lualine_augroup",
        pattern = "LspProgressStatusUpdated",
        callback = require("lualine").refresh,
      })
    end
  },

  {
    "someone-stole-my-name/yaml-companion.nvim",
    ft = {"yaml"},
    dependencies = {
        {"neovim/nvim-lspconfig"},
        {"nvim-lua/plenary.nvim"},
        {"nvim-telescope/telescope.nvim"}
    },
    config = function(_, opts)
        local cfg = require("yaml-companion").setup(opts)
        require("lspconfig")["yamlls"].setup(cfg)
        require("telescope").load_extension("yaml_schema")
    end
  },

  {
    "linrongbin16/lsp-progress.nvim",
    event = "VeryLazy",
    config = function()
      require("lsp-progress").setup({
        client_format = function(client_name, spinner, series_messages)
          if #series_messages == 0 then
            return nil
          end
          return {
            name = client_name,
            body = spinner .. " " .. table.concat(series_messages, ", "),
          }
        end,
        format = function(client_messages)
          --- @param name string
          --- @param msg string?
          --- @return string
          local function stringify(name, msg)
            return msg and string.format("%s %s", name, msg) or name
          end

          local sign = "" -- nf-fa-gear \uf013
          local lsp_clients = vim.lsp.get_active_clients()
          local messages_map = {}
          for _, climsg in ipairs(client_messages) do
            messages_map[climsg.name] = climsg.body
          end

          if #lsp_clients > 0 then
            table.sort(lsp_clients, function(a, b)
              return a.name < b.name
            end)
            local builder = {}
            for _, cli in ipairs(lsp_clients) do
              if
                  type(cli) == "table"
                  and type(cli.name) == "string"
                  and string.len(cli.name) > 0
              then
                if messages_map[cli.name] then
                  table.insert(
                    builder,
                    stringify(cli.name, messages_map[cli.name])
                  )
                else
                  table.insert(builder, stringify(cli.name))
                end
              end
            end
            if #builder > 0 then
              return sign .. " " .. table.concat(builder, ", ")
            end
          end
          return ""
        end,
      })
    end
  }
}
