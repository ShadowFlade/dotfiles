-- This file can be loaded by calling `lua require('plugins')` from your init.vim
--
--
-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
  -- Packer can manage itself
	use 'wbthomason/packer.nvim'
    use('jose-elias-alvarez/null-ls.nvim')
    use('MunifTanjim/prettier.nvim')
  	use {
		'nvim-telescope/telescope.nvim', tag = '0.1.1',
	  -- or                            , branch = '0.1.x',
	  	requires = { {'nvim-lua/plenary.nvim'} }
    }
    use({ 'rose-pine/neovim', as = 'rose-pine' })

    vim.cmd('colorscheme rose-pine')
    use ('nvim-treesitter/nvim-treesitter', {run = ':TSUpdate'})
    use ('nvim-treesitter/nvim-treesitter-context')
    use ('eandrju/cellular-automaton.nvim')
    use ('nvim-treesitter/playground')
    use ("theprimeagen/harpoon")
    use ("mbbill/undotree")
    use ('neovim/nvim-lspconfig')
    use ("tpope/vim-fugitive")
    use ('L3MON4D3/LuaSnip')
    use ('saadparwaiz1/cmp_luasnip')
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
    use ({
        'nvimdev/lspsaga.nvim',
        after = 'nvim-lspconfig',
        config = function()
            require('lspsaga').setup({})
        end,
    }) 
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
    
    local null_ls = require("null-ls")

    local group = vim.api.nvim_create_augroup("lsp_format_on_save", { clear = false })
    local event = "BufWritePre" -- or "BufWritePost"
    local async = event == "BufWritePost"

    null_ls.setup({
        on_attach = function(client, bufnr)
            if client.server_capabilities.documentFormattingProvider then
                vim.api.nvim_command [[augroup Format]]
                vim.api.nvim_command [[autocmd! * <buffer>]]
                vim.api.nvim_command [[autocmd BufWritePre <buffe> lua vim.lsp.buf.formatting_seq_sync()]]
                vim.api.nvim_command [[augroup END]]
            end
--            if client.supports_method("textDocument/formatting") then
--                vim.keymap.set("n", "<Leader>f", function()
--                    vim.lsp.buf.format({ bufnr = vim.api.nvim_get_current_buf() })
--                end, { buffer = bufnr, desc = "[lsp] format" })
--
--                -- format on save
--                vim.api.nvim_clear_autocmds({ buffer = bufnr, group = group })
--                vim.api.nvim_create_autocmd(event, {
--                    buffer = bufnr,
--                    group = group,
--                    callback = function()
--                        vim.lsp.buf.format({ bufnr = bufnr, async = async })
--                    end,
--                    desc = "[lsp] format on save",
--                })
--            end
--
--            if client.supports_method("textDocument/rangeFormatting") then
--                vim.keymap.set("x", "<Leader>f", function()
--                    vim.lsp.buf.format({ bufnr = vim.api.nvim_get_current_buf() })
--                end, { buffer = bufnr, desc = "[lsp] format" })
--            end
        end,
        sources = {
            null_ls.builtins.diagnostics.eslint_d.with({
                diagnostics_format = '[eslint] #{m}\n(#{c})'
            }),
            null_ls.builtins.diagnostics.fish
        }})
end)


