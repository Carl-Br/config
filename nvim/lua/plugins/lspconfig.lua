return {
  'neovim/nvim-lspconfig',
  dependencies = {
    { 'mason-org/mason.nvim', opts = {} },
    'mason-org/mason-lspconfig.nvim',
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    { 'j-hui/fidget.nvim', opts = {} },
    'hrsh7th/cmp-nvim-lsp',
  },
  config = function()
    -- Keymaps / Highlights / Inlay Hints beim Attach (reine vim.lsp.*-API, kein Deprecation)
    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
      callback = function(event)
        local map = function(keys, func, desc, mode)
          mode = mode or 'n'
          vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
        end

        map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
        map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
        map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
        map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
        map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
        map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
        map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
        map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction', { 'n', 'x' })
        map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
          local hl = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
          vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
            buffer = event.buf,
            group = hl,
            callback = vim.lsp.buf.document_highlight,
          })
          vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
            buffer = event.buf,
            group = hl,
            callback = vim.lsp.buf.clear_references,
          })
          vim.api.nvim_create_autocmd('LspDetach', {
            group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
            callback = function(event2)
              vim.lsp.buf.clear_references()
              vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
            end,
          })
        end

        if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
          map('<leader>th', function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
          end, '[T]oggle Inlay [H]ints')
        end
      end,
    })

    -- Diagnostics
    vim.diagnostic.config {
      severity_sort = true,
      float = { border = 'rounded', source = 'if_many' },
      underline = { severity = vim.diagnostic.severity.ERROR },
      signs = vim.g.have_nerd_font and {
        text = {
          [vim.diagnostic.severity.ERROR] = '󰅚 ',
          [vim.diagnostic.severity.WARN] = '󰀪 ',
          [vim.diagnostic.severity.INFO] = '󰋽 ',
          [vim.diagnostic.severity.HINT] = '󰌶 ',
        },
      } or {},
      virtual_text = {
        source = 'if_many',
        spacing = 2,
        format = function(d)
          return d.message
        end,
      },
    }

    -- Capabilities global für ALLE Server ('*' ist die Wildcard der neuen API)
    vim.lsp.config('*', {
      capabilities = require('cmp_nvim_lsp').default_capabilities(),
    })

    -- Server-spezifische Overrides (erweitern die mitgelieferten lsp/-Configs)
    vim.lsp.config('gopls', {
      settings = {
        gopls = {
          completeUnimported = true,
          usePlaceholders = true,
          analyses = { unusedparams = true },
          gofumpt = true,
        },
      },
    })
    vim.lsp.config('lua_ls', {
      settings = { Lua = { completion = { callSnippet = 'Replace' } } },
    })
    vim.lsp.config('eslint', {
      workspace_required = false,
      root_dir = function(bufnr, on_dir)
        local found = vim.fs.root(bufnr, {
          'eslint.config.mjs',
          'eslint.config.js',
          'eslint.config.cjs',
          'eslint.config.ts',
          '.eslintrc.js',
          '.eslintrc.cjs',
          '.eslintrc.json',
          '.eslintrc',
        })
        if found then
          on_dir(found)
        end
      end,
    })

    require('mason-lspconfig').setup { ensure_installed = {} }
    require('mason-tool-installer').setup {
      ensure_installed = {
        'gopls',
        'lua_ls',
        'stylua',
        'tailwindcss-language-server',
        'templ',
        'json-lsp',
        'prettier',
        'eslint-lsp',
        'typescript-language-server',
        'omnisharp',
      },
    }

    vim.lsp.enable {
      'gopls',
      'lua_ls',
      'tailwindcss',
      'ts_ls',
      'eslint',
      'jsonls',
      'omnisharp',
      'templ',
    }

    -- Tab-Breite für Go
    vim.api.nvim_create_autocmd('FileType', {
      pattern = 'go',
      callback = function()
        vim.bo.expandtab = true
        vim.bo.tabstop = 4
        vim.bo.shiftwidth = 2
      end,
    })
  end,
}
