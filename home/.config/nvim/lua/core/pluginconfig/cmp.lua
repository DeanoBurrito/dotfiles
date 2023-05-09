local cmp = require('cmp')

cmp.setup({
    mapping = cmp.mapping.preset.insert({
        ['<C-d>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
    }),
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
    }, {
        { name = 'buffer' }
    })
})

local caps = require('cmp_nvim_lsp').default_capabilities()
require('lspconfig')['clangd'].setup {
    capabilities = caps
}
require('lspconfig')['lua_ls'].setup {
    capabilities = caps
}
require('lspconfig')['ltex'].setup {
    capabilities = caps
}
