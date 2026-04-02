return {
    "kndndrj/nvim-dbee",
    dependencies = {
        "MunifTanjim/nui.nvim",
    },
    build = function()
        -- Install tries to automatically detect the install method.
        -- if it fails, try calling it with one of these parameters:
        --    "curl", "wget", "bitsadmin", "go"
        require("dbee").install()
    end,
    config = function()
        require("dbee").setup( --[[optional config]])

        -- nvim-dbee Default layout calls `make_only(0)` which closes every *non-floating*
        -- window except `nvim_get_current_win()`. If focus is in a *floating* window,
        -- that closes the only normal window → E444. Focus a normal window first.
        -- local function dbee_open_safe()
        --     local cur = vim.api.nvim_get_current_win()
        --     if vim.api.nvim_win_get_config(cur).relative ~= "" then
        --         for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
        --             if vim.api.nvim_win_get_config(win).relative == "" then
        --                 vim.api.nvim_set_current_win(win)
        --                 break
        --             end
        --         end
        --     end
        --     require("dbee").open()
        -- end
        vim.keymap.set("n", "<C-n>", "<cmd>Dbee open<CR>", {
            desc = "Open dbee",
            silent = true,
        })


        -- vim.keymap.set("n", "<C-n>", dbee_open_safe, {
        --     desc = "Open dbee",
        --     silent = true,
        -- })
    end,
}
