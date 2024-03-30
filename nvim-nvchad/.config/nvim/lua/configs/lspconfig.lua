-- local on_attach = require("nvchad.configs.lspconfig").on_attach
local on_init = require("nvchad.configs.lspconfig").on_init
local capabilities = require("nvchad.configs.lspconfig").capabilities

local map = vim.keymap.set
local conf = require("nvconfig").ui.lsp

-- Override default settings
local on_attach = function(client, bufnr)
  local function opts(desc)
    return { buffer = bufnr, desc = desc }
  end

  -- These are mostly lazyvim mappings
  -- https://www.lazyvim.org/keymaps#lsp
  map("n", "<leader>cl", "<cmd>LspInfo<cr>", opts "Lsp Info")
  map("n", "gD", vim.lsp.buf.declaration, opts "Lsp Go to declaration")
  map("n", "gd", function() require("telescope.builtin").lsp_definitions({ reuse_win = true }) end,
    opts "Goto Definition")
  map("n", "gr", "<cmd>Telescope lsp_references<cr>", opts "Show References")
  map("n", "gi", function() require("telescope.builtin").lsp_implementations({ reuse_win = true }) end,
    opts "Goto Implementation")
  map("n", "gt", function() require("telescope.builtin").lsp_type_definitions({ reuse_win = true }) end,
    opts "Goto Type Definition")
  map("n", "K", vim.lsp.buf.hover, opts "Hover")
  map("n", "gK", vim.lsp.buf.signature_help, opts "Signature Help")
  map("i", "<c-k>", vim.lsp.buf.signature_help, opts "Signature Help")
  map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts "Lsp Code action")
  map("n", "<leader>cc", vim.lsp.codelens.run, opts "Run Codelens")
  map("n", "<leader>cC", vim.lsp.codelens.refresh, opts "Refresh & Display Codelens")
  map("n", "<leader>cA",
    function()
      vim.lsp.buf.code_action({
        context = {
          only = {
            "source",
          },
          diagnostics = {},
        },
      })
    end,
    opts "Source Action"
  )
  map("n", "<leader>cr", function() require "nvchad.lsp.renamer" () end, opts "Lsp NvRenamer")

  -- setup signature popup
  if conf.signature and client.server_capabilities.signatureHelpProvider then
    require("nvchad.lsp.signature").setup(client, bufnr)
  end

  if client.name == 'ruff_lsp' then
    -- Disable hover in favor of Pyright
    client.server_capabilities.hoverProvider = false
  end
end

local lspconfig = require "lspconfig"
local servers = { "html", "cssls" }

-- lsps with default config
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = on_attach,
    on_init = on_init,
    capabilities = capabilities,
  }
end

-- typescript
lspconfig.tsserver.setup {
  on_attach = on_attach,
  on_init = on_init,
  capabilities = capabilities,
  init_options = {
    preferences = {
      disableSuggestions = true,
    }
  }
}

-- python
lspconfig.pyright.setup {
  filetypes = { "python" },
  on_attach = on_attach,
  on_init = on_init,
  capabilities = capabilities,
  settings = {
    pyright = {
      -- disable to use ruff import organizer
      disableOrganizeImports = true,
    },
    python = {
      analysis = {
        -- Ignore all files for analysis to exclusively use ruff for linting
        ignore = { '*' },
      },
    },
  },
}

lspconfig.ruff_lsp.setup {
  filetypes = { "python" },
  on_attach = on_attach,
  on_init = on_init,
  capabilities = capabilities,
  init_options = {
    settings = {
      -- Any extra CLI arguments for `ruff` go here.
      args = {},
    }
  },
}
