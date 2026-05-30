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
  "'match:fg:178'",
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
  regex_title = [[^\*\s|^\*+\s*[\w<`\?].*$]]
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

local function relative_path(from_dir, to_path)
  from_dir = vim.fs.normalize(from_dir):gsub("/$", "")
  to_path = vim.fs.normalize(to_path)

  local to_dir = vim.fs.dirname(to_path)
  local to_file = vim.fn.fnamemodify(to_path, ":t")

  local function split(path)
    local parts = {}
    for p in path:gmatch "[^/]+" do
      if p ~= "" then
        parts[#parts + 1] = p
      end
    end
    return parts
  end

  local from_parts = split(from_dir)
  local to_parts = split(to_dir)

  local common = 0
  local limit = math.min(#from_parts, #to_parts)
  for i = 1, limit do
    if from_parts[i] == to_parts[i] then
      common = i
    else
      break
    end
  end

  local parts = {}

  local up = #from_parts - common
  if up == 0 then
    parts[#parts + 1] = "."
  else
    for _ = 1, up do
      parts[#parts + 1] = ".."
    end
  end

  for i = common + 1, #to_parts do
    parts[#parts + 1] = to_parts[i]
  end

  parts[#parts + 1] = to_file

  return table.concat(parts, "/")
end

-- ─────────────────────────────────────────────────────────────────────────────

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

-- local load_plenary_plugin = function()
--   local scan = require "plenary.scandir"
--   local Path = require "plenary.path"
--   return Path, scan
-- end
--
-- local load_opts_orgmode = function()
--   local plugin = require("lazy.core.config").plugins["orgmode"]
--   local Plugin = require "lazy.core.plugin"
--   local opts_plugin = Plugin.values(plugin, "opts", false)
--   return opts_plugin
-- end
--
-- local get_tbl_backup_and_todos = function(scan, is_ignore_file)
--   is_ignore_file = is_ignore_file or false
--
--   local opts_plugin = load_opts_orgmode()
--
--   local org_backup = {}
--   local org_todos = {}
--   for _, x in pairs(opts_plugin.org_agenda_files) do
--     local path
--     if string.match(x, [[%*%*]], 1) then
--       path = string.gsub(x, [[%/%*%*/%*$]], "")
--     else
--       path = string.gsub(x, [[%/%*$]], "")
--     end
--     local dirs = scan.scan_dir(path)
--     for _, file_path in pairs(dirs) do
--       if is_ignore_file and (not string.match(file_path, "org_archive")) then
--         local check_org_ext = string.match(RUtils.file.basename(file_path), "%.org$")
--         if check_org_ext then
--           local basename_file = string.gsub(RUtils.file.basename(file_path), ".org$", "")
--           table.insert(org_backup, { full_path = file_path, path = path, basename_file = basename_file })
--           table.insert(org_todos, basename_file)
--         end
--       else
--         local check_org_ext = string.match(RUtils.file.basename(file_path), "%.org")
--         if check_org_ext then
--           local basename_file = string.gsub(RUtils.file.basename(file_path), ".org$", "")
--           table.insert(org_backup, { full_path = file_path, path = path, basename_file = basename_file })
--           table.insert(org_todos, basename_file)
--         end
--       end
--     end
--   end
--
--   return org_backup, org_todos
-- end

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
    RUtils.cmd.force_foldopen()

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
        fmt_str = "[[*" .. file_opts.title_str .. "][🔗" .. file_opts.title_str .. "]]"
      else
        local e = Fzflua.path.entry_to_file(selected[1])
        local target_path = e and e.path or nil
        local root = RUtils.config.path.wiki_path or ""

        if target_path and root then
          target_path = realpath(target_path) or ""
          root = realpath(root) or ""

          local current_file = realpath(vim.api.nvim_buf_get_name(0)) or ""

          if (#current_file > 1) and target_path then
            if vim.startswith(current_file, root) and vim.startswith(target_path, root) then
              local current_dir = vim.fs.dirname(current_file)
              local relative = relative_path(current_dir, target_path)

              if relative then
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
  return {
    ["default"] = function(selected, _)
      local e = Fzflua.path.entry_to_file(selected[1])
      local target_path = e and e.path
      if not target_path then
        RUtils.warn "Invalid target path."
        return
      end

      local function norm(path)
        if not path or path == "" then
          return nil
        end
        return vim.fs.normalize(vim.fn.fnamemodify(path, ":p")):gsub("/$", "")
      end

      local wiki_sym = norm(RUtils.config.path.wiki_path)
      local current_file = norm(vim.api.nvim_buf_get_name(0))
      target_path = norm(target_path)

      if not current_file or not target_path or not wiki_sym then
        RUtils.warn "Could not resolve paths."
        return
      end

      if not vim.startswith(current_file, wiki_sym) then
        RUtils.warn "The current file is not part of the wiki."
        return
      end

      local function find_wiki_equivalent(real_target, wiki_root)
        local fname = vim.fn.fnamemodify(real_target, ":t")
        local matches = vim.fn.glob(wiki_root .. "/**/" .. fname, false, true)

        if #matches == 1 then
          return norm(matches[1])
        elseif #matches > 1 then
          local target_parts = vim.split(real_target, "/")
          local best, best_score = nil, 0
          for _, candidate in ipairs(matches) do
            local cparts = vim.split(candidate, "/")
            local score = 0
            local ti, ci = #target_parts, #cparts
            while ti > 0 and ci > 0 and target_parts[ti] == cparts[ci] do
              score = score + 1
              ti = ti - 1
              ci = ci - 1
            end
            if score > best_score then
              best = candidate
              best_score = score
            end
          end
          return best and norm(best) or nil
        end

        return nil
      end

      if not vim.startswith(target_path, wiki_sym) then
        local found = find_wiki_equivalent(target_path, wiki_sym)
        if found then
          target_path = found
        else
          RUtils.warn "Target file is not part of the wiki."
          return
        end
      end

      local current_dir = vim.fs.dirname(current_file)
      local relative = relative_path(current_dir, target_path)
      local label = vim.fn.fnamemodify(target_path, ":t:r")
      local link = string.format("[[%s][ %s]]", relative, label)
      vim.api.nvim_put({ link }, "c", false, true)
    end,
  }
end

local match_tags

function Mappicker.open_tags()
  Orgmode = setup_orgmode()
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

      -- Orgmode.agenda:tags {
      --   match_query = match_tags,
      -- }

      -- Temporarily swap ke full wiki path
      local wiki_path = RUtils.config.path.wiki_path .. "/**/*.org"
      require("orgmode").setup { org_agenda_files = wiki_path }

      require("orgmode").agenda:tags { match_query = match_tags }

      -- Restore ke path original setelah agenda terbuka
      -- vim.schedule(function()
      --   Orgmode.setup { org_agenda_files = "~/Dropbox/neorg/orgmode/**/*.org" }
      -- end)
    end,
  }
end

---@param path string
local function get_tags_from_path(path)
  local tags = {}
  local seen = {}

  local files = vim.fn.glob(path .. "/**/*.org", false, true)

  for _, file in ipairs(files) do
    local lines = vim.fn.readfile(file)
    for _, line in ipairs(lines) do
      -- Skip baris timestamp, schedule, deadline, property
      if
        not line:match "^%s*SCHEDULED:"
        and not line:match "^%s*DEADLINE:"
        and not line:match "^%s*CLOSED:"
        and not line:match "^%s*:.*:$" -- property drawer
        and not line:match "<%d%d%d%d%-%d%d%-%d%d" -- timestamp
      then
        -- Tag org harus diawali huruf, minimal 2 karakter
        for tag in line:gmatch ":([%a][%w_@]+):" do
          if not seen[tag] then
            seen[tag] = true
            -- tags[#tags + 1] = tag .. " > " .. line
            tags[#tags + 1] = tag
          end
        end
      end
    end
  end

  table.sort(tags)
  return tags
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

  local wiki_path = RUtils.config.path.wiki_path
  local contents_tags = get_tags_from_path(wiki_path)

  if #contents_tags == 0 then
    RUtils.warn "No tags found."
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

local function insert_backlinks_files()
  Fzflua = setup_fzflua()
  Fzflua.files {
    prompt = RUtils.fzflua.padding_prompt(),
    cwd = RUtils.config.path.wiki_path,
    file_ignore_patterns = file_ignores,
    winopts = { title = get_title_note "- Insert Backlinks" },
    actions = Mappicker.insert_backlinks(),
  }
end

local function get_or_create_bufnr(filename)
  local bufnr = vim.fn.bufnr(filename)
  if bufnr == -1 then
    -- Buffer not exist, create it without loading
    bufnr = vim.fn.bufadd(filename)
  end
  vim.fn.bufload(bufnr) -- load isi file ke memory
  return bufnr
end

local function set_repeater_todo(bufnr, repeater_dates, headline)
  local OrgMappings = Orgmode.org_mappings

  vim.api.nvim_buf_call(bufnr, function()
    local range = headline:get_range()
    vim.api.nvim_win_set_cursor(0, { range.start_line, 0 })

    -- Step 1: advance repeater dates dulu (ini pakai range dari date object sendiri)
    for _, date in ipairs(repeater_dates) do
      OrgMappings:_replace_date(date:apply_repeater())
    end

    -- Step 2: setelah buffer berubah, reload file dan cari headline yang sama by line
    vim.cmd "silent! write"

    local file = require("orgmode").files:get(vim.api.nvim_buf_get_name(bufnr))
    if not file then
      return
    end

    -- Cari headline di range yang sama (start_line tidak bergeser karena _replace_date
    -- hanya replace konten di baris yang sama, tidak menambah/kurang baris)
    local target_line = range.start_line
    local fresh_headline = nil
    for _, h in ipairs(file:get_headlines()) do
      if h:get_range().start_line == target_line then
        fresh_headline = h
        break
      end
    end

    if not fresh_headline then
      RUtils.warn("Cannot find headline at line " .. target_line)
      return
    end

    local Date = require "orgmode.objects.date"

    -- Step 3: set LAST_REPEAT pada headline yang sudah fresh
    fresh_headline:set_property("LAST_REPEAT", Date.now():to_wrapped_string(false))

    -- Step 4: add state note
    local indent = fresh_headline:get_indent()
    local note = ("%s- State %-12s from %-12s [%s]"):format(indent, [["DONE"]], [["TODO"]], Date.now():to_string())
    fresh_headline:add_note { note }

    vim.cmd "silent! write"
  end)
end

---TAKEN from: orgmode.nvim
---Schedule a fold update for the given range. Call after buffer edits.
---OrgRange is 1-indexed; vim._foldupdate expects 0-indexed lines.
local function schedule_fold_update(range)
  local bufnr = vim.api.nvim_get_current_buf()
  vim.schedule(function()
    if not vim.api.nvim_buf_is_valid(bufnr) then
      return
    end
    local start_line = range.start_line - 1
    local end_line = math.min(range.end_line, vim.api.nvim_buf_line_count(bufnr))
    for _, win in ipairs(vim.fn.win_findbuf(bufnr)) do
      if vim.wo[win].foldmethod == "expr" then
        vim._foldupdate(win, start_line, end_line)
      end
    end
  end)
end

---@param tags string[]
local function remove_todo_by_tag(tags)
  Orgmode = setup_orgmode()
  local files = Orgmode.files

  local EventManager = require "orgmode.events"
  local events = EventManager.event

  if not files then
    return
  end

  local processed = {}

  for _, file in ipairs(files:all()) do
    for _, headline in ipairs(file:get_headlines()) do
      local todos = headline:get_todo()
      -- local title = headline:get_title()

      if not (todos and todos == "TODO") then
        goto continue_headline_loop
      end

      local has_matching_tag = false
      for _, tag in ipairs(tags) do
        if headline:has_tag(tag) then
          has_matching_tag = true
          break
        end
      end
      if not has_matching_tag then
        goto continue_headline_loop
      end

      local todo_schedule = headline:get_scheduled_date()
      if not todo_schedule or not todo_schedule.active then
        goto continue_headline_loop
      end

      local raw_date = todo_schedule:without_adjustments()
      local now = os.date "*t"

      local is_past = (raw_date.year < now.year)
        or (raw_date.year == now.year and raw_date.month < now.month)
        or (raw_date.year == now.year and raw_date.month == now.month and raw_date.day < now.day)

      local is_today = (raw_date.year == now.year) and (raw_date.month == now.month) and (raw_date.day == now.day)

      -- Ignore todo today if the scheduled time has not been reached yet
      local today_is_due = is_today
        and (
          not raw_date.hour -- tidak ada jam → anggap due
          or (raw_date.hour < now.hour)
          or (raw_date.hour == now.hour and (raw_date.min or 0) <= now.min)
        )

      local is_past_or_today = is_past or today_is_due

      if not is_past_or_today then
        goto continue_headline_loop
      end

      local repeater_dates = headline:get_repeater_dates()
      -- RUtils.info("  repeater_dates count: " .. tostring(#repeater_dates))
      if #repeater_dates == 0 then
        goto continue_headline_loop
      end

      local filename = file.filename
      local bufnr = get_or_create_bufnr(filename)
      if bufnr == nil then
        goto continue_headline_loop
      end

      local old_state = headline:get_todo()
      local was_done = headline:is_done()
      local range = headline:get_range()

      EventManager.dispatch(events.TodoChanged:new(headline, old_state, was_done))

      set_repeater_todo(bufnr, repeater_dates, headline)
      schedule_fold_update(range)

      table.insert(processed, {
        title = headline:get_title(),
        file = vim.fn.fnamemodify(filename, ":t"), -- hanya nama file, tanpa path penuh
        old_date = todo_schedule:without_adjustments():to_string(),
        new_date = repeater_dates[1]:apply_repeater():to_string(),
      })

      ::continue_headline_loop::
    end
  end

  if #processed == 0 then
    RUtils.info "No expired repeater tasks found"
  else
    local lines = { ("Processed %d repeater task(s):"):format(#processed) }
    for _, item in ipairs(processed) do
      table.insert(lines, ("  • [%s] %s"):format(item.file, item.title))
      table.insert(lines, ("    %s → %s"):format(item.old_date, item.new_date))
    end
    RUtils.info(table.concat(lines, "\n"))
  end
end

-- ─────────────────────────────────────────────────────────────────────────────
-- Public API
-- ─────────────────────────────────────────────────────────────────────────────

M.not_implement = not_implement

M.find_files_notes = find_files_org
M.live_grep = live_grep_org

M.filter_by_tags = get_tags
M.last_filter_by_tags = function()
  get_tags { last = true }
end

M.insert_tag = insert_tag_org

M.insert_backlinks = insert_backlinks_files

M.insert_title_local = function()
  insert_heading_title(false)
end

M.insert_title_global = function()
  insert_heading_title(true)
end

M.jump_heading_local = function()
  jump_to_heading(false)
end

M.jump_heading_global = function()
  jump_to_heading(true)
end

M.find_backlinks_local = function()
  find_url_and_backlinks(false)
end

M.find_backlinks_global = function()
  find_url_and_backlinks(true)
end

M.open_item_heading_vsplit = function()
  local data = get_headline_at_cursor()
  if not data then
    return
  end
  open_vsplit { filename = data.filename, lnum = data.lnum, col = data.col }
end

M.open_item_heading_split = function()
  local data = get_headline_at_cursor()
  if not data then
    return
  end
  open_split { filename = data.filename, lnum = data.lnum, col = data.col }
end

M.open_item_heading_tab = function()
  local data = get_headline_at_cursor()
  if not data then
    return
  end
  open_tab { filename = data.filename, lnum = data.lnum, col = data.col }
end

M.auto_remote_repeater_todo = function()
  -- NOTE: disarankan menggunakan tag yang di set di `#+filetags`,
  -- bukan pada heading TODO, jika menggunakan tag pada heading
  -- hasilnya kurang optimal, string bakal di apply pada incorrect line
  local tags = { "working", "workout" }
  remove_todo_by_tag(tags)
end

return M
