return {
  'xiyaowong/transparent.nvim',
  lazy = false,
  config = function()
    require('transparent').setup {
      extra_groups = {
        'NvimTreeNormal', -- Für NvimTree
      },
    }
    -- Transparenz automatisch beim Start aktivieren
    vim.cmd 'TransparentEnable'
  end,
}
