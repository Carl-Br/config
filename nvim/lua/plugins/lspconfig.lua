return {
  -- Main LSP Configuration
  'neovim/nvim-lspconfig',
  dependencies = {
    -- Automatically install LSPs and related tools to stdpath for Neovim
    -- Mason must be loaded before its dependents so we need to set it up here.
    -- NOTE: `opts = {}` is the same as calling `require('mason').setup({})`
    -- NOTE: Mason ist auf die Organisation `mason-org` umgezogen (v2).
    { 'mason-org/mason.nvim', opts = {} },
    'mason-org/mason-lspconfig.nvim',
    'WhoIsSethDaniel/mason-tool-installer.nvim',

    -- Useful status updates for LSP.
    { 'j-hui/fidget.nvim', opts = {} },

    -- Allows extra capabilities provided by nvim-cmp
    'hrsh7th/cmp-nvim-lsp',
  },
  config = function()
    --  This function gets run when an LSP attaches to a particular buffer.
    --    That is to say, every time a new file is opened that is associated with
    --    an lsp (for example, opening `main.rs` is associated with `rust_analyzer`) this
    --    function will be executed to configure the current buffer
    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
      callback = function(event)
        -- In this case, we create a function that lets us more easily define mappings specific
        -- for LSP related items. It sets the mode, buffer and description for us each time.
        local map = function(keys, func, desc, mode)
          mode = mode or 'n'
          vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
        end

        -- Jump to the definition of the word under your cursor.
        map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')

        -- Find references for the word under your cursor.
        map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')

        -- Jump to the implementation of the word under your cursor.
        map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')

        -- Jump to the type of the word under your cursor.
        map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')

        -- Fuzzy find all the symbols in your current document.
        map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')

        -- Fuzzy find all the symbols in your current workspace.
        map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

        -- Rename the variable under your cursor.
        map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')

        -- Execute a code action, usually your cursor needs to be on top of an error
        -- or a suggestion from your LSP for this to activate.
        map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction', { 'n', 'x' })

        -- WARN: This is not Goto Definition, this is Goto Declaration.
        map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

        -- The following two autocommands are used to highlight references of the
        -- word under your cursor when your cursor rests there for a little while.
        --    See `:help CursorHold` for information about when this is executed
        --
        -- When you move your cursor, the highlights will be cleared (the second autocommand).
        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
          local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
          vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
            buffer = event.buf,
            group = highlight_augroup,
            callback = vim.lsp.buf.document_highlight,
          })

          vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
            buffer = event.buf,
            group = highlight_augroup,
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

        -- The following code creates a keymap to toggle inlay hints in your
        -- code, if the language server you are using supports them
        if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
          map('<leader>th', function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
          end, '[T]oggle Inlay [H]ints')
        end
      end,
    })

    -- Diagnostic Config
    -- See :help vim.diagnostic.Opts
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
        format = function(diagnostic)
          local diagnostic_message = {
            [vim.diagnostic.severity.ERROR] = diagnostic.message,
            [vim.diagnostic.severity.WARN] = diagnostic.message,
            [vim.diagnostic.severity.INFO] = diagnostic.message,
            [vim.diagnostic.severity.HINT] = diagnostic.message,
          }
          return diagnostic_message[diagnostic.severity]
        end,
      },
    }

    -- LSP servers and clients are able to communicate to each other what features they support.
    --  By default, Neovim doesn't support everything that is in the LSP specification.
    --  When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
    --  So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
    local capabilities = require('cmp_nvim_lsp').default_capabilities()

    -- Enable the following language servers.
    --  Add any additional override configuration in the following tables. Available keys are:
    --  - cmd (table): Override the default command used to start the server
    --  - filetypes (table): Override the default list of associated filetypes for the server
    --  - capabilities (table): Override fields in capabilities.
    --  - settings (table): Override the default settings passed when initializing the server.
    --  - root_markers (table): Files/dirs that mark the project root (native 0.11+ API).
    local servers = {
      -- templ LSP selbst (für die Go-Template-Sprache)
      templ = {},

      -- html-Server soll auch in templ-Dateien greifen
      html = {
        filetypes = { 'html', 'templ' },
      },

      -- Tailwind: templ zu den Filetypes hinzufügen, includeLanguages setzen,
      -- und das Projekt-Root über .git ankern (du nutzt die Standalone-CLI v4,
      -- es gibt also keine tailwind.config.* / package.json im Repo).
      tailwindcss = {
        filetypes = {
          'html',
          'css',
          'scss',
          'javascript',
          'javascriptreact',
          'typescript',
          'typescriptreact',
          'svelte',
          'vue',
          'templ',
        },
        root_markers = {
          'tailwind.config.js',
          'tailwind.config.ts',
          'tailwind.config.cjs',
          'postcss.config.js',
          'package.json',
          '.git',
        },
        settings = {
          tailwindCSS = {
            includeLanguages = {
              templ = 'html',
            },
          },
        },
      },

      gopls = {
        cmd = { 'gopls' },
        filetypes = { 'go', 'gomod', 'gowork', 'gotmpl' },
        settings = {
          gopls = {
            completeUnimported = true,
            usePlaceholders = true,
            analyses = {
              unusedparams = true,
            },
            gofumpt = true, -- optional, stricter formatting rules
          },
        },
      },
      lua_ls = {
        settings = {
          Lua = {
            completion = {
              callSnippet = 'Replace',
            },
            diagnostics = {
              -- behebt "Undefined global `vim`"
              globals = { 'vim' },
              -- ignoriert Lua_LS's noisy `missing-fields` warnings (z.B. bei mason-lspconfig.setup)
              disable = { 'missing-fields' },
            },
          },
        },
      },
    }

    -- Ensure the servers and tools above are installed.
    --  To check the current status of installed tools and/or manually install
    --  other tools, you can run :Mason
    local ensure_installed = vim.tbl_keys(servers or {})
    vim.list_extend(ensure_installed, {
      'stylua', -- Used to format Lua code
      'tailwindcss-language-server',
      'templ',
      'json-lsp',
      'prettier',
      'eslint-lsp',
      'typescript-language-server',
      'omnisharp',
    })
    require('mason-tool-installer').setup { ensure_installed = ensure_installed }

    -- [[ Native LSP configuration (Neovim 0.11+ / 0.12) ]]
    --  mason-lspconfig v2 hat `handlers`/`setup_handlers` entfernt. Server werden
    --  jetzt über die native `vim.lsp.config()`-API konfiguriert und von
    --  mason-lspconfig automatisch aktiviert (`automatic_enable`, default an).

    -- Default-Capabilities für ALLE Server (cmp-Completion-Capabilities).
    vim.lsp.config('*', {
      capabilities = capabilities,
    })

    -- Pro-Server-Overrides registrieren.
    for server_name, config in pairs(servers) do
      vim.lsp.config(server_name, config)
    end

    require('mason-lspconfig').setup {
      ensure_installed = {}, -- via mason-tool-installer oben
      automatic_enable = true, -- aktiviert installierte Server automatisch über vim.lsp.enable()
    }

    -- Set tab width for Go files (scoped to `go`, war vorher versehentlich global!)
    vim.api.nvim_create_autocmd('FileType', {
      pattern = 'go',
      callback = function()
        vim.bo.expandtab = true
        vim.bo.tabstop = 4
        vim.bo.shiftwidth = 2
      end,
    })
    vim.api.nvim_create_autocmd('FileType', {
      pattern = 'templ',
      callback = function()
        vim.bo.expandtab = false -- templ benutzt echte Tabs
        vim.bo.tabstop = 2
        vim.bo.shiftwidth = 2
        vim.bo.softtabstop = 2
      end,
    })
  end,
}
