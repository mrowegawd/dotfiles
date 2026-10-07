local Log = require "utils.log"

local option = vim.api.nvim_get_option_value

local IconMisc = require("icons").misc

local M = {}

function M._only()
  local del_non_modifiable = vim.g.bufonly_delete_non_modifiable or false

  local cur = vim.api.nvim_get_current_buf()

  local deleted, modified = 0, 0

  for _, n in ipairs(vim.api.nvim_list_bufs()) do
    -- If the iter buffer is modified one, then don't do anything
    ---@diagnostic disable-next-line: redundant-parameter
    if option("modified", { buf = n }) then
      modified = modified + 1

      -- iter is not equal to current buffer
      -- iter is modifiable or del_non_modifiable == true
      -- `modifiable` check is needed as it will prevent closing file tree ie. NERD_tree
      ---@diagnostic disable-next-line: redundant-parameter
    elseif n ~= cur and (option("modifiable", { buf = n }) or del_non_modifiable) then
      vim.api.nvim_buf_delete(n, {})
      deleted = deleted + 1
    end
  end

  vim.cmd [[only]]
  Log.info("BufOnly: " .. deleted .. " deleted buffer(s), " .. modified .. " modified buffer(s)")
end

---@param bufnr? integer
function M.get_bo_buft(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  local buftype = vim.api.nvim_get_option_value("buftype", { buf = bufnr })
  local filetype = vim.api.nvim_get_option_value("filetype", { buf = bufnr })
  return filetype, buftype
end

---@param cmd string
local function toggle_diffview(cmd)
  if next(require("diffview.lib").views) == nil then
    vim.cmd(cmd)
  else
    vim.cmd "DiffviewClose"
  end
end

local function smart_quit()
  local bufnr = vim.api.nvim_get_current_buf()
  ---@diagnostic disable-next-line: param-type-mismatch
  local buf_windows = vim.call("win_findbuf", bufnr)

  ---@diagnostic disable-next-line: redundant-parameter
  local modified = vim.api.nvim_get_option_value("modified", { buf = bufnr })
  if modified and #buf_windows == 1 then
    vim.ui.input({
      prompt = "You have unsaved changes. Quit anyway? (y/n) ",
    }, function(input)
      if input == "y" then
        vim.cmd "q!"
      end
    end)
  else
    vim.cmd "q"
  end
end

function M.magic_quit()
  local buf_fts = {
    ["fugitive"] = "bd",
    ["Trouble"] = "bd",
    ["help"] = "q!",
    ["octo"] = "q!",
    ["log"] = "bd",
    ["git"] = function()
      local quit_cmd = function()
        return vim.cmd "close"
      end
      return nil, quit_cmd
    end,
    ["Outline"] = function()
      local quit_cmd = function()
        return vim.cmd "OutlineClose"
      end
      return true, quit_cmd
    end,
    ["DiffviewFileHistory"] = function()
      local quit_cmd = function()
        return toggle_diffview "DiffviewClose"
      end
      if vim.t.diffview_view_initialized then
        return true, quit_cmd
      end
      return nil, nil
    end,
    ["DiffviewFiles"] = function()
      local quit_cmd = function()
        return toggle_diffview "DiffviewClose"
      end
      if vim.t.diffview_view_initialized then
        return true, quit_cmd
      end
      return nil, nil
    end,
    ["feed"] = function()
      local quit_cmd = function()
        return require("feed").quit()
      end
      return true, quit_cmd
    end,
    ["grug-far"] = function()
      local quit_cmd = function()
        return vim.cmd "q"
      end
      return true, quit_cmd
    end,
  }

  local bufname = vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf())
  local buf_ft = buf_fts[vim.bo[0].filetype]
  if buf_ft then
    if type(buf_ft) == "function" then
      local is_ok_cmd, call_cmd = buf_fts[vim.bo[0].filetype]()
      if is_ok_cmd and call_cmd then
        return call_cmd()
      end
    end
    if type(buf_ft) == "string" then
      return vim.cmd(buf_fts[vim.bo[0].filetype])
    end
  end

  if vim.bo.buftype == "acwrite" then
    if vim.bo.modified then
      return vim.cmd "q!"
    end
    return vim.cmd "q"
  end

  local filepath = vim.fn.fnamemodify(bufname, ":.")
  if filepath then
    if bufname:match "diffview://" then
      Log.warn(IconMisc.cross_sign .. " Switch to the Diffview window to quit or close")
      return
    end
    if filepath:match "gitsigns:/" then
      return vim.cmd "close"
    end

    if filepath:match "fugitive:/" then
      return vim.cmd "close"
    end
  end

  if vim.bo.buftype == "terminal" and vim.bo.filetype == "" then
    if tonumber(require("sniprun.display").term.buffer) > 0 then
      return vim.cmd "SnipClose"
    end
  end

  return smart_quit()
end

---@param buf number?
function M.bufremove(buf)
  buf = buf or 0
  buf = buf == 0 and vim.api.nvim_get_current_buf() or buf

  if vim.bo.modified then
    local choice = vim.fn.confirm(("Save changes to %q?"):format(vim.fn.bufname()), "&Yes\n&No\n&Cancel")
    if choice == 0 then -- Cancel
      return
    end
    if choice == 1 then -- Yes
      vim.cmd.write()
    end
  end

  for _, win in ipairs(vim.fn.win_findbuf(buf)) do
    vim.api.nvim_win_call(win, function()
      if not vim.api.nvim_win_is_valid(win) or vim.api.nvim_win_get_buf(win) ~= buf then
        return
      end
      -- Try using alternate buffer
      local alt = vim.fn.bufnr "#"
      if alt ~= buf and vim.fn.buflisted(alt) == 1 then
        vim.api.nvim_win_set_buf(win, alt)
        return
      end

      -- Try using previous buffer
      ---@diagnostic disable-next-line: param-type-mismatch
      local has_previous = pcall(vim.cmd, "bprevious")
      if has_previous and buf ~= vim.api.nvim_win_get_buf(win) then
        return
      end

      -- Create new listed buffer
      local new_buf = vim.api.nvim_create_buf(true, false)
      vim.api.nvim_win_set_buf(win, new_buf)
    end)
  end
  if vim.api.nvim_buf_is_valid(buf) then
    ---@diagnostic disable-next-line: param-type-mismatch
    pcall(vim.cmd, "bdelete! " .. buf)
  end
end

local exclude_ft_arrange = { "DiffviewFileHistory", "DiffviewFiles" }

---@param direction "split" | "vsplit" | "tabe" | "J" | "K" | "H" | "L"
function M.arange_wins(direction)
  return function()
    if vim.wo.diff then
      return
    end

    if vim.tbl_contains(exclude_ft_arrange, vim.bo.filetype) then
      return
    end

    if vim.w.is_overlook_popup then
      if direction == "split" then
        require("overlook.api").open_in_split()
      end
      if direction == "vsplit" then
        require("overlook.api").open_in_vsplit()
      end
      if direction == "tabe" then
        require("overlook.api").open_in_tab()
      end
      return
    end

    if vim.tbl_contains({ "split", "vsplit" }, direction) then
      vim.cmd(direction)
      return
    end

    if direction == "tabe" then
      vim.cmd "tabedit %"
      return
    end

    vim.cmd("wincmd " .. direction)
    vim.cmd "wincmd ="
  end
end

---@param fts table
---@return boolean
local function go_back_to_window(fts)
  for _, ft in pairs(fts) do
    local win_checked = M.windows_is_opened({ ft }, true)
    if win_checked.found then
      -- pcall(vim.api.nvim_set_current_win, win_checked.winid)
      vim.api.nvim_set_current_win(win_checked.winid)
      return true
    end
  end
  return false
end

---@param ft_wins table
---@return boolean
local function go_prev_window(ft_wins)
  -- Go back to the window if any windows are open
  if vim.tbl_contains(ft_wins, vim.bo.filetype) then
    vim.cmd [[wincmd p]]
    return true
  end
  return false
end

---@return boolean, integer|nil
function M.call_stack_peek()
  if vim.w.is_overlook_popup then
    return true, vim.w.overlook_popup.root_winid
  end

  local Stack = require "overlook.stack"
  if not Stack then
    return false, nil
  end

  local current_win = vim.api.nvim_get_current_win()

  if Stack.instances[current_win] and not Stack.empty() then
    return true, Stack.top().winid
  end
  return false, nil
end

function M.switch_focus_targeted_window()
  local ok, switch_winid = M.call_stack_peek()
  if ok then
    pcall(vim.api.nvim_set_current_win, switch_winid)
    return
  end

  local float_win = { "codecompanion", "wayfinder" }
  if go_prev_window(float_win) then
    return
  end
  if go_back_to_window(float_win) then
    return
  end

  local right_win = { "trouble", "aerial", "Outline", "neo-tree", "snacks_notif_history", "ErgoTerm" }
  if go_prev_window(right_win) then
    return
  end
  if go_back_to_window(right_win) then
    return
  end
end

---@param filetypes string|string[]
---@param is_tab? boolean
---@param is_more_guard? boolean
---@return { found: boolean, winbufnr: integer, winnr: integer, winid: integer, ft: string }
function M.windows_is_opened(filetypes, is_tab, is_more_guard)
  is_tab = is_tab or false
  is_more_guard = is_more_guard or false

  local QfbookmarkUtils = require "qfbookmark.utils"
  return QfbookmarkUtils.windows_is_opened(filetypes, is_tab, is_more_guard)
end

return M
