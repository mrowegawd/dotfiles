local util = require("internal._utils")
local qf = {}

qf.keep = function()
    if not util.is_qf_window() then
        return
    end

    local ans_keep = vim.fn.input("Search > ")

    util.clear_prompt()

    if #ans_keep == 0 then
        return
    end

    local qf_newentries = {}

    local getqf = vim.fn.getqflist()

    for i = 1, #getqf do
        if -- TODO: match regex sepertinya belum optimal..
            vim.api.nvim_buf_get_name(getqf[i].bufnr):match("[/]*" .. ans_keep .. ".*") then
            -- if bufname(d['bufnr']) !~ a:pat && d['text'] !~ a:pat
            table.insert(qf_newentries, getqf[i])
        end
    end

    vim.fn.setqflist({}, " ", {title = ans_keep, id = "r", items = qf_newentries})
end

return qf
