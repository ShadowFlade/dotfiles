return {
    {
        "nvim-lua/plenary.nvim",
        name = "plenary"
    },

    {
        "folke/trouble.nvim",
        config = function()
            require("trouble").setup {
                icons = false
            }
        end
    },
    "mbbill/undotree",
    "folke/zen-mode.nvim",
--    "eandrju/cellular-automation.nvim",
}
