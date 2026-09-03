return {
  'chomosuke/typst-preview.nvim',
  ft = 'typst',
  build = 'cargo +stable build --release',
  keys = {
    {
      '<leader>tp',
      '<cmd>TypstPreviewToggle<cr>',
      ft = 'typst',
      desc = 'Toggle Typst Preview (Browser)',
    },
  },
}
