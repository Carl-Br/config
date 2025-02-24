local on_attach = require("plugins.configs.lspconfig").on_attach
local capabilities = require("plugins.configs.lspconfig").capabilities

local lspconfig = require("lspconfig")
local util = require "lspconfig/util"

-- general
-- Extend the imported on_attach function
local function custom_on_attach(client, bufnr)
    on_attach(client, bufnr)  -- Call the imported on_attach function
    -- Add your custom configuration here
    local opts = { noremap = true, silent = true }

    -- open, copy error
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>es', '<cmd>lua vim.diagnostic.open_float()<CR>', opts) -- es -> error show
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>ec', '<cmd>lua copy_diagnostic_to_clipboard()<CR>', opts) -- ec -> error copy
end

-- Function to copy diagnostics to the clipboard
_G.copy_diagnostic_to_clipboard = function()
    local diagnostics = vim.diagnostic.get()  -- Use vim.diagnostic.get() instead of vim.lsp.diagnostic.get_all()
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
      gofumpt = true, -- optional, stricter formatting rules
      format = {
        lineWidth = 120, -- Adjust this value to control line breaks
      },
    },
  },
}

-- Go Templ
lspconfig.templ.setup {
  on_attach = custom_on_attach,
  capabilities = capabilities,
  filetypes = { "html", "templ" },
}

-- C++
lspconfig.clangd.setup {
  on_attach = function(client, bufnr)
    client.server_capabilities.signatureHelpProvider = false
    custom_on_attach(client, bufnr)
  end,
  capabilities = capabilities,
}

-- Python
lspconfig.pyright.setup({
  on_attach = custom_on_attach,
  capabilities = capabilities,
  filetypes = {"python"}
})

-- TailwindCSS
lspconfig.tailwindcss.setup({
  on_attach = custom_on_attach,  -- Use your custom on_attach function
  capabilities = capabilities,
  filetypes = { "templ", "astro", "javascript", "typescript", "react" },
  settings = {
    tailwindCSS = {
      includeLanguages = {
        templ = "html",
      },
    },
  },
  init_options = {
    userLanguages = {
      templ = "html",
    },
  },
  document_color = {
    enabled = true, -- can be toggled by commands
    kind = "inline", -- "inline" | "foreground" | "background"
    inline_symbol = "󰝤 ", -- only used in inline mode
    debounce = 200, -- in milliseconds, only applied in insert mode
  },
  conceal = {
    enabled = false, -- can be toggled by commands
    min_length = nil, -- only conceal classes exceeding the provided length
    symbol = "󱏿", -- only a single character is allowed
    highlight = { -- extmark highlight options, see :h 'highlight'
      fg = "#38BDF8",
    },
  },
  cmp = {
    highlight = "foreground", -- color preview style, "foreground" | "background"
  },
  telescope = {
    utilities = {
      callback = function(name, class) end, -- callback used when selecting an utility class in telescope
    },
  },
  extension = {
    queries = {}, -- a list of filetypes having custom `class` queries
    patterns = { -- a map of filetypes to Lua pattern lists
      -- example:
      -- rust = { "class=[\"']([^\"']+)[\"']" },
      -- javascript = { "clsx%(([^)]+)%)" },
    },
  },
})

-- C#
lspconfig.csharp_ls.setup({
  on_attach = custom_on_attach,
  capabilities = capabilities,
})

-- TypeScript
lspconfig.ts_ls.setup({
  on_attach = custom_on_attach,
  capabilities = capabilities,
  init_options = {
    preferences = {
      disableSuggestions = true,
    },
  },
})
