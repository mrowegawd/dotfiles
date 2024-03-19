local Util = require "r.utils"

local scan = require "plenary.scandir"
local fmt, cmd = string.format, vim.cmd
local neorg = require "neorg"

---@class r.utils.neorg
local M = {}

local separator = function()
  return "/"
end

local function remove_trailing(path)
  local p, _ = path:gsub(separator() .. "$", "")
  return p
end

function M.basename(path)
  path = remove_trailing(path)
  local i = path:match("^.*()" .. separator())
  if not i then
    return path
  end
  return path:sub(i + 1, #path)
end

function M.open_orgagenda_paths()
  local plugin = require("lazy.core.config").plugins["orgmode"]
  local Plugin = require "lazy.core.plugin"
  local opts_plugin = Plugin.values(plugin, "opts", false)

  local org_backup = {}
  local org_todos = {}
  for _, x in pairs(opts_plugin.org_agenda_files) do
    local path
    if string.match(x, [[%*%*]], 1) then
      path = string.gsub(x, [[%/%*%*/%*$]], "")
    else
      path = string.gsub(x, [[%/%*$]], "")
    end
    -- local path = string.gsub(x, [[%/%*$]], "")
    local dirs = scan.scan_dir(path)
    for _, file_path in pairs(dirs) do
      if not string.match(file_path, "org_archive") then
        local check_org_ext = string.match(M.basename(file_path), "%.org$")
        if check_org_ext then
          local basename_file = string.gsub(M.basename(file_path), ".org$", "")
          table.insert(org_backup, { full_path = file_path, path = path, basename_file = basename_file })
          table.insert(org_todos, basename_file)
        end
      end
    end
  end

  vim.ui.select(
    org_todos,
    { prompt = require("r.config").icons.misc.pencil .. " Open OrgTodos ", kind = "pojokan" },
    function(choice)
      if choice == nil then
        return
      end
      for _, x in pairs(org_backup) do
        if choice == x.basename_file then
          if Util.file.exists(x.full_path) then
            return cmd(":edit " .. x.full_path)
          else
            return Util.warn("Path not exists: " .. x.full_path, { title = "orgmode" })
          end
        end
      end
    end
  )
end

function M.convert_norg_to_markdown()
  local fname = vim.fn.expand "%:t:r"
  local pname = vim.fn.expand "%:p:h"
  local path_mdfIle = pname .. "/" .. fname .. ".md"

  local msg_cmd = "Neorg export to-file " .. path_mdfIle
  vim.cmd(msg_cmd)

  local Job = require "plenary.job"
  local data = {}
  -- sed 's/\[\(.*\)\](#\(.*\))/[\2](\1)/' -i index.md
  local scc = Job:new({ command = "sed", args = { [[s/\[\(.*\)\](#\(.*\)md)/[\2](\1)/]], "-i", path_mdfIle } }):sync()
  for i, _ in ipairs(scc) do
    assert(scc[i] == data[i])
  end

  local ls = Job:new({ command = "sed", args = { [[s/\[\(.*\)\](#\(.*\))/[#\2]/]], "-i", path_mdfIle } }):sync()
  for i, _ in ipairs(ls) do
    assert(ls[i] == data[i])
  end

  local cc = Job:new({ command = "sed", args = { [[s/\[\(.*\)\](\$.\(.*\))/[[\2\]\]/]], "-i", path_mdfIle } }):sync()
  for i, _ in ipairs(cc) do
    assert(cc[i] == data[i])
  end

  -- \[.*?\]\(.*?)(#)(.*?\))
  local dcl = Job:new({ command = "sed", args = { [[s/\[\[\(.*\)\(#\)\(.*\)\]\]/\[\[\1|\3\]\]/]], "-i", path_mdfIle } })
    :sync()
  for i, _ in ipairs(dcl) do
    assert(dcl[i] == data[i])
  end
end

local function __get_check_dirman()
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

function M.finder_linkableGlobal()
  local tbl_files = __get_norg_files(__get_check_dirman())

  local tb_rt = {}

  ---@diagnostic disable-next-line: param-type-mismatch
  for _, tb in ipairs(__generate_links(tbl_files)) do
    table.insert(tb_rt, tb.file .. " | " .. tb.display)
  end
  return tb_rt
end

function M.finder_linkable()
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

function M.check_broken_links()
  -- local dirman_utils = neorg.modules.get_module "core.dirman.utils"
  -- -- 1. regex/grep all links on curbuf
  -- local scripts =
  --   vim.api.nvim_exec2(fmt([[!rg ':[a-z|$](.*):' %s -N | cut -d: -f2 ]], vim.fn.expand "%:p"), { output = true })

  -- -- local brokenbuf_ids = {}
  -- if scripts.output ~= nil then
  --   local res = vim.split(scripts.output, "\n")
  --   for index = 2, #res do
  --     local item = res[index]
  --     if #item > 0 then
  --       -- 2. validate the links before collect them
  --       local expanded_link_text = dirman_utils.expand_path(item)
  --       local buf_pointer = vim.uri_to_bufnr("file://" .. expanded_link_text)
  --       -- print(buf_pointer)
  --       if not vim.api.nvim_buf_is_valid(buf_pointer) then
  --         print(buf_pointer)
  --         -- table.insert(brokenbuf_ids, buf_pointer)
  --       end
  --     end
  --   end
  -- end
  -- print(vim.inspect(brokenbuf_ids))

  -- 2. validate the links before sending to qf
  local module = neorg.modules.get_module "core.esupports.hop"
  -- local ts_utils = neorg.modules.get_module("core.integrations.treesitter").get_ts_utils()
  -- local current_node = ts_utils.get_node_at_cursor()
  -- local found_node = neorg.modules
  --   .get_module("core.integrations.treesitter")
  --   .find_parent(current_node, { "link", "anchor_declaration", "anchor_definition" })
  -- print(found_node:type())

  -- `link_node_at_cursor` this just an example,
  local link_node_at_cursor = module.extract_link_node()
  print(vim.inspect(link_node_at_cursor))
  -- local parse_link = module.parse_link(link_node_at_cursor)
  -- print(vim.inspect(parse_link))

  -- local located_link_information = module.locate_link_target(parse_link)
  -- print(vim.inspect(located_link_information))
  -- print(vim.api.nvim_buf_is_valid(located_link_information.buffer))
  -- if vim.api.nvim_buf_is_valid(located_link_information.buffer) then
  --   print "this link is broken"
  --   -- collect the broken links
  -- end
end

--  ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
--  ┃                       SITELINKABLE                       ┃
--  ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

function M.finder_sitelinkable()
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

function M.find_by_categories()
  local scripts = vim.api.nvim_exec2(
    fmt(
      [[!find %s -type f -exec sed -n '/categories:/s/categories: \(.*\)/\1/p' {} \; ]],
      require("r.config").path.wiki_path
    ),
    { output = true }
  )
  local categories = {}
  local exile = {}
  if scripts.output ~= nil then
    local res = vim.split(scripts.output, "\n")
    for index = 2, #res do
      local item = res[index]
      if #item > 0 then
        -- Output dari item, ex: "git index go" bertype string
        -- harus di buat split menjadi table lalu dimasukkan ke table categories
        for token in string.gmatch(item, "[^%s]+") do
          if not exile[token] then
            exile[token] = true
            table.insert(categories, token)
          end
        end
      end
    end
  end
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

return M
