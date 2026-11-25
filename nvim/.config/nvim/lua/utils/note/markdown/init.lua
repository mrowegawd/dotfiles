local M = {}

local lazy = require("utils.plugin").require_lazy

local Log = lazy "utils.log"

local find = lazy "utils.note.markdown.find"
local NoteUtils = lazy "utils.note.note_utils"

local note_provider = "Markdown"

local function get_data()
  return {
    file_ignores = { "%.norg$", "%.json$", "%.org$", "%.png$" },
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
    },
    regex_title = [[^#{1,}\s\w.*$]],
    regex_url_backlinks = [[http|\[\[]],
  }
end

local base = get_data()

M.todo = {
  remove_repeater_todo = function()
    Log.warn "not implemented yet"
  end,
}
M.tags = {
  get_tags = function(is_last)
    is_last = is_last or false
    Log.warn "not implemented yet"
  end,
}
M.find = {
  find_files = function()
    Log.warn "not implemented yet"
  end,
  live_grep = function()
    Log.warn "not implemented yet"
  end,
  live_grep_visual = function()
    Log.warn "not implemented yet"
  end,
  find_url_and_backlinks = function(is_global)
    is_global = is_global or false
    Log.warn "not implemented yet"
  end,
  find_backlinks = function(is_global)
    is_global = is_global or false
    Log.warn "not implemented yet"
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

return M
