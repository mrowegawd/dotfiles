local fmt = string.format
-- local neorg = require "neorg"

---@class r.utils.neorg
local M = {}

local insert_tags = {}

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
    fmt([[!find %s -type f -exec sed -n '/categories:/s/categories: \(.*\)/\1/p' {} \; ]], RUtils.config.path.wiki_path),
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

-- ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
-- ┃                        OBSIDIAN                         ┃
-- ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛
--

local AsyncExecutor = require("obsidian.async").AsyncExecutor
local channel = require("plenary.async.control").channel
local search = require "obsidian.search"
local async = require "plenary.async"
local Path = require "obsidian.path"
local log = require "obsidian.log"
-- local path = require "fzf-lua.path"
local Note = require "obsidian.note"

local builtin = require "fzf-lua.previewer.builtin"
local tags_previewer = builtin.buffer_or_file:extend()

local TagCharsOptional = "[A-Za-z0-9_/-]*"
local TagCharsRequired = "[A-Za-z]+[A-Za-z0-9_/-]*[A-Za-z0-9]+" -- assumes tag is at least 2 chars
-- local Tag = "#[A-Za-z]+[A-Za-z0-9_/-]*[A-Za-z0-9]+"

local iter = function(iterable)
  if type(iterable) == "function" then
    return iterable
  elseif type(iterable) == "string" then
    local i = 1
    local n = string.len(iterable)

    return function()
      if i > n then
        return nil
      else
        local c = string.sub(iterable, i, i)
        i = i + 1
        return c
      end
    end
  elseif type(iterable) == "table" then
    if vim.tbl_isempty(iterable) then
      return function()
        return nil
      end
    elseif vim.islist(iterable) then
      local i = 1
      local n = #iterable

      return function()
        if i > n then
          return nil
        else
          local x = iterable[i]
          i = i + 1
          return x
        end
      end
    else
      return iter(vim.tbl_keys(iterable))
    end
  else
    error("unexpected type '" .. type(iterable) .. "'")
  end
end

local rstrip_whitespace = function(str)
  str = string.gsub(str, "%s+$", "")
  return str
end

local lstrip_whitespace = function(str, limit)
  if limit ~= nil then
    local num_found = 0
    while num_found < limit do
      str = string.gsub(str, "^%s", "")
      num_found = num_found + 1
    end
  else
    str = string.gsub(str, "^%s+", "")
  end
  return str
end

local strip_whitespace = function(str)
  return rstrip_whitespace(lstrip_whitespace(str))
end

local string_contains = function(str, substr)
  local i = string.find(str, substr, 1, true)
  return i ~= nil
end

local tbl_contains = function(table, val)
  for i = 1, #table do
    if table[i] == val then
      return true
    end
  end
  return false
end

local tbl_unique = function(table)
  local out = {}
  for _, val in pairs(table) do
    if not tbl_contains(out, val) then
      out[#out + 1] = val
    end
  end
  return out
end

local function find_tags_async(term, callback, opts)
  opts = opts or {}

  ---@type string[]
  local terms
  if type(term) == "string" then
    terms = { term }
  else
    terms = term
  end

  -- for i, t in ipairs(terms) do
  --   if vim.startswith(t, "#") then
  --     terms[i] = string.sub(t, 2)
  --   end
  -- end

  terms = tbl_unique(terms)

  local path_to_tag_loc = {}

  local path_to_note = {}

  local path_to_code_blocks = {}
  -- Keeps track of the order of the paths.
  ---@type table<string, integer>
  local path_order = {}

  local num_paths = 0
  local err_count = 0
  local first_err = nil
  local first_err_path = nil

  local executor = AsyncExecutor.new()

  local add_match = function(tag, path, note, lnum, text, col_start, col_end)
    if not path_to_tag_loc[path] then
      path_to_tag_loc[path] = {}
    end
    path_to_tag_loc[path][#path_to_tag_loc[path] + 1] = {
      tag = tag,
      path = path,
      note = note,
      line = lnum,
      text = text,
      tag_start = col_start,
      tag_end = col_end,
    }
  end

  local load_note = function(path)
    local note, contents = Note.from_file_with_contents_async(path)
    return { note, search.find_code_blocks(contents) }
  end

  local on_match = function(match_data)
    local path = Path.new(match_data.path.text):resolve { strict = true }

    if path_order[path] == nil then
      num_paths = num_paths + 1
      path_order[path] = num_paths
    end

    executor:submit(function()
      -- Load note.
      local note = path_to_note[path]
      local code_blocks = path_to_code_blocks[path]
      if not note or not code_blocks then
        local ok, res = pcall(load_note, path)
        if ok then
          note, code_blocks = unpack(res)
          path_to_note[path] = note
          path_to_code_blocks[path] = code_blocks
        else
          err_count = err_count + 1
          if first_err == nil then
            first_err = res
            first_err_path = path
          end
          return
        end
      end

      -- check if the match was inside a code block.
      for block in iter(code_blocks) do
        if block[1] <= match_data.line_number and match_data.line_number <= block[2] then
          return
        end
      end

      local line = strip_whitespace(match_data.lines.text)
      local n_matches = 0

      -- check for tag in the wild of the form '#{tag}'
      for match in iter(search.find_tags(line)) do
        local m_start, m_end, _ = unpack(match)
        local tag = string.sub(line, m_start + 1, m_end)
        if string.match(tag, "^" .. TagCharsRequired .. "$") then
          add_match(tag, path, note, match_data.line_number, line, m_start, m_end)
        end
      end

      -- check for tags in frontmatter
      if n_matches == 0 and note.tags ~= nil and (vim.startswith(line, "tags:") or string.match(line, "%s*- ")) then
        for tag in iter(note.tags) do
          tag = tostring(tag)
          for _, t in ipairs(terms) do
            if string.len(t) == 0 or string_contains(tag, t) then
              add_match(tag, path, note, match_data.line_number, line)
            end
          end
        end
      end
    end)
  end

  local tx, rx = channel.oneshot()

  local search_terms = {}
  for t in iter(terms) do
    if string.len(t) > 0 then
      -- tag in the wild
      -- search_terms[#search_terms + 1] = "#" .. TagCharsOptional .. t .. TagCharsOptional
      -- frontmatter tag in multiline list
      search_terms[#search_terms + 1] = "\\s*- " .. TagCharsOptional .. t .. TagCharsOptional .. "$"
      -- frontmatter tag in inline list
      search_terms[#search_terms + 1] = "tags: .*" .. TagCharsOptional .. t .. TagCharsOptional
    else
      -- tag in the wild
      -- search_terms[#search_terms + 1] = "#" .. TagCharsRequired
      -- frontmatter tag in multiline list
      search_terms[#search_terms + 1] = "\\s*- " .. TagCharsRequired .. "$"
      -- frontmatter tag in inline list
      search_terms[#search_terms + 1] = "tags: .*" .. TagCharsRequired
    end
  end

  search.search_async(RUtils.config.path.wiki_path, search_terms, { ignore_case = true }, on_match, function(_)
    tx()
  end)

  async.run(function()
    rx()
    executor:join_async()

    local tags_list = {}

    -- Order by path.
    local paths = {}
    for path, idx in pairs(path_order) do
      paths[idx] = path
    end

    -- Gather results in path order.
    for _, path in ipairs(paths) do
      local tag_locs = path_to_tag_loc[path]
      -- print(vim.inspect(tag_locs))
      if tag_locs ~= nil then
        table.sort(tag_locs, function(a, b)
          return a.line < b.line
        end)
        for _, tag_loc in ipairs(tag_locs) do
          tags_list[#tags_list + 1] = tag_loc
        end
      end
    end

    -- Log any errors.
    if first_err ~= nil and first_err_path ~= nil then
      log.err(
        "%d error(s) occurred during search. First error from note at '%s':\n%s",
        err_count,
        first_err_path,
        first_err
      )
    end

    return tags_list
  end, callback)
end

local get_visual_selection = function(opts)
  opts = opts or {}
  -- Adapted from fzf-lua:
  -- https://github.com/ibhagwan/fzf-lua/blob/6ee73fdf2a79bbd74ec56d980262e29993b46f2b/lua/fzf-lua/utils.lua#L434-L466
  -- this will exit visual mode
  -- use 'gv' to reselect the text
  local _, csrow, cscol, cerow, cecol
  local mode = vim.fn.mode()
  if opts.strict and not vim.endswith(string.lower(mode), "v") then
    return
  end

  if mode == "v" or mode == "V" or mode == "" then
    -- if we are in visual mode use the live position
    _, csrow, cscol, _ = unpack(vim.fn.getpos ".")
    _, cerow, cecol, _ = unpack(vim.fn.getpos "v")
    if mode == "V" then
      -- visual line doesn't provide columns
      cscol, cecol = 0, 999
    end
    -- exit visual mode
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", true)
  else
    -- otherwise, use the last known visual position
    _, csrow, cscol, _ = unpack(vim.fn.getpos "'<")
    _, cerow, cecol, _ = unpack(vim.fn.getpos "'>")
  end

  -- Swap vars if needed
  if cerow < csrow then
    csrow, cerow = cerow, csrow
    cscol, cecol = cecol, cscol
  elseif cerow == csrow and cecol < cscol then
    cscol, cecol = cecol, cscol
  end

  local lines = vim.fn.getline(csrow, cerow)
  assert(type(lines) == "table")
  if vim.tbl_isempty(lines) then
    return
  end

  -- When the whole line is selected via visual line mode ("V"), cscol / cecol will be equal to "v:maxcol"
  -- for some odd reason. So change that to what they should be here. See ':h getpos' for more info.
  local maxcol = vim.api.nvim_get_vvar "maxcol"
  if cscol == maxcol then
    cscol = string.len(lines[1])
  end
  if cecol == maxcol then
    cecol = string.len(lines[#lines])
  end

  ---@type string
  local selection
  local n = #lines
  if n <= 0 then
    selection = ""
  elseif n == 1 then
    selection = string.sub(lines[1], cscol, cecol)
  elseif n == 2 then
    selection = string.sub(lines[1], cscol) .. "\n" .. string.sub(lines[n], 1, cecol)
  else
    selection = string.sub(lines[1], cscol)
      .. "\n"
      .. table.concat(lines, "\n", 2, n - 1)
      .. "\n"
      .. string.sub(lines[n], 1, cecol)
  end

  return {
    lines = lines,
    selection = selection,
    csrow = csrow,
    cscol = cscol,
    cerow = cerow,
    cecol = cecol,
  }
end

local cursor_tag = function(line, col)
  local current_line = line and line or vim.api.nvim_get_current_line()
  local _, cur_col = unpack(vim.api.nvim_win_get_cursor(0))
  cur_col = col or cur_col + 1 -- nvim_win_get_cursor returns 0-indexed column

  for match in iter(search.find_tags(current_line)) do
    local open, close, _ = unpack(match)
    if open <= cur_col and cur_col <= close then
      return string.sub(current_line, open + 1, close)
    end
  end

  return nil
end

local list_tags_async = function(term, callback)
  find_tags_async(term and term or "", function(tag_locations)
    local tags = {}
    for _, tag_loc in ipairs(tag_locations) do
      tags[tag_loc.tag] = true
    end
    callback(vim.tbl_keys(tags))
  end)
end

local picker = function(entries)
  local titles = {}
  local checkerTbl = {}
  for _, element in ipairs(entries) do
    if not checkerTbl[element] then
      checkerTbl[element.display] = element.col
      table.insert(titles, element.display)
    end
  end

  function tags_previewer:new(o, opts, fzf_win)
    tags_previewer.super.new(self, o, opts, fzf_win)
    setmetatable(self, tags_previewer)
    return self
  end

  function tags_previewer:parse_entry(entry_str)
    for _, x in pairs(entries) do
      if x.display == entry_str then
        return {
          path = x.filename,
          line = x.lnum,
          col = x.col,
        }
      end
    end
  end

  local format_prompt_strings = function()
    local msg = ""
    if #insert_tags > 0 then
      msg = "[" .. table.concat(insert_tags, ",") .. "]"
      msg = string.format("[Obsidian] Search by tag %s > ", msg)
    else
      msg = "[Obsidian] Search by tag > "
    end
    return msg
  end

  require("fzf-lua").fzf_exec(titles, {
    previewer = tags_previewer,
    prompt = format_prompt_strings(),
    fzf_opts = { ["--header"] = [[Ctrl-t: filter by tag | Ctrl-a: add tag | Ctrl-r: reload | Ctrl-g: search by regex]] },
    actions = {
      ["default"] = function(selected, _)
        local sel = selected[1]
        for _, x in pairs(entries) do
          if x.display == sel then
            vim.cmd("e " .. x.filename)
            vim.api.nvim_win_set_cursor(0, { x.lnum, 1 })
          end
        end
      end,

      ["ctrl-v"] = function(selected, _)
        local sel = selected[1]
        for _, x in pairs(entries) do
          if x.display == sel then
            vim.cmd("vsplit " .. x.filename)
            vim.api.nvim_win_set_cursor(0, { x.lnum, 1 })
            break
          end
        end
      end,

      ["ctrl-s"] = function(selected, _)
        local sel = selected[1]
        for _, x in pairs(entries) do
          if x.display == sel then
            vim.cmd("sp " .. x.filename)
            vim.api.nvim_win_set_cursor(0, { x.lnum, 1 })
            break
          end
        end
      end,

      ["ctrl-a"] = function(selected, _)
        local sel = selected[1]

        local sel_splits = vim.split(sel, "-")
        local sel_tag = string.gsub(sel_splits[#sel_splits], "%s", "") -- remove whitespaces

        -- local function removeDuplicate(tbl, element)
        --   for _, x in pairs(tbl) do
        --     if x == element then
        --       return true
        --     end
        --   end
        --   return false
        -- end

        for _, x in pairs(entries) do
          if x.tag_name == sel_tag then
            table.insert(insert_tags, x.tag_name)
            -- if #insert_tags == 0 then
            --   table.insert(insert_tags, x.tag_name)
            -- else
            --   for _, inserted_tag in pairs(insert_tags) do
            --     if x.tag_name == inserted_tag then
            --       break
            --     end
            --     table.insert(insert_tags, x.tag_name)
            --   end
            -- end
            break
          end
        end

        print("Add tag: " .. vim.inspect(insert_tags))

        require("fzf-lua").actions.resume()
      end,

      ["ctrl-r"] = function()
        insert_tags = {}
        -- print("Add tag: " .. vim.inspect(insert_tags))
        M.find_by_tags()
      end,

      ["ctrl-g"] = function(selected)
        if #selected > 1 then
          M.find_grep_by_all_regex_or_selected_tag(entries, selected)
        else
          M.find_grep_by_all_regex_or_selected_tag(entries, selected[1])
        end
      end,

      ["ctrl-t"] = function(selected, _)
        local sel = selected[1]

        local sel_splits = vim.split(sel, "-")
        local sel_tag = string.gsub(sel_splits[#sel_splits], "%s", "") -- remove whitespaces

        local tag
        for _, x in pairs(entries) do
          if x.tag_name == sel_tag then
            if #insert_tags > 0 then
              tag = insert_tags
            else
              tag = { x.tag_name }
            end
            M.find_by_tags { fargs = tag }
            break
          end
        end
      end,
    },
  })
end

function M.checkTbl(arrays, elements)
  for _, x in pairs(arrays) do
    if x.display == elements.display then
      return true
    end
  end
  return false
end

local function loop_entries(tags, tag_locations)
  local entries = {}
  for _, tag_loc in ipairs(tag_locations) do
    for _, tag in ipairs(tags) do
      if tag_loc.tag == tag or vim.startswith(tag_loc.tag, tag .. "/") then
        local display = string.format("%s [%s] %s", tag_loc.note:display_name(), tag_loc.line, tag_loc.text)

        local sel_splits = vim.split(display, "-")
        local sel_tag = string.gsub(sel_splits[#sel_splits], "%s", "") -- remove whitespaces

        local element_items = {
          value = { path = tag_loc.path, line = tag_loc.line, col = tag_loc.tag_start },
          display = display,
          ordinal = display,
          tag_name = sel_tag,
          filename = tostring(tag_loc.path),
          lnum = tag_loc.line,
          col = tag_loc.tag_start,
        }

        if not M.checkTbl(entries, element_items) then
          table.insert(entries, element_items)
        end
      end
    end
  end
  return entries
end

function M.find_grep_by_all_regex_or_selected_tag(entries, selected)
  local rg_opts = [[--column --hidden --no-heading --ignore-case --smart-case --color=always --max-columns=4096 ]]
  local path = {}

  if type(selected) == "table" then
    for _, x in pairs(entries) do
      for _, sel in pairs(selected) do
        if x.display == sel then
          local local_path = x.value.path.filename
          table.insert(path, local_path)
        end
      end
    end
    rg_opts = rg_opts .. " " .. table.concat(path, " ") .. " -e "
  elseif type(selected) == "string" then
    for _, x in pairs(entries) do
      if x.display == selected then
        path = x.value.path.filename
        rg_opts = rg_opts .. " " .. path .. " -e "
      end
    end
  end

  function tags_previewer:new(o, opts, fzf_win)
    tags_previewer.super.new(self, o, opts, fzf_win)
    setmetatable(self, tags_previewer)
    return self
  end

  function tags_previewer:parse_entry(entry_str)
    local row, col = entry_str:match "(%d+):(%d+)"
    -- print(tostring(row) .. " " .. tostring(col))
    return {
      path = path,
      line = row,
      col = col,
    }
  end
  local opts = {
    -- debug = true,
    fzf_opts = { ["--header"] = [[Ctrl-r: reload]] },
    rg_opts = rg_opts,
  }

  if type(selected) == "string" then
    opts.previewer = tags_previewer
    opts.actions = {
      ["default"] = function(sell, _)
        local sel = sell[1]
        local row, col = sel:match "(%d+):(%d+)"
        vim.cmd("e " .. path)
        vim.api.nvim_win_set_cursor(0, { tonumber(row), tonumber(col) })
      end,

      ["ctrl-v"] = function(sell, _)
        local sel = sell[1]
        local row, col = sel:match "(%d+):(%d+)"

        vim.cmd("vsplit " .. path)
        vim.api.nvim_win_set_cursor(0, { tonumber(row), tonumber(col) })
      end,

      ["ctrl-r"] = function()
        insert_tags = {}
        M.find_by_tags()
      end,

      ["ctrl-s"] = function(sell, _)
        local sel = sell[1]
        local row, col = sel:match "(%d+):(%d+)"

        vim.cmd("sp " .. path)
        vim.api.nvim_win_set_cursor(0, { tonumber(row), tonumber(col) })
      end,
    }
  elseif type(selected) == "table" then
    opts.actions = {
      ["default"] = function(sell, _)
        local sel = sell[1]
        -- TODO: sel:match nya berubah harus di ubah matching nya
        -- local row, col = sel:match "(%d+):(%d+)" --> ini harus diubah
        print "not implemented yet "
        print(sel)

        -- vim.cmd("e " .. path)
        -- vim.api.nvim_win_set_cursor(0, { tonumber(row), tonumber(col) })
      end,
    }
  end

  require("fzf-lua").live_grep(opts)
end

function M.find_by_tags(data)
  data = data or {}
  local tags = data.fargs or {}

  if vim.tbl_isempty(tags) then
    -- Check for visual selection.
    local viz = get_visual_selection { strict = true }
    if viz and #viz.lines == 1 and string.match(viz.selection, "^#?" .. TagCharsRequired .. "$") then
      local tag = viz.selection

      if vim.startswith(tag, "#") then
        tag = string.sub(tag, 2)
      end

      tags = { tag }
    else
      -- Otherwise check for a tag under the cursor.
      local tag = cursor_tag()
      if tag then
        tags = { tag }
      end
    end
  end

  -- print(vim.inspect(tags))

  if not vim.tbl_isempty(tags) then
    return find_tags_async(tags, function(tag_locations)
      -- print(vim.inspect(tags))
      local entries = loop_entries(tags, tag_locations)
      picker(entries)
    end, { search = { sort = true } })
  else
    list_tags_async(nil, function(all_tags)
      vim.schedule(function()
        -- Open picker with tags.
        find_tags_async(all_tags, function(tag_locations)
          local entries = loop_entries(all_tags, tag_locations)
          picker(entries)
        end, { search = { sort = true } })
      end)
    end)
  end
end

return M
