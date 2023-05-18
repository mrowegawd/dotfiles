local fmt = string.format

local norg = {}

-----------------------------------------------------------------------
-- LINKABLE
-----------------------------------------------------------------------

--- Get a list of all norg files in current workspace. Returns { workspace_path, norg_files }
--- @return table
local function get_norg_files(neorg)
    local dirman = neorg.modules.get_module "core.dirman"

    if not dirman then
        ---@diagnostic disable-next-line: return-type-mismatch
        return nil
    end

    local current_workspace = dirman.get_current_workspace()

    local norg_files = dirman.get_norg_files(current_workspace[1])

    return { current_workspace[2], norg_files }
end

--- Creates links for a `file` specified by `bufnr`
--- @param bufnr number
--- @param file string | nil
--- @return table | nil
local function get_linkables(bufnr, file)
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

--- Generate links for telescope
--- @return table | nil
local function generate_links(neorg)
    local res = {}
    local dirman = neorg.modules.get_module "core.dirman"

    if not dirman then
        return nil
    end

    local files = get_norg_files(neorg)

    if not files[2] then
        return
    end

    for _, file in pairs(files[2]) do
        local full_path_file = files[1] .. "/" .. file
        -- local bufnr = dirman.get_file_bufnr(
        --     full_path_file
        -- )
        -- if not bufnr then
        --     return
        -- end

        -- Because we do not want file name to appear in a link to the same file
        local file_inserted = (function()
            if vim.api.nvim_get_current_buf() == full_path_file then
                return nil
            else
                return file
            end
        end)()

        local links =
            ---@diagnostic disable-next-line: undefined-global
            get_linkables(bufnr, file_inserted)

        ---@diagnostic disable-next-line: param-type-mismatch
        vim.list_extend(res, links)
    end

    return res
end

function norg.finder_linkable(neorg)
    local tb_rt = {}

    ---@diagnostic disable-next-line: param-type-mismatch
    for _, tb in ipairs(generate_links(neorg)) do
        table.insert(tb_rt, tb.file .. " | " .. tb.display)
    end
    return tb_rt
end

-----------------------------------------------------------------------
-- BROKEN LINKS
-----------------------------------------------------------------------

local escape_chars = function(x)
    x = x or ""
    return (
        x:gsub("%%", "%%%%")
            :gsub("^%^", "%%^")
            :gsub("%$$", "%%$")
            :gsub("%(", "%%(")
            :gsub("%)", "%%)")
            :gsub("%.", "%%.")
            :gsub("%[", "%%[")
            :gsub("%]", "%%]")
            :gsub("%*", "%%*")
            :gsub("%+", "%%+")
            :gsub("%-", "%%-")
            :gsub("%?", "%%?")
    )
end

local function set_command()
    local command = {
        "rg",
        "tools",
        -- as.absolute_path(vim.api.nvim_get_current_buf()),
        "/home/mr00x/Dropbox/neorg/index.norg",
    }
    return vim.tbl_flatten(command)
end

function norg.finder_broken_links(all)
    if all then
        return print "get all broken links"
    end

    return table.concat(set_command(), " ")
end

return norg
