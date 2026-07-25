vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- move line below to the end of current line
vim.keymap.set("n", "J", "mzJ`z")
-- move up and down
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

vim.keymap.set("n", "<leader>vwm", function()
    require("vim-with-me").StartVimWithMe()
end)
vim.keymap.set("n", "<leader>svwm", function()
    require("vim-with-me").StopVimWithMe()
end)
-- pastes text in buffer into the next paragraph
vim.keymap.set("x", "<leader>p", [["_dP]])

-- copies into outer buffer
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
-- copies line into buffer
vim.keymap.set("n", "<leader>Y", [["+Y]])
-- deletes into void
vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])

-- US layout; same physical keys on JCUKEN (RU)
vim.keymap.set("i", "<C-c>", "<Esc>")
vim.keymap.set("i", "<C-с>", "<Esc>")
vim.keymap.set("i", "<C-С>", "<Esc>")
vim.keymap.set("i", "<C-ц>", "<C-w>")
vim.keymap.set("i", "<C-Ц>", "<C-w>")
-- disables Q
vim.keymap.set("n", "Q", "<nop>")
-- TODO set my own tmux hotkey
--vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")
vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")

vim.keymap.set("n", "<leader>=", function()
    local ok, conform = pcall(require, "conform")
    if ok then
        -- Uses formatters_by_ft when set; otherwise falls back to LSP (same as other languages)
        conform.format({ bufnr = 0, async = false, lsp_fallback = true })
        return
    end
    vim.lsp.buf.format()
end)
--vim.keymap.set("n", "<leader>==", "<cmd>:Prettier<CR>", { noremap = true, silent = true })
--next/prev error
vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
--vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")

vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")
-- replace worde under cursor with smth
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
-- make it executable
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

vim.keymap.set("n", "<leader>vpp", "<cmd>e ~/Desktop/code/.dotfiles/nvim/lua/shadowflade/remap.lua<CR>");
vim.keymap.set("n", "<leader>mr", "<cmd>CellularAutomaton make_it_rain<CR>");

--vim.keymap.set("n", "<leader><leader>", function()
--    vim.cmd("so")
--end)
vim.api.nvim_set_keymap("n", "<Leader>nf", ":lua require('neogen').generate()<CR>",
    { noremap = true, silent = true })
vim.keymap.set("n", "<leader>e", ":lua vim.diagnostic.open_float(0, {scope='line'})<CR>",
    { noremap = true, silent = true })
--vim.keymap.set("n", "=", ":Prettier<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-b>", "");
vim.keymap.set("n", "<C-t>", "<cmd>tabnew <CR>");
vim.api.nvim_create_autocmd("FileType", {
    pattern = "qf",
    callback = function(args)
        vim.keymap.set("n", "<C-t>", function()
            local qf = vim.fn.getqflist({ idx = 0, items = 0 })
            local item = qf.items and qf.items[qf.idx] or nil
            if not item then
                return
            end

            vim.cmd("tabnew")
            if item.bufnr and item.bufnr > 0 then
                vim.api.nvim_set_current_buf(item.bufnr)
            elseif item.filename and item.filename ~= "" then
                vim.cmd("edit " .. vim.fn.fnameescape(item.filename))
            else
                return
            end

            if item.lnum and item.lnum > 0 then
                vim.api.nvim_win_set_cursor(0, { item.lnum, math.max((item.col or 1) - 1, 0) })
            end
        end, { buffer = args.buf, silent = true, desc = "Open quickfix item in new tab" })
    end,
})
--vim.keymap.set("n", "<C-w>", "<cmd>tabclose<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>q", "<cmd>tabclose<CR>", { noremap = true, silent = true })
--vim.keymap.set("n", "<leader>w", "<cmd>tabclose <CR>");
vim.keymap.set("n", "<leader>fu", function()
    local word = vim.fn.expand('<cword>')
    vim.cmd('execute "vimgrep /' .. word .. '/ **/*"')
    vim.cmd('copen')
end)
-- vim.keymap.set("n", "<C-j>", function()
--     vim.cmd.vnew()
--     vim.cmd.term()
--     vim.cmd.wincmd('J')
--     vim.api.nvim_win_set_height(0, 5);
-- end)

-- get current file path
vim.keymap.set("n", "<leader>-", "<cmd>let @+ = expand('%:p')<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-S-PageUp>", "<cmd>tabm -1<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-S-PageDown>", "<cmd>tabm +1<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-PageDown>", "<cmd>tabnext<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-PageUp>", "<cmd>tabprev<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-Left>", "<cmd>tabprev<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-Right>", "<cmd>tabnext<CR>", { noremap = true, silent = true })
