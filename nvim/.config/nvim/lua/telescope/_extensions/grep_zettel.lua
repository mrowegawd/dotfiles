local telescope = require("telescope")
local conf = require("telescope._extensions._configs")

-- this code not well btw..
-- local api = vim.api

-- local function is_qf_window()
--     local filetype = api.nvim_buf_get_option(0, "filetype")

--     if filetype ~= "qf" then
--         print("[!] Current window not in the quickfix window..")
--         return false
--     end

--     return true
-- end

local function removeDuplicates(arr)
    local newArray = {}
    local checkerTbl = {}
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
local grep_zettel = function(opts)
    -- if is_qf_window() == false then
    --     return
    -- end

    local path = {}

    local _qf = vim.fn.getqflist()

    -- The able 'path' still contains duplicate elements
    for i = 1, #_qf do
        table.insert(path, vim.fn.bufname(_qf[i].bufnr))
    end

    if #path == 0 then
        return
    end

    -- TODO: use async? maybe coroutine? :QUESTION:
    opts =
        {
        vimgrep_arguments = conf.custom_vimgrep_arguments,
        shorten_path = true,
        search_dirs = removeDuplicates(path), -- much better, unique path
        prompt_title = "Find Zettel"
    } or {}

    require("telescope.builtin").live_grep(opts)
end

return telescope.register_extension {exports = {grep_zettel = grep_zettel}}
