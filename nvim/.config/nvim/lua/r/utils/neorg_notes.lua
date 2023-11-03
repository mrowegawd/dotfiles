local fmt, cmd, L = string.format, vim.cmd, vim.log.levels

local M = {}

function M.EditOrgTodo()
  local org_todos = { "inbox", "refile" }
  local org_todo_path = require("r.config").path.wiki_path .. "/orgmode/gtd/"

  vim.ui.select(org_todos, { prompt = "Edit OrgTODO's> " }, function(choice)
    if choice == nil then
      return
    end

    if not require("r.utils").file.exists(org_todo_path .. choice .. ".org") then
      return vim.notify("Cant find todo path: " .. org_todo_path .. choice .. ".org", L.WARN, { title = "Todo info" })
    end
    cmd(":edit " .. org_todo_path .. choice .. ".org")
  end)
end

function M.convert_norg_to_markdown()
  local fname = vim.fn.expand "%:t:r"
  local pname = vim.fn.expand "%:p:h"

  local msg_cmd = "Neorg export to-file " .. pname .. "/" .. fname .. ".md"

  vim.cmd(msg_cmd)
end

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

function M.finder_linkableGlobal(neorg)
  local tbl_files = __get_norg_files(__get_check_dirman(neorg))

  local tb_rt = {}

  ---@diagnostic disable-next-line: param-type-mismatch
  for _, tb in ipairs(__generate_links(tbl_files)) do
    table.insert(tb_rt, tb.file .. " | " .. tb.display)
  end
  return tb_rt
end

function M.finder_linkable(neorg)
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

function M.get_check_linkdir(neorg)
  -- TODO: check link broken di norg
  -- check jika ada broken link di local dan global
  -- output masukkan ke quickfix

  -- local mod_hop = neorg.modules.get_module "core.dirman.utils"
  -- local expanded_link_text = mod_hop.expand_path "$/"
  --
  -- if expanded_link_text ~= vim.fn.expand "%:p" then
  --     print "no"
  --     -- We are dealing with a foreign file
  --     -- buf_pointer = vim.uri_to_bufnr("file://" .. expanded_link_text)
  -- end
  --
  -- print(expanded_link_text)

  local module = neorg.modules.get_module "core.esupports.hop"

  -- local jj = module.parse_link(module.extract_link_node())
  -- local mm = module.locate_link_target(jj)
  local jj = module.locate_anchor_declaration_target(module.extract_link_node())

  print(vim.inspect(jj))
  -- print(vim.inspect(mm))

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
  -- print(vim.inspect(mod_hop.expand_path "$/mode"))
end

--  ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
--  ┃                       SITELINKABLE                       ┃
--  ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

function M.finder_sitelinkable(neorg)
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

  local res = {}

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

function M.testing()
  local neorg = require "neorg"
  local neorg_core = require "neorg.core"
  local utils = neorg_core.utils
  local lib = neorg_core.lib

  local dirman = neorg.modules.get_module "core.dirman"
  if not dirman then
    print "not found"
    return
  end

  -- local module = neorg.modules.get_module "core.summary"
  local ts = neorg.modules.get_module "core.integrations.treesitter"

  local heading_query

  local get_first_heading_title = function(bufnr)
    local document_root = ts.get_document_root(bufnr)
    if not heading_query then
      -- allow second level headings, just in case
      local heading_query_string = [[
                         [
                             (heading1
                                 title: (paragraph_segment) @next-segment
                             )
                             (heading2
                                 title: (paragraph_segment) @next-segment
                             )
                         ]
                     ]]
      heading_query = utils.ts_parse_query("norg", heading_query_string)
    end
    -- search up to 20 lines (a doc could potentially have metadata without metadata.title)
    local _, heading = heading_query:iter_captures(document_root, bufnr)()
    if not heading then
      return nil
    end
    local start_line, _ = heading:start()
    local lines = vim.api.nvim_buf_get_lines(bufnr, start_line, start_line + 1, false)
    if #lines > 0 then
      local title = lines[1]:gsub("^%s*%*+%s*", "") -- strip out '*' prefix (handle '* title', ' **title', etc)
      if title ~= "" then -- exclude an empty heading like `*` (although the query should have excluded)
        return title
      end
    end
  end

  local categories = vim.defaulttable()
  local ws_root = dirman.get_current_workspace()[2]
  utils.read_files(dirman.get_norg_files(dirman.get_current_workspace()[1]) or {}, function(bufnr, filename)
    local metadata = ts.get_document_metadata(bufnr)

    if not metadata then
      metadata = {}
    end

    local norgname = filename:match "(.+)%.norg$" -- strip extension for link destinations
    if not norgname then
      norgname = filename
    end
    norgname = string.sub(norgname, string.len(ws_root) + 1)

    -- normalise categories into a list. Could be vim.NIL, a number, a string or a list ...
    if not metadata.categories or metadata.categories == vim.NIL then
      metadata.categories = { "Uncategorised" }
    elseif not vim.tbl_islist(metadata.categories) then
      metadata.categories = { tostring(metadata.categories) }
    end
    for _, category in ipairs(metadata.categories) do
      if not metadata.title then
        metadata.title = get_first_heading_title(bufnr)
        if not metadata.title then
          metadata.title = vim.fs.basename(norgname)
        end
      end
      if metadata.description == vim.NIL then
        metadata.description = nil
      end
      table.insert(categories[lib.title(category)], {
        title = tostring(metadata.title),
        norgname = norgname,
        description = metadata.description,
      })
    end
  end)

  return categories
end

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

return M
