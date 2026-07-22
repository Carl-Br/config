return {
  'NeogitOrg/neogit',
  lazy = true,
  dependencies = {
    'sindrets/diffview.nvim',
    'nvim-telescope/telescope.nvim',
  },
  cmd = 'Neogit',
  keys = {
    {
      '<leader>ng',
      function()
        -- cwd kann nach 'worktree remove' auf ein gelöschtes Verzeichnis zeigen
        if vim.fn.isdirectory(vim.fn.getcwd()) == 0 then
          local fallback = vim.fn.expand '~'
          vim.cmd('cd ' .. vim.fn.fnameescape(fallback))
          vim.notify('cwd war ungültig - zurückgesetzt auf ' .. fallback, vim.log.levels.WARN)
        end

        local neogit = require 'neogit'
        pcall(neogit.close) -- alten State verwerfen
        neogit.open { cwd = vim.fn.getcwd() }
      end,
      desc = 'Open Neogit',
    },
  },
  opts = {
    integrations = {
      diffview = true,
      telescope = true,
    },
  },
}
