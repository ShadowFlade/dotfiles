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

vim.keymap.set("i", "<C-c>", "<Esc>")
-- disables Q
vim.keymap.set("n", "Q", "<nop>")
-- TODO set my own tmux hotkey
--vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")
vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")

vim.keymap.set("n", "<leader>=", vim.lsp.buf.format)
vim.keymap.set("n", "<leader>==", "<cmd>:Prettier<CR>", { noremap = true, silent = true })
--next/prev error
vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")

vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")
-- replace worde under cursor with smth
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
-- make it executable
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

vim.keymap.set("n", "<leader>vpp", "<cmd>e ~/Desktop/code/.dotfiles/nvim/lua/shadowflade/remap.lua<CR>");
vim.keymap.set("n", "<leader>mr", "<cmd>CellularAutomaton make_it_rain<CR>");

vim.keymap.set("n", "<leader><leader>", function()
    vim.cmd("so")
    vim.api.nvim_set_keymap("n", "<Leader>nf", ":lua require('neogen').generate()<CR>",
        { noremap = true, silent = true })
end)
vim.keymap.set("n","<leader>e",":lua vim.diagnostic.open_float(0, {scope='line'})<CR>", { noremap = true, silent = true}) 
--vim.keymap.set("n", "=", ":Prettier<CR>", { noremap = true, silent = true })
