return {
  'NeogitOrg/neogit',
  lazy = true,
  dependencies = {
    'sindrets/diffview.nvim', -- optional: diff integration
    'nvim-telescope/telescope.nvim', -- optional: telescope picker
  },
  cmd = 'Neogit',
  keys = {
    {
      '<leader>ng',
      function()
        require('neogit').open()
      end,
      desc = 'Open Neogit',
    },
  },
  opts = {
    -- Optional: open as split instead of tab (remove or change as needed)
    -- kind = "split",

    integrations = {
      diffview = true,
      telescope = true,
    },
  },
}
