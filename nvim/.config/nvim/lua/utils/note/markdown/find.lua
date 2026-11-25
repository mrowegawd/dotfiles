local M = {}

local lazy = require("utils.plugin").require_lazy

local Config = lazy "config"
local ConfigPath = Config.path

local NoteUtils = lazy "utils.note.note_utils"

---@param is_global boolean
---@param regex_title string
---@param rg_opts table
---@param title string
function M.jump_to_heading(is_global, regex_title, rg_opts, title)
  local target_file = NoteUtils.get_target_file(ConfigPath.wiki_path, is_global)

  -- Copy to avoid mutating base.rg_opts; otherwise args grow on every call.
  local copy_rgopts = vim.deepcopy(rg_opts)
  copy_rgopts[#copy_rgopts + 1] = target_file
  copy_rgopts[#copy_rgopts + 1] = "-e"

  NoteUtils.grep(is_global, target_file, {
    winopts = { title = title },
    search = regex_title,
    actions = NoteUtils.mapping.open_and_jump_to_file(target_file, is_global),
    rg_opts = table.concat(copy_rgopts, " "),
  })
end

return M
