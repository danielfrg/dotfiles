return {
    cmd = {
        "bun", "run", "vscode-eslint-language-server", "--", "--stdio"
    },
    filetypes = {
        "javascript", "javascriptreact", "typescript", "typescriptreact",
    },
    root_markers = {
        "eslint.config.js", "eslint.config.mjs", "eslint.config.cjs", "eslint.config.ts",
        ".eslintrc", ".eslintrc.js", ".eslintrc.cjs", ".eslintrc.json", ".eslintrc.yaml", ".eslintrc.yml",
        "package.json",
    },
    settings = {
        validate = "on",
        packageManager = "pnpm",
        useESLintClass = false,
        experimental = {
            useFlatConfig = true,
        },
        codeAction = {
            disableRuleComment = {
                enable = true,
                location = "separateLine",
            },
            showDocumentation = {
                enable = true,
            },
        },
        codeActionOnSave = {
            mode = "all",
        },
        format = true,
        quiet = false,
        onIgnoredFiles = "off",
        run = "onType",
        workingDirectory = {
            mode = "location",
        },
    },
}
