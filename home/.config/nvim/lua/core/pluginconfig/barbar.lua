require('barbar').setup {
    animation = true,
    auto_hide = false,
    highlight_visible = true,
    gitsigns = {
        added = { enabled = true, icon = '+' },
        changed = { enabled = true, icon = '~' },
        deleted = { enabled = true, icon = 'D' }
    },
    filetype = { enabled = true }
}

vim.keymap.set('n', '<A-,>', '<Cmd>BufferPrevious<CR>', {})
vim.keymap.set('n', '<A-.>', '<Cmd>BufferNext<CR>', {})
vim.keymap.set('n', '<A-<>', '<Cmd>BufferMovePrevious<CR>', {})
vim.keymap.set('n', '<A->>', '<Cmd>BufferMoveNext<CR>', {})
