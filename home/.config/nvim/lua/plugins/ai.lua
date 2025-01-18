return {
    {
        "yetone/avante.nvim",
        event = "VeryLazy",
        version = false, -- set this if you want to always pull the latest change
        opts = {
            -- add any opts here
        },
        -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
        build = "make",
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "stevearc/dressing.nvim",
            "nvim-lua/plenary.nvim",
            "MunifTanjim/nui.nvim",
            --- The below dependencies are optional,
            "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
            "zbirenbaum/copilot.lua",      -- for providers='copilot'
        },
        config = function()
            require("avante").setup({
                ---@alias Provider "claude" | "openai" | "azure" | "gemini" | "cohere" | "copilot" | string
                -- provider = "copilot", -- Recommend using Claude
                provider = "copilot", -- Recommend using Claude
                auto_suggestions_provider = "copilot",

            })
        end,
    }
}
