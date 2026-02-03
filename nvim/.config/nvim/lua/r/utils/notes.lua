---@class r.utils.notes
local M = {}

---@alias Mode_open "vsplit" | "split" | "tabe" | "default"
---@alias Opts_file {filename: string, col?: integer, lnum?: integer, title_str?: string }

-- Initial definition for setting up the note mode,
-- whether to use an org file or markdown
---@type "org" | "markdown"
local note_mode = "org"

local Orgmode, Fzflua, FzfluaBuiltin
local file_ignores, title_picker, icon_note, regex_url_backlinks, regex_title

local rg_opts = {
  "--column",
  "--hidden",
  "--line-number",
  "--no-heading",
  "--ignore-case",
  "--smart-case",
  "--color=always",
  "--max-columns=4096",
  "--colors",
  "'match:fg:178'", -- color match
}

local icon_markdown = RUtils.config.icons.misc.markdown
local title_picker_markdown = "Markdown"
local file_ignore_pattern_markdown = { "%.norg$", "%.json$", "%.org$", "%.png$" }

local icon_orgmode = RUtils.config.icons.misc.org
local title_picker_orgmode = "Orgmode"
local file_ignore_patterns_orgmode =
  { "%.norg$", "%.json$", "%.md$", "%.png$", "%.txt$", "%.toml$", "%.css$", "%.sh$", "%.bak$", "%.lua$" }

if note_mode == "markdown" then
  file_ignores = file_ignore_pattern_markdown
  title_picker = title_picker_markdown
  icon_note = icon_markdown
  rg_opts[#rg_opts + 1] = "--type=md"
  regex_title = [[^#{1,}\s\w.*$]]
  regex_url_backlinks = [[http|\[\[]]
else
  file_ignores = file_ignore_patterns_orgmode
  title_picker = title_picker_orgmode
  icon_note = icon_orgmode
  rg_opts[#rg_opts + 1] = "--type=org"
  regex_url_backlinks = [[http|\[\[]]
  -- regex_title = [[^\*{1,}\s[\w<`\?].*$]]
  regex_title = [[^\*\s|^\*+\s*[\w<`\?].*$]]
  -- regex_title = [[^\*{1,}+\s*(.*)$]]
end

---@param title string?
local function get_title_note(title)
  title = title or ""
  local title_tbl =
    RUtils.fzflua.format_title(string.format("%s %s", title_picker, title), RUtils.strip_whitespaces(icon_note))
  if not title_tbl then
    return
  end
  return title_tbl
end

local function not_implement()
  RUtils.warn "not implemented yet"
end

local function clone_tbl(tbl)
  local t = {}
  for i, v in ipairs(tbl) do
    t[i] = v
  end
  return t
end

local function check_duplicate_element_data_tags(tbl, element)
  for _, x in pairs(tbl) do
    if x["text"] == element then
      return true
    end
  end
  return false
end

local function realpath(path)
  if not path or path == "" then
    return nil
  end
  return vim.loop.fs_realpath(vim.fn.fnamemodify(path, ":p")) or path
end

-- Helper function to calculate the relative path
-- from the current directory to the target file
local function relative_path(from_dir, to_file)
  -- Ensure both paths are absolute
  local from = vim.fn.fnamemodify(from_dir, ":p"):gsub("/$", "") -- hapus trailing slash
  local to = vim.fn.fnamemodify(to_file, ":p")

  -- Split paths into arrays
  local from_parts = vim.split(from, "/", { plain = true })
  local to_parts = vim.split(to, "/", { plain = true })

  -- Remove common prefix
  while #from_parts > 0 and #to_parts > 0 and from_parts[1] == to_parts[1] do
    table.remove(from_parts, 1)
    table.remove(to_parts, 1)
  end

  -- Add "../" for each remaining level in 'from'
  local ups = {}
  for _ = 1, #from_parts do
    table.insert(ups, "..")
  end

  -- Append the remaining target path
  for _, part in ipairs(to_parts) do
    table.insert(ups, part)
  end

  return table.concat(ups, "/")
end

local function setup_orgmode()
  if Orgmode then
    return Orgmode
  end

  Orgmode = require "orgmode"
  return Orgmode
end

local function get_headline_at_cursor()
  local orgapi = require "orgmode.api.agenda"
  local filename, headline_opts, lnum, col

  if note_mode == "org" then
    headline_opts = orgapi.get_headline_at_cursor()
    if not headline_opts then
      return
    end

    ---@diagnostic disable-next-line: invisible
    local item_section = headline_opts._section
    filename = item_section.file.filename

    lnum = headline_opts.position.start_line
    col = headline_opts.position.end_col
  elseif note_mode == "markdown" then
    -- belum di setting
    headline_opts = {}
    lnum = 0
    col = 0
    filename = ""
  end

  if not headline_opts then
    RUtils.error "Failed error"
    return
  end

  return {
    filename = filename,
    lnum = lnum,
    col = col,
    opts = headline_opts,
  }
end

local function setup_fzflua()
  if Fzflua then
    return Fzflua
  end

  Fzflua = require "fzf-lua"
  return Fzflua
end

local function setup_buffer_or_file_fzflua(fn)
  if not FzfluaBuiltin then
    FzfluaBuiltin = require "fzf-lua.previewer.builtin"
  end

  local Previewer = FzfluaBuiltin.buffer_or_file:extend()

  function Previewer:new(o, optsc, fzf_win)
    Previewer.super.new(self, o, optsc, fzf_win)
    setmetatable(self, Previewer)
    return self
  end

  function Previewer:parse_entry(entry_str)
    local dataparse = fn(entry_str)
    if not dataparse then
      return {}
    end

    return dataparse
  end

  return Previewer
end

local load_plenary_plugin = function()
  local scan = require "plenary.scandir"
  local Path = require "plenary.path"
  return Path, scan
end

local load_opts_orgmode = function()
  local plugin = require("lazy.core.config").plugins["orgmode"]
  local Plugin = require "lazy.core.plugin"
  local opts_plugin = Plugin.values(plugin, "opts", false)
  return opts_plugin
end

local get_tbl_backup_and_todos = function(scan, is_ignore_file)
  is_ignore_file = is_ignore_file or false

  local opts_plugin = load_opts_orgmode()

  local org_backup = {}
  local org_todos = {}
  for _, x in pairs(opts_plugin.org_agenda_files) do
    local path
    if string.match(x, [[%*%*]], 1) then
      path = string.gsub(x, [[%/%*%*/%*$]], "")
    else
      path = string.gsub(x, [[%/%*$]], "")
    end
    local dirs = scan.scan_dir(path)
    for _, file_path in pairs(dirs) do
      if is_ignore_file and (not string.match(file_path, "org_archive")) then
        local check_org_ext = string.match(RUtils.file.basename(file_path), "%.org$")
        if check_org_ext then
          local basename_file = string.gsub(RUtils.file.basename(file_path), ".org$", "")
          table.insert(org_backup, { full_path = file_path, path = path, basename_file = basename_file })
          table.insert(org_todos, basename_file)
        end
      else
        -- include file org_archive
        local check_org_ext = string.match(RUtils.file.basename(file_path), "%.org")
        if check_org_ext then
          local basename_file = string.gsub(RUtils.file.basename(file_path), ".org$", "")
          table.insert(org_backup, { full_path = file_path, path = path, basename_file = basename_file })
          table.insert(org_todos, basename_file)
        end
      end
    end
  end

  return org_backup, org_todos
end

---@param opts {}
local function opts_fzf(opts)
  return {
    prompt = RUtils.fzflua.padding_prompt(),
    winopts = opts.winopts,
    actions = opts.actions,
    fzf_opts = opts.fzf_opts,
  }
end

---@param tbl_paths table<string>?
---@return { paths: string, path_merge_str: string }
local function __define_tbl_paths(tbl_paths)
  local concat_fnames

  if not tbl_paths then
    local starting_bufname = vim.api.nvim_buf_get_name(0)
    concat_fnames = vim.fn.fnamemodify(starting_bufname, ":p")
    tbl_paths = { concat_fnames }
  end

  if type(tbl_paths) == "string" then
    concat_fnames = tbl_paths
  end

  if type(tbl_paths) == "table" then
    concat_fnames = table.concat(tbl_paths, " ")
  end

  return {
    paths = tbl_paths,
    path_merge_str = concat_fnames,
  }
end

local function find_files_org()
  Fzflua = setup_fzflua()
  Fzflua.files {
    prompt = RUtils.fzflua.padding_prompt(),
    cwd = RUtils.config.path.wiki_path,
    file_ignore_patterns = file_ignores,
    rg_opts = table.concat(rg_opts, " "),
    winopts = { title = get_title_note "- Files" },
  }
end

local function live_grep_org()
  Fzflua = setup_fzflua()
  return Fzflua.live_grep_glob {
    prompt = RUtils.fzflua.padding_prompt(),
    cwd = RUtils.config.path.wiki_path,
    rg_opts = table.concat(rg_opts, " "),
    winopts = { title = get_title_note "- Live grep" },
  }
end

local function insert_tag_org()
  Orgmode = setup_orgmode()
  local contents_tags = Orgmode.files:get_tags()
  if #contents_tags == 0 then
    return
  end

  local opts = {
    winopts = { title = get_title_note "- Search note by tags" },
    actions = {
      ["default"] = function(selection)
        if selection == nil then
          return
        end

        local sel = selection[1]
        if not sel then
          return
        end

        vim.api.nvim_put({ sel }, "c", false, true)
      end,
    },
  }
  Fzflua = setup_fzflua()
  Fzflua.fzf_exec(contents_tags, RUtils.fzflua.open_cursor_dropdown(opts_fzf(opts)))
end

local Mappicker = {}

---@param mode_open Mode_open
---@param opts_file Opts_file
local function open(mode_open, opts_file)
  local cmd_msg
  if mode_open == "default" then
    cmd_msg = "e " .. opts_file.filename
  else
    cmd_msg = mode_open .. " " .. opts_file.filename
    if mode_open == "vsplit" then
      cmd_msg = "botright " .. cmd_msg
    end
  end

  vim.cmd(cmd_msg)

  vim.schedule(function()
    vim.api.nvim_win_set_cursor(0, { opts_file.lnum, opts_file.col })
    RUtils.cmd.force_foldopen() -- force to open fold

    local row = vim.fn.winline()
    local height = vim.api.nvim_win_get_height(0)

    if row > height * 0.7 then
      vim.cmd "normal! zt"
    end
  end)
end

---@param target_file Opts_file
local function open_vsplit(target_file)
  open("vsplit", target_file)
end

---@param target_file Opts_file
local function open_split(target_file)
  open("split", target_file)
end

---@param target_file Opts_file
local function open_tab(target_file)
  open("tabe", target_file)
end

---@param target_file Opts_file
local function open_default(target_file)
  open("default", target_file)
end

---@param selected table|string
---@param filename string
---@param is_global boolean?
---@return Opts_file|nil
local function extract_str_title(selected, filename, is_global)
  is_global = is_global or false

  local sel
  if type(selected) == "table" then
    sel = RUtils.fzflua.__strip_str(selected[1])
  end

  if type(selected) == "string" then
    sel = RUtils.fzflua.__strip_str(selected)
  end

  if not sel then
    return
  end

  local sel_slice = vim.split(sel, ":")

  local lnum, col, title_str

  if is_global then
    lnum = tonumber(sel_slice[2]) or 1
    col = tonumber(sel_slice[3]) or 1
    title_str = sel_slice[4]:gsub("*", "") or ""
  else
    lnum = tonumber(sel_slice[1]) or 1
    col = tonumber(sel_slice[2]) or 1
    title_str = sel_slice[3]:gsub("*", "") or ""
  end

  local file_opts = {
    filename = filename,
    lnum = lnum,
    col = col,
    title_str = RUtils.strip_whitespaces(title_str),
  }

  return file_opts
end

---@param filename string
---@param selected string[]
---@param is_global boolean
---@return Opts_file|nil
local function extracted_selected_tags(selected, filename, is_global)
  local items = {}
  if #selected > 1 then
    for _, sel in pairs(selected) do
      local data = extract_str_title(sel, filename, is_global)
      if not data then
        return
      end

      if not check_duplicate_element_data_tags(items, data.title_str) then
        items[#items + 1] = {
          filename = data.filename,
          lnum = data.lnum,
          col = data.col,
          text = data.title_str,
        }
      end
    end
  else
    local data = extract_str_title(selected, filename, is_global)
    if not data then
      return
    end

    if not check_duplicate_element_data_tags(items, data.title_str) then
      items[#items + 1] = {
        filename = data.filename,
        lnum = data.lnum,
        col = data.col,
        text = data.title_str,
      }
    end
  end

  return items
end

---@param filename string
---@param is_global boolean?
function Mappicker.open_and_jump_to_file(filename, is_global)
  is_global = is_global or false

  return {
    ["default"] = function(selected, _)
      if is_global then
        local e = Fzflua.path.entry_to_file(selected[1])
        if e.path then
          filename = e.path
        end
      end

      local file_opts = extract_str_title(selected, filename, is_global)
      if file_opts then
        open_default(file_opts)
      end
    end,
    ["ctrl-v"] = function(selected, _)
      if is_global then
        local e = Fzflua.path.entry_to_file(selected[1])
        if e.path then
          filename = e.path
        end
      end

      local file_opts = extract_str_title(selected, filename, is_global)
      if file_opts then
        open_vsplit(file_opts)
      end
    end,
    ["ctrl-s"] = function(selected, _)
      if is_global then
        local e = Fzflua.path.entry_to_file(selected[1])
        if e.path then
          filename = e.path
        end
      end

      local file_opts = extract_str_title(selected, filename, is_global)
      if file_opts then
        open_split(file_opts)
      end
    end,
    ["ctrl-t"] = function(selected, _)
      if is_global then
        local e = Fzflua.path.entry_to_file(selected[1])
        if e.path then
          filename = e.path
        end
      end

      local file_opts = extract_str_title(selected, filename, is_global)
      if file_opts then
        open_tab(file_opts)
      end
    end,

    ["alt-q"] = function(selected)
      if not selected then
        return
      end
      local list_items = {
        items = extracted_selected_tags(selected, filename, is_global),
        title = "Tags Note",
      }
      RUtils.qf.save_to_qf_and_auto_open_qf(list_items)
    end,

    ["alt-Q"] = {
      prefix = "toggle-all",
      fn = function(selected)
        if not selected then
          return
        end

        local list_items = {
          items = extracted_selected_tags(selected, filename, is_global),
          title = "Note Stuff",
        }

        RUtils.qf.save_to_qf_and_auto_open_qf(list_items)
      end,
    },
    ["alt-v"] = function(selected)
      if not selected then
        return
      end
      local list_items = {
        items = extracted_selected_tags(selected, filename, is_global),
        title = "Tags Note",
      }
      RUtils.qf.save_to_qf_and_auto_open_qf(list_items, true)
    end,

    ["alt-V"] = {
      prefix = "toggle-all",
      fn = function(selected)
        if not selected then
          return
        end

        local list_items = {
          items = extracted_selected_tags(selected, filename, is_global),
          title = "Note Stuff",
        }

        RUtils.qf.save_to_qf_and_auto_open_qf(list_items, true)
      end,
    },
  }
end

---@param filename string
---@param is_global boolean?
function Mappicker.insert_title(filename, is_global)
  is_global = is_global or false

  return {
    ["default"] = function(selected, _)
      local file_opts = extract_str_title(selected, filename, is_global)
      if not file_opts then
        return
      end

      local fmt_str

      if not is_global then
        fmt_str = "[[*" .. file_opts.title_str .. "][ " .. file_opts.title_str .. "]]"
      else
        local e = Fzflua.path.entry_to_file(selected[1])
        local target_path = e and e.path or nil
        local root = RUtils.config.path.wiki_path or ""

        if target_path and root then
          target_path = vim.loop.fs_realpath(vim.fn.fnamemodify(target_path, ":p")) or ""
          root = vim.loop.fs_realpath(vim.fn.fnamemodify(root, ":p")) or ""

          local current_file = vim.api.nvim_buf_get_name(0)
          current_file = current_file and vim.loop.fs_realpath(vim.fn.fnamemodify(current_file, ":p")) or ""

          if (#current_file > 1) and target_path then
            if vim.startswith(current_file, root) and vim.startswith(target_path, root) then
              local current_dir = vim.fs.dirname(current_file)
              local relative = relative_path(current_dir, target_path)

              if relative then
                -- fmt_str = "[[./" .. relative .. "::*" .. file_opts.title_str .. "]]"
                fmt_str = "[[./" .. relative .. "::*" .. file_opts.title_str .. "][🔗" .. file_opts.title_str .. "]]"
              end
            end
          end
        end
      end

      if fmt_str then
        vim.api.nvim_put({ fmt_str }, "c", false, true)
      end
    end,
  }
end

function Mappicker.insert_backlinks()
  local function filename_label(path)
    local name = vim.fn.fnamemodify(path, ":t") -- ex: financial.org
    return vim.fn.fnamemodify(name, ":r") -- financial
  end

  return {
    ["default"] = function(selected, _)
      local e = Fzflua.path.entry_to_file(selected[1])
      local target_path = e and e.path
      if not target_path then
        RUtils.warn "Invalid target path."
        return
      end

      local current_file = realpath(vim.api.nvim_buf_get_name(0)) or ""
      local wiki_root = realpath(RUtils.config.path.wiki_path) or ""

      if not vim.startswith(current_file, wiki_root) then
        RUtils.warn "The current file is not part of the wiki"
        return
      end

      local current_dir = vim.fs.dirname(current_file)
      local up_to_root = relative_path(current_dir, wiki_root)

      local target_tail = vim.fn.fnamemodify(target_path, ":~:.")

      local relative = vim.fs.normalize(up_to_root .. "/" .. target_tail)

      --ex: [[./../financial.org]] -> [[./../financial.org][financial]]
      local label = filename_label(relative)

      local link = string.format("[[./%s][%s]]", relative, label)
      vim.api.nvim_put({ link }, "c", false, true)
    end,
  }
end

local match_tags

function Mappicker.open_tags()
  return {
    ["default"] = function(selection)
      if selection == nil then
        return
      end

      local sel = {}
      if #selection > 1 then
        for _, x in pairs(selection) do
          table.insert(sel, x)
        end

        match_tags = table.concat(sel, "+")
      else
        sel = { selection[1] }
        match_tags = table.concat(sel, "")
      end

      if not sel then
        return
      end

      -- RUtils.info(vim.inspect(sel))

      Orgmode.agenda:tags {
        match_query = match_tags,
        -- org_agenda_todo_ignore_scheduled =
        -- org_agenda_todo_ignore_deadlines =
      }
    end,

    -- ["ctrl-y"] = function(selection, opts)
    --   if selection == nil then
    --     return
    --   end
    --
    --   RUtils.info(vim.inspect(selection))
    --
    --   local query = opts.query
    --   if not query or query == "" then
    --     return
    --   end
    --
    --   local pattern = query
    --   RUtils.info(vim.inspect(pattern))
    --
    --   local results = {}
    --
    --   for _, item in ipairs(opts._all_items or {}) do
    --     if item:match(pattern) then
    --       table.insert(results, item)
    --     end
    --   end
    --   RUtils.info(vim.inspect(results))
    -- end,
  }
end

---@param opts? {last: boolean }
local function get_tags(opts)
  opts = opts or {}
  Orgmode = setup_orgmode()

  if opts.last and match_tags then
    RUtils.info("Last tags: " .. vim.inspect(match_tags))
    Orgmode.agenda:tags { match_query = match_tags }
    return
  end

  -- RUtils.info(vim.inspect(orgmode.files:get_tags()))
  -- RUtils.info(vim.inspect(orgmode.files:all()))
  -- RUtils.info(vim.inspect(result:check {}))
  local contents_tags = Orgmode.files:get_tags()
  if #contents_tags == 0 then
    return
  end

  local fzopts = {
    winopts = { title = get_title_note "- Search note by tags" },
    actions = Mappicker.open_tags(),
  }

  Fzflua = setup_fzflua()
  Fzflua.fzf_exec(contents_tags, RUtils.fzflua.open_center_medium(opts_fzf(fzopts)))
end

---@param is_global boolean
local function get_target_file(is_global)
  local fnames = __define_tbl_paths()

  local target_file = fnames.path_merge_str
  if is_global then
    target_file = RUtils.config.path.wiki_path
  end
  return target_file
end

---@param is_global boolean
---@param target_file string
---@param opts table?
local function call_fzf_grep(is_global, target_file, opts)
  opts = opts or {}

  local clone_rg_opts = clone_tbl(rg_opts)
  table.insert(clone_rg_opts, target_file)
  table.insert(clone_rg_opts, "-e")

  local previewer = setup_buffer_or_file_fzflua(function(entry)
    local data = {}

    local entry_strip_ansi = RUtils.fzflua.__strip_str(entry)
    if not entry_strip_ansi then
      return data
    end

    local entry_split = vim.split(entry_strip_ansi, ":")
    if not entry_split then
      return data
    end

    local line, path, col, text

    if is_global then
      path = vim.fn.fnamemodify(entry_split[1], ":p")
      line = entry_split[2]
      col = entry_split[3]
      text = entry_split[4]
    else
      path = target_file
      line = entry_split[1]
      col = entry_split[2]
      text = entry_split[3]
    end

    return {
      text = text,
      path = path,
      col = tonumber(col),
      line = tonumber(line),
    }
  end)

  local fzfopts = vim.tbl_deep_extend("force", {
    prompt = RUtils.fzflua.padding_prompt(),
    winopts = { title = get_title_note "- Notes" },
    previewer = previewer,
    rg_glob = false,
    no_esc = true,
    file_ignore_patterns = file_ignores,
    rg_opts = table.concat(clone_rg_opts, " "),
    -- fzf_opts = {
    --   -- ["--delimiter"] = "[:\t]",
    --   --
    --   ["--tabstop"] = "1",
    --   -- ["--tiebreak"] = "index",
    --   -- Separated by tab and ':', 1: file icon+name, 2: file path 3: line number, it is dependes on rg_opts whether column or line number is enabled or not.
    --   ["--with-nth"] = "2..",
    --   -- Search fileds
    --   ["--nth"] = "3..",
    --
    --   -- ["--delimiter"] = "[\t]",
    --   -- ["--tabstop"] = "1",
    --   -- ["--tiebreak"] = "index",
    --   -- ["--with-nth"] = "2..",
    --   -- ["--nth"] = "4..",
    --
    --   -- ["--multi"] = true,
    --   -- ["--delimiter"] = "[:\t]",
    --   -- ["--with-nth"] = "2..",
    --   -- ["--with-nth"] = "3..",
    --   -- ["--tiebreak"] = "index",
    -- },
  }, opts)

  Fzflua = setup_fzflua()
  Fzflua.grep(fzfopts)
end

---@param is_global boolean?
local function insert_heading_title(is_global)
  is_global = is_global or false

  local target_file = get_target_file(is_global)

  local title_a = "Local"
  if is_global then
    title_a = "Global"
  end
  local __title = "- Insert " .. title_a .. " Title"

  call_fzf_grep(is_global, target_file, {
    winopts = { title = get_title_note(__title) },
    search = regex_title,
    actions = Mappicker.insert_title(target_file, is_global),
  })
end

---@param is_global boolean?
local function find_url_and_backlinks(is_global)
  is_global = is_global or false

  local target_file = get_target_file(is_global)
  call_fzf_grep(is_global, target_file, {
    winopts = { title = get_title_note "- Backlinks / URLs" },
    search = regex_url_backlinks,
    actions = Mappicker.open_and_jump_to_file(target_file, is_global),
  })
end

---@param is_global boolean?
local function jump_to_heading(is_global)
  is_global = is_global or false

  local title_a = "Local"
  if is_global then
    title_a = "Global"
  end
  local __title = "- Jump " .. title_a .. " Title"

  local target_file = get_target_file(is_global)
  call_fzf_grep(is_global, target_file, {
    winopts = { title = get_title_note(__title) },
    search = regex_title,
    actions = Mappicker.open_and_jump_to_file(target_file, is_global),
  })
end

---@param is_global boolean?
local function find_references_backlinks(is_global)
  is_global = is_global or false

  local __title = "- Find References Backlinks"

  local target_file = get_target_file(is_global)
  call_fzf_grep(is_global, target_file, {
    actions = Mappicker.open_and_jump_to_file(target_file, is_global),
    search = regex_title,
    winopts = { title = get_title_note(__title) },
  })
end

---@param is_global boolean?
local function insert_backlinks(is_global)
  is_global = is_global or false

  local __title = "- Insert Backlinks"

  Fzflua = setup_fzflua()
  Fzflua.files {
    prompt = RUtils.fzflua.padding_prompt(),
    cwd = RUtils.config.path.wiki_path,
    file_ignore_patterns = file_ignores,
    winopts = { title = get_title_note(__title) },
    actions = Mappicker.insert_backlinks(),
  }
end

---@class NotesCmdsObjt
---@field filter_by_tags fun()
---@field lfilter_by_tags fun()
---@field find_files_notes fun()
---@field find_curbuf_title_notes fun()
---@field find_global_title_notes fun()
---@field find_reference_backlinks fun()
---@field find_local_url_and_backlinks fun()
---@field find_global_url_and_backlinks fun()
---@field live_grep fun()
---@field insert_title_curbuf fun()
---@field insert_title_global fun()
---@field insert_backlinks fun()
---@field insert_tags fun()

---@type table<"org" | "markdown", NotesCmdsObjt>
local get_cmds = {
  ["org"] = {
    filter_by_tags = function()
      get_tags()
    end,
    lfilter_by_tags = function()
      get_tags { last = true }
    end,
    find_files_notes = function()
      find_files_org()
    end,
    find_curbuf_title_notes = function()
      jump_to_heading()
    end,
    find_global_title_notes = function()
      jump_to_heading(true)
    end,
    find_reference_backlinks = function()
      find_references_backlinks()
    end,
    find_local_url_and_backlinks = function()
      find_url_and_backlinks()
    end,
    find_global_url_and_backlinks = function()
      find_url_and_backlinks(true)
    end,
    live_grep = function()
      live_grep_org()
    end,
    insert_backlinks = function()
      insert_backlinks(true)
    end,
    insert_title_curbuf = function()
      insert_heading_title()
    end,
    insert_title_global = function()
      insert_heading_title(true)
    end,
    insert_tags = function()
      insert_tag_org()
    end,
  },
  ["markdown"] = {
    filter_by_tags = function()
      RUtils.markdown.find_note_by_tag()
    end,
    lfilter_by_tags = function()
      get_tags { last = true }
    end,
    find_files_notes = function()
      not_implement()
    end,
    find_curbuf_title_notes = function()
      not_implement()
    end,
    find_global_title_notes = function()
      not_implement()
    end,
    find_reference_backlinks = function()
      find_references_backlinks()
    end,
    find_local_url_and_backlinks = function()
      not_implement()
    end,
    find_global_url_and_backlinks = function()
      not_implement()
    end,
    live_grep = function()
      not_implement()
    end,
    insert_title_curbuf = function()
      RUtils.markdown.insert_local_titles()
    end,
    insert_title_global = function()
      RUtils.markdown.insert_global_titles()
    end,
    insert_backlinks = function()
      not_implement()
    end,
    insert_tags = function()
      RUtils.markdown.insert_by_categories()
    end,
  },
}

---@param name_cmd string
local function call_cmd(name_cmd)
  local f = get_cmds[note_mode][name_cmd]
  if f then
    return f
  end
  RUtils.warn(string.format("Error command `%s`", name_cmd))
end

function M.filter_by_tags()
  return call_cmd "filter_by_tags"()
end

function M.last_filter_by_tags()
  return call_cmd "lfilter_by_tags"()
end

function M.find_files_notes()
  return call_cmd "find_files_notes"()
end

function M.find_local_title()
  return call_cmd "find_curbuf_title_notes"()
end

function M.find_global_title()
  return call_cmd "find_global_title_notes"()
end

function M.find_backlinks()
  return call_cmd "find_backlinks"()
end

function M.find_local_url_and_backlinks()
  return call_cmd "find_local_url_and_backlinks"()
end

function M.find_global_url_and_backlinks()
  return call_cmd "find_global_url_and_backlinks"()
end

function M.live_grep()
  return call_cmd "live_grep"()
end

function M.insert_tag()
  return call_cmd "insert_tags"()
end

function M.insert_local_title()
  return call_cmd "insert_title_curbuf"()
end

function M.insert_global_title()
  return call_cmd "insert_title_global"()
end

function M.add_and_insert_backlinks()
  return call_cmd "insert_backlinks"()
end

---@param mode_open Mode_open
local function open_item_heading(mode_open)
  mode_open = mode_open or "default"

  local is_float = vim.api.nvim_win_get_config(0).relative ~= ""

  if not vim.tbl_contains({ "org", "orgagenda" }, vim.bo.filetype) or is_float then
    return
  end

  local headline_opts = get_headline_at_cursor()
  if not headline_opts then
    return
  end

  local opts_file = {
    filename = headline_opts.filename,
    lnum = headline_opts.lnum,
    col = headline_opts.col,
  }
  open(mode_open, opts_file)

  vim.cmd "wincmd ="
end

function M.open_item_heading_vsplit()
  open_item_heading "vsplit"
end

function M.open_item_heading_split()
  open_item_heading "split"
end

function M.open_item_heading_tab()
  open_item_heading "tabe"
end

function M.open_agenda_file_lists()
  local Path, scan = load_plenary_plugin()
  local org_backup, org_todos = get_tbl_backup_and_todos(scan, true)

  local contains_match = function(str_path, str)
    if str_path:match(str) then
      return true
    end
    return false
  end

  local opts = {
    winopts = { title = get_title_note "- OrgFiles" },
    fzf_opts = { ["--header"] = [[^x:cleanup]] },
    actions = {
      ["default"] = function(selected, _)
        local sel = RUtils.fzflua.__strip_str(selected[1])
        for _, x in pairs(org_backup) do
          if sel == x.basename_file then
            if RUtils.file.exists(x.full_path) then
              return vim.cmd("edit " .. x.full_path)
            end
            return RUtils.warn("Path not exists: " .. x.full_path, { title = "Notes" })
          end
        end
      end,
      ["ctrl-v"] = function(selected, _)
        local sel = RUtils.fzflua.__strip_str(selected[1])
        for _, x in pairs(org_backup) do
          if sel == x.basename_file then
            if RUtils.file.exists(x.full_path) then
              return vim.cmd("vsplit " .. x.full_path)
            end
            return RUtils.warn("Path not exists: " .. x.full_path, { title = "Notes" })
          end
        end
      end,
      ["ctrl-s"] = function(selected, _)
        local sel = RUtils.fzflua.__strip_str(selected[1])
        for _, x in pairs(org_backup) do
          if sel == x.basename_file then
            if RUtils.file.exists(x.full_path) then
              return vim.cmd("split " .. x.full_path)
            end
            return RUtils.warn("Path not exists: " .. x.full_path, { title = "Notes" })
          end
        end
      end,
      -- TODO: buat delete file, delete folder kosong
      ["ctrl-x"] = function()
        local project_todo_path = RUtils.config.path.dropbox_path .. "/neorg/orgmode/project-todo"
        local dirs = scan.scan_dir(project_todo_path, { depth = 2, add_dirs = true })

        for _, file_path in pairs(dirs) do
          local is_file_org = contains_match(tostring(file_path), ".org$")
          if is_file_org then
            if vim.fn.getfsize(file_path) <= 3 then
              local p = Path:new(file_path)
              if p:exists() then
                p:rm()
              end
            end
          else
            local p = Path:new(file_path)
            if p:exists() then
              p:rmdir()
            end
          end
        end

        RUtils.info("✅ Clean up todos path done!", { title = "Notes" })
      end,
    },
  }

  Fzflua = setup_fzflua()
  Fzflua.fzf_exec(org_todos, RUtils.fzflua.open_dock_bottom(opts_fzf(opts)))
end

return M
