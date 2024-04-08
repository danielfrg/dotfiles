return {
    {
        "hrsh7th/nvim-cmp",
        event = "VeryLazy",
        -- event = "InsertEnter",

        dependencies = {
            "saadparwaiz1/cmp_luasnip",
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-path",
            {
                "zbirenbaum/copilot-cmp",
                dependencies = "copilot.lua",
                opts = {},
                config = function(_, opts)
                    local copilot_cmp = require("copilot_cmp")
                    copilot_cmp.setup(opts)
                    -- attach cmp source whenever copilot attaches
                    -- fixes lazy-loading issues with the copilot cmp source
                    -- LazyVim.lsp.on_attach(function(client)
                    --     if client.name == "copilot" then
                    --         copilot_cmp._on_insert_enter({})
                    --     end
                    -- end)
                end,
            },
        },

        config = function(_, opts)
            local cmp = require('cmp')
            local luasnip = require('luasnip')
            luasnip.config.setup {}

            cmp.setup({
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                completion = { completeopt = 'menu,menuone,noinsert' },
                window = {
                    completion = cmp.config.window.bordered(),
                    documentation = cmp.config.window.bordered(),
                },
                mapping = cmp.mapping.preset.insert({
                    -- Select the [n]ext item
                    ['<C-n>'] = cmp.mapping.select_next_item(),
                    -- Select the [p]revious item
                    ['<C-p>'] = cmp.mapping.select_prev_item(),

                    -- Scroll the documentation window [b]ack / [f]orward
                    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
                    ['<C-f>'] = cmp.mapping.scroll_docs(4),

                    -- Accept ([y]es) the completion.
                    --  This will auto-import if your LSP supports it.
                    --  This will expand snippets if the LSP sent a snippet.
                    ['<C-y>'] = cmp.mapping.confirm { select = true },
                    ["<CR>"] = cmp.mapping.confirm({ select = true }),

                    -- Manually trigger a completion from nvim-cmp.
                    --  Generally you don't need this, because nvim-cmp will display
                    --  completions whenever it has completion options available.
                    ['<M-Space>'] = cmp.mapping.complete {},

                    -- Think of <c-l> as moving to the right of your snippet expansion.
                    --  So if you have a snippet that's like:
                    --  function $name($args)
                    --    $body
                    --  end
                    --
                    -- <c-l> will move you to the right of each of the expansion locations.
                    -- <c-h> is similar, except moving you backwards.
                    ['<C-l>'] = cmp.mapping(function()
                        if luasnip.expand_or_locally_jumpable() then
                            luasnip.expand_or_jump()
                        end
                    end, { 'i', 's' }),
                    ['<C-h>'] = cmp.mapping(function()
                        if luasnip.locally_jumpable(-1) then
                            luasnip.jump(-1)
                        end
                    end, { 'i', 's' }),
                    -- Trying to not use <Tab> and <S-Tab>
                    -- ["<Tab>"] = cmp.mapping(function(fallback)
                    --     if cmp.visible() then
                    --         cmp.select_next_item()
                    --     elseif require("luasnip").expand_or_jumpable() then
                    --         vim.fn.feedkeys(
                    --             vim.api.nvim_replace_termcodes("<Plug>luasnip-expand-or-jump", true, true, true), "")
                    --     else
                    --         fallback()
                    --     end
                    -- end, {
                    --     "i",
                    --     "s",
                    -- }),
                    -- ["<S-Tab>"] = cmp.mapping(function(fallback)
                    --     if cmp.visible() then
                    --         cmp.select_prev_item()
                    --     elseif require("luasnip").jumpable(-1) then
                    --         vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>luasnip-jump-prev", true, true, true),
                    --             "")
                    --     else
                    --         fallback()
                    --     end
                    -- end, {
                    --     "i",
                    --     "s",
                    -- }),
                }),
                sources = cmp.config.sources({
                    { name = 'nvim_lsp' },
                    { name = 'luasnip' },
                    { name = 'path' },
                    { name = 'copilot' },
                })
            })
        end,

    },

    {
        "L3MON4D3/LuaSnip",
        lazy = true,
        dependencies = {
            "saadparwaiz1/cmp_luasnip",
            {
                "rafamadriz/friendly-snippets",
                config = function()
                    require("luasnip.loaders.from_vscode").lazy_load()
                end,
            },
        },
        build = (function()
            -- Build Step is needed for regex support in snippets.
            return "make install_jsregexp"
        end)(),
    },


}
