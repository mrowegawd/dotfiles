local M = {}

local lazy = require("utils.plugin").require_lazy

local Log = lazy "utils.log"
local Config = lazy "config"
local ConfigPath = Config.path

local NoteUtils = lazy "utils.note.note_utils"

local Fzflua = lazy "fzf-lua"

---@param tbl table
local function clone_tbl(tbl)
  local t = {}
  for i, v in ipairs(tbl) do
    t[i] = v
  end
  return t
end

function M.find_files(cwd, ignores, rg_opts, title)
  Fzflua.files {
    cwd = cwd,
    file_ignore_patterns = ignores,
    rg_opts = table.concat(rg_opts, " "),
    winopts = { title = title },
  }
end

function M.live_grep(cwd, rg_opts, title)
  Fzflua.live_grep {
    cwd = cwd,
    rg_opts = table.concat(rg_opts, " "),
    winopts = { title = title },
  }
end

function M.live_grep_visual(cwd, rg_opts, title)
  local viz = lazy("utils.cmd").get_selection()
  vim.api.nvim_feedkeys(vim.keycode "<Esc>", "nx", false)
  vim.inspect(viz)
  -- opts.query = sel
  Fzflua.grep {
    search = string.format("%s", viz),
    rg_glob = true,
    cwd = cwd,
    rg_opts = table.concat(rg_opts, " "),
    winopts = { title = title },
  }
end

function M.find_url_and_backlinks(is_global, rg_opts, file_ignores, regex_url_backlinks, title)
  is_global = is_global or false
  local target_file = NoteUtils.get_target_file(ConfigPath.wiki_path, is_global)

  local clone_rg_opts = clone_tbl(rg_opts)
  table.insert(clone_rg_opts, target_file)
  table.insert(clone_rg_opts, "-e")

  NoteUtils.grep(is_global, target_file, {
    search = regex_url_backlinks,
    actions = NoteUtils.mapping.open_and_jump_to_file(target_file, is_global),
    winopts = { title = title },
    file_ignore_patterns = file_ignores,
    rg_opts = table.concat(clone_rg_opts, " "),
  })
end

---@param is_global? boolean
function M.find_backlinks(is_global)
  is_global = is_global or false
  Log.info "not implemented yet"
end

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
