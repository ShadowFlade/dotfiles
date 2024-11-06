return {
    {
        "folke/trouble.nvim",
        config = function()
            require("trouble").setup({
                icons = {
                    indent        = {
                        top         = "│ ",
                        middle      = "├╴",
                        last        = "└╴",
                        -- last          = "-╴",
                        -- last       = "╰╴", -- rounded
                        fold_open   = " ",
                        fold_closed = " ",
                        ws          = "  ",
                    },
                    folder_closed = " ",
                    folder_open   = " ",
                    kinds         = {
                        Array         = " ",
                        Boolean       = "󰨙 ",
                        Class         = " ",
                        Constant      = "󰏿 ",
                        Constructor   = " ",
                        Enum          = " ",
                        EnumMember    = " ",
                        Event         = " ",
                        Field         = " ",
                        File          = " ",
                        Function      = "󰊕 ",
                        Interface     = " ",
                        Key           = " ",
                        Method        = "󰊕 ",
                        Module        = " ",
                        Namespace     = "󰦮 ",
                        Null          = " ",
                        Number        = "󰎠 ",
                        Object        = " ",
                        Operator      = " ",
                        Package       = " ",
                        Property      = " ",
                        String        = " ",
                        Struct        = "󰆼 ",
                        TypeParameter = " ",
                        Variable      = "󰀫 ",
                    },

                }
            })

            -- vim.keymap.set("n", "<leader>tt", function()
            --     require("trouble").toggle()
            -- end)
            --
            -- vim.keymap.set("n", "[t", function()
            --     require("trouble").next({ skip_groups = true, jump = true });
            -- end)
            --
            -- vim.keymap.set("n", "]t", function()
            --     require("trouble").previous({ skip_groups = true, jump = true });
            -- end)

            vim.keymap.set("n", "]t", "<cmd>Trouble previous diagnostics<CR>");
        end
    },
}
