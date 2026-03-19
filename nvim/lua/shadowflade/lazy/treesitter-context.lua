return {
    "nvim-treesitter/nvim-treesitter-context",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    event = "BufReadPre",
    config = function()
        require("treesitter-context").setup({
            enable = true,            -- Enable the plugin
            max_lines = 5,            -- Max context lines to show
            min_window_height = 0,    -- Min window height to show context
            line_numbers = true,      -- Show line numbers in context
            multiline_threshold = 20, -- Max lines for multiline context
            trim_scope = "outer",     -- Which scope to trim: "inner" or "outer"
            mode = "topline",          -- "cursor" or "topline"
            separator = nil,          -- Separator between context and content
            zindex = 50,              -- Z-index for floating window
            scope_priority = 100,      -- Priority of scopes (higher = more important)
        })

        -- Optional: Toggle command
        vim.keymap.set("n", "<leader>uc", "<cmd>TreesitterContextToggle<cr>", {
            desc = "Toggle Treesitter Context",
        })
    end,
}
