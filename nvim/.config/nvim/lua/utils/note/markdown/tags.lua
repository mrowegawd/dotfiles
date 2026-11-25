local file_ignores, title_picker, regex_url_backlinks, regex_title, rg_opts

-- ├─────────────────────────────────┤ SETUP ├──────────────────────────────┤

local function not_implement()
  Log.warn "not implemented yet"
end

---@param tbl table
local function clone_tbl(tbl)
  local t = {}
  for i, v in ipairs(tbl) do
    t[i] = v
  end
  return t
end

local match_tags
local set_global_agenda_files

local org_pgk = {
  org = {
    path_global_wiki = string.format("%s/**/**/*", wiki_path),
    path_local_wiki = string.format("%s/orgmode/**/**/*", ConfigPath.wiki_path),
    search_tag = function(t)
      lazy("org.tags").set_tags(nil, { t })
    end,
    collect_tags = function()
      local files = lazy "org.files"
      local _tags = {}
      for _, f in ipairs(files.agenda_files()) do
        for _, x in ipairs(f.headlines) do
          local tags = x:get_tags()
          if vim.tbl_isempty(tags) then
            goto continue
          end
          for _, t in ipairs(tags) do
            table.insert(_tags, t)
          end
          ::continue::
        end
      end
      contents_tags.tags = lazy("utils.cmd").remove_duplicates_table(_tags)
    end,
    set_agenda_dir = function(path)
      local opts_ = lazy("org.config").opts
      opts_.agenda_files = { path }
    end,
  },
  orgmode = {
    path_global_wiki = string.format("%s/**/**/*", wiki_path),
    path_local_wiki = string.format("%s/orgmode/**/**/*", ConfigPath.wiki_path),
    search_tag = function(tag)
      Org.agenda:tags { match_query = tag }
    end,
    collect_tags = function()
      contents_tags.tags = {}
    end,
    set_agenda_dir = function(path)
      Org.setup { org_agenda_files = path }
    end,
  },
}

local org = org_pgk[M.note_mode]

---@param notify boolean?
---@param is_set boolean?
function M.toggle_agenda_dir(notify, is_set)
  notify = notify or false
  is_set = is_set or false

  if set_global_agenda_files or is_set then
    org.set_agenda_dir(org.path_local_wiki)
    set_global_agenda_files = false
  else
    org.set_agenda_dir(org.path_global_wiki)
    set_global_agenda_files = true
  end

  if notify then
    Log.info("Agenda dir changed to: " .. (set_global_agenda_files and "global" or "minimal"))
  end
end

---@param tbl table
---@param element string
local function check_duplicate_element_data_tags(tbl, element)
  for _, x in pairs(tbl) do
    if x["text"] == element then
      return true
    end
  end
  return false
end

---@param opts {}
local function opts_fzf(opts)
  return {
    winopts = opts.winopts,
    actions = opts.actions,
    fzf_opts = opts.fzf_opts,
  }
end

-- ├─────────────────────────────────┤ RESET ├──────────────────────────────┤
local function reset_vars()
  if M.note_mode == "markdown" then
    title_picker = "Markdown"
    file_ignores = { "%.norg$", "%.json$", "%.org$", "%.png$" }
    rg_opts = {
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
      "--type=md",
    }
    regex_title = [[^#{1,}\s\w.*$]]
    regex_url_backlinks = [[http|\[\[]]
    return
  end

  title_picker = "Orgmode"
  file_ignores = { "%.norg$", "%.json$", "%.md$", "%.png$", "%.txt$", "%.toml$", "%.css$", "%.sh$", "%.bak$", "%.lua$" }
  rg_opts = {
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
    "--type=org",
  }
  regex_url_backlinks = [[http|\[\[]]
  regex_title = [[^\*\s|^\*+\s*[\w<`~\?].*$]]
end

---@param force_set string
---@return "markdown" | "org" |"orgagenda"
local function swith_note_mode(force_set)
  if M.note_mode == "markdown" then
    M.note_mode = "org"
  else
    M.note_mode = "markdown"
  end

  if force_set then
    M.note_mode = force_set
  end

  if M.note_mode ~= force_set then
    Log.info("Note mode:`" .. M.note_mode .. "`")
  end
  return M.note_mode
end

-- ├──────────────────────────────────┤ TAGS ├──────────────────────────────────┤
---@return string[]
local list_tags = function(tag_locations)
  local tags = {}
  for _, tag_loc in ipairs(tag_locations) do
    local tag = tag_loc.tag
    if not tags[tag] then
      tags[tag] = true
    end
  end
  return vim.tbl_keys(tags)
end

-- ├──────────────────────────────────┤ FIND ├──────────────────────────────────┤
---@param title string?
local function get_title_note(title)
  title = title or ""
  local title_tbl = string.format("%s %s", title_picker, title)
  if not title_tbl then
    return
  end
  return title_tbl
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

-- ├───────────────────────────────┤ MODE OPEN ├────────────────────────────┤
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

  if opts_file.lnum and opts_file.col then
    vim.api.nvim_win_set_cursor(0, { opts_file.lnum, opts_file.col })
  else
    local set_cursor_position = vim.api.nvim_buf_get_mark(0, '"')
    pcall(vim.api.nvim_win_set_cursor, 0, set_cursor_position)
  end

  vim.schedule(function()
    lazy("utils.cmd").force_foldopen()

    local row = vim.fn.winline()
    local height = vim.api.nvim_win_get_height(0)

    if row > height * 0.8 then
      vim.cmd "normal! zt"
    end
  end)
end

---@param opts_file Opts_file
local function open_vsplit(opts_file)
  open("vsplit", opts_file)
end

---@param opts_file Opts_file
local function open_split(opts_file)
  open("split", opts_file)
end

---@param opts_file Opts_file
local function open_tab(opts_file)
  open("tabe", opts_file)
end

---@param opts_file Opts_file
local function open_default(opts_file)
  open("default", opts_file)
end

---@param mode_open? string
local function get_headline_at_cursor(mode_open)
  local filename, headline_opts, lnum, col

  if M.note_mode == "orgagenda" then
    local orgapi = lazy "orgmode.api.agenda"
    headline_opts = orgapi.get_headline_at_cursor()
    if not headline_opts then
      Log.warn "orgagenda: `headline_opts` is nil. Something went wrong."
      return
    end

    ---@diagnostic disable-next-line: invisible
    local item_section = headline_opts._section
    filename = item_section.file.filename

    lnum = headline_opts.position.start_line
    col = headline_opts.position.end_col
  elseif M.note_mode == "org" then
    local OrgHyperlink = lazy "orgmode.org.links.hyperlink"
    local OrgLinkUrl = lazy "orgmode.org.links.url"
    local link = OrgHyperlink.at_cursor()
    if not link then
      return
    end

    local file = link.url:to_string()
    local org_link_url = OrgLinkUrl:new(file)

    -- To resolve the target heading in a link (e.g. 'path/to/org:*some heading'),
    -- Orgmode exposes it via `.target`, so we can use that here.
    if org_link_url.target and #org_link_url.target > 0 then
      if mode_open then
        if mode_open == "tabe" then
          vim.cmd "tabe %"
        elseif mode_open == "default" then
          vim.cmd "e %"
        else
          vim.cmd(mode_open)
        end
      end

      Org.action "org_mappings.open_at_point"
      return
    end

    -- Resolve the target heading when targeting the current buffer.
    if link then
      if mode_open then
        if mode_open == "tabe" then
          vim.cmd "tabe %"
        elseif mode_open == "default" then
          vim.cmd "e %"
        else
          vim.cmd(mode_open)
        end
      end

      Org.links:follow(link.url:to_string())
      return
    end

    filename = org_link_url:get_real_path()
  elseif M.note_mode == "markdown" then
    ---@param items table[]
    ---@return table[]
    local function dedupe_items(items)
      local seen = {}
      local result = {}
      for _, item in ipairs(items) do
        local key = item.filename or item.uri
        if key and not seen[key] then
          seen[key] = true
          result[#result + 1] = item
        end
      end
      return result
    end

    vim.lsp.buf.definition {
      on_list = function(t)
        local items = dedupe_items(t.items)
        if #items == 1 then
          filename = items[1].filename

          if vim.startswith(items[1].text, "#") then
            local open_strategy = mode_open
            if open_strategy == "default" then
              open_strategy = "e"
            elseif open_strategy == "tabe" then
              vim.cmd "tabe %"
              open_strategy = "e"
            end

            -- NOTE: It's not possible to open a heading with the desired `mode_open`
            -- when the heading is located in the current file. This is caused by the
            -- behavior of `api.open_note`, even if `mode_open` is called directly, like this:
            -- local bufname = vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf())
            -- if bufname == filename then
            --   if mode_open == "tabe" then
            --     vim.cmd "tabe %"
            --   else
            --     vim.cmd(mode_open)
            --   end
            -- end

            local obsidian = lazy "obsidian"
            local api = obsidian.api
            api.open_note(items[1], open_strategy)
          else
            if mode_open then
              open(mode_open, { filename = filename, lnum = nil, col = nil })
            end
          end
        else
          lazy("obsidian").picker.pick(items, { prompt_title = "Resolve link" })
        end
      end,
    }
    return
  end

  if filename == nil then
    Log.warn "Target filename not found. Aborting."
    return
  end

  return {
    filename = filename,
    lnum = lnum,
    col = col,
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

-- local function find_files()
--   reset_vars()
--
--   Fzflua.files {
--     cwd = ConfigPath.wiki_path,
--     file_ignore_patterns = file_ignores,
--     rg_opts = table.concat(rg_opts, " "),
--     winopts = { title = get_title_note "- Files" },
--   }
-- end

-- local function live_grep()
--   reset_vars()
--
--   return Fzflua.live_grep {
--     cwd = ConfigPath.wiki_path,
--     rg_opts = table.concat(rg_opts, " "),
--     winopts = { title = get_title_note "- Live grep" },
--   }
-- end

local function live_grep_visual()
  reset_vars()

  local viz = lazy("utils.cmd").get_selection()
  return Fzflua.grep {
    query = string.format("%s", viz),
    rg_glob = true,
    cwd = ConfigPath.path.wiki_path,
    rg_opts = table.concat(rg_opts, " "),
    winopts = { title = get_title_note "- Live grep visual" },
  }
end

local state_name = {
  ["search tags"] = true,
  ["insert tags"] = true,
}

---@param name string -- id picker with name
---@param contents table
---@param opts table
local function picker(name, contents, opts)
  opts = opts or {}
  if not state_name[name] then
    Log.warn("There is no state name for `" .. name .. "`")
    return
  end

  last_state[name] = { contents = contents.tags, opts = vim.deepcopy(opts) }

  if name == "search tags" then
    Fzflua.fzf_exec(contents.tags, opts_fzf(opts))
  else
    Fzflua.fzf_exec(contents.tags, opts_fzf(opts))
  end
end

local Mapping = {}

---@param selected table|string
---@param filename string
---@param is_global boolean?
---@return Opts_file|nil
-- local function extract_str_title(selected, filename, is_global)
--   is_global = is_global or false
--
--   local sel
--   if type(selected) == "table" then
--     sel = lazy("utils.cmd").__strip_str(selected[1])
--   end
--
--   if type(selected) == "string" then
--     sel = lazy("utils.cmd").__strip_str(selected)
--   end
--
--   if not sel then
--     return
--   end
--
--   local sel_slice = vim.split(sel, ":")
--
--   local lnum, col, title_str
--
--   if is_global then
--     lnum = tonumber(sel_slice[2]) or 1
--     col = tonumber(sel_slice[3]) or 1
--     title_str = sel_slice[4]:gsub("*", "") or ""
--   else
--     lnum = tonumber(sel_slice[1]) or 1
--     col = tonumber(sel_slice[2]) or 1
--     title_str = sel_slice[3]:gsub("*", "") or ""
--   end
--
--   local file_opts = {
--     filename = filename,
--     lnum = lnum,
--     col = col,
--     title_str = lazy("utils.cmd").strip_whitespaces(title_str),
--   }
--
--   return file_opts
-- end

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
function Mapping.open_and_jump_to_file(filename, is_global)
  is_global = is_global or false

  return {
    ["default"] = function(selected, _)
      if is_global then
        local e = Fzflua.path.entry_to_file(selected[1])
        local path = e.path
        if path then
          filename = path
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
        local path = e.path
        if path then
          filename = path
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
        local path = e.path
        if path then
          filename = path
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
        local path = e.path
        if path then
          filename = path
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
      lazy("utils.qf").save_to_qf_and_auto_open_qf(list_items)
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

        lazy("utils.qf").save_to_qf_and_auto_open_qf(list_items)
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
      lazy("utils.qf").save_to_qf_and_auto_open_qf(list_items, true)
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

        lazy("utils.qf").save_to_qf_and_auto_open_qf(list_items, true)
      end,
    },
  }
end

---@param filename string
---@param is_global boolean?
function Mapping.insert_title(filename, is_global)
  is_global = is_global or false

  local icon_prefix = is_global and "🔗" or " "

  return {
    ["default"] = function(selected, _)
      local file_opts = extract_str_title(selected, filename, is_global)
      if not file_opts then
        return
      end

      local fmt_str

      local title
      if M.note_mode == "org" then
        title = file_opts.title_str
      elseif M.note_mode == "markdown" then
        title = file_opts.title_str:gsub("^#+%s*", "")
      end

      if not is_global then
        if M.note_mode == "org" then
          fmt_str = "[[*" .. title .. "][" .. icon_prefix .. title .. "]]"
        elseif M.note_mode == "markdown" then
          fmt_str = "[[#" .. title .. "]]"
        end
      else
        local e = Fzflua.path.entry_to_file(selected[1])
        local target_path = e and e.path or nil
        local root = ConfigPath.wiki_path or ""

        if target_path and root then
          target_path = realpath(target_path) or ""
          root = realpath(root) or ""

          local current_file = realpath(vim.api.nvim_buf_get_name(0)) or ""

          if (#current_file > 1) and target_path then
            if vim.startswith(current_file, root) and vim.startswith(target_path, root) then
              local current_dir = vim.fs.dirname(current_file)
              local relative = relative_path(current_dir, target_path)
              relative = M.note_mode == "org" and relative or vim.fn.fnamemodify(relative, ":t:r")

              if relative then
                if M.note_mode == "org" then
                  fmt_str = "[[./" .. relative .. "::*" .. title .. "][" .. icon_prefix .. title .. "]]"
                elseif M.note_mode == "markdown" then
                  fmt_str = "[[" .. relative .. "#" .. title .. "]]"
                end
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

-- local function scan()
--   local ok, s = pcall(require, "plenary.scandir")
--   if not ok then
--     return nil
--   end
--
--   return s
-- end

-- local function extract_tags(line)
--   local result = {}
--   local pos = 1
--   while true do
--     local s, e, tag = line:find(":([%a][%w_@]+):", pos)
--     if not s then
--       break
--     end
--     result[#result + 1] = tag
--     pos = e -- not e + 1! Reuse the closing ":" as the opening ":" for the next match.
--   end
--   return result
-- end

-- local function get_tags_from_path_async(path, callback)
--   local _scan = scan()
--   if not _scan then
--     return
--   end
--
--   _scan.scan_dir_async(path, {
--     hidden = false,
--     add_dirs = false,
--     search_pattern = "%.org$",
--     on_exit = function(files)
--       vim.schedule(function()
--         local tags = {}
--         local seen = {}
--         for _, file in ipairs(files) do
--           local lines = vim.fn.readfile(file)
--           for _, line in ipairs(lines) do
--             if
--               not line:match "^%s*SCHEDULED:"
--               and not line:match "^%s*DEADLINE:"
--               and not line:match "^%s*CLOSED:"
--               and not line:match "^%s*:.*:$"
--               and not line:match "<%d%d%d%d%-%d%d%-%d%d"
--             then
--               for _, tag in ipairs(extract_tags(line)) do
--                 if not seen[tag] then
--                   seen[tag] = true
--                   tags[#tags + 1] = tag
--                 end
--               end
--             end
--           end
--         end
--         table.sort(tags)
--         callback(tags)
--       end)
--     end,
--   })
-- end

---@param is_global boolean
local function get_target_file(is_global)
  local fnames = __define_tbl_paths()

  local target_file = fnames.path_merge_str
  if is_global then
    target_file = ConfigPath.wiki_path
  end
  return target_file
end

---@param is_global boolean
---@param target_file string
---@param opts table?
local function grep(is_global, target_file, opts)
  opts = opts or {}

  local clone_rg_opts = clone_tbl(rg_opts)
  table.insert(clone_rg_opts, target_file)
  table.insert(clone_rg_opts, "-e")

  local function Preview_buffer_fzflua(fn)
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

  local previewer = Preview_buffer_fzflua(function(entry)
    local data = {}

    local entry_strip_ansi = lazy("utils.cmd").__strip_str(entry)
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
    winopts = { title = get_title_note "- Notes" },
    previewer = previewer,
    rg_glob = false,
    no_esc = true,
    file_ignore_patterns = file_ignores,
    rg_opts = table.concat(clone_rg_opts, " "),
  }, opts)

  Fzflua.grep(fzfopts)
end

---@param is_global boolean?
local function insert_heading_title(is_global)
  is_global = is_global or false
  reset_vars()

  local target_file = get_target_file(is_global)

  local title_a = "Local"
  if is_global then
    title_a = "Global"
  end
  local __title = "- Insert " .. title_a .. " Title"

  grep(is_global, target_file, {
    winopts = { title = get_title_note(__title) },
    search = regex_title,
    actions = Mapping.insert_title(target_file, is_global),
  })
end

---@param opts? {last: boolean }
local function insert_tag(opts)
  reset_vars()
  opts = opts or {}

  -- if M.note_mode == "orgagenda" then
  --   M.note_mode = "org"
  -- end

  -- if opts.last then
  --   if M.note_mode == "org" then
  --     resume_picker "insert tags"
  --   elseif M.note_mode == "markdown" then
  --     resume_picker "insert tags"
  --   end
  --   return
  -- end

  -- local optsfzf = {
  --   winopts = { title = get_title_note "- insert tag" },
  --   actions = {
  --     ["default"] = function(selection)
  --       if selection == nil then
  --         return
  --       end
  --
  --       local sel = selection[1]
  --       if not sel then
  --         return
  --       end
  --
  --       vim.api.nvim_put({ sel }, "c", false, true)
  --     end,
  --   },
  -- }

  if M.note_mode == "org" then
    if not set_global_agenda_files then
      -- Log.info "set to global dir"
      org.set_agenda_dir(org.path_global_wiki)
    end

    -- Log.info "hello bro"
    vim.cmd "Org pick_set_tags"
    -- local tags = lazy "org.tags"
    -- local counts, defined = {}, {}
    --
    -- local function define(defs)
    --   for _, d in ipairs(defs or {}) do
    --     if type(d) == "table" and d.name and not d.name:match "^[{}]" then
    --       defined[d.name] = true
    --     end
    --   end
    -- end
    --
    -- pcall(function()
    --   define(tags.option_definitions())
    -- end)
    --
    -- for _, f in ipairs(lazy("org.files").agenda_files()) do
    --   pcall(function()
    --     define(f:tag_definitions())
    --   end)
    --
    --   for _, t in ipairs(f.settings.filetags or {}) do
    --     counts[t] = (counts[t] or 0) + 1
    --   end
    --
    --   for _, hl in ipairs(f.headlines) do
    --     for _, t in ipairs(hl.tags) do
    --       counts[t] = (counts[t] or 0) + 1
    --     end
    --   end
    -- end
    --
    -- local names = {}
    -- for k in pairs(counts) do
    --   names[#names + 1] = k
    -- end
    -- for k in pairs(defined) do
    --   if not counts[k] then
    --     names[#names + 1] = k
    --   end
    -- end
    --
    -- table.sort(names)
    -- contents_tags.tags = names
    --
    -- if not contents_tags.tags or #contents_tags.tags == 0 then
    --   return
    -- end
    -- picker("insert tags", contents_tags, optsfzf)
    org.set_agenda_dir(org.path_local_wiki)
    -- elseif M.note_mode == "markdown" then
    --   local search = lazy "obsidian.search"
    --   search.find_tags_async("", function(tag_locations)
    --     contents_tags.tags = list_tags(tag_locations)
    --     contents_tags.val = tag_locations
    --     if not contents_tags.tags or #contents_tags.tags == 0 then
    --       return
    --     end
    --     picker("insert tags", contents_tags, optsfzf)
    --   end)
    --   return
  end
end
