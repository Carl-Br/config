-- general
vim.keymap.set('n', '<C-d>', '<C-d>zz')
vim.keymap.set('n', '<C-u>', '<C-u>zz')
vim.keymap.set('n', '<leader>gd', '<leader>gdzz')

-- harpoon
vim.keymap.set('n', '<leader>ha', '<cmd>lua require("harpoon.mark").add_file()<CR>',{desc="add File to Harpoon"})
vim.keymap.set('n', '<leader>hm', '<cmd>lua require("harpoon.ui").toggle_quick_menu()<CR>',{desc="toggle Harpoon Menu"})
vim.keymap.set('n', '<leader>j', '<cmd>lua require("harpoon.ui").nav_file(1)<CR>',{desc="jump to Harpoon File 1"})
vim.keymap.set('n', '<leader>k', '<cmd>lua require("harpoon.ui").nav_file(2)<CR>',{desc="jump to Harpoon File 2"})
