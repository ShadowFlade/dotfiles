-- Normal/Visual: only US (hjkl / leader work). Insert: restore RU or US.
-- Matches i3 setxkbmap line. Does not use IBus or xdotool.

local M = {}

-- Keep in sync with i3/config exec_always setxkbmap ...
local LAYOUT_US_ONLY = "setxkbmap -model pc105 -layout us"
local LAYOUT_US_DEFAULT = "setxkbmap -model pc105 -layout us,ru -variant ,, -option grp:alt_shift_toggle"
local LAYOUT_RU_DEFAULT = "setxkbmap -model pc105 -layout ru,us -variant ,, -option grp:alt_shift_toggle"

local function run(cmd)
    if vim.fn.executable("setxkbmap") ~= 1 then
        return false
    end
    vim.fn.system(cmd)
    return vim.v.shell_error == 0
end

local function force_us()
    run(LAYOUT_US_ONLY)
    vim.g.kb_layout = "us"
end

local function apply_layout(name)
    if name == "ru" then
        run(LAYOUT_RU_DEFAULT)
        vim.g.kb_layout = "ru"
    else
        run(LAYOUT_US_DEFAULT)
        vim.g.kb_layout = "us"
    end
end

local function layout_to_restore()
    if vim.b.insert_used_cyrillic or vim.g.kb_layout == "ru" then
        return "ru"
    end
    return "us"
end

local function save_and_switch_to_us()
    vim.g.kb_restore_layout = layout_to_restore()
    force_us()
    vim.b.insert_used_cyrillic = false
end

local function restore_saved()
    apply_layout(vim.g.kb_restore_layout or "ru")
end

local function in_insert_like_mode()
    local mode = vim.api.nvim_get_mode().mode
    return mode == "i" or mode == "R" or mode:sub(1, 1) == "R"
end

local function char_is_cyrillic(char)
    if not char or char == "" then
        return false
    end
    local cp = vim.fn.char2nr(char)
    return (cp >= 0x0400 and cp <= 0x04FF) or (cp >= 0x0500 and cp <= 0x052F)
end

function M.setup()
    vim.g.kb_layout = vim.g.kb_layout or "us"

    if vim.fn.executable("setxkbmap") ~= 1 then
        vim.notify("keyboard.lua: setxkbmap not found", vim.log.levels.WARN)
        return
    end

    local aug = vim.api.nvim_create_augroup("ShadowFladeKeyboard", { clear = true })

    vim.api.nvim_create_autocmd("InsertCharPre", {
        group = aug,
        callback = function()
            if char_is_cyrillic(vim.v.char) then
                vim.b.insert_used_cyrillic = true
                vim.g.kb_layout = "ru"
            end
        end,
    })

    vim.api.nvim_create_autocmd("InsertLeave", {
        group = aug,
        callback = save_and_switch_to_us,
    })

    vim.api.nvim_create_autocmd("InsertEnter", {
        group = aug,
        callback = function()
            vim.b.insert_used_cyrillic = false
            vim.schedule(restore_saved)
        end,
    })

    vim.api.nvim_create_autocmd("CmdlineEnter", {
        group = aug,
        callback = force_us,
    })

    vim.api.nvim_create_autocmd("CmdlineLeave", {
        group = aug,
        callback = function()
            if in_insert_like_mode() then
                vim.schedule(restore_saved)
            end
        end,
    })

    -- Other apps need us,ru; nvim Normal needs layout us only for keymaps
    vim.api.nvim_create_autocmd("FocusLost", {
        group = aug,
        callback = function()
            if in_insert_like_mode() then
                return
            end
            run(LAYOUT_US_DEFAULT)
            vim.g.kb_layout = "us"
        end,
    })

    vim.api.nvim_create_autocmd("FocusGained", {
        group = aug,
        callback = function()
            if in_insert_like_mode() then
                vim.schedule(restore_saved)
            else
                force_us()
            end
        end,
    })
end

return M
