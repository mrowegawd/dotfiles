local telescope = require("telescope")
local conf = require("telescope._extensions.conf")
local util = require("internal.util")

local function removeDuplicates(arr)
    local newArray = {}
    local checkerTbl = {}
    -- TODO: use async? :QUESTION:
    for _, element in ipairs(arr) do
        -- [[if there is not yet a value at the index of element, then it will
        -- be nil, which will operate like false in an if statement
        -- ]]
        if not checkerTbl[element] then
            checkerTbl[element] = true
            table.insert(newArray, element)
        end
    end
    return newArray
end

-- TODO: create telescope zettel :DONE:
local grepzettel = function(opts)
    if util.is_qf_window() then
        return
    end

    local path = {}

    local _qf = vim.fn.getqflist()

    -- the table 'path' still contains duplicate elements
    for i = 1, #_qf do
        table.insert(path, vim.fn.bufname(_qf[i].bufnr))
    end

    if #path == 0 then
        return
    end

    opts =
        {
        vimgrep_arguments = conf.custom_vimgrep_arguments,
        shorten_path = true,
        search_dirs = removeDuplicates(path), -- much better, unique path
        prompt_title = "Find Zettel"
    } or {}

    require("telescope.builtin").live_grep(opts)
end

return telescope.register_extension {exports = {grepzettel = grepzettel}}
