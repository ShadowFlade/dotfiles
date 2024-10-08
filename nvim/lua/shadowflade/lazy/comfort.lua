return {
    "stevearc/conform.nvim",
    config = function()
        require("conform").setup({
            formatters_by_ft = {
                php = { "pint" }
            }
        })
        vim.api.nvim_create_autocmd("BufWritePre", {
            pattern = "*.php",
            callback = function(args)
                require("conform").format { bufnr = args.buf, lsp_fallback = true }
            end
        })
    end
}
