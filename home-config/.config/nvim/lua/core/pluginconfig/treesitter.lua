require('nvim-treesitter.configs').setup {
    ensure_installed = { "c", "cpp", "lua", "markdown" },
    auto_install = false,
    hightlight = {
        enable = false,
    },
}
