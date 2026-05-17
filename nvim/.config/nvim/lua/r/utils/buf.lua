local api = vim.api
local option = api.nvim_get_option_value

---@class r.utils.buf
local M = {
  window = {},
}

function M._only()
  local del_non_modifiable = vim.g.bufonly_delete_non_modifiable or false

  local cur = api.nvim_get_current_buf()

  local deleted, modified = 0, 0

  for _, n in ipairs(api.nvim_list_bufs()) do
    -- If the iter buffer is modified one, then don't do anything
    ---@diagnostic disable-next-line: redundant-parameter
    if option("modified", { buf = n }) then
      modified = modified + 1

      -- iter is not equal to current buffer
      -- iter is modifiable or del_non_modifiable == true
      -- `modifiable` check is needed as it will prevent closing file tree ie. NERD_tree
      ---@diagnostic disable-next-line: redundant-parameter
    elseif n ~= cur and (option("modifiable", { buf = n }) or del_non_modifiable) then
      api.nvim_buf_delete(n, {})
      deleted = deleted + 1
    end
  end

  vim.cmd [[only]]
  vim.notify("BufOnly: " .. deleted .. " deleted buffer(s), " .. modified .. " modified buffer(s)")
end

function M.get_bo_buft(bufnr)
  bufnr = bufnr or api.nvim_get_current_buf()
  local buftype = api.nvim_get_option_value("buftype", { buf = bufnr })
  local filetype = api.nvim_get_option_value("filetype", { buf = bufnr })
  return filetype, buftype
end

function M.smart_quit()
  local bufnr = api.nvim_get_current_buf()
  ---@diagnostic disable-next-line: param-type-mismatch
  local buf_windows = vim.call("win_findbuf", bufnr)

  ---@diagnostic disable-next-line: redundant-parameter
  local modified = option("modified", { buf = bufnr })
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

local function toggle_diffview(cmd)
  if next(require("diffview.lib").views) == nil then
    vim.cmd(cmd)
  else
    vim.cmd "DiffviewClose"
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
      local j = function()
        return vim.cmd "close"
      end
      return nil, j
    end,
    ["Outline"] = function()
      local j = function()
        return vim.cmd "OutlineClose"
      end
      return true, j
    end,
    ["DiffviewFileHistory"] = function()
      local j = function()
        return toggle_diffview "DiffviewClose"
      end
      if vim.t.diffview_view_initialized then
        return true, j
      end
      return nil, nil
    end,
    ["DiffviewFiles"] = function()
      local j = function()
        return toggle_diffview "DiffviewClose"
      end
      if vim.t.diffview_view_initialized then
        return true, j
      end
      return nil, nil
    end,
    ["feed"] = function()
      local j = function()
        return require("feed").quit()
      end
      return true, j
    end,
    ["grug-far"] = function()
      local j = function()
        return vim.cmd "q"
      end
      return true, j
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

  local filepath = vim.fn.fnamemodify(bufname, ":.")
  if filepath then
    if bufname:match "diffview://" then
      RUtils.warn(
        RUtils.config.icons.misc.cross_sign .. " Switch to the Diffview window to quit or close",
        { title = "Magic Quit" }
      )
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

  return M.smart_quit()
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
    pcall(vim.cmd, "bdelete! " .. buf)
  end
end

function M.get_fsize(bufnr)
  local file = nil
  if bufnr == nil then
    file = vim.fn.expand "%:p"
  else
    file = vim.api.nvim_buf_get_name(bufnr)
  end

  local size = vim.fn.getfsize(file)
  if size <= 0 then
    return 0
  end
  return size
end

function M.is_big_file(buf, opts)
  opts = opts or {}
  local size = opts.size or (1024 * 1000)
  local lines = opts.lines or 3500

  if M.get_fsize(buf) > size then
    return true
  end

  if vim.api.nvim_buf_line_count(buf) > lines then
    return true
  end
end

-- ╭─────────────────────────────────────────────────────────╮
-- │ WINDOW                                                  │
-- ╰─────────────────────────────────────────────────────────╯
--
local exclude_ft_arrange = { "DiffviewFileHistory", "DiffviewFiles" }

M.window.arange_wins = function(direction)
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

---@param tbl_wins table
---@return boolean
local function go_back_to_window(tbl_wins)
  for _, win in pairs(tbl_wins) do
    local win_checked = RUtils.cmd.windows_is_opened { win }
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

local function call_stack_peek()
  local Stack = require "overlook.stack"
  local switch_to_winid = nil
  if vim.w.is_overlook_popup then
    switch_to_winid = vim.w.overlook_popup.root_winid
  elseif Stack.instances[vim.api.nvim_get_current_win()] and not Stack.empty() then
    switch_to_winid = Stack.top().winid
  end

  if switch_to_winid == nil then
    return false, nil
  end
  return true, switch_to_winid
end

function M.window.switch_focus_targeted_window()
  local ok, switch_winid = call_stack_peek()
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

local function not_vscode()
  return vim.fn.exists "g:vscode" == 0
end

function M.window.replace_keymap(confirmation, visual)
  confirmation = confirmation or false
  visual = visual or false
  local key = [[:%s/]]
  local search_string = ""
  if visual then
    local selection_str = RUtils.get_visual_selection()
    if selection_str then
      search_string = selection_str.selection
    end
  else
    key = key .. [[\<]]
    search_string = vim.fn.expand "<cword>"
  end
  key = key .. RUtils.map.escape(search_string, "[]")
  if not visual then
    key = key .. [[\>]]
  end
  key = key .. "/" .. RUtils.map.escape(search_string, "&")
  if confirmation then
    key = key .. [[/gcI]]
  else
    key = key .. [[/gI]]
  end
  RUtils.map.feedkey(key)

  if not_vscode() then
    local key_move = [[<Left><Left><Left>]]
    if confirmation then
      key_move = key_move .. [[<Left>]]
    end
    RUtils.map.feedkey(key_move)
  end
end

return M
