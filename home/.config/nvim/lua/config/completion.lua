-- vim.opt.completeopt = { "menu", "menuone", "noselect" }
-- vim.opt.shortmess:append("c")

-- local lspkind = require("lspkind")
-- lspkind.init({})

-- local cmp = require("cmp")

-- local base_sources = {
--     { name = "nvim_lsp", group_index = 2 },
--     { name = "path",     group_index = 3 },
--     { name = "buffer",   group_index = 4 },
-- }

-- local copilot_source = { name = "copilot", group_index = 2 }

-- -- Create a shallow copy of base_sources
-- local sources = { unpack(base_sources) }

-- -- Add copilot_source to the copy
-- table.insert(sources, copilot_source)

-- cmp.setup({
--     sources = sources,
--     mapping = {
--         ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
--         ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
--         ["<C-y>"] = cmp.mapping(
--             cmp.mapping.confirm({
--                 behavior = cmp.ConfirmBehavior.Insert,
--                 select = true,
--             }),
--             { "i", "c" }
--         ),
--     },

--     -- Enable luasnip to handle snippet expansion for nvim-cmp
--     snippet = {
--         expand = function(args)
--             vim.snippet.expand(args.body)
--         end,
--     },
-- })

-- cmp.setup.cmdline('/', {
--     mapping = cmp.mapping.preset.cmdline(),
--     sources = {
--         { name = 'buffer' }
--     }
-- })

-- cmp.setup.cmdline(':', {
--     mapping = cmp.mapping.preset.cmdline(),
--     sources = cmp.config.sources({
--         { name = 'path' }
--     }, {
--         {
--             name = 'cmdline',
--             option = {
--                 ignore_cmds = { 'Man', '!' }
--             }
--         }
--     })
-- })

-- vim.api.nvim_create_user_command("CopilotDisable", function(args)
--     vim.g.disable_copilot = true
--     cmp.setup({
--         sources = base_sources,
--     })
-- end, {
--     desc = "Disable Copilot",
--     bang = true,
-- })

-- vim.api.nvim_create_user_command("CopilotEnable", function(args)
--     vim.g.disable_copilot = false

--     -- Create a shallow copy of base_sources
--     local sources = { unpack(base_sources) }
--     -- Add copilot_source to the copy
--     table.insert(sources, copilot_source)

--     cmp.setup({
--         sources = sources,
--     })
-- end, {
--     desc = "Disable Copilot",
--     bang = true,
-- })
