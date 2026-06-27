return { -- Highlight, edit, and navigate code
  'nvim-treesitter/nvim-treesitter',
  -- NOTE: `master` ist eingefroren und inkompatibel mit Neovim 0.12 (Crash in
  -- query_predicates.lua). Die `main`-Branch ist ein kompletter Rewrite mit
  -- anderer API und der einzige fuer 0.12 vorgesehene Branch.
  branch = 'main',
  lazy = false, -- die main-Branch unterstuetzt KEIN lazy-loading
  build = ':TSUpdate', -- haelt installierte Parser nach Plugin-Updates aktuell
  config = function()
    local ts = require 'nvim-treesitter'

    -- Sicherheitsnetz: Wenn die main-Branch-API noch nicht bereitsteht (z.B.
    -- weil der Plugin-/Parser-Checkout veraltet ist), NICHT crashen -- nur
    -- hinweisen, damit Neovim trotzdem bootet und man :TSUpdate ausfuehren kann.
    if type(ts.install) ~= 'function' then
      vim.schedule(function()
        vim.notify(
          'nvim-treesitter (main) ist nicht fertig gebaut.\n' .. 'Bitte `:Lazy update nvim-treesitter`, dann `:TSUpdate`, dann Neovim neu starten.',
          vim.log.levels.WARN
        )
      end)
      return
    end

    -- Parser, die du sicher haben willst. In der main-Branch gibt es kein
    -- `ensure_installed`-opts-Feld mehr. `install` ist ein No-op fuer bereits
    -- installierte Parser und laeuft asynchron -- blockiert den Start also nicht.
    ts.install {
      'bash',
      'c',
      'diff',
      'html',
      'css',
      'lua',
      'luadoc',
      'markdown',
      'markdown_inline',
      'query',
      'vim',
      'vimdoc',
      'go',
      'templ',
    }

    -- Highlighting + Indentation muessen in der main-Branch pro Buffer selbst
    -- aktiviert werden (kein globales `highlight = { enable = true }` mehr).
    local function enable(buf)
      -- vim.treesitter.start() ermittelt die Sprache selbst aus dem Filetype.
      -- Per pcall, weil es fehlschlaegt, solange der Parser (noch) fehlt --
      -- z.B. beim allerersten Start, waehrend die Parser im Hintergrund
      -- kompiliert werden. Nach einem Neustart greift es dann sofort.
      pcall(vim.treesitter.start, buf)

      -- Treesitter-basierte Einrueckung (in der main-Branch noch experimentell).
      -- Diese Zeile entfernen, falls die Einrueckung mal spinnt.
      vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end

    vim.api.nvim_create_autocmd('FileType', {
      group = vim.api.nvim_create_augroup('treesitter-setup', { clear = true }),
      callback = function(args)
        enable(args.buf)
      end,
    })

    -- Bereits geoeffnete Buffer (z.B. via Kommandozeile geoeffnet) nachtraeglich
    -- aktivieren, da deren FileType-Event vor dem Laden dieses Plugins gefeuert
    -- haben kann.
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
      if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].filetype ~= '' then
        enable(buf)
      end
    end
  end,
}
