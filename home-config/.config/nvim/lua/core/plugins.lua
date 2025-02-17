local ensure_packer = function()
    local fn = vim.fn
    local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
    if fn.empty(fn.glob(install_path)) > 0 then
        fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
        vim.cmd [[packadd packer.nvim]]
        return true
    end
    return false
end

local packer_bootstrap = ensure_packer()

return require('packer').startup(function(use)
    -- Packer itself
    use 'wbthomason/packer.nvim'

    -- User Plugins
    use 'nvim-tree/nvim-tree.lua'
    use 'nvim-tree/nvim-web-devicons'
    use {
        'nvim-treesitter/nvim-treesitter',
        run = ":TSUpdate"
    }

    use {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.8',
	requires = { {'nvim-lua/plenary.nvim'} },
    }
    use {
        'williamboman/mason.nvim',
        'williamboman/mason-lspconfig.nvim',
        'neovim/nvim-lspconfig',
    }
    use {
        'hrsh7th/cmp-cmdline',
        'hrsh7th/cmp-buffer',
        'hrsh7th/cmp-nvim-lsp',
        'hrsh7th/cmp-path',
        'hrsh7th/nvim-cmp',
        'L3MON4D3/LuaSnip',
    }
    use 'lewis6991/gitsigns.nvim'
    use 'romgrk/barbar.nvim'
    use 'nvim-lualine/lualine.nvim'
    use 'folke/trouble.nvim'

    use 'zaldih/themery.nvim'
    use 'shatur/neovim-ayu'
    use 'slugbyte/lackluster.nvim'
    use 'EdenEast/nightfox.nvim'
    use 'daschw/leaf.nvim'

    -- Put this at the end after all plugins
    if packer_bootstrap then
        require('packer').sync()
    end
end)
