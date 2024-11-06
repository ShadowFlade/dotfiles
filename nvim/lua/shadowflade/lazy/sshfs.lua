return {
    'DanielWeidinger/nvim-sshfs',
    config = function()
        require("sshfs").setup {
            mnt_base_dir = vim.fn.expand("$HOME") .. "/tmp/sshfs",
            width = 0.6, -- host window width
            height = 0.5, -- host window height
            connection_icon = "✓", -- icon for connection indication
        }
    end
}
