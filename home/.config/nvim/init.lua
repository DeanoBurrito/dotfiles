vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.opt.showcmd = true
vim.opt.laststatus = 2
vim.opt.autowrite = true
vim.opt.cursorline = true
vim.opt.autoread = true
vim.opt.termguicolors = true

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.shiftround = true
vim.opt.expandtab = true

vim.opt.number = true
vim.opt.relativenumber = true

require("core.keymaps")
require("core.plugins")
require("core.theme")
require("core.pluginconfig")
