return {
    "stevearc/conform.nvim",
    config = function()
        local function format_php(args)
            require("conform").format({ bufnr = args and args.buf or nil, async = false, lsp_fallback = true })
        end

        require("conform").setup({
            formatters_by_ft = {
                -- pint first; if missing (no vendor/bin/pint), fall back to php-cs-fixer when present
                php = { "pint", "php_cs_fixer", stop_after_first = true },
            },
        })

        vim.api.nvim_create_autocmd("FileType", {
            pattern = "php",
            callback = function(args)
                vim.keymap.set("n", "=", function()
                    format_php(args)
                end, { buffer = args.buf, desc = "Format PHP buffer" })
            end,
        })
    end
}
