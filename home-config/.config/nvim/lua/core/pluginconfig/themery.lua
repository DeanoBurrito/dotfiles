require('themery').setup({
    themes = {{
        name = "Ayu Dark",
        colorscheme = "ayu",
        before = [[
            vim.opt.background = "dark"
        ]]
        }, {
        name = "Leaf",
        colorscheme = "leaf"
        }, {
        name = "Lackluster (Monochrome)",
        colorscheme = "lackluster"
        }, {
        name = "Lackluster (Mint)",
        colorscheme = "lackluster-mint",
        }, {
        name = "Nightfox",
        colorscheme = "nightfox"
        }, {
        name = "Carbonfox",
        colorscheme = "carbonfox"
        }, {
        name = "Blue",
        colorscheme = "blue"
        }, {
        name = "Ayu Light",
        colorscheme = "ayu",
        before = [[
            vim.opt.background = "light"
        ]]
        }
    },
    globalAfter = [[
        hi Normal guibg=none
        hi NormalFloat guibg=none
        hi ColorColumn guibg=none
        hi SignColumn guibg=none
        hi Folded guibg=none
        hi FoldColumn guibg=none
    ]]
})

vim.keymap.set('n', '<leader>tt', "<Cmd>Themery<CR>", {})
