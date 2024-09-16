return {
    "yetone/avante.nvim",
    event = "VeryLazy",
    opts = {
        ---@alias Provider "openai" | "claude" | "azure" | "cohere" | [string]
        provider = "openai", -- Only recommend using Claude
        openai = {
            endpoint = "https://integrate.api.nvidia.com/v1",
            model = "meta/llama-3.1-405b-instruct",
            api_key_name = "OPENAI_API_KEY"
        },
    },
    dependencies = {
        "stevearc/dressing.nvim",
        "nvim-lua/plenary.nvim",
        "MunifTanjim/nui.nvim",
        --- The below dependencies are optional,
        "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
        {
            -- support for image pasting
            "HakonHarnes/img-clip.nvim",
            event = "VeryLazy",
            opts = {
                -- recommended settings
                default = {
                    embed_image_as_base64 = false,
                    prompt_for_file_name = false,
                    drag_and_drop = {
                        insert_mode = true,
                    },
                },
            },
        },
        {
            -- Make sure to setup it properly if you have lazy=true
            'MeanderingProgrammer/render-markdown.nvim',
            opts = {
                file_types = { "markdown", "Avante" },
            },
            ft = { "markdown", "Avante" },
        },
    },

    -- {
    --     {
    --         "CopilotC-Nvim/CopilotChat.nvim",
    --         branch = "canary",
    --         dependencies = {
    --             { "zbirenbaum/copilot.lua" }, -- or github/copilot.vim
    --             { "nvim-lua/plenary.nvim" },  -- for curl, log wrapper
    --         },
    --         config = function()
    --             require("CopilotChat").setup(
    --                 {
    --                     debug = true,
    --                 }
    --             )

    --             vim.api.nvim_create_user_command("CopilotQuickChat", function()
    --                 local input = vim.fn.input("Quick Chat: ")
    --                 if input ~= "" then
    --                     require("CopilotChat").ask(input, { selection = require("CopilotChat.select").buffer })
    --                 end
    --             end, {})
    --         end,
    --     },
    -- }
}
