local dap = require('dap')

-- Set up codelldb as the debugger for C++
dap.adapters.codelldb = {
    type = 'server',
    port = "${port}",
    executable = {
        command = 'lldb-vscode', -- Adjust this path to your codelldb executable
        args = { "--port", "${port}" },
    },
}

-- Define configurations for C++ debugging
dap.configurations.cpp = {
    {
        name = "Launch file",
        type = "codelldb",
        request = "launch",
        program = function()
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
        end,
        cwd = '${workspaceFolder}',
        stopOnEntry = false,
        args = {},
    },
}
