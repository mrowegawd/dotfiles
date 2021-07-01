local function check_back_space()
    local col = vim.fn.col(".") - 1
    if col == 0 or vim.fn.getline("."):sub(col, col):match("%s") then
        return true
    else
        return false
    end
end

local t = function(str)
    return vim.api.nvim_replace_termcodes(str, true, true, true)
end

--- move to prev/next item in completion menuone
--- jump to prev/next snippet's placeholder
_G.tab_complete = function()
    if vim.fn.pumvisible() == 1 then
        return t "<C-n>"
    elseif vim.fn.call("vsnip#available", {1}) == 1 then
        return t "<Plug>(vsnip-expand-or-jump)"
    elseif check_back_space() then
        return t "<Tab>"
    else
        return vim.fn["compe#complete"]()
    end
end

_G.s_tab_complete = function()
    if vim.fn.pumvisible() == 1 then
        return t "<C-p>"
    elseif vim.fn.call("vsnip#jumpable", {-1}) == 1 then
        return t "<Plug>(vsnip-jump-prev)"
    else
        return t "<S-Tab>"
    end
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

-- taken from: https://forum.zettelkasten.de/discussion/875/vim-users-how-did-you-set-up-vim-for-zettelkasten
_G.nZettel = function(name)
    name = name or "todo"

    local zettel_path = os.getenv("HOME") .. "/MrKampang/vimwiki/daily/"
    return zettel_path
end

-- vim.cmd [[command! -range -nargs=* Nzettel call v:lua.nZettel(<f-args>)]]
-- vim.cmd [[command! -nargs=1 Keep :execute ":" nZettel() . strftime("%Y%m%d%H%M") . " <args>.md"]]
vim.cmd [[command! -nargs=1 NewZettel :execute ":e" v:lua.nZettel() . strftime("%Y%m%d%H%M") . " <args>.md"]]
