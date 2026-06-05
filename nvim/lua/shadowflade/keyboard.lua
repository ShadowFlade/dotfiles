-- Normal/Visual: US only (hjkl / leader). Insert: restore last Insert layout (RU/US).
-- Track layout via Cyrillic/Latin input and Alt+Shift in Insert.

local M = {}

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

local function apply_layout(name)
    if name == "ru" then
        run(LAYOUT_RU_DEFAULT)
    else
        run(LAYOUT_US_DEFAULT)
    end
end

local function force_us()
    run(LAYOUT_US_ONLY)
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

local function char_is_latin(char)
    if not char or char == "" then
        return false
    end
    local cp = vim.fn.char2nr(char)
    return (cp >= 0x41 and cp <= 0x5A) or (cp >= 0x61 and cp <= 0x7A)
end

local function set_insert_layout(name)
    vim.b.kb_insert_layout = name
    apply_layout(name)
end

local function restore_insert_layout()
    local layout = vim.g.kb_restore_layout or "us"
    vim.b.kb_insert_layout = layout
    apply_layout(layout)
end

local function save_and_leave_insert()
    vim.g.kb_restore_layout = vim.b.kb_insert_layout or "us"
    force_us()
end

function M.setup()
    vim.g.kb_restore_layout = vim.g.kb_restore_layout or "us"

    if vim.fn.executable("setxkbmap") ~= 1 then
        vim.notify("keyboard.lua: setxkbmap not found", vim.log.levels.WARN)
        return
    end

    local aug = vim.api.nvim_create_augroup("ShadowFladeKeyboard", { clear = true })

    vim.api.nvim_create_autocmd("InsertCharPre", {
        group = aug,
        callback = function()
            if char_is_cyrillic(vim.v.char) then
                vim.b.kb_insert_layout = "ru"
            elseif char_is_latin(vim.v.char) then
                vim.b.kb_insert_layout = "us"
            end
        end,
    })

    vim.api.nvim_create_autocmd("InsertLeave", {
        group = aug,
        callback = save_and_leave_insert,
    })

    vim.api.nvim_create_autocmd("InsertEnter", {
        group = aug,
        callback = function()
            vim.schedule(restore_insert_layout)
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
                vim.schedule(restore_insert_layout)
            end
        end,
    })

    vim.api.nvim_create_autocmd("FocusLost", {
        group = aug,
        callback = function()
            if not in_insert_like_mode() then
                run(LAYOUT_US_DEFAULT)
            end
        end,
    })

    vim.api.nvim_create_autocmd("FocusGained", {
        group = aug,
        callback = function()
            if in_insert_like_mode() then
                vim.schedule(restore_insert_layout)
            else
                force_us()
            end
        end,
    })

    vim.keymap.set("i", "<A-S>", function()
        local next_layout = (vim.b.kb_insert_layout == "ru") and "us" or "ru"
        set_insert_layout(next_layout)
    end, { desc = "Toggle keyboard layout in Insert" })
end

return M
