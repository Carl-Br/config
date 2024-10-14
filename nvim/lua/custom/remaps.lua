-- general
vim.keymap.set('n', '<C-d>', '<C-d>zz')
vim.keymap.set('n', '<C-u>', '<C-u>zz')
vim.keymap.set('n','<s-g>','<s-g>zz')
vim.keymap.set('n', 'gd', function()
    vim.cmd('normal! gdzz')
end)

