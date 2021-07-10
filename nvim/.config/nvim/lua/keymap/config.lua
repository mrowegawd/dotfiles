local t = function(str)
    return vim.api.nvim_replace_termcodes(str, true, true, true)
end

_G.enhance_jk_move = function(key)
    if packer_plugins["accelerated-jk"] and not packer_plugins["accelerated-jk"].loaded then
        vim.cmd [[packadd accelerated-jk]]
    end
    local map = key == "j" and "<Plug>(accelerated_jk_gj)" or "<Plug>(accelerated_jk_gk)"
    return t(map)
end

_G.enhance_ft_move = function(key)
    if not packer_plugins["vim-eft"].loaded then
        vim.cmd [[packadd vim-eft]]
    end
    local map = {
        f = "<Plug>(eft-f)",
        F = "<Plug>(eft-F)",
        [";"] = "<Plug>(eft-repeat)"
    }
    return t(map[key])
end

_G.enhance_nice_block = function(key)
    if not packer_plugins["vim-niceblock"].loaded then
        vim.cmd [[packadd vim-niceblock]]
    end
    local map = {
        I = "<Plug>(niceblock-I)",
        ["gI"] = "<Plug>(niceblock-gI)",
        A = "<Plug>(niceblock-A)"
    }
    return t(map[key])
end

_G.FoldText = function()
    local padding =
        vim.wo.fdc +
        vim.fn.max(
            {
                vim.wo.numberwidth,
                vim.fn.strlen(vim.v.foldstart - vim.fn.line("w0")),
                vim.fn.strlen(vim.fn.line("w$") - vim.v.foldstart),
                vim.fn.strlen(vim.v.foldstart)
            }
        )
    -- expand tabs
    local t_start = vim.fn.substitute(vim.fn.getline(vim.v.foldstart), "\t", string.rep(" ", vim.bo.tabstop), "g")
    local t_end =
        vim.fn.substitute(
        vim.fn.substitute(vim.fn.getline(vim.v.foldend), "\t", string.rep(" ", vim.bo.tabstop), "g"),
        "^\\s*",
        "",
        "g"
    )

    local info = " (" .. (vim.v.foldend - vim.v.foldstart) .. ")"
    local infolen = vim.fn.strlen(vim.fn.substitute(info, ".", "x", "g"))
    local width = vim.fn.winwidth(0) - padding - infolen

    local separator = " … "
    local separatorlen = vim.fn.strlen(vim.fn.substitute(separator, ".", "x", "g"))
    local start =
        vim.fn.strpart(t_start, 0, width - vim.fn.strlen(vim.fn.substitute(t_end, ".", "x", "g")) - separatorlen)
    local text = start .. " … " .. t_end
    return text .. string.rep(" ", width - vim.fn.strlen(vim.fn.substitute(text, ".", "x", "g")) - 2) .. info
end
