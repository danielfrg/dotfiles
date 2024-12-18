if vim.fn.executable("ruff") == 0 then
    print("ruff not found. Python LSP not set up.")
end
