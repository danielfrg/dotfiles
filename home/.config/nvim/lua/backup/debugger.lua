return {
    {
        "rcarriga/nvim-dap-ui",
        dependencies = {
            "mfussenegger/nvim-dap",
            "nvim-neotest/nvim-nio"
        },
        lazy = true,
        event = "VeryLazy",
        config = function()
            local dap = require('dap')
            local dapui = require("dapui")

            dapui.setup()

            vim.keymap.set('n', '<leader>db', function() dap.toggle_breakpoint() end)
            vim.keymap.set('n', '<leader>dc', function() dap.continue() end)

            dap.listeners.before.attach.dapui_config = function()
                dapui.open()
            end
            dap.listeners.before.launch.dapui_config = function()
                dapui.open()
            end
            dap.listeners.before.event_terminated.dapui_config = function()
                dapui.close()
            end
            dap.listeners.before.event_exited.dapui_config = function()
                dapui.close()
            end

            require("config.debugger")
        end
    }
}
