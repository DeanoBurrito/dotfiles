vim.opt.completeopt = { 'menu', 'menuone', 'noselect' }

require("luasnip.loaders.from_vscode").lazy_load()
local cmp = require('cmp')
local luasnip = require('luasnip')

cmp.setup({
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-d>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
    }),
    sources = {
        { name = 'nvim_lsp', keyword_length = 1 },
        { name = 'buffer', keyword_length = 3 },
        { name = 'luasnip', keyword_length = 2 },
        { name = 'path' },
    },
    window = {
        documentation = cmp.config.window.bordered(),
        completion = cmp.config.window.bordered()
    },
    formatting = {
        format = function(entry, vim_item)
            vim_item.menu = ({
                buffer = "[Buff]",
                nvim_lsp = "[LSP]",
                luasnip = "[Snip]",
                path = "[Path]",
            })[entry.source.name]
            return vim_item
        end
    },
})

cmp.setup.cmdline({ '/', '?'}, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
        { name = 'buffer' },
    }
})

cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
        { name = 'path' }
    }, {
        {name = 'cmdline' }
    })
})

