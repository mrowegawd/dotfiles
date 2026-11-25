local M = {}

local lazy = require("utils.plugin").require_lazy
local Fzflua = lazy "fzf-lua"

---@alias Mode_open "vsplit" | "split" | "tabe" | "default"

---@param note_provider string
---@param title string?
function M.get_title_note(note_provider, title)
  title = title or ""
  local title_tbl = string.format("%s - %s", note_provider, title)
  if not title_tbl then
    return
  end
  return title_tbl
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

---@param wiki_path string
---@param is_global boolean
function M.get_target_file(wiki_path, is_global)
  local fnames = __define_tbl_paths()

  local target_file = fnames.path_merge_str
  if is_global then
    target_file = wiki_path
    -- target_file = ConfigPath.wiki_path
  end
  return target_file
end

---@param selected table|string
---@param filename string
---@param is_global boolean?
---@return Opts_file|nil
function M.extract_str_title(selected, filename, is_global)
  is_global = is_global or false

  local sel
  if type(selected) == "table" then
    sel = lazy("utils.cmd").__strip_str(selected[1])
  end

  if type(selected) == "string" then
    sel = lazy("utils.cmd").__strip_str(selected)
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
    title_str = lazy("utils.cmd").strip_whitespaces(title_str),
  }

  return file_opts
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

---@param filename string
---@param selected string[]
---@param is_global boolean
---@return Opts_file|nil
local function extracted_selected_tags(selected, filename, is_global)
  local items = {}
  if #selected > 1 then
    for _, sel in pairs(selected) do
      local data = M.extract_str_title(sel, filename, is_global)
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
    local data = M.extract_str_title(selected, filename, is_global)
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

M.mapping = {}

function M.mapping.open_and_jump_to_file(filename, is_global)
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

      local file_opts = M.extract_str_title(selected, filename, is_global)
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

      local file_opts = M.extract_str_title(selected, filename, is_global)
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

      local file_opts = M.extract_str_title(selected, filename, is_global)
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

      local file_opts = M.extract_str_title(selected, filename, is_global)
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

---@param is_global boolean
---@param target_file string
---@param opts table
function M.grep(is_global, target_file, opts)
  opts = opts or {}

  local function Preview_buffer_fzflua(fn)
    local FzfluaBuiltin = lazy "fzf-lua.previewer.builtin"
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
    previewer = previewer,
    rg_glob = false,
    no_esc = true,
  }, opts)

  Fzflua.grep(fzfopts)
end

return M
