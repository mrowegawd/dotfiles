local M = {}

local lazy = require("utils.plugin").require_lazy

local Log = lazy "utils.log"

local Config = lazy "config"
local ConfigPath = Config.path
local wiki_path = ConfigPath.wiki_path

local NoteUtils = lazy "utils.note.note_utils"

local find = lazy "utils.note.org.find"
local tags = lazy "utils.note.org.tags"
local link = lazy "utils.note.org.link"

local note_provider = "Org"

local set_global_agenda_files

local function get_data()
  return {
    file_ignores = {
      "%.norg$",
      "%.json$",
      "%.md$",
      "%.png$",
      "%.txt$",
      "%.toml$",
      "%.css$",
      "%.sh$",
      "%.bak$",
      "%.lua$",
    },
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
    },
    regex_url_backlinks = [[\[\[http|\[\[]],
    regex_title = [[^\*\s|^\*+\s.*$]],
  }
end

local base = get_data()

local org = {
  path_global_wiki = string.format("%s/**/**/*", wiki_path),
  path_local_wiki = string.format("%s/orgmode/**/**/*", ConfigPath.wiki_path),
  search_tag = function(t)
    lazy("org.tags").set_tags(nil, { t })
  end,
  -- collect_tags = function()
  --   local files = lazy "org.files"
  --   local _tags = {}
  --   for _, f in ipairs(files.agenda_files()) do
  --     for _, x in ipairs(f.headlines) do
  --       local tags = x:get_tags()
  --       if vim.tbl_isempty(tags) then
  --         goto continue
  --       end
  --       for _, t in ipairs(tags) do
  --         table.insert(_tags, t)
  --       end
  --       ::continue::
  --     end
  --   end
  --   contents_tags.tags = lazy("utils.cmd").remove_duplicates_table(_tags)
  -- end,
  set_agenda_dir = function(path)
    local opts_ = lazy("org.config").opts
    opts_.agenda_files = { path }
  end,
}

M.todo = {
  remove_repeater_todo = function(opts)
    require("utils.note.org.todo").remove_repeater_todo(opts)
  end,
  toggle_agenda_dir = function(notify, is_set)
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
  end,
}
M.tags = {
  get_tags = function(is_last)
    is_last = is_last or false
    local opts = {
      last = is_last,
      title = NoteUtils.get_title_note(note_provider, "Search note by tags"),
    }
    if not set_global_agenda_files then
      org.set_agenda_dir(org.path_global_wiki)
    end
    tags.get_tags("search tags", function()
      org.set_agenda_dir(org.path_local_wiki)
    end, opts)
  end,
  insert_tag = function(is_last, is_use_plugin)
    is_last = is_last or false
    is_use_plugin = is_use_plugin or false
    local opts = {
      last = is_last,
      title = NoteUtils.get_title_note(note_provider, "Insert tag"),
      use_plugin = is_use_plugin,
    }
    if not set_global_agenda_files then
      org.set_agenda_dir(org.path_global_wiki)
    end
    tags.insert_tag("insert tag", function()
      org.set_agenda_dir(org.path_local_wiki)
    end, opts)
  end,
}
M.find = {
  find_files = function()
    find.find_files(
      ConfigPath.wiki_path,
      base.file_ignores,
      base.rg_opts,
      NoteUtils.get_title_note(note_provider, "Files")
    )
  end,
  live_grep = function()
    find.live_grep(ConfigPath.wiki_path, base.rg_opts, NoteUtils.get_title_note(note_provider, "Live Grep"))
  end,
  live_grep_visual = function()
    find.live_grep_visual(
      ConfigPath.wiki_path,
      base.rg_opts,
      NoteUtils.get_title_note(note_provider, "Live Grep Visual")
    )
  end,
  find_url_and_backlinks = function(is_global)
    is_global = is_global or false
    find.find_url_and_backlinks(
      is_global,
      base.rg_opts,
      base.file_ignores,
      base.regex_url_backlinks,
      NoteUtils.get_title_note(note_provider, "Backlinks / URLs")
    )
  end,
  find_backlinks = function(is_global)
    is_global = is_global or false
    find.find_backlinks(is_global)
  end,
  jump_to_heading = function(is_global)
    is_global = is_global or false
    local title_a = "Local"
    if is_global then
      title_a = "Global"
    end
    local __title = "Jump " .. title_a .. " Title"
    find.jump_to_heading(is_global, base.regex_title, base.rg_opts, NoteUtils.get_title_note(note_provider, __title))
  end,
}
M.link = {
  insert_backlink_file = function()
    link.insert_backlinks_files(base.file_ignores, NoteUtils.get_title_note(note_provider, "Insert Backlinks"))
  end,
  insert_heading = function(is_global)
    is_global = is_global or false
    local title_a = "Local"
    if is_global then
      title_a = "Global"
    end
    local __title = "Insert " .. title_a .. " Title"
    link.insert_heading_title(
      base.rg_opts,
      base.regex_title,
      NoteUtils.get_title_note(note_provider, __title),
      is_global
    )
  end,
}

return M
