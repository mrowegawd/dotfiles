local isDiffOpen = 1

local diffview = function()
    -- need plugin sindrets/diffview.nvim
    if isDiffOpen == 1 then
        vim.api.nvim_command([[silent!exec 'DiffviewOpen']])
        isDiffOpen = 0
    else
        vim.api.nvim_command([[silent!exec 'DiffviewClose']])
        isDiffOpen = 1
    end
end

return {
    diffview = diffview
}
