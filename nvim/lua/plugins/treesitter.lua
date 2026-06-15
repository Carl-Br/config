return { -- Highlight, edit, and navigate code
  'nvim-treesitter/nvim-treesitter',
  branch = 'main',
  lazy = false,
  build = ':TSUpdate',
  config = function()
    require('nvim-treesitter').setup()

    local ensure_installed = {
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
      'javascript',
      'typescript',
      'tsx',
    }

    -- Nur installieren, was noch fehlt (kein Reinstall bei jedem Start)
    local already = require('nvim-treesitter.config').get_installed()
    local to_install = vim
      .iter(ensure_installed)
      :filter(function(p)
        return not vim.tbl_contains(already, p)
      end)
      :totable()
    if #to_install > 0 then
      require('nvim-treesitter').install(to_install)
    end

    -- Highlighting + Indentation pro Buffer aktivieren
    vim.api.nvim_create_autocmd('FileType', {
      callback = function(args)
        -- startet nur, wenn für das Filetype ein Parser da ist
        if pcall(vim.treesitter.start) then
          vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
      end,
    })
  end,
}
