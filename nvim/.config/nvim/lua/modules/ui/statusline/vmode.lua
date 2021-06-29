local colors = require("modules.ui._colors").nm

-- local util = require("modules.ui.util")
local i = require("modules.ui.util").icon

local config = {}

local GalaxyBG = function(item, col)
    vim.api.nvim_command("hi Galaxy" .. item .. " guibg=" .. col)
end

local GalaxyHi = function(item, colorfg, colorbg)
    vim.api.nvim_command("hi Galaxy" .. item .. " guifg=" .. colorfg .. " guibg=" .. colorbg)
end

local buffer_not_empty = function()
    if vim.fn.empty(vim.fn.expand("%:t")) ~= 1 then
        return true
    end
    return false
end

local num = {
    "❶",
    "❷",
    "❸",
    "❹",
    "❺",
    "❻",
    "❼",
    "❽",
    "❾",
    "❿",
    "⓫",
    "⓬",
    "⓭",
    "⓮",
    "⓯",
    "⓰",
    "⓱",
    "⓲",
    "⓳",
    "⓴"
}

config.vmode = function()
    local mode = {
        c = {i.mode.c, colors.red},
        ce = {i.mode.c, colors.red},
        cv = {i.mode.c, colors.red},
        i = {i.mode.i, colors.green},
        ic = {i.mode.i, colors.green},
        n = {i.mode.n, colors.fg},
        no = {i.mode.n, colors.fg},
        r = {i.mode.r, colors.cyan},
        rm = {i.mode.r, colors.cyan},
        R = {i.mode.r, colors.violet},
        Rv = {i.mode.r, colors.violet},
        s = {i.mode.s, colors.orange},
        S = {i.mode.s, colors.orange},
        t = {i.mode.t, colors.blue},
        V = {i.mode.v, colors.blue},
        v = {i.mode.v, colors.blue},
        ["r?"] = {i.mode.r, colors.cyan},
        [""] = {"🅢 ", colors.orange},
        [""] = {" ", colors.blue},
        ["!"] = {"! ", colors.red}
    }

    local n = (function()
        if num[vim.fn.bufnr("%")] ~= nil then
            return num[vim.fn.bufnr("%")]
        else
            return vim.fn.bufnr("%")
        end
    end)()

    -- vim.api.nvim_command("hi GalaxyViMode guifg=" .. mode_color[vim.fn.mode()] .. " guibg=" .. colors.bg)

    local vimMode = mode[vim.fn.mode()]
    if mode[vim.fn.mode()] ~= nil then
        GalaxyBG("ViMode", vimMode[2])
        return "   " .. vimMode[1] .. " | " .. n .. "  "
    else
        GalaxyBG("ViMode", "error")
        return "  ? | " .. n .. "  "
    end
end

config.separatorVmode = function()
    local mode_color = {
        c = colors.red,
        ce = colors.red,
        cv = colors.red,
        i = colors.green,
        ic = colors.green,
        n = colors.fg,
        no = colors.fg,
        r = colors.cyan,
        rm = colors.cyan,
        R = colors.violet,
        Rv = colors.violet,
        s = colors.orange,
        S = colors.orange,
        t = colors.blue,
        V = colors.blue,
        v = colors.blue,
        ["r?"] = colors.cyan,
        [""] = colors.orange,
        [""] = colors.blue,
        ["!"] = colors.red
    }

    local m_color = "error"
    if mode_color[vim.fn.mode()] ~= nil then
        m_color = mode_color[vim.fn.mode()]
    end

    if not buffer_not_empty() or vim.bo.filetype == "dashboard" then
        GalaxyHi("ViModeSeperator", m_color, colors.fg)
    else
        GalaxyHi("ViModeSeperator", m_color, colors.fg)
    end

    return i.slant.Right
end

return config
