-- Setze das Mapping für Ctrl + n, um NvimTreeToggle aufzurufen
vim.keymap.set('n', '<C-n>', ':Neotree toggle<CR>', { noremap = true, silent = true, desc = 'toggle neotree' })
