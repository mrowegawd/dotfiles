---@class r.utils.layout
local M = {}

local Win = {}
Win.layout = {}

local is_processing_layout = false
local is_all_window = true
local is_toggle

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
local function is_valid_layout_window(main_layout, buf)
  buf = buf or vim.api.nvim_get_current_buf()
  local winid = main_layout.win
  if not is_valid_window(winid, buf) then
    return false
  end
  return true
end

local timer_closed = false

---@param timer uv.uv_timer_t
local function stop_timer(timer)
  if not timer_closed then
    timer_closed = true
    timer:stop()
    timer:close()
  end
end

---@param name string
local group_name = function(name)
  return Win.prefix_group_name .. name
end

---@generic F: fun()
---@param fn F
---@return F
local function noautocmd(fn)
  return function(...)
    vim.o.eventignore = "all"
    local ok, ret = pcall(fn, ...)
    vim.o.eventignore = ""
    if not ok then
      error(ret)
    end
    return ret
  end
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
}

Win.filetype_skip_resize_layout = {
  ["grug-far"] = true,
  ["oil"] = true,
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
function Win.get_current_layout(tab)
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

  local winid = vim.api.nvim_get_current_win()
  local buf = vim.api.nvim_get_current_buf()

  local tab = vim.fn.tabpagenr()
  Win.update_layout(winid, buf, tab)

  local main_layout = Win.get_current_layout(tab)
  local empty_buf = vim.api.nvim_create_buf(false, true)

  if not is_valid_layout_window(main_layout, buf) then
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

  is_toggle = true
  vim.cmd "wincmd p"
end

---@param cur_winid integer
---@param main_layout_winid integer
---@param fn function
local __cmd_win_call = function(cur_winid, main_layout_winid, fn)
  local saved_before_fn, saved_cmdheight

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

---@param master_saved_layout table
function Win.ensure_main_sidebar_is_left(master_saved_layout)
  local timer = vim.uv.new_timer()
  if not timer then
    return
  end

  local attempts = 0
  local max_attempts = 300
  timer_closed = false
  timer:start(
    20,
    20,
    vim.schedule_wrap(function()
      attempts = attempts + 1

      local layouts_win = RUtils.cmd.windows_is_opened(Win.slot_win.fts, true)
      if layouts_win.found then
        Win.update_layout(layouts_win.winid)
        local main_layout = Win.get_current_layout()

        vim.api.nvim_win_call(main_layout.win, function()
          vim.cmd "wincmd H"
          if master_saved_layout then
            restore_wins(master_saved_layout)
          end

          vim.wo[main_layout.win].winfixwidth = true
          vim.api.nvim_win_set_width(main_layout.win, Win.main_size)
        end)

        stop_timer(timer)
        return
      end

      if attempts >= max_attempts then
        stop_timer(timer)
      end
    end)
  )

  if Win.filetype_blacklist_jump_cursor[vim.bo.filetype] then
    vim.cmd "wincmd p"
  end
end

function Win.keep_sidebar_left()
  if vim.fn.getcmdwintype() ~= "" then
    return
  end

  local main_layout = Win.get_current_layout()

  if not is_valid_layout_window(main_layout) then
    return
  end

  local buf = vim.api.nvim_get_current_buf()
  local winid = main_layout.win
  Win.main_size = _get_width_size()

  local cur_winid = vim.api.nvim_get_current_win()

  if is_ft_skip_resize(cur_winid) then
    return
  end

  if is_float_win(cur_winid) then
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
    __cmd_win_call(cur_winid, winid, function()
      vim.cmd "wincmd H"
    end)
    is_processing_layout = false
  end
end

function Win.update_sidebar()
  noautocmd(function()
    Win.keep_sidebar_left()
  end)()
end

-- +-----------------------------------------------------------------------------+
-- |                                   AUTOCMD                                   |
-- +-----------------------------------------------------------------------------+

local is_autocmd_registered = false -- false = belum di-setup

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
      local found = false
      for _, layout in pairs(Win.layout) do
        if layout.win and vim.api.nvim_win_is_valid(layout.win) then
          found = true
        end
      end

      if found then
        return
      end

      vim.schedule(function()
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
      end)
    end,
  })

  RUtils.map.augroup(group_name "FixSize", {
    event = { "BufWinEnter", "WinResized" },
    pattern = "*",
    command = function()
      if not Win.is_set_layout_width then
        return
      end
      Win.update_sidebar()
    end,
  })

  RUtils.map.augroup(group_name "FileType", {
    event = { "FileType", "VimResized" },
    pattern = "*",
    command = function()
      if not Win.is_set_layout_width then
        return
      end
      vim.schedule(function()
        Win.update_sidebar()
      end)
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
      vim.schedule(function()
        is_processing_layout = false
      end)
    end,
  })

  RUtils.map.augroup(group_name "FixSizeWinEnter", {
    event = { "WinEnter", "BufEnter" },
    pattern = "*",
    command = function()
      if not Win.is_set_layout_width then
        return
      end

      local main_layout = Win.get_current_layout()
      if not is_valid_layout_window(main_layout) then
        return
      end

      vim.schedule(function()
        local buf = vim.api.nvim_get_current_buf()
        local winid = main_layout.win

        if not is_valid_window(winid, buf) then
          return
        end

        Win.main_size = _get_width_size()

        vim.wo[winid].winfixwidth = true
        vim.api.nvim_win_set_width(winid, Win.main_size)

        is_processing_layout = false
      end)
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

  local tab = vim.fn.tabpagenr()
  local main_layout = Win.get_current_layout(tab)

  local current_sidebar = RUtils.cmd.windows_is_opened(Win.slot_win.fts, true)
  local target_skip_win = current_sidebar.found and current_sidebar.winid or main_layout.win
  local master_saved_layout = save_wins_current_tab(target_skip_win)

  if current_sidebar.found then
    vim.api.nvim_win_close(current_sidebar.winid, true)
    vim.schedule(function()
      restore_wins(master_saved_layout)
    end)
  end

  if not is_toggle then
    Win.open_empty_blank_buffer "topleft"
    if not is_force then
      return
    end
  end

  if is_valid_layout_window(main_layout) then
    vim.api.nvim_win_close(main_layout.win, true)
    vim.schedule(function()
      restore_wins(master_saved_layout)
    end)
  end

  fn()

  Win.ensure_main_sidebar_is_left(master_saved_layout)

  is_toggle = false
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
function M.open_window_safely(fn)
  is_processing_layout = true
  is_all_window = false
  local winid = vim.api.nvim_get_current_win()
  local saved = save_wins_current_tab(winid)
  fn()
  vim.schedule(function()
    restore_wins(saved)
    is_processing_layout = false
    is_all_window = false
  end)
end

setup_autocmd()

return M
