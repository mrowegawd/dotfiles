---@class r.utils.layout
local M = {}

local Win = {}
Win.layout = {}

local is_autocmd_registered = false
local is_processing_layout = false
local is_all_window = true
local is_toggle

---@type {height: integer, width: integer, win:integer}
local opts_external_window = {}

---Helper to prevent multiple respawns in autocmd callbacks.
local respawn = 0

vim.o.equalalways = false -- this motherfucker is driving me insane!! hadeeeh

-- +-----------------------------------------------------------------------------+
-- |                                   HELPER                                    |
-- +-----------------------------------------------------------------------------+

local function warn(msg)
  RUtils.warn(msg, { title = "Layout" })
end

local function info(msg)
  RUtils.info(msg, { title = "Layout" })
end

local function _get_width_size()
  local col = vim.o.columns
  if RUtils and RUtils.get_option then
    col = RUtils.get_option "columns"
  end
  local w = math.floor(col * 18 / 100)
  return w
end

---@param skip_winids integer | table
---@return table
local function save_wins_current_tab(skip_winids)
  local skip = {}
  if type(skip_winids) == "number" then
    skip[skip_winids] = true
  elseif type(skip_winids) == "table" then
    for _, w in ipairs(skip_winids) do
      skip[w] = true
    end
  end

  local saved = {}
  local tab = vim.api.nvim_get_current_tabpage()
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(tab)) do
    if vim.api.nvim_win_is_valid(win) and not skip[win] then
      local cfg = vim.api.nvim_win_get_config(win)
      local buf = vim.api.nvim_win_get_buf(win)
      local ft = vim.api.nvim_get_option_value("filetype", { buf = buf })
      if cfg.relative == "" and not Win.filetype_skip_resize_layout[ft] then
        saved[win] = {
          width = vim.api.nvim_win_get_width(win),
          height = vim.api.nvim_win_get_height(win),
        }
      end
    end
  end
  return saved
end

---@param saved table
local function restore_wins(saved)
  for win, size in pairs(saved) do
    if vim.api.nvim_win_is_valid(win) then
      vim.api.nvim_win_set_width(win, size.width)
      vim.api.nvim_win_set_height(win, size.height)
    end
  end
end

---@param winid? integer
local function is_ft_skip_resize(winid)
  winid = winid or vim.api.nvim_get_current_win()
  local cur_buf = vim.api.nvim_win_get_buf(winid)
  local cur_ft = vim.api.nvim_get_option_value("filetype", { buf = cur_buf })
  return Win.filetype_skip_resize_layout[cur_ft]
end

---@param winid integer
local function is_float_win(winid)
  if vim.api.nvim_win_is_valid(winid) then
    local config = vim.api.nvim_win_get_config(winid)
    return config.relative ~= ""
  end
end

---@param buf integer
---@param winid integer
local function is_valid_window(winid, buf)
  if not winid or not vim.api.nvim_win_is_valid(winid) then
    return false
  end

  if not buf or not vim.api.nvim_buf_is_valid(buf) then
    return false
  end

  return true
end

---@param main_layout {win: integer}
---@param buf? integer
local function is_valid_main_layout(main_layout, buf)
  buf = buf or vim.api.nvim_get_current_buf()
  local winid = main_layout.win
  if not is_valid_window(winid, buf) then
    return false
  end
  return true
end

---@param name string
local group_name = function(name)
  return Win.prefix_group_name .. name
end

-----@generic F: fun()
-----@param fn F
-----@return F
-- local function noautocmd(fn)
--   return function(...)
--     vim.o.eventignore = "all"
--     local ok, ret = pcall(fn, ...)
--     vim.o.eventignore = ""
--     if not ok then
--       error(ret)
--     end
--     return ret
--   end
-- end

--- @param  f function
--- @param  delay number
--- @return function
local function debounce(f, delay)
  local timer = vim.loop.new_timer()
  if not timer then
    return f
  end

  return function(...)
    local args = { ... }

    timer:start(
      delay,
      0,
      vim.schedule_wrap(function()
        timer:stop()
        f(unpack(args))
      end)
    )
  end
end

---@param winid integer
---@param node? table
---@return "leaf"|"row"|"col"|nil
local function get_layout_type(winid, node)
  node = node or vim.fn.winlayout()

  local typ = node[1]

  -- leaf node
  if typ == "leaf" then
    if node[2] == winid then
      return "leaf"
    end
    return nil
  end

  -- row / col node
  ---@diagnostic disable-next-line: param-type-mismatch
  for _, child in ipairs(node[2]) do
    local found = get_layout_type(winid, child)

    if found then
      return typ
    end
  end

  return nil
end

---Checks if the LSP on the current buffer is ready and supports Document Symbols
---@return boolean is_ready, string? message
local function check_lsp_symbol_readiness()
  local bufnr = vim.api.nvim_get_current_buf()
  local clients = vim.lsp.get_clients { bufnr = bufnr }

  if #clients == 0 then
    return false, "No active LSP clients found in this buffer."
  end

  local has_symbol_support = false
  for _, client in ipairs(clients) do
    -- 1. Check if the LSP supports documentSymbol (required for Outline)
    ---@diagnostic disable-next-line: param-type-mismatch, missing-parameter
    if client.supports_method "textDocument/documentSymbol" then
      has_symbol_support = true
    end

    -- 2. Check if the LSP is currently busy indexing or loading progress
    if vim.lsp.status and vim.lsp.status() ~= "" then
      return false, "LSP is busy running progress/indexing..."
    end
  end

  if not has_symbol_support then
    return false, "The active LSP in this buffer does not support the Outline feature (Document Symbol)."
  end

  return true
end

-- +-----------------------------------------------------------------------------+
-- |                                 WIN LAYOUT                                  |
-- +-----------------------------------------------------------------------------+

Win.slot_win = {
  last_open = nil,
  fts = {},
}

Win.filetype_blacklist_jump_cursor = {
  ["Outline"] = true,
  ["aerial"] = true,
  ["nvim-undotree"] = true,
}

Win.filetype_skip_resize_layout = {
  ["grug-far"] = true,
  -- ["oil"] = true,
  -- ["NeogitStatus"] = true,
  -- ["eldochover"] = true,
  ["wk"] = true, -- whichkey ft
  -- ["qf"] = true,
  -- ["trouble"] = true,
  -- ["noice"] = true,
}

Win.main_size = _get_width_size()
Win.main_ft_name = "main_layout"
Win.prefix_group_name = "Layout_"
Win.is_set_layout_width = true
Win.need_reopen = {}

function Win.disable()
  local msg
  local layout_enabled = Win.is_set_layout_width
  if not layout_enabled then
    Win.is_set_layout_width = true
    msg = "Enabled"
  else
    Win.is_set_layout_width = false
    msg = "Disabled"
  end
  info(msg)
end

---@param winid integer
---@param buf? integer
---@param tab? integer
function Win.update_layout(winid, buf, tab)
  tab = tab or vim.fn.tabpagenr()
  buf = buf or vim.api.nvim_get_current_buf()
  if not is_valid_window(winid, buf) then
    ---@diagnostic disable-next-line: undefined-field
    warn "Win.update_layout: winid or buf is invalid"
    return
  end

  Win.layout[tab] = Win.layout[tab] or {}

  Win.layout[tab] = {
    win = winid,
  }
end

---@param tab? integer
---@return {win: integer}
function Win.get_main_layout(tab)
  tab = tab or vim.fn.tabpagenr()

  if not Win.layout[tab] then
    Win.layout[tab] = {
      win = nil,
    }
  end

  return Win.layout[tab]
end

---@param position "topleft" | "right"
function Win.open_empty_blank_buffer(position)
  vim.cmd(position .. " vsplit")

  vim.schedule(function()
    local winid = vim.api.nvim_get_current_win()
    local buf = vim.api.nvim_get_current_buf()

    local tab = vim.fn.tabpagenr()
    Win.update_layout(winid, buf, tab)

    local main_layout = Win.get_main_layout(tab)
    local empty_buf = vim.api.nvim_create_buf(false, true)

    if not is_valid_main_layout(main_layout, buf) then
      ---@diagnostic disable-next-line: undefined-field
      warn "open_empty_blank_buffer: cannot continue, main_layout or buf is invalid "
      return
    end

    vim.api.nvim_win_set_buf(main_layout.win, empty_buf)
    vim.api.nvim_set_option_value("cursorline", false, { win = main_layout.win, scope = "local" })
    vim.api.nvim_set_option_value("number", false, { win = main_layout.win, scope = "local" })
    vim.api.nvim_set_option_value("modifiable", true, { buf = empty_buf })
    vim.api.nvim_set_option_value("readonly", false, { buf = empty_buf })
    vim.api.nvim_set_option_value("filetype", Win.main_ft_name, { buf = empty_buf })

    vim.wo[main_layout.win].winfixwidth = true
    vim.api.nvim_win_set_width(main_layout.win, Win.main_size)

    vim.cmd "wincmd p"
  end)
end

---@param cur_winid integer
---@param main_layout_winid integer
---@param fn function
local __cmd_win_call = function(cur_winid, main_layout_winid, fn)
  local saved_before_fn, saved_cmdheight

  RUtils.info(tostring(is_all_window))

  if is_all_window then
    saved_before_fn = save_wins_current_tab(cur_winid)
    saved_cmdheight = vim.o.cmdheight
  end

  vim.api.nvim_win_call(main_layout_winid, function()
    local saved = save_wins_current_tab(main_layout_winid)

    fn()

    restore_wins(saved)

    if is_all_window then
      restore_wins(saved_before_fn)
      vim.o.cmdheight = saved_cmdheight
    end

    vim.wo[main_layout_winid].winfixwidth = true
    vim.api.nvim_win_set_width(main_layout_winid, Win.main_size)
  end)

  if is_all_window and opts_external_window and opts_external_window.height then
    vim.api.nvim_win_call(cur_winid, function()
      vim.api.nvim_win_set_height(cur_winid, opts_external_window.height)
      -- The external window opts must be cleared because they will interfere
      -- if `opts_external_window.height` is still present
      opts_external_window = {}
    end)
  end
end

---@param master_saved_layout table
function Win.ensure_main_sidebar_is_left(master_saved_layout)
  local layouts_win = RUtils.cmd.windows_is_opened(Win.slot_win.fts, true)
  Win.update_layout(layouts_win.winid)

  if not layouts_win.found then
    return
  end

  debounce(function()
    local main_layout = Win.get_main_layout()
    if
      (main_layout and not main_layout.win)
      or (main_layout.win and not vim.api.nvim_win_is_valid(main_layout.win))
    then
      return
    end
    vim.api.nvim_win_call(main_layout.win, function()
      vim.cmd "wincmd H"
      if master_saved_layout then
        restore_wins(master_saved_layout)
      end

      vim.wo[main_layout.win].winfixwidth = true
      vim.api.nvim_win_set_width(main_layout.win, Win.main_size)
    end)
  end, 100)()

  if Win.filetype_blacklist_jump_cursor[vim.bo.filetype] then
    vim.cmd "wincmd p"
  end
end

function Win.keep_sidebar_left()
  if vim.fn.getcmdwintype() ~= "" then
    return
  end

  local main_layout = Win.get_main_layout()

  if not is_valid_main_layout(main_layout) then
    return
  end

  local buf = vim.api.nvim_get_current_buf()
  local winid = main_layout.win
  Win.main_size = _get_width_size()

  local cur_winid = vim.api.nvim_get_current_win()

  if is_ft_skip_resize(cur_winid) then
    return
  end

  --- Check window widths that are larger than the column width, such as Fugitive, Noice, etc.
  local win_col = vim.api.nvim_win_get_position(cur_winid)[2]
  local win_width = vim.api.nvim_win_get_width(cur_winid)
  local is_fullwidth = win_col == 0 and win_width >= vim.o.columns - 2
  if is_fullwidth then
    is_processing_layout = true

    -- note: kenapa diset is_all_window = true,
    -- karena open window eldochover itu filetye nya ==  ""
    -- jadi mesti di set is_all_window = false, check bagian M.open_window_safely
    -- ini guna mencegah winbar terhapus setelah `wincmd H`
    if vim.bo.filetype ~= "" then
      is_all_window = true
    end
  end

  -- More guard before `is_processing_layout`
  if not is_valid_window(winid, buf) then
    ---@diagnostic disable-next-line: undefined-field
    warn "keep_sidebar_left: winid or buf is invalid"
    return
  end

  if is_processing_layout then
    debounce(function()
      Win.handle_close_support_win()

      __cmd_win_call(cur_winid, winid, function()
        vim.cmd "wincmd H"
      end)

      Win.reopen_win(true)
    end, 100)()
    is_processing_layout = false
  end
end

function Win.update_sidebar()
  Win.keep_sidebar_left()
end

function Win.reopen_win(is_autocmd)
  is_autocmd = is_autocmd or false
  if #Win.need_reopen == 1 then -- ini table dict bukan list
    return
  end

  if is_processing_layout then
    return
  end

  for name_win, win in pairs(Win.need_reopen) do
    if is_autocmd and respawn > 0 then
      break
    end
    local name_cmd = "open_" .. name_win
    if RUtils.terminal[name_cmd] and not vim.api.nvim_win_is_valid(win) then
      RUtils.terminal[name_cmd]()
      if is_autocmd then
        respawn = 1
      end
    else
      warn("Try to call this command but something went wrong: `" .. name_cmd .. "` is nil?")
    end
  end
end

--- This will close other windows that are not the main window.
--- This is needed because we need to close the support windows before
--- re-layouting the Neovim windows.
---@param target_win? string
function Win.handle_close_support_win(target_win)
  target_win = target_win or ""
  local support_wins = M.get_support_win_layout()

  if #target_win > 0 then
    for key_win, win in pairs(support_wins) do
      if key_win == target_win then
        if win and vim.api.nvim_win_is_valid(win) then
          vim.api.nvim_win_close(win, true)
          -- After closing the window
          -- ensure that window is removed from current main layout
          Win.need_reopen[key_win] = nil
        end
      end
    end
    return
  end
  for key_win, win in pairs(support_wins) do
    if win and vim.api.nvim_win_is_valid(win) then
      vim.api.nvim_win_close(win, true)
      Win.need_reopen[key_win] = win
      respawn = 0
    end
  end
end

-- +-----------------------------------------------------------------------------+
-- |                                   AUTOCMD                                   |
-- +-----------------------------------------------------------------------------+

local function setup_autocmd()
  if is_autocmd_registered then
    return
  end
  is_autocmd_registered = true

  --FIX:  augroup WinClosed works, but make sure the toggle toggle_sidebar logic is correct
  RUtils.map.augroup(group_name "Closed", {
    event = { "WinClosed" },
    pattern = "*",
    command = function()
      debounce(function()
        local found = false
        for _, layout in pairs(Win.layout) do
          if layout.win and vim.api.nvim_win_is_valid(layout.win) then
            found = true
          end
        end

        if found then
          return
        end

        -- Cleanup state
        Win.layout = {}
        Win.slot_win = {
          last_open = nil,
          fts = {},
        }
        is_processing_layout = false
        is_autocmd_registered = false
        is_toggle = false

        -- Clear all augroups
        pcall(vim.api.nvim_del_augroup_by_name, group_name "FixSize")
        pcall(vim.api.nvim_del_augroup_by_name, group_name "FileType")
        pcall(vim.api.nvim_del_augroup_by_name, group_name "DisableCmdline")
        pcall(vim.api.nvim_del_augroup_by_name, group_name "DisableWinLeave")
        pcall(vim.api.nvim_del_augroup_by_name, group_name "FixSizeWinEnter")
        pcall(vim.api.nvim_del_augroup_by_name, group_name "Closed")
      end, 100)()
    end,
  })

  RUtils.map.augroup(group_name "FixSize", {
    event = { "BufWinEnter", "WinResized" },
    pattern = "*",
    command = function()
      if not Win.is_set_layout_width then
        return
      end
      local curwin = vim.api.nvim_get_current_win()
      if is_float_win(curwin) then
        return
      end
      Win.update_sidebar()
    end,
  })

  RUtils.map.augroup(group_name "FocusGaindAndLost", {
    event = { "FocusGained", "FocusLost" },
    pattern = "*",
    command = function()
      if not Win.is_set_layout_width then
        return
      end
      local curwin = vim.api.nvim_get_current_win()
      if is_float_win(curwin) then
        return
      end

      if is_all_window then
        is_all_window = true
      end

      if not is_processing_layout then
        is_processing_layout = true
      end

      local master_saved_layout = save_wins_current_tab(vim.api.nvim_get_current_win())

      Win.update_sidebar()

      vim.schedule(function()
        restore_wins(master_saved_layout)
      end)
    end,
  })

  RUtils.map.augroup(group_name "FileType", {
    event = { "FileType", "VimResized" },
    pattern = "*",
    command = function()
      if not Win.is_set_layout_width then
        return
      end
      local curwin = vim.api.nvim_get_current_win()
      if is_float_win(curwin) then
        return
      end
      Win.update_sidebar()
    end,
  })

  RUtils.map.augroup(group_name "DisableCmdline", {
    event = { "CmdlineEnter" },
    pattern = "*",
    command = function()
      if not Win.is_set_layout_width then
        return
      end
      is_processing_layout = false
    end,
  })

  RUtils.map.augroup(group_name "DisableWinLeave", {
    event = { "WinLeave", "BufLeave" },
    pattern = "*",
    command = function()
      if not Win.is_set_layout_width then
        return
      end
      is_processing_layout = false
    end,
  })

  RUtils.map.augroup(group_name "FixSizeWinEnter", {
    event = { "WinEnter", "BufEnter" },
    pattern = "*",
    command = function()
      if not Win.is_set_layout_width then
        return
      end

      local curwin = vim.api.nvim_get_current_win()
      if is_float_win(curwin) then
        return
      end

      debounce(function()
        local main_layout = Win.get_main_layout()
        if not is_valid_main_layout(main_layout) then
          return
        end

        local buf = vim.api.nvim_get_current_buf()
        local winid = main_layout.win

        if not is_valid_window(winid, buf) then
          return
        end

        Win.main_size = _get_width_size()

        vim.wo[winid].winfixwidth = true
        vim.api.nvim_win_set_width(winid, Win.main_size)

        is_processing_layout = false
      end, 100)()
    end,
  })
end

-- ┏╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┓
-- ╏                                 PUBLIC API                                  ╏
-- ┗╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┛

M.save_wins_current_tab = save_wins_current_tab
M.restore_wins = restore_wins
M.disable = Win.disable

---@param fn function
---@param is_force? boolean
function M.toggle_sidebar(ft, fn, is_force)
  is_force = is_force or false
  Win.main_size = _get_width_size()

  if not is_autocmd_registered then
    setup_autocmd()
  end

  if #Win.slot_win.fts == 0 then
    Win.slot_win.fts = { ft }
    Win.slot_win.last_open = ft
  else
    local ft_already_registered = vim.tbl_contains(Win.slot_win.fts, ft)

    if not ft_already_registered then
      Win.slot_win.last_open = ft
      table.insert(Win.slot_win.fts, ft)
      is_toggle = true
      is_force = true
    end

    if vim.bo.filetype == ft then
      vim.cmd "wincmd p"
    else
      is_toggle = true
    end
  end

  -- Close support window first e.g clock window
  Win.handle_close_support_win()

  local tab = vim.fn.tabpagenr()
  local main_layout = Win.get_main_layout(tab)
  local target_skip_win = (main_layout.win and vim.api.nvim_win_is_valid(main_layout.win)) and main_layout.win
    or vim.api.nvim_get_current_win()
  local master_saved_layout = save_wins_current_tab(target_skip_win)

  -- Close the sidebar window before opening a new blank window
  if is_valid_main_layout(main_layout) then
    vim.api.nvim_win_close(main_layout.win, true)
    vim.schedule(function()
      restore_wins(master_saved_layout)
    end)
  end

  if not is_toggle then
    Win.open_empty_blank_buffer "topleft"
    is_toggle = true

    if not is_force then
      return
    end
  end

  fn()

  Win.ensure_main_sidebar_is_left(master_saved_layout)

  is_toggle = false

  debounce(function()
    Win.reopen_win()
  end, 100)()
end

function M.debug()
  local winid = vim.api.nvim_get_current_win()
  local cfg = vim.api.nvim_win_get_config(winid)
  local buf = vim.api.nvim_win_get_buf(winid)
  local ft = vim.api.nvim_get_option_value("filetype", { buf = buf })
  if cfg.relative == "" then
    info(tostring(get_layout_type(winid)) .. " ft:" .. ft)
  end

  return Win
end

function M.get_Win()
  return Win
end

M.close_support_window = Win.handle_close_support_win

---@return table
function M.get_support_win_layout()
  local support_wins = {}

  local tab = vim.api.nvim_get_current_tabpage()
  local main_layout = Win.get_main_layout(tab)

  for key_winid, winid in pairs(Win.layout[tab]) do
    if main_layout.win ~= winid then
      if winid and vim.api.nvim_win_is_valid(winid) then
        support_wins[key_winid] = winid
      end
    end
  end
  return support_wins
end

---@param name_win string
---@param winid integer
function M.update_win_layout(name_win, winid)
  local tab = vim.api.nvim_get_current_tabpage()
  Win.layout[tab][name_win] = winid
end

-- ╓─────────────────────────────────────────────────────────────────────────────╖
-- ║                                 OPEN HELPER                                 ║
-- ╙─────────────────────────────────────────────────────────────────────────────╜

---Special wrapper to handle commands that take a long time to execute
---@param ft string
---@param fn function The original open/toggle outline function
function M.open_outline_safely(ft, fn, is_force)
  local is_org = vim.tbl_contains({ "org", "markdown", "norg", "help" }, vim.bo.filetype)

  local is_ready, msg
  if not is_org and ft ~= "Outline" then
    is_ready, msg = check_lsp_symbol_readiness()
  else
    is_ready = true
  end

  if not is_ready then
    ---@diagnostic disable-next-line: undefined-field
    warn(msg or "LSP is not ready.")
    return
  end

  -- If LSP is fully synchronized, proceed with our layout-safe handler
  ---@diagnostic disable-next-line: undefined-field
  info "LSP Ready. Opening Outline..."

  M.toggle_sidebar(ft, fn, is_force)
end

---@param fn function
function M.toggle_sidebar_with_clear(fn)
  -- If LSP is fully synchronized, proceed with our layout-safe handler
  ---@diagnostic disable-next-line: undefined-field
  info "LSP Ready. Opening Outline..."

  M.toggle_sidebar("clear", fn, false)
end

---Handle external window with specific parameter, e.g eldochover window
---this parameter is needed to configure with main layout
---@param fn function
---@param external_opts {height: integer, width: integer, win:integer}
function M.open_external_window_safely(fn, external_opts)
  is_processing_layout = true
  is_all_window = false
  local winid = vim.api.nvim_get_current_win()
  local saved = save_wins_current_tab(winid)

  opts_external_window = external_opts

  fn()
  vim.schedule(function()
    restore_wins(saved)
    is_processing_layout = false
    is_all_window = false
  end)
end

setup_autocmd()

return M
