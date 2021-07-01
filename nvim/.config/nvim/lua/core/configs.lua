local fn = vim.fn
local api = vim.api

local M = {}

SETFoldingAll = 1
SETFolding = 1

M.fold_toggle = function(key)
    if key == "a" then
        if SETFolding == 1 then
            api.nvim_command("exec 'normal! zM'")
            SETFolding = 0
        else
            api.nvim_command("exec 'normal! zR'")
            SETFolding = 1
        end
        return
    end

    if SETFoldingAll == 1 then
        api.nvim_command("exec 'normal! za'")
        SETFoldingAll = 0
    else
        api.nvim_command("exec 'normal! za'")
        SETFoldingAll = 1
    end
    return
end

-- Toggle quicfix and location list
M.copenloc_toggle = function(prefix)
    for _, i in ipairs(vim.fn.getwininfo()) do
        if prefix == "c" then
            if i.quickfix == 0 then
                api.nvim_command("exec 'copen'")
            else
                api.nvim_command("exec 'cclose'")
            end
        end

        if prefix == "l" then
            if i.loclist == 0 then
                api.nvim_command("exec 'lopen'")
            else
                api.nvim_command("exec 'lclose'")
            end
        end
    end
end

-- taken from: https://www.reddit.com/r/neovim/comments/j7wub2/how_does_visual_selection_interact_with_executing/
local get_selection = function()
    -- does not handle rectangular selection
    local s_start = vim.fn.getpos("'<")
    local s_end = vim.fn.getpos("'>")
    local n_lines = math.abs(s_end[2] - s_start[2]) + 1
    local lines = api.nvim_buf_get_lines(0, s_start[2] - 1, s_end[2], false)
    lines[1] = string.sub(lines[1], s_start[3], -1)

    if n_lines == 1 then
        lines[n_lines] = string.sub(lines[n_lines], 1, s_end[3] - s_start[3] + 1)
    else
        lines[n_lines] = string.sub(lines[n_lines], 1, s_end[3])
    end
    return lines
end

local urlEncode = function(str)
    if (str) then
        str = string.gsub(str, "\n", "\r\n")
        str =
            string.gsub(
            str,
            "([^%w %-%_%.%~])",
            function(c)
                return string.format("%%%02X", string.byte(c))
            end
        )
        str = string.gsub(str, " ", "+")
    end

    return str
end

M.handleURL = function(isVisual)
    if isVisual then
        local uri = fn.matchstr(fn.getline("."), [[[a-z]*:\/\/[^ >,;")]*]])
        local expand_word = fn.expand("<cword>")

        if uri ~= "" then
            print("open URL: " .. uri)
            api.nvim_command(string.format([[silent!exec '!%s "%s"']], "firefox", uri))
            return
        end

        if expand_word ~= "" then
            print("search keyword: " .. expand_word)
            api.nvim_command(
                string.format([[silent!exec '!%s "https://www.google.com/search?&q=%s"']], "firefox", expand_word)
            )
            return
        end
    end

    if #get_selection() > 0 then
        local selected_lines = get_selection()[1]

        print("search keyboard: " .. selected_lines)

        selected_lines = string.gsub(vim.fn.shellescape(urlEncode(selected_lines), "\\"), "'", "")

        api.nvim_command(
            string.format([[silent!exec '!%s "https://www.google.com/search?q=%s"']], "firefox", selected_lines)
        )
        return
    end
end

local isDiffOpen = 1

M.diffview = function()
    -- need plugin sindrets/diffview.nvim
    if isDiffOpen == 1 then
        api.nvim_command([[silent!exec 'DiffviewOpen']])
        isDiffOpen = 0
    else
        api.nvim_command([[silent!exec 'DiffviewClose']])
        isDiffOpen = 1
    end
end

M.zettel = function()
    -- [[
    -- cara menjalankan lua
    vim.cmd([[au BufReadPre * ++once lua require('config.session').start()]])
    -- ]]
end

return M
