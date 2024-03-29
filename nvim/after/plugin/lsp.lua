local masonLspConfig = require("mason-lspconfig")
masonLspConfig.setup()
vim.lsp.set_log_level("debug");
local mason = require('mason')
mason.setup()
local lspSaga = require('lspsaga')
local lspConfig = require('lspconfig')
local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())

local on_attach = function(client, bufnr)
    local opts = { buffer = bufnr, remap = false }

    vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
    vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
    vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
    vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
    vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
    vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
    vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
    vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
    vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
    vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
    --if client.resolved_capabilities.document_formatting then
    --    vim.api.nvim_command [[augroup Format]]
    --    vim.api.nvim_command [[autocmd! * <buffer>]]
    --    vim.api.nvim_command [[autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_seq_sync()]]
    --    vim.api.nvim_command [[augroup END]]
    --end
end


lspSaga.setup({
    code_action_icon = "💡",
    symbol_in_winbar = {
        in_custom = false,
        enable = false,
        separator = ' ',
        show_file = false,
        file_formatter = ""
    },
})

vim.keymap.set("n", "gd", "<cmd>Lspsaga lsp_finder<CR>", { silent = true })
vim.keymap.set('n', 'K', '<Cmd>Lspsaga hover_doc<cr>', { silent = true })
vim.keymap.set({ "n", "v" }, "<leader>ca", "<cmd>Lspsaga code_action<CR>", { silent = true })
vim.keymap.set("n", "<leader>rn", "<cmd>Lspsaga rename<CR>", { silent = true })

lspConfig.emmet_language_server.setup({
    filetypes = { "css", "eruby", "html", "javascript", "javascriptreact", "less", "sass", "scss", "svelte", "pug",
        "typescriptreact", "vue",'markdown','markdown_inline','typescript' },
    init_options = {
        --- @type table<string, any> https://docs.emmet.io/customization/preferences/
        preferences = {},
        --- @type "always" | "never" defaults to `"always"`
        showexpandedabbreviation = "always",
        --- @type boolean defaults to `true`
        showabbreviationsuggestions = true,
        --- @type boolean defaults to `false`
        showsuggestionsassnippets = false,
        --- @type table<string, any> https://docs.emmet.io/customization/syntax-profiles/
        syntaxprofiles = {},
        --- @type table<string, string> https://docs.emmet.io/customization/snippets/#variables
        variables = {},
        --- @type string[]
        excludelanguages = {},
    },
})
lspConfig.lua_ls.setup {
    capabilities = capabilities,

    on_attach = on_attach,
    settings = {
        Lua = {
            diagnostics = {
                globals = { "vim" },
            },
            workspace = {
                library = {
                    [vim.fn.expand "$VIMRUNTIME/lua"] = true,
                    [vim.fn.stdpath "config" .. "/lua"] = true,
                },
            },
        },
    }
}
lspConfig.tsserver.setup {}
lspConfig.solargraph.setup {
    capabilities = capabilities,
}

lspConfig.pyright.setup {
    capabilities = capabilities,
}
lspConfig.gopls.setup {
    capabilities = capabilities,
    on_attach = on_attach,
    filetypes = {'go','gomod','gowork','gotmpl'},
    cmd = {"gopls"},
    settings = {
        gopls = {
            completeUnimported = true,
            usePlaceholders = true,
            analyses = {
                unusedparams = true
            }
        }
    }
}
vim.diagnostic.config({
    virtual_text = true
})
lspConfig.diagnosticls.setup {
    on_attach = on_attach,
    filetypes = { 'javascript', 'javascriptreact', 'json', 'typescript', 'typescriptreact', 'css', 'less', 'scss',
        'markdown', 'pandoc' },
    init_options = {
        --linters = {
        --  eslint = {
        --    command = 'eslint_d',
        --    rootPatterns = { '.git' },
        --    debounce = 100,
        --    args = { '--stdin', '--stdin-filename', '%filepath', '--format', 'json' },
        --    sourceName = 'eslint_d',
        --    parseJson = {
        --      errorsRoot = '[0].messages',
        --      line = 'line',
        --      column = 'column',
        --      endLine = 'endLine',
        --      endColumn = 'endColumn',
        --      message = '[eslint] ${message} [${ruleId}]',
        --      security = 'severity'
        --    },
        --    securities = {
        --      [2] = 'error',
        --      [1] = 'warning'
        --    }
        --  },
        --},
        filetypes = {
            javascript = 'eslint',
            javascriptreact = 'eslint',
            typescript = 'eslint',
            typescriptreact = 'eslint',
        },
        formatters = {
            eslint_d = {
                command = 'eslint_d',
                args = { 'stdin', 'stdin-filename', '%filename', 'fix-to-stdout' },
                rootPatterns = { '.git' },
            },
            prettier = {
                command = 'prettierd',
                args = { '--stdin-filepath', '%filename' }
            }
        },
        formatFiletypes = {
            css = 'prettier',
            javascript = 'prettierd',
            javascriptreact = 'prettier',
            scss = 'prettier',
            less = 'prettier',
            typescript = 'eslint_d',
            typescriptreact = 'eslint_d',
            json = 'prettier',
            markdown = 'prettier',
        }
    }
}
