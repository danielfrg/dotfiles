-- For stuff that is not to be configured as an LSP server
local ensure_installed = {
    "stylua",
}

-- typescript
local tsserver = {
    init_options = {
        preferences = {
            disableSuggestions = true
        }
    },
    server_capabilities = {
        documentFormattingProvider = false,
    },
}

-- python
local pyright = {
    filetypes = { "python" },
    settings = {
        pyright = {
            -- disable to use ruff import organizer
            disableOrganizeImports = true
        },
        python = {
            analysis = {
                -- Ignore all files for analysis to exclusively use ruff for linting
                ignore = { "*" }
            }
        }
    }
}

local ruff_lsp = {
    filetypes = { "python" },
    init_options = {
        settings = {
            -- Any extra CLI arguments for `ruff` go here.
            args = true
        }
    }
}

-- typescript
local clangd = {
    on_attach = function(client, bufnr)
        client.server_capabilities.signatureHelpProvider = false
        base_on_attach(client, bufnr)
    end
}

local lua_ls = {
    settings = {
        Lua = {
            runtime = {
                version = "LuaJIT"
            },
            workspace = {
                checkThirdParty = false,
                -- Tells lua_ls where to find all the Lua files that you
                -- have loaded for your nvim config
                library = { "${3rd}/luv/library", unpack(vim.api.nvim_get_runtime_file("", true)) }
            },
            completion = {
                callSnippet = "Replace"
            }
            -- You can toggle below to ignore Lua_LS"s noisy `missing-fields` warnings
            -- diagnostics = { disable = { "missing-fields" } },
        }
    },
    server_capabilities = {
        semanticTokensProvider = vim.NIL,
    },
}

local jsonls = {
    -- lazy-load schemastore when needed
    on_new_config = function(new_config)
        new_config.settings.json.schemas = new_config.settings.json.schemas or true
        vim.list_extend(new_config.settings.json.schemas, require("schemastore").json.schemas())
    end,
    settings = {
        json = {
            schemas = require("schemastore").json.schemas(),
            validate = { enable = true },
            format = { enable = true },
        },
    }
}

local yamlls = {
    -- Have to add this for yamlls to understand that we support line folding
    capabilities = {
        textDocument = {
            foldingRange = {
                dynamicRegistration = false,
                lineFoldingOnly = true
            }
        }
    },
    -- lazy-load schemastore when needed
    on_new_config = function(new_config)
        new_config.settings.yaml.schemas = vim.tbl_deep_extend("force", new_config.settings.yaml.schemas or true,
            require("schemastore").yaml.schemas())
    end,
    settings = {
        redhat = {
            telemetry = {
                enabled = false
            }
        },
        yaml = {
            schemas = require("schemastore").yaml.schemas(),
            schemaStore = {
                -- Must disable built-in schemaStore support to use
                -- schemas from SchemaStore.nvim plugin
                enable = false,
                -- Avoid TypeError: Cannot read properties of undefined (reading "length")
                url = ""
            },
            format = {
                enable = true
            },
            validate = true,
            keyOrdering = false,
        }
    }
}

local servers = {
    astro = true,
    cssls = true,
    eslint = true,
    html = true,
    tailwindcss = true,
    tsserver = tsserver,
    svelte = true,

    pyright = pyright,
    ruff = true,
    ruff_lsp = ruff_lsp,

    clangd = clangd,

    terraformls = true,
    ansiblels = true,

    jsonls = jsonls,
    yamlls = yamlls,

    lua_ls = lua_ls
}

---------------------------------------

local capabilities = nil
if pcall(require, "cmp_nvim_lsp") then
    capabilities = require("cmp_nvim_lsp").default_capabilities()
end

local servers_to_install = vim.tbl_filter(function(key)
    local t = servers[key]
    if type(t) == "table" then
        return not t.manual_install
    else
        return t
    end
end, vim.tbl_keys(servers))

require("mason").setup()

vim.list_extend(ensure_installed, servers_to_install)
require("mason-tool-installer").setup { ensure_installed = ensure_installed }

local lspconfig = require "lspconfig"

for name, config in pairs(servers) do
    if config == true then
        config = {}
    end

    config = vim.tbl_deep_extend("force", {
        capabilities = capabilities,
    }, config)

    lspconfig[name].setup(config)
end

local disable_semantic_tokens = {
    lua = true,
}

vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
        local bufnr = args.buf
        local client = assert(vim.lsp.get_client_by_id(args.data.client_id), "must have valid client")

        local settings = servers[client.name]
        if type(settings) ~= "table" then
            settings = {}
        end

        vim.opt_local.omnifunc = "v:lua.vim.lsp.omnifunc"

        local builtin = require "telescope.builtin"

        local map = function(mode, keys, func, desc)
            vim.keymap.set(mode, keys, func, {
                buffer = bufnr,
                desc = "LSP: " .. desc
            })
        end

        local telescope = require("telescope.builtin")
        -- mostly lazyvim mappings
        -- https://www.lazyvim.org/keymaps#lsp
        map("n", "gd", telescope.lsp_definitions, "Goto Definition")
        --  Declaration, not definition. For example, in C this would take you to the header.
        map("n", "gD", vim.lsp.buf.declaration, "Lsp Go to declaration")
        map("n", "gr", telescope.lsp_references, "Show References")
        map("n", "gi", telescope.lsp_implementations, "Goto Implementation")
        map("n", "gt", telescope.lsp_type_definitions, "Goto Type Definition")
        map("n", "<leader>fs", telescope.lsp_document_symbols, "Find Symbols")
        map("n", "<leader>rn", vim.lsp.buf.rename, "Rename")
        map("n", "K", vim.lsp.buf.hover, "Hover")
        map("n", "gK", vim.lsp.buf.signature_help, "Signature Help")
        map("i", "<c-k>", vim.lsp.buf.signature_help, "Signature Help")
        map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, "Lsp Code action")
        map("n", "<leader>cl", "<cmd>LspInfo<cr>", "Lsp Info")
        map("n", "<leader>cc", vim.lsp.codelens.run, "Run Codelens")
        map("n", "<leader>cC", vim.lsp.codelens.refresh, "Refresh & Display Codelens")
        map("n", "<leader>ca", function()
            vim.lsp.buf.code_action({
                context = {
                    only = { "source" },
                    diagnostics = {}
                }
            })
        end, "Source Action")
        map("n", "<leader>co", function()
            vim.lsp.buf.code_action({
                apply = true,
                context = {
                    only = { "source.organizeImports.ts" },
                    diagnostics = {}
                }
            })
        end, "Organize Imports")
        map("n", "<leader>cR", function()
            vim.lsp.buf.code_action({
                apply = true,
                context = {
                    only = { "source.removeUnused.ts" },
                    diagnostics = {}
                }
            })
        end, "Remove Unused Imports")
        map("n", "<leader>cr", function()
            require "nvchad.lsp.renamer" ()
        end, "Lsp NvRenamer")

        -- Python
        if client.name == "ruff_lsp" then
            -- Disable hover in favor of Pyright
            client.server_capabilities.hoverProvider = false
        end

        local filetype = vim.bo[bufnr].filetype
        if disable_semantic_tokens[filetype] then
            client.server_capabilities.semanticTokensProvider = nil
        end

        -- Override server capabilities
        if settings.server_capabilities then
            for k, v in pairs(settings.server_capabilities) do
                if v == vim.NIL then
                    ---@diagnostic disable-next-line: cast-local-type
                    v = nil
                end

                client.server_capabilities[k] = v
            end
        end
    end,
})

-- Autoformatting Setup
require("conform").setup {
    formatters_by_ft = {

        python = { "ruff_format" },

        javascript = { "prettier" },
        javascriptreact = { "prettier" },
        typescript = { "prettier" },
        typescriptreact = { "prettier" },
        css = { "prettier" },
        html = { "prettier" },

        terraform = { "terraform_fmt" },

        lua = { "stylua" },

        ["_"] = { "trim_whitespace" },
    },

    format_on_save = function(bufnr)
        -- Disable with a global or buffer-local variable
        if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
            return
        end
        return { timeout_ms = 500, lsp_format = "fallback" }
    end,
}

vim.keymap.set("n", "<leader>cf", function()
    require("conform").format { lsp_fallback = true }
end, { desc = "Format Files" })

vim.api.nvim_create_user_command("Format", function(args)
    local range = nil
    if args.count ~= -1 then
        local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
        range = {
            start = { args.line1, 0 },
            ["end"] = { args.line2, end_line:len() },
        }
    end
    require("conform").format({ async = true, lsp_format = "fallback", range = range })
end, { range = true })

vim.api.nvim_create_user_command("FormatDisable", function(args)
    if args.bang then
        -- FormatDisable! will disable formatting just for this buffer
        vim.b.disable_autoformat = true
    else
        vim.g.disable_autoformat = true
    end
end, {
    desc = "Disable autoformat-on-save",
    bang = true,
})

vim.api.nvim_create_user_command("FormatEnable", function()
    vim.b.disable_autoformat = false
    vim.g.disable_autoformat = false
end, {
    desc = "Re-enable autoformat-on-save",
})
