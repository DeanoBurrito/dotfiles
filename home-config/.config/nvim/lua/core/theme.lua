local theme = require('ayu')
local colours = require('ayu.colors')
colours.generate()

theme.setup({
    mirage = false,
    overrides = {
        Normal = { bg = "None" },
        SignColumn = { bg = "None" },
        LineNr = { fg = colours.fg },
    }
})

theme.colorscheme()
