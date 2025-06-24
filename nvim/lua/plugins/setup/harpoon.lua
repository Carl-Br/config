local harpoon = require 'harpoon'

-- REQUIRED
harpoon:setup()
-- REQUIRED

vim.keymap.set('n', '<leader>a', function()
  harpoon:list():add()
end, { desc = 'harpoon: add' })

vim.keymap.set('n', '<C-a>', function()
  harpoon.ui:toggle_quick_menu(harpoon:list())
end, { desc = 'harpoon: menu' })

vim.keymap.set('n', '<leader>1', function()
  harpoon:list():select(1)
end, { desc = 'harpoon: select 1' })

vim.keymap.set('n', '<leader>2', function()
  harpoon:list():select(2)
end, { desc = 'harpoon: select 2' })

vim.keymap.set('n', '<leader>3', function()
  harpoon:list():select(3)
end, { desc = 'harpoon: select 3' })

vim.keymap.set('n', '<leader>4', function()
  harpoon:list():select(4)
end, { desc = 'harpoon: select 4' })

-- Toggle previous & next buffers stored within Harpoon list
vim.keymap.set('n', '<leader>p', function()
  harpoon:list():prev()
end, { desc = 'harpoon: prev' })
vim.keymap.set('n', '<leader>n', function()
  harpoon:list():next()
end, { desc = 'harpoon: next' })
