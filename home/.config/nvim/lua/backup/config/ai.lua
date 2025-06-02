require("codecompanion").setup({
    adapters = {
        -- llm_gateway = function()
        --     return require("codecompanion.adapters").extend("openai_compatible", {
        --         env = {
        --             url = "https://prod.api.nvidia.com",         -- optional: default value is ollama url http://127.0.0.1:11434
        --             api_key = "LLM_GATEWAY_TOKEN",
        --             chat_url = "/llm/v1/azure/chat/completions", -- optional: default value, override if different
        --             models_endpoint = "/llm/v1/models",          -- optional: attaches to the end of the URL to form the endpoint to retrieve models
        --         },
        --         schema = {
        --             model = {
        --                 default = "deepseek-r1-671b", -- define llm model to be used
        --             },
        --         }
        --     })
        -- end,
        nv_one_api = function()
            return require("codecompanion.adapters").extend("azure_openai", {
                env = {
                    endpoint = "https://llm-proxy.perflab.nvidia.com",
                    api_key =
                    "ONEAPI_API_KEY",
                    api_version = "2024-12-01-preview",
                },
                headers = {
                    ["Content-Type"] = "application/json",
                    ["Authorization"] =
                    "Bearer ${api_key}",
                },
                schema = {
                    model = {
                        default = "o3-mini-20250131",
                        choices = { "o3-mini-20250131" },
                    },
                }
            })
        end,
    },
    strategies = {
        chat = {
            adapter = "nv_one_api",
        },
        inline = {
            adapter = "nv_one_api",
        },
    },
})

vim.keymap.set({ "n", "v" }, "<C-a>", "<cmd>CodeCompanionActions<cr>", { noremap = true, silent = true })
vim.keymap.set({ "n", "v" }, "<LocalLeader>a", "<cmd>CodeCompanionChat Toggle<cr>", { noremap = true, silent = true })
vim.keymap.set("v", "ga", "<cmd>CodeCompanionChat Add<cr>", { noremap = true, silent = true })

-- Expand 'cc' into 'CodeCompanion' in the command line
vim.cmd([[cab cc CodeCompanion]])
