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

return {
    GalaxyBG = GalaxyBG,
    GalaxyHi = GalaxyHi,
    buffer_not_empty = buffer_not_empty
}
