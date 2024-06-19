local on_attach = require("plugins.configs.lspconfig").on_attach
local capabilities = require("plugins.configs.lspconfig").capabilities

local lspconfig = require("lspconfig")
local util = require "lspconfig/util"

-- general
-- Erweitere die importierte on_attach-Funktion
local function custom_on_attach(client, bufnr)
    on_attach(client, bufnr)  -- Aufruf der importierten on_attach-Funktion
    -- Füge deine benutzerdefinierte Konfiguration hinzu
    local opts = { noremap = true, silent = true }

  -- open, copy error
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>es', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)-- es -> error show
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>ec', '<cmd>lua copy_diagnostic_to_clipboard()<CR>', opts)-- ec -> error copy
end

-- Funktion zum Kopieren der Diagnose in die Zwischenablage
_G.copy_diagnostic_to_clipboard = function()
    local diagnostics = vim.lsp.diagnostic.get_all()
    local messages = {}
    for _, diagnostic in ipairs(diagnostics) do
        table.insert(messages, diagnostic.message)
    end
    local clipboard_text = table.concat(messages, '\n')
    vim.fn.setreg('+', clipboard_text)
    vim.notify("Diagnose in Zwischenablage kopiert", "info")
end



-- GO
lspconfig.gopls.setup {
  on_attach = custom_on_attach,
  capabilities = capabilities,
  cmd = {"gopls"},
  filetypes = { "go", "gomod", "gowork", "gotmpl" },
  root_dir = util.root_pattern("go.work", "go.mod", ".git"),
  settings = {
    gopls = {
      completeUnimported = true,
      usePlaceholders = true,
      analyses = {
        unusedparams = true,
      },
    },
  },
}

--C++
lspconfig.clangd.setup {
  on_attach = function(client, bufnr)
    client.server_capabilities.signatureHelpProvider = false
    custom_on_attach(client, bufnr)
  end,
  capabilities = capabilities,
}

--Python
lspconfig.pyright.setup({
  on_attach = on_attach,
  capabilities = capabilities,
  filetypes = {"python"}
})
