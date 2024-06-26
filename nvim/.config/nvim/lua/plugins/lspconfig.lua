local base_on_attach = function(client, bufnr)
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
    map({"n", "v"}, "<leader>ca", vim.lsp.buf.code_action, "Lsp Code action")
    map("n", "<leader>cl", "<cmd>LspInfo<cr>", "Lsp Info")
    map("n", "<leader>cc", vim.lsp.codelens.run, "Run Codelens")
    map("n", "<leader>cC", vim.lsp.codelens.refresh, "Refresh & Display Codelens")
    map("n", "<leader>ca", function()
        vim.lsp.buf.code_action({
            context = {
                only = {"source"},
                diagnostics = {}
            }
        })
    end, "Source Action")
    map("n", "<leader>co", function()
        vim.lsp.buf.code_action({
            apply = true,
            context = {
                only = {"source.organizeImports.ts"},
                diagnostics = {}
            }
        })
    end, "Organize Imports")
    map("n", "<leader>cR", function()
        vim.lsp.buf.code_action({
            apply = true,
            context = {
                only = {"source.removeUnused.ts"},
                diagnostics = {}
            }
        })
    end, "Remove Unused Imports")
    map("n", "<leader>cr", function()
        require "nvchad.lsp.renamer"()
    end, "Lsp NvRenamer")

    -- Python
    if client.name == "ruff_lsp" then
        -- Disable hover in favor of Pyright
        client.server_capabilities.hoverProvider = false
    end
end

-- typescript
local tsserver = {
    init_options = {
        preferences = {
            disableSuggestions = true
        }
    }
}

-- python
local pyright = {
    filetypes = {"python"},
    settings = {
        pyright = {
            -- disable to use ruff import organizer
            disableOrganizeImports = true
        },
        python = {
            analysis = {
                -- Ignore all files for analysis to exclusively use ruff for linting
                ignore = {"*"}
            }
        }
    }
}

local ruff_lsp = {
    filetypes = {"python"},
    init_options = {
        settings = {
            -- Any extra CLI arguments for `ruff` go here.
            args = {}
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
                library = {"${3rd}/luv/library", unpack(vim.api.nvim_get_runtime_file("", true))}
            },
            completion = {
                callSnippet = "Replace"
            }
            -- You can toggle below to ignore Lua_LS"s noisy `missing-fields` warnings
            -- diagnostics = { disable = { "missing-fields" } },
        }
    }
}

local jsonls = {
    -- lazy-load schemastore when needed
    on_new_config = function(new_config)
        new_config.settings.json.schemas = new_config.settings.json.schemas or {}
        vim.list_extend(new_config.settings.json.schemas, require("schemastore").json.schemas())
    end,
    settings = {
        json = {
            format = {
                enable = true
            },
            validate = {
                enable = true
            }
        }
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
        new_config.settings.yaml.schemas = vim.tbl_deep_extend("force", new_config.settings.yaml.schemas or {},
            require("schemastore").yaml.schemas())
    end,
    settings = {
        redhat = {
            telemetry = {
                enabled = false
            }
        },
        yaml = {
            keyOrdering = false,
            format = {
                enable = true
            },
            validate = true,
            schemaStore = {
                -- Must disable built-in schemaStore support to use
                -- schemas from SchemaStore.nvim plugin
                enable = false,
                -- Avoid TypeError: Cannot read properties of undefined (reading "length")
                url = ""
            }
        }
    }
}

local servers = {
    astro = {},
    cssls = {},
    eslint = {},
    html = {},
    tailwindcss = {},
    tsserver = tsserver,
    svelte = {},

    pyright = pyright,
    ruff = {},
    ruff_lsp = ruff_lsp,

    clangd = clangd,

    terraformls = {},
    ansiblels = {},

    jsonls = jsonls,
    yamlls = yamlls,

    lua_ls = lua_ls
}

local function get_yaml_schema()
    -- Get the current buffer
    local buf = vim.api.nvim_get_current_buf()

    -- Get the LSP client for the current buffer
    local client = vim.lsp.get_active_clients({
        name = "yamlls",
        bufnr = bufnr
    })[1]

    -- Check if the LSP client is available
    if not client then
        vim.notify("No LSP client found for the current buffer", vim.log.levels.WARN)
        return
    end

    -- Request the YAML schema from the LSP client
    local params = {
        textDocument = {
            uri = vim.uri.from_bufnr(buf)
        }
    }
    local result = vim.lsp.buf_request(buf, "yaml/schema", params)

    -- Handle the result
    if result then
        -- Print the schema information (this is just an example, you can do anything you want with it)
        vim.notify("Schema: " .. vim.inspect(result), vim.log.levels.INFO)
    else
        vim.notify("Failed to retrieve YAML schema", vim.log.levels.WARN)
    end
end

-- Create a command to trigger the function
vim.api.nvim_create_user_command("YAMLSchema", function()
    get_yaml_schema()
end, {})

return {
    {
        "b0o/SchemaStore.nvim",
        version = false
    },
    {
        "neovim/nvim-lspconfig",
        event = "VeryLazy",

        dependencies = {"williamboman/mason.nvim", "williamboman/mason-lspconfig.nvim",
                        "WhoIsSethDaniel/mason-tool-installer.nvim", "b0o/SchemaStore.nvim" -- "someone-stole-my-name/yaml-companion.nvim",
        },

        config = function()
            -- Neovim LSP config UI
            vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
                border = "single"
            })

            vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
                border = "single",
                focusable = false,
                relative = "cursor",
                silent = true
            })

            local capabilities = vim.lsp.protocol.make_client_capabilities()
            -- capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

            -- Ensure the servers and tools defined in `servers` above are installed
            require("mason").setup()

            local ensure_installed = vim.tbl_keys(servers or {})
            -- vim.print(ensure_installed)
            -- require("mason-tool-installer").setup { ensure_installed = ensure_installed }

            require("mason-lspconfig").setup {
                ensure_installed = ensure_installed,
                handlers = {function(server_name)
                    local server = servers[server_name] or {}
                    -- This handles overriding only values explicitly passed
                    -- by the server configuration above. Useful when disabling
                    -- certain features of an LSP (for example, turning off formatting for tsserver)
                    server.on_attach = server.on_attach or base_on_attach or {}
                    server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
                    require("lspconfig")[server_name].setup(server)
                end}
            }
        end
    },
}
