local builtin = require('telescope.builtin')

require('telescope').setup {
        defaults = {
            file_ignore_patterns = {
                '^.git/',
                '%.o',
            }
        }
}

vim.keymap.set('n', '<c-p>', "<Cmd>Telescope find_files hidden=true no_ignore=true<CR>", {})
vim.keymap.set('n', '<leader><Space>', builtin.oldfiles, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
vim.keymap.set('n', '<leader>fr', builtin.lsp_references, {})
vim.keymap.set('n', '<leader>gl', builtin.git_commits, {})
vim.keymap.set('n', '<leader>gb', builtin.git_branches, {})
vim.keymap.set('n', '<leader>gs', builtin.git_status, {})
vim.keymap.set('n', '<leader>gc', builtin.git_bcommits, {})

