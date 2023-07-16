-- This file can be loaded by calling `lua require('plugins')` from your init.vim
--
--

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
  -- Packer can manage itself
	use 'wbthomason/packer.nvim'
  	use {
		'nvim-telescope/telescope.nvim', tag = '0.1.1',
	  -- or                            , branch = '0.1.x',
	  	requires = { {'nvim-lua/plenary.nvim'} }
  	}
  	use({ 'rose-pine/neovim', as = 'rose-pine' })

  	vim.cmd('colorscheme rose-pine')
	use ('nvim-treesitter/nvim-treesitter', {run = ':TSUpdate'})
    use ('eandrju/cellular-automaton.nvim')
	use ('nvim-treesitter/playground')
	use ("theprimeagen/harpoon")
	use ("mbbill/undotree")

	use ("tpope/vim-fugitive")
	use {
		'VonHeikemen/lsp-zero.nvim',
		branch = 'v2.x',
		requires = {
			-- LSP Support
			{'neovim/nvim-lspconfig'},             -- Required
			{                                      -- Optional
			'williamboman/mason.nvim',
			run = function()
				pcall(vim.cmd, 'MasonUpdate')
			end,
		},
		{'williamboman/mason-lspconfig.nvim'}, -- Optional

		-- Autocompletion
		{'hrsh7th/nvim-cmp'},     -- Required
		{'hrsh7th/cmp-nvim-lsp'}, -- Required
		{'L3MON4D3/LuaSnip'},     -- Required
	}
	
}
use ('ThePrimeagen/vim-be-good')
use {
    'chipsenkbeil/distant.nvim',
    branch = 'v0.2',
    config = function()
        require('distant').setup {
            -- Applies Chip's personal settings to every machine you connect to
            --
            -- 1. Ensures that distant servers terminate with no connections
            -- 2. Provides navigation bindings for remote directories
            -- 3. Provides keybinding to jump into a remote file's parent directory
            ['*'] = require('distant.settings').chip_default()
        }
    end
}
end)


