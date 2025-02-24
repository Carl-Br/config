return {
  'xiyaowong/transparent.nvim',
  lazy = false,
  config = function()
    require('transparent').setup {
      extra_groups = {
        'NormalFloat', -- Für Floating-Windows wie Lazy, Mason, LspInfo
        'NvimTreeNormal', -- Für NvimTree
      },
    }
    -- Transparenz automatisch beim Start aktivieren
    vim.cmd 'TransparentEnable'
  end,
}
