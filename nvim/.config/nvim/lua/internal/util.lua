local fn = vim.fn
local api = vim.api
local option = api.nvim_buf_get_option

local clear_prompt = function()
    api.nvim_command("normal :esc<CR>")
end

_G.Util = {}

Util.is_qf_window = function()
    local filetype = api.nvim_buf_get_option(0, "filetype")

    if filetype ~= "qf" then
        return false
    end

    print("[!] you still inside quickfix morron..~_~")
    return true
end

Util.clear_prompt_with_print = function(msg)
    clear_prompt()
    print(msg)
end

Util.buf_only = function()
    local del_non_modifiable = vim.g.bufonly_delete_non_modifiable or false

    local cur = api.nvim_get_current_buf()

    local deleted, modified = 0, 0

    for _, n in ipairs(api.nvim_list_bufs()) do
        -- If the iter buffer is modified one, then don't do anything
        if option(n, "modified") then
            -- iter is not equal to current buffer
            -- iter is modifiable or del_non_modifiable == true
            -- `modifiable` check is needed as it will prevent closing file tree ie. NERD_tree
            modified = modified + 1
        elseif n ~= cur and (option(n, "modifiable") or del_non_modifiable) then
            api.nvim_buf_delete(n, {})
            deleted = deleted + 1
        end
    end

    print("BufOnly: " .. deleted .. " deleted buffer(s), " .. modified .. " modified buffer(s)")
end

local SETFoldingAll = 1
local SETFolding = 1

Util.fold_toggle = function(key)
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
Util.copenloc_toggle = function(prefix)
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

Util.handleURL = function(isVisual)
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

Util.diffview = function()
    -- need plugin sindrets/diffview.nvim
    if isDiffOpen == 1 then
        api.nvim_command([[silent!exec 'DiffviewOpen']])
        isDiffOpen = 0
    else
        api.nvim_command([[silent!exec 'DiffviewClose']])
        isDiffOpen = 1
    end
end

return Util
