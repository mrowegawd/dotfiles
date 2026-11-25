local lazy = require("utils.plugin").require_lazy

local Log = lazy "utils.log"

---@alias Opts_file {filename: string, col?: integer, lnum?: integer, title_str?: string }

local M = {}

---@param note_provider "org" | "orgnvim" | "markdown"
local resolve_provider = function(note_provider)
  local ok, note = pcall(require, string.format("utils.note.%s", note_provider))
  if not ok then
    Log.error(string.format("The note provider `%s` has not been implemented yet.", note_provider))
    return
  end
  return note
end

local note_provider = resolve_provider "org"

---@param ft string?
local function swith_note_mode(ft)
  ft = ft or "org"
  note_provider = resolve_provider(ft)
end

if not note_provider then
  return
end

local function find()
  return note_provider.find
end
local function tags()
  return note_provider.tags
end
local function todo()
  return note_provider.todo
end
local function link()
  return note_provider.link
end

-- ┏╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┓
-- ╏                                     API                                     ╏
-- ┗╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┛
M.swith_note_mode = swith_note_mode

-- ┌╌╌╌╌╌╌┐
-- ╎ Find ╎
-- └╌╌╌╌╌╌┘
M.find_files = function()
  find().find_files()
end
M.live_grep = function()
  find().live_grep()
end
M.live_grep_visual = function()
  find().live_grep_visual()
end
M.find_backlinks_local = function()
  find().find_backlinks()
end
M.find_backlinks_global = function()
  find().find_backlinks(true)
end
M.find_url_and_backlinks_local = function()
  find().find_url_and_backlinks()
end
M.find_url_and_backlinks_global = function()
  find().find_url_and_backlinks(true)
end
M.jump_heading_local = function()
  find().jump_to_heading()
end
M.jump_heading_global = function()
  find().jump_to_heading(true)
end

-- ┌╌╌╌╌╌╌╌╌┐
-- ╎ Filter ╎
-- └╌╌╌╌╌╌╌╌┘
M.filter_by_tags = function()
  tags().get_tags()
end
M.last_filter_by_tags = function()
  tags().get_tags(true)
end

-- ┌╌╌╌╌╌╌╌╌┐
-- ╎ Insert ╎
-- └╌╌╌╌╌╌╌╌┘
M.insert_tag = function()
  tags().insert_tag()
end
M.insert_tag_by_plugin = function()
  tags().insert_tag(false, true)
end
M.last_insert_tag = function()
  tags().insert_tag(true)
end
M.insert_backlinks = function()
  link().insert_backlink_file()
end
M.insert_title_local = function()
  link().insert_heading()
end
M.insert_title_global = function()
  link().insert_heading(true)
end

-- ┌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌┐
-- ╎ SPECIFIC: ORG ╎
-- └╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌┘
M.remove_repeater_todo = function(opts)
  todo().remove_repeater_todo(opts)
end
M.toggle_agenda_dir = function()
  todo().toggle_agenda_dir(true)
end

return M
