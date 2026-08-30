---@class r.utils.notes
local M = {
  note_mode = "org",
}

---@alias Mode_open "vsplit" | "split" | "tabe" | "default"
---@alias Opts_file {filename: string, col?: integer, lnum?: integer, title_str?: string }

-- Initial definition for setting up the note mode,
-- whether to use an org file or markdown
---@type "org" | "markdown" | "orgagenda"

local Orgmode, FzfluaBuiltin
local file_ignores, title_picker, icon_note, regex_url_backlinks, regex_title, rg_opts

-- ├─────────────────────────────────┤ SETUP ├──────────────────────────────┤
local function setup_orgmode()
  if Orgmode then
    return Orgmode
  end
  Orgmode = require "orgmode"
  return Orgmode
end

M.setup_orgmode = setup_orgmode

local function not_implement()
  RUtils.warn "not implemented yet"
end

---@param tbl table
local function clone_tbl(tbl)
  local t = {}
  for i, v in ipairs(tbl) do
    t[i] = v
  end
  return t
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
    prompt = RUtils.fzflua.padding_prompt(),
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
    icon_note = RUtils.config.icons.misc.markdown
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
  icon_note = RUtils.config.icons.misc.org
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
  regex_title = [[^\*\s|^\*+\s*[\w<`\?].*$]]
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
    RUtils.info("Note mode:`" .. M.note_mode .. "`")
  end
  return M.note_mode
end

-- ├──────────────────────────────────┤ TAGS ├──────────────────────────────────┤
---@param tag_locations obsidian.TagLocation[]
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
  local title_tbl =
    RUtils.fzflua.format_title(string.format("%s %s", title_picker, title), RUtils.strip_whitespaces(icon_note))
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
    RUtils.cmd.force_foldopen()

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
    local orgapi = require "orgmode.api.agenda"
    headline_opts = orgapi.get_headline_at_cursor()
    if not headline_opts then
      ---@diagnostic disable-next-line: undefined-field
      RUtils.warn "orgagenda: `headline_opts` is nil. Something went wrong."
      return
    end

    ---@diagnostic disable-next-line: invisible
    local item_section = headline_opts._section
    filename = item_section.file.filename

    lnum = headline_opts.position.start_line
    col = headline_opts.position.end_col
  elseif M.note_mode == "org" then
    local OrgHyperlink = require "orgmode.org.links.hyperlink"
    local OrgLinkUrl = require "orgmode.org.links.url"
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

      Orgmode = setup_orgmode()
      Orgmode.action "org_mappings.open_at_point"
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

      Orgmode = setup_orgmode()
      Orgmode.links:follow(link.url:to_string())
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

            local obsidian = require "obsidian"
            local api = obsidian.api
            api.open_note(items[1], open_strategy)
          else
            if mode_open then
              open(mode_open, { filename = filename, lnum = nil, col = nil })
            end
          end
        else
          require("obsidian").picker.pick(items, { prompt_title = "Resolve link" })
        end
      end,
    }
    return
  end

  if filename == nil then
    RUtils.warn "Target filename not found. Aborting."
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

local function find_files()
  local Fzflua = RUtils.fzflua.setup_fzflua()
  reset_vars()

  Fzflua.files {
    prompt = RUtils.fzflua.padding_prompt(),
    cwd = RUtils.config.path.wiki_path,
    file_ignore_patterns = file_ignores,
    rg_opts = table.concat(rg_opts, " "),
    winopts = { title = get_title_note "- Files" },
  }
end

local function live_grep()
  local Fzflua = RUtils.fzflua.setup_fzflua()
  reset_vars()

  return Fzflua.live_grep_glob {
    prompt = RUtils.fzflua.padding_prompt(),
    cwd = RUtils.config.path.wiki_path,
    rg_opts = table.concat(rg_opts, " "),
    winopts = { title = get_title_note "- Live grep" },
  }
end

local function live_grep_visual()
  reset_vars()

  local viz = RUtils.get_visual_selection { strict = true }
  if not viz then
    return
  end

  local Fzflua = RUtils.fzflua.setup_fzflua()
  return Fzflua.grep {
    prompt = RUtils.fzflua.padding_prompt(),
    query = string.format("%s", viz.selection),
    rg_glob = true,
    cwd = RUtils.config.path.wiki_path,
    rg_opts = table.concat(rg_opts, " "),
    winopts = { title = get_title_note "- Live grep visual" },
  }
end

-- Stores the last state for each custom picker
local last_state = {}

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
    RUtils.warn("There is no state name for `" .. name .. "`")
    return
  end

  last_state[name] = { contents = contents.tags, opts = vim.deepcopy(opts) }

  local Fzflua = RUtils.fzflua.setup_fzflua()

  if name == "search tags" then
    Fzflua.fzf_exec(contents.tags, RUtils.fzflua.open_center_medium(opts_fzf(opts)))
  else
    Fzflua.fzf_exec(contents.tags, RUtils.fzflua.open_cursor_dropdown(opts_fzf(opts)))
  end
end

local function resume_picker(name)
  local s = last_state[name]
  if not s then
    RUtils.warn("No cache for picker: `" .. name .. "`")
    return
  end
  s.opts.resume = true
  local Fzflua = RUtils.fzflua.setup_fzflua()
  Fzflua.fzf_exec(s.contents, s.opts)
end

local Mapping = {}

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
function Mapping.open_and_jump_to_file(filename, is_global)
  is_global = is_global or false
  local Fzflua = RUtils.fzflua.setup_fzflua()

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
function Mapping.insert_title(filename, is_global)
  is_global = is_global or false
  local Fzflua = RUtils.fzflua.setup_fzflua()

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
        local root = RUtils.config.path.wiki_path or ""

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

function Mapping.insert_backlinks()
  local Fzflua = RUtils.fzflua.setup_fzflua()
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

      local link
      if M.note_mode == "org" then
        link = string.format("[[%s][ %s]]", relative, label)
      elseif M.note_mode == "markdown" then
        local fname = vim.fn.fnamemodify(target_path, ":t")
        link = string.format("[%s](%s)", label, fname)
      end
      vim.api.nvim_put({ link }, "c", false, true)
    end,
  }
end

local match_tags
local set_global_agenda_files

---@param contents_tags table
function Mapping.open_tags(contents_tags)
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

      -- Temporarily swap ke full wiki path
      if M.note_mode == "org" then
        Orgmode = setup_orgmode()
        Orgmode.agenda:tags { match_query = match_tags }
      elseif M.note_mode == "markdown" then
        local function gather_tag_picker_list(tag_locations, tags)
          local entries = {}
          for _, tag_loc in ipairs(tag_locations) do
            for _, tag in ipairs(tags) do
              if tag_loc.tag:lower() == tag:lower() or vim.startswith(tag_loc.tag:lower(), tag:lower() .. "/") then
                local display = string.format("%s [%s] %s", tag_loc.note:display_name(), tag_loc.line, tag_loc.text)
                entries[#entries + 1] = {
                  value = { path = tag_loc.path, line = tag_loc.line, col = tag_loc.tag_start },
                  display = display,
                  ordinal = display,
                  filename = tostring(tag_loc.path),
                  lnum = tag_loc.line,
                  col = tag_loc.tag_start,
                }
                break
              end
            end
          end
          if vim.tbl_isempty(entries) then
            return
          end

          vim.schedule(function()
            Obsidian.picker.pick(entries, {
              prompt_title = "#" .. table.concat(tags, ", #"),
              actions = {
                ["default"] = function(selected, fzf_opts)
                  local entry_to_file = require("fzf-lua.path").entry_to_file
                  local path = entry_to_file(selected[1], fzf_opts).path
                  if not path then
                    return
                  end

                  RUtils.info(path)

                  -- if path_only then
                  --   opts.callback(path)
                  -- else
                  --   opts.callback { filename = path }
                  -- end
                  -- elseif not opts.no_default_mappings then
                  --   require("fzf-lua.actions").file_edit_or_qf(selected, fzf_opts)
                  -- end
                end,
              },
            })
          end)
        end

        gather_tag_picker_list(contents_tags.val, sel)
      end
    end,
  }
end

local scan = require "plenary.scandir"

local function extract_tags(line)
  local result = {}
  local pos = 1
  while true do
    local s, e, tag = line:find(":([%a][%w_@]+):", pos)
    if not s then
      break
    end
    result[#result + 1] = tag
    pos = e -- not e + 1! Reuse the closing ":" as the opening ":" for the next match.
  end
  return result
end

local function get_tags_from_path_async(path, callback)
  scan.scan_dir_async(path, {
    hidden = false,
    add_dirs = false,
    search_pattern = "%.org$",
    on_exit = function(files)
      vim.schedule(function()
        local tags = {}
        local seen = {}
        for _, file in ipairs(files) do
          local lines = vim.fn.readfile(file)
          for _, line in ipairs(lines) do
            if
              not line:match "^%s*SCHEDULED:"
              and not line:match "^%s*DEADLINE:"
              and not line:match "^%s*CLOSED:"
              and not line:match "^%s*:.*:$"
              and not line:match "<%d%d%d%d%-%d%d%-%d%d"
            then
              for _, tag in ipairs(extract_tags(line)) do
                if not seen[tag] then
                  seen[tag] = true
                  tags[#tags + 1] = tag
                end
              end
            end
          end
        end
        table.sort(tags)
        callback(tags)
      end)
    end,
  })
end

---@param opts? {last: boolean }
local function get_tags(opts)
  reset_vars()
  opts = opts or {}

  if M.note_mode == "orgagenda" then
    M.note_mode = "org"
  end

  if opts.last then
    if M.note_mode == "org" then
      resume_picker "search tags"
    elseif M.note_mode == "markdown" then
      resume_picker "search tags"
    end
    return
  end

  local contents_tags = { val = {}, tags = {} }

  if M.note_mode == "org" then
    local wiki_path = RUtils.config.path.wiki_path

    if not set_global_agenda_files then
      local orgfiles = wiki_path .. "/**/*.org"
      Orgmode = setup_orgmode()
      Orgmode.setup { org_agenda_files = orgfiles }
      set_global_agenda_files = true
    end

    get_tags_from_path_async(wiki_path, function(tags)
      contents_tags.tags = tags

      if #contents_tags.tags == 0 then
        RUtils.warn "No tags found."
        return
      end

      local fzfopts = {
        winopts = { title = get_title_note "- Search note by tags" },
        actions = Mapping.open_tags(contents_tags),
      }
      picker("search tags", contents_tags, fzfopts)
    end)
  elseif M.note_mode == "markdown" then
    local search = require "obsidian.search"
    search.find_tags_async("", function(tag_locations)
      contents_tags.tags = list_tags(tag_locations)
      contents_tags.val = tag_locations
      if #contents_tags.tags == 0 then
        RUtils.warn "No tags found."
        return
      end
      local fzfopts = {
        winopts = { title = get_title_note "- Search note by tags", preview = { hidden = true } },
        actions = Mapping.open_tags(contents_tags),
      }
      picker("search tags", contents_tags, fzfopts)
    end)
  end
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
local function grep(is_global, target_file, opts)
  opts = opts or {}

  local clone_rg_opts = clone_tbl(rg_opts)
  table.insert(clone_rg_opts, target_file)
  table.insert(clone_rg_opts, "-e")

  local function Preview_buffer_fzflua(fn)
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

  local previewer = Preview_buffer_fzflua(function(entry)
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

  local Fzflua = RUtils.fzflua.setup_fzflua()
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

  if M.note_mode == "orgagenda" then
    M.note_mode = "org"
  end

  if opts.last then
    if M.note_mode == "org" then
      resume_picker "insert tags"
    elseif M.note_mode == "markdown" then
      resume_picker "insert tags"
    end
    return
  end

  local contents_tags = { val = {}, tags = {} }

  local optsfzf = {
    winopts = { title = get_title_note "- insert tag" },
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

  if M.note_mode == "org" then
    Orgmode = setup_orgmode()
    contents_tags.tags = Orgmode.files:get_tags()
    if not contents_tags.tags or #contents_tags.tags == 0 then
      return
    end
    picker("insert tags", contents_tags, optsfzf)
  elseif M.note_mode == "markdown" then
    local search = require "obsidian.search"
    search.find_tags_async("", function(tag_locations)
      contents_tags.tags = list_tags(tag_locations)
      contents_tags.val = tag_locations
      if not contents_tags.tags or #contents_tags.tags == 0 then
        return
      end
      picker("insert tags", contents_tags, optsfzf)
    end)
    return
  end
end

---@param is_global boolean?
local function find_url_and_backlinks(is_global)
  is_global = is_global or false
  reset_vars()

  local target_file = get_target_file(is_global)
  grep(is_global, target_file, {
    winopts = { title = get_title_note "- Backlinks / URLs" },
    search = regex_url_backlinks,
    actions = Mapping.open_and_jump_to_file(target_file, is_global),
  })
end

---@param is_global? boolean
local function find_backlinks(is_global)
  is_global = is_global or false
  reset_vars()

  if M.note_mode == "markdown" then
    vim.cmd "Obsidian backlinks"
  elseif M.note_mode == "org" then
    not_implement()
  end
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
  grep(is_global, target_file, {
    winopts = { title = get_title_note(__title) },
    search = regex_title,
    actions = Mapping.open_and_jump_to_file(target_file, is_global),
  })
end

local function insert_backlinks_files()
  reset_vars()

  local Fzflua = RUtils.fzflua.setup_fzflua()
  Fzflua.files {
    prompt = RUtils.fzflua.padding_prompt(),
    cwd = RUtils.config.path.wiki_path,
    file_ignore_patterns = file_ignores,
    winopts = { title = get_title_note "- Insert Backlinks" },
    actions = Mapping.insert_backlinks(),
  }
end

-- ┏╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┓
-- ╏                                     API                                     ╏
-- ┗╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┛
M.swith_note_mode = swith_note_mode
M.get_note_mode = M.note_mode

-- ═══════════════════════════════════ Picker ═══════════════════════════════════
M.find_files_notes = find_files
M.live_grep = live_grep
M.live_grep_visual = live_grep_visual

M.filter_by_tags = get_tags
M.last_filter_by_tags = function()
  get_tags { last = true }
end

-- ═══════════════════════════════════ Insert ═══════════════════════════════════
M.insert_tag = insert_tag
M.last_insert_tag = function()
  insert_tag { last = true }
end

M.insert_backlinks = insert_backlinks_files
M.insert_title_local = function()
  insert_heading_title(false)
end
M.insert_title_global = function()
  insert_heading_title(true)
end

-- ════════════════════════════════════ Jump ════════════════════════════════════
M.jump_heading_local = function()
  jump_to_heading(false)
end
M.jump_heading_global = function()
  jump_to_heading(true)
end

-- ════════════════════════════════════ Find ════════════════════════════════════
M.find_backlinks_local = function()
  find_backlinks()
end
M.find_backlinks_global = function()
  find_backlinks(true)
end
M.find_url_and_backlinks_local = function()
  find_url_and_backlinks(false)
end
M.find_url_and_backlinks_global = function()
  find_url_and_backlinks(true)
end

-- ════════════════════════════════════ Open ════════════════════════════════════
M.open_item_heading_vsplit = function()
  local mode_open = "vsplit"
  local data = get_headline_at_cursor(mode_open)
  if not data then
    return
  end
  open(mode_open, data)
end
M.open_item_heading_split = function()
  local mode_open = "split"
  local data = get_headline_at_cursor(mode_open)
  if not data then
    return
  end
  open(mode_open, data)
end
M.open_item_heading_tab = function()
  local mode_open = "tabe"
  local data = get_headline_at_cursor(mode_open)
  if not data then
    return
  end
  open(mode_open, data)
end
M.open_item_heading_default = function()
  local mode_open = "default"
  local data = get_headline_at_cursor(mode_open)

  if not data then
    return
  end

  open(mode_open, data)
end

-- +-----------------------------------------------------------------------------+
-- |                                SPECIFIC: ORG                                |
-- +-----------------------------------------------------------------------------+

---@param filename string
local function get_or_create_bufnr(filename)
  local bufnr = vim.fn.bufnr(filename)
  if bufnr == -1 then
    -- Buffer not exist, create it without loading
    bufnr = vim.fn.bufadd(filename)
  end
  vim.fn.bufload(bufnr) -- load isi file ke memory
  return bufnr
end

---@param bufnr integer
local function set_repeater_todo(bufnr, repeater_dates, headline)
  Orgmode = setup_orgmode()
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

    local file = Orgmode.files:get(vim.api.nvim_buf_get_name(bufnr))
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

      EventManager.dispatch(events.TodoChanged:new(headline, old_state, was_done))
      set_repeater_todo(bufnr, repeater_dates, headline)

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

M.auto_remote_repeater_todo = function()
  -- NOTE: disarankan menggunakan tag yang di set di `#+filetags`,
  -- bukan pada heading TODO, jika menggunakan tag pada heading
  -- hasilnya kurang optimal, string bakal di apply pada incorrect line
  local tags = { "working", "workout" }
  remove_todo_by_tag(tags)
end

return M
