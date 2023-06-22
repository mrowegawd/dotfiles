local fmt = string.format

local norg = {}

local function __get_check_dirman(neorg)
    local dirman = neorg.modules.get_module "core.dirman"

    if not dirman then
        ---@diagnostic disable-next-line: return-type-mismatch
        return nil
    end
    return dirman
end

local function __get_norg_files(dirman)
    local current_workspace = dirman.get_current_workspace()
    local norg_files = dirman.get_norg_files(current_workspace[1])

    return { current_workspace[2], norg_files }
end

local function __get_linkables(file, bufnr)
    bufnr = bufnr or 0

    local ret = {}

    local lines

    if file then
        lines = vim.fn.readfile(file)
        file = file:gsub(".norg", "")
    else
        lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, true)
    end

    file = string.gsub(
        ---@diagnostic disable-next-line: param-type-mismatch
        file,
        fmt("%s/Dropbox/neorg/", os.getenv "HOME"),
        ""
    )

    -- Loop setiap line text pada file, lalu match sesuai kebutuhan kita
    for i, line in ipairs(lines) do
        local heading = { line:match "^%s*(%*+%s+(.+))$" }
        if not vim.tbl_isempty(heading) then
            table.insert(ret, {
                line = i,
                linkable = heading[2],
                display = heading[1],
                file = file,
            })
        end

        local marker_or_drawer = { line:match "^%s*(%|%|?%s+(.+))$" }
        if not vim.tbl_isempty(marker_or_drawer) then
            table.insert(ret, {
                line = i,
                linkable = marker_or_drawer[2],
                display = marker_or_drawer[1],
                file = file,
            })
        end
    end

    return ret
end

local function __generate_links(files)
    if not files[2] then
        return
    end

    local res = {}

    for _, fname in pairs(files[2]) do
        local full_fpath = files[1] .. "/" .. fname

        -- Because we do not want file name to appear in a link to the same file
        local file_inserted = (function()
            if vim.api.nvim_get_current_buf() == full_fpath then
                return nil
            else
                return fname
            end
        end)()

        ---@diagnostic disable-next-line: param-type-mismatch
        vim.list_extend(res, __get_linkables(file_inserted, _))
    end

    return res
end

--  ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
--  ┃                         LINKABLE                         ┃
--  ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

function norg.finder_linkableGlobal(neorg)
    local tbl_files = __get_norg_files(__get_check_dirman(neorg))

    local tb_rt = {}

    ---@diagnostic disable-next-line: param-type-mismatch
    for _, tb in ipairs(__generate_links(tbl_files)) do
        table.insert(tb_rt, tb.file .. " | " .. tb.display)
    end
    return tb_rt
end

function norg.finder_linkable(neorg)
    local res = {}
    local dirman = neorg.modules.get_module "core.dirman"

    if not dirman then
        return nil
    end

    local file = vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf())

    local lines
    if file then
        lines = vim.fn.readfile(file)
        file = file:gsub(".norg", "")
    end

    file = string.gsub(file, fmt("%s/Dropbox/neorg/", os.getenv "HOME"), "")

    for i, line in pairs(lines) do
        local title_str_match = { line:match "[%*].*$" } -- return tbl match

        for _, ln in pairs(title_str_match) do
            -- local sf = ln:match [[.*:.*$]]
            table.insert(res, i .. ": " .. file .. " | " .. ln)
        end
    end

    return res
end

function norg.get_check_linkdir(neorg)
    -- TODO: check link broken di norg
    -- check jika ada broken link di local dan global
    -- output masukkan ke quickfix

    local mod_hop = neorg.modules.get_module "core.dirman.utils"
    local expanded_link_text = mod_hop.expand_path "$/mode"

    if expanded_link_text ~= vim.fn.expand "%:p" then
        print "no"
        -- We are dealing with a foreign file
        -- buf_pointer = vim.uri_to_bufnr("file://" .. expanded_link_text)
    end

    print(vim.fn.expand "%:p")

    -- if not parsed_link_information.link_type then
    --     return {
    --         type = "buffer",
    --         original_title = nil,
    --         node = nil,
    --         buffer = buf_pointer,
    --     }
    -- end

    -- local parsed_link = mod_hop.parse_link(mod_hop.extract_link_node())
    -- vim.notify(vim.inspect(parsed_link))

    -- module.required["core.dirman.utils"].expand_path(
    --     parsed_link_information.link_file_text
    -- )

    -- vim.inspect(mod_hop.expand_path "$/mode")
    print(vim.inspect(mod_hop.expand_path "$/mode"))

    -- vim.inspect(mod_hop.expand_path "$/mode")
    -- print "yee"

    -- local jj = {
    --     link_description = "index_game_hacking",
    --     link_file_text = "$/learning/index_game_hacking",
    -- }
end

--  ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
--  ┃                       SITELINKABLE                       ┃
--  ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

function norg.finder_sitelinkable(neorg)
    local res = {}
    local dirman = neorg.modules.get_module "core.dirman"

    if not dirman then
        return nil
    end

    local file = vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf())

    local lines
    if file then
        lines = vim.fn.readfile(file)
        file = file:gsub(".norg", "")
    end

    file = string.gsub(file, fmt("%s/Dropbox/neorg/", os.getenv "HOME"), "")

    for i, line in pairs(lines) do
        local http_str_match = { line:match [[.*{http.*$]] } -- return tbl match

        for _, ln in pairs(http_str_match) do
            local sf = ln:match [[.*:.*$]]
            if sf ~= nil then
                table.insert(res, i .. ": " .. file .. " | " .. sf)
            end
        end
    end

    return res
end

--  ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
--  ┃                       BROKEN LINKS                       ┃
--  ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

-- local escape_chars = function(x)
--     x = x or ""
--     return (
--         x:gsub("%%", "%%%%")
--             :gsub("^%^", "%%^")
--             :gsub("%$$", "%%$")
--             :gsub("%(", "%%(")
--             :gsub("%)", "%%)")
--             :gsub("%.", "%%.")
--             :gsub("%[", "%%[")
--             :gsub("%]", "%%]")
--             :gsub("%*", "%%*")
--             :gsub("%+", "%%+")
--             :gsub("%-", "%%-")
--             :gsub("%?", "%%?")
--     )
-- end
--
-- local function set_command()
--     local command = {
--         "rg",
--         "tools",
--         -- as.absolute_path(vim.api.nvim_get_current_buf()),
--     }
--     return vim.tbl_flatten(command)
-- end
--
-- function norg.finder_broken_links(all)
--     if all then
--         return print "get all broken links"
--     end
--
--     return table.concat(set_command(), " ")
-- end

return norg
