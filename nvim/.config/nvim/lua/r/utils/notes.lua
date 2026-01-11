---@class r.utils.notes
local M = {}

-- Initial definition for setting up the note mode,
-- whether to use an org file or markdown
---@type "org" | "markdown"
local note_mode = "org"

local Orgmode, Fzflua, file_ignores, title_picker, icon_note

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
else
  file_ignores = file_ignore_patterns_orgmode
  title_picker = title_picker_orgmode
  icon_note = icon_orgmode
  rg_opts[#rg_opts + 1] = "--type=org"
end

---@param title string?
local function get_title_note(title)
  title = title or ""
  return RUtils.fzflua.format_title(string.format("%s %s", title_picker, title), RUtils.strip_whitespaces(icon_note))
end

local function not_implement()
  RUtils.warn "not implemented yet"
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

---@param is_live_grep boolean?
function M.grep_title(is_live_grep)
  is_live_grep = is_live_grep or false

  local _, scan = load_plenary_plugin()
  local org_backup, _ = get_tbl_backup_and_todos(scan)

  local extract_str_rg = function(tbl)
    local newtbl = {}
    for _, x in pairs(tbl) do
      newtbl[#newtbl + 1] = x.full_path
    end
    return newtbl
  end

  local regex_title = [[^\*{1,}\s[\w<`].*$]]
  local cas = extract_str_rg(org_backup)

  local rg_opts_title = [[--column --line-number --hidden --no-heading --ignore-case --smart-case --color=always --max-columns=4096 ]]
    .. table.concat(cas, " ")
    .. " -e "

  Fzflua = setup_fzflua()

  if is_live_grep then
    return Fzflua.live_grep {
      no_esc = true,
      rg_glob = false,
      rg_opts = rg_opts_title,
      winopts = {
        title = RUtils.fzflua.format_title("Orgmode > Grep", RUtils.strip_whitespaces(RUtils.config.icons.misc.fire)),
      },
    }
  end

  return Fzflua.grep {
    no_esc = true,
    rg_glob = false,
    rg_opts = rg_opts_title,
    search = regex_title,
    winopts = {
      fullscreen = false,
      title = RUtils.fzflua.format_title(
        "Orgmode > Jump Global Title",
        RUtils.strip_whitespaces(RUtils.config.icons.misc.fire)
      ),
    },
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

local function get_tags()
  Orgmode = setup_orgmode()
  -- RUtils.info(vim.inspect(orgmode.files:get_tags()))
  -- RUtils.info(vim.inspect(orgmode.files:all()))
  -- RUtils.info(vim.inspect(result:check {}))
  local contents_tags = Orgmode.files:get_tags()
  if #contents_tags == 0 then
    return
  end

  local opts = {
    winopts = {
      title = get_title_note "- Search note by tags",
    },
    actions = {
      ["default"] = function(selection)
        if selection == nil then
          return
        end

        local sel = selection[1]
        if not sel then
          return
        end

        Orgmode.agenda:tags {
          match_query = sel,
          -- org_agenda_todo_ignore_scheduled =
          -- org_agenda_todo_ignore_deadlines =
        }
      end,
    },
  }

  Fzflua = setup_fzflua()
  Fzflua.fzf_exec(contents_tags, RUtils.fzflua.open_center_medium(opts_fzf(opts)))
end

local function find_files_org()
  Fzflua = setup_fzflua()
  Fzflua.files {
    prompt = RUtils.fzflua.padding_prompt(),
    cwd = RUtils.config.path.wiki_path,
    file_ignore_patterns = file_ignores,
    rg_opts = table.concat(rg_opts, " "),
    winopts = {
      title = get_title_note "- Files",
    },
  }
end

local function live_grep_org()
  Fzflua = setup_fzflua()
  return Fzflua.live_grep_glob {
    prompt = RUtils.fzflua.padding_prompt(),
    cwd = RUtils.config.path.wiki_path,
    rg_opts = table.concat(rg_opts, " "),
    winopts = {
      title = get_title_note "- Live grep",
    },
  }
end

local function insert_tag_org()
  Orgmode = setup_orgmode()
  local contents_tags = Orgmode.files:get_tags()
  if #contents_tags == 0 then
    return
  end

  local opts = {
    winopts = {
      title = get_title_note "- Search note by tags",
    },
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

---@param is_global boolean?
local function jump_to_heading(is_global)
  is_global = is_global or false

  local fnames = __define_tbl_paths()

  RUtils.info(vim.inspect(fnames))

  Fzflua = setup_fzflua()
  Fzflua.grep {
    prompt = RUtils.fzflua.padding_prompt(),
    cwd = RUtils.config.path.wiki_path,
    -- search = is_markdown_file(filename) and regex_title or regex_title_org,
    rg_glob = false,
    no_esc = true,
    -- file_ignore_patterns = { "%.norg$", "%.json$", vim.bo.filetype == "markdown" and "%.org$" or "%.md$" },
    -- rg_opts = [[--column --hidden --no-heading --ignore-case --smart-case --color=always --max-columns=4096 -g "*.md" ]],
    file_ignore_patterns = { "%.norg$", "%.json$", "%.org$" },
    -- winopts = {
    --   title = format_prompt_strings "Jump Global Title",
    --   fullscreen = false,
    --   height = 0.90,
    --   width = 0.90,
    --   row = 0.50,
    --   col = 0.50,
    -- },
  }

  -- vim.cmd "normal! zRzz" -- open all closed fold (but it doesnt work)
end

---@class NotesCmdsObjt
---@field filter_by_tags fun()
---@field find_files_notes fun()
---@field find_curbuf_title_notes fun()
---@field find_global_title_notes fun()
---@field find_backlinks fun()
---@field find_curbuf_links fun()
---@field find_global_links fun()
---@field live_grep fun()
---@field insert_title_curbuf fun()
---@field insert_title_global fun()
---@field insert_tags fun()

---@type table<"org" | "markdown", NotesCmdsObjt>
local get_cmds = {
  ["org"] = {
    filter_by_tags = function()
      get_tags()
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
    find_backlinks = function()
      not_implement()
    end,
    find_curbuf_links = function()
      not_implement()
    end,
    find_global_links = function()
      not_implement()
    end,
    live_grep = function()
      live_grep_org()
    end,
    insert_title_curbuf = function()
      not_implement()
    end,
    insert_title_global = function()
      not_implement()
    end,
    insert_tags = function()
      insert_tag_org()
    end,
  },
  ["markdown"] = {
    filter_by_tags = function()
      RUtils.markdown.find_note_by_tag()
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
    find_backlinks = function()
      not_implement()
    end,
    find_curbuf_links = function()
      not_implement()
    end,
    find_global_links = function()
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

function M.find_files_notes()
  return call_cmd "find_files_notes"()
end

function M.find_local_title()
  return call_cmd "find_curbuf_title_notes"()
end

function M.find_global_title()
  return call_cmd "find_global_title_notes"()
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

---@param mode_open "vsplit" | "split" | "tabe" | "default"
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

  vim.cmd(mode_open .. " " .. headline_opts.filename)
  vim.api.nvim_win_set_cursor(0, { headline_opts.lnum, headline_opts.col })

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
    winopts = {
      title = RUtils.config.icons.misc.pencil .. " OrgFiles",
    },
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
