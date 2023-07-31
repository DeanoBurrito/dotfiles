require('mason').setup()
require('mason-lspconfig').setup({
    ensure_installed = { 'lua_ls', 'clangd', 'ltex' }
})

local on_attach = function(_, bufnr)
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, {})
    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, {})

    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, {})
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, {})
    vim.keymap.set('n', 'gr', require('telescope.builtin').lsp_references, {})
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, {})
end

local caps = require('cmp_nvim_lsp').default_capabilities()

require('lspconfig').lua_ls.setup ({
    on_attach = on_attach,
    capabilities = caps
})
require('lspconfig').clangd.setup ({
    on_attach = on_attach,
    capabilities = caps,
    cmd = { "clangd", "--header-insertion=never" }
})
require('lspconfig').ltex.setup ({
    on_attach = on_attach,
    capabilities = caps
})
