return {
  'github/copilot.vim',
  event = 'VeryLazy',
  config = function()
    vim.g.copilot_enabled = false
    vim.keymap.set('i', '<C-F>', 'copilot#Accept("\\<CR>")', {
      expr = true,
      replace_keycodes = false,
    })
    vim.g.copilot_no_tab_map = true
  end,
}
