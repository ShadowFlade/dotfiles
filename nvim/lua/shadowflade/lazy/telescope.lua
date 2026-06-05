return {
    "nvim-telescope/telescope.nvim",

    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-lua/popup.nvim",
        "nvim-telescope/telescope-media-files.nvim",
        "nvim-telescope/telescope-live-grep-args.nvim"
    },



    config = function()
        local select_one_or_multi = function(prompt_bufnr)
            local picker = require("telescope.actions.state").get_current_picker(prompt_bufnr)
            local multi = picker:get_multi_selection()
            if not vim.tbl_isempty(multi) then
                require("telescope.actions").close(prompt_bufnr)
                for _, j in pairs(multi) do
                    if j.path ~= nil then
                        vim.cmd(string.format("%s %s", "edit", j.path))
                    end
                end
            else
                require("telescope.actions").select_default(prompt_bufnr)
            end
        end
        local actions = require("telescope.actions")
        require('telescope').setup {
            initial_mode = "normal",
            extensions = {
                media_files = {
                    -- filetypes whitelist
                    -- defaults to {"png", "jpg", "mp4", "webm", "pdf"}
                    filetypes = { "png", "webp", "jpg", "jpeg" },
                    -- find command (defaults to `fd`)
                    find_cmd = "rg"
                }
            },
            mappings = {
                n = {
                    ["<C-w>"] = actions.send_selected_to_qflist + actions.open_qflist,
                },
                i = {
                    ["<C-j>"] = actions.cycle_history_next,
                    ["<C-k>"] = actions.cycle_history_prev,
                    ["<CR>"] = select_one_or_multi,
                    ["<C-w>"] = actions.send_selected_to_qflist + actions.open_qflist,
                    ["<C-D>"] = actions.delete_buffer,
                    ["<C-s>"] = actions.cycle_previewers_next,
                    ["<C-a>"] = actions.cycle_previewers_prev,
                },
            },
        }

        local builtin = require('telescope.builtin')
        local media_files = require('telescope').extensions.media_files;
        vim.keymap.set('n', '<leader>pf', builtin.find_files, {})
        vim.keymap.set('n', '<C-p>', function()
            builtin.git_files({
                show_untracked = false,
                cwd = vim.fn.getcwd(),
                --git_command = { 'git', 'status', '--porcelain', '-z' },
                --previewer = true,
                layout_config = { preview_width = 50, width =  .99},
            })
        end, { desc = 'Git files' })
        vim.keymap.set('n', '<leader>of', builtin.oldfiles, {})
        vim.keymap.set('n', '<leader>fs', builtin.lsp_document_symbols, {})
        vim.keymap.set("n", "<leader>fw", builtin.grep_string, { desc = "Find Word under Cursor" })
        --
        -- e.g. "timer" views/
        vim.keymap.set(
            'n',
            '<leader>fg',
            "<cmd>lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>"
        )

        vim.keymap.set('n', '<leader>pws', function()
            local word = vim.fn.expand("<cword>")
            builtin.grep_string({ search = word })
        end)
        vim.keymap.set('n', '<C-e>', builtin.buffers, {})
        vim.keymap.set('n', '<leader>pWs', function()
            local word = vim.fn.expand("<cWORD>")
            builtin.grep_string({ search = word })
        end)
        vim.keymap.set('n', '<leader>ps', function()
            builtin.grep_string({ search = vim.fn.input("Grep > ") })
        end)
        vim.keymap.set('n', '<leader>vh', builtin.help_tags, {})

        vim.keymap.set('n', '<leader>img', media_files.media_files, {})
        require("telescope").load_extension("live_grep_args")
        --require("telescope").load_extension("ui-select")
    end
}
