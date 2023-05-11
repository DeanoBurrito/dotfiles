local builtin = require('telescope.builtin')

vim.keymap.set('n', '<c-p>', "<Cmd>Telescope find_files hidden=true no_ignore=true<CR>", {})
vim.keymap.set('n', '<leader><Space>', builtin.oldfiles, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
