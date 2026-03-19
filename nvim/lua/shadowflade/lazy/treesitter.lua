-- ~/.config/nvim/lua/shadowflade/lazy/treesitter.lua
return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
        ensure_installed = {
            "vimdoc",
            "javascript",
            "typescript",
            "c",
            "lua",
            "jsdoc",
            "bash",
            "go",
            "templ",
            "blade",
        },
        sync_install = false,
        auto_install = true,
        highlight = {
            enable = true,
            additional_vim_regex_highlighting = { "markdown" },
        },
        indent = { enable = true },
        parsers = {
            templ = {
                install_info = {
                    url = "https://github.com/vrischmann/tree-sitter-templ.git",
                    files = { "src/parser.c", "src/scanner.c" },
                    branch = "master",
                },
                filetype = { "templ" },
            },
            blade = {
                install_info = {
                    url = "https://github.com/EmranMR/tree-sitter-blade",
                    files = { "src/parser.c" },
                    branch = "main",
                },
                filetype = { "blade", "blade.php" },
            },
        },
    },
}
