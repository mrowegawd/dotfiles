---@class r.utils.fold
local M = {}

---@param winid number
---@param f fun(): any
---@return any
local function win_call(winid, f)
  if winid == 0 or winid == vim.api.nvim_get_current_win() then
    return f()
  else
    return vim.api.nvim_win_call(winid, f)
  end
end

local ft_disabled = { "neo-tree", "aerial" }

---@param winid number
---@param lnum number
---@return number
local function fold_closed(winid, lnum)
  return win_call(winid, function()
    return vim.fn.foldclosed(lnum)
  end)
end

local function find_target_win(current_winnr, exclude_filetypes)
  local candidate = vim.fn.winnr "#"
  local max_attempts = vim.fn.winnr "$"
  local attempt = 0

  while attempt < max_attempts do
    local ft = vim.fn.getwinvar(candidate, "&filetype")
    if
      candidate ~= current_winnr
      and not RUtils.qf.is_quickfix_win(candidate)
      and not vim.tbl_contains(exclude_filetypes, ft)
    then
      return vim.fn.win_getid(candidate)
    end
    candidate = candidate - 1
    if candidate < 1 then
      candidate = vim.fn.winnr "$"
    end
    attempt = attempt + 1
  end

  -- If no suitable window found, use the first non-quickfix window
  for i = 1, vim.fn.winnr "$" do
    if i ~= current_winnr and not RUtils.qf.is_quickfix_win(i) then
      return vim.fn.win_getid(i)
    end
  end

  return nil -- Fallback, though unlikely
end

local function open_qf_items(cmd, indices, opts, is_only)
  opts = opts or {}
  is_only = is_only or false

  if opts and not opts.exclude_filetypes then
    ---@diagnostic disable-next-line: undefined-field
    RUtils.warn "field `exclude_filetypes` required"
    return
  end
  if opts and not opts.enable_autoquickfix then
    RUtils.warn "field `enable_autoquickfix` required"
    return
  end
  if opts and not opts.prevtabwin_policy then
    RUtils.warn "field `prevtabwin_policy` required"
    return
  end

  -- local qf_winid = vim.api.nvim_get_current_win()
  local current_winnr = vim.api.nvim_win_get_number(vim.api.nvim_get_current_win())
  local is_loc = RUtils.qf.is_loclist_win(current_winnr)

  local target_winid = find_target_win(current_winnr, opts.exclude_filetypes)
  if not target_winid then
    return
  end

  local keep_focus = cmd:match "_keep$" ~= nil
  local base_cmd = keep_focus and cmd:gsub("_keep", "") or cmd

  local use_next = base_cmd:match "cnext" ~= nil or base_cmd:match "lnext" ~= nil
  local use_prev = base_cmd:match "cprev" ~= nil or base_cmd:match "lprev" ~= nil
  local use_open = not use_next and not use_prev

  local qf_open_cmd

  if use_open then
    qf_open_cmd = is_loc and "ll" or "cc"
  end

  if use_next then
    qf_open_cmd = is_loc and "lnext" or "cnext"
  end

  if use_prev then
    qf_open_cmd = is_loc and "lprev" or "cprev"
  end

  if use_next or use_prev then
    -- For next/prev, ignore multiple indices, use single
    if #indices > 1 then
      RUtils.warn "Visual selection not supported for next/prev commands. Using cursor position"
    end
    indices = { vim.fn.line "." }
  end

  -- local original_tab = vim.fn.tabpagenr()

  for _, idx in ipairs(indices) do
    vim.api.nvim_set_current_win(target_winid)

    -- local is_new_tab_win = ""

    if open_type == "t" then
      vim.cmd "tabnew"
      -- is_new_tab_win = "nt"
      if opts.enable_autoquickfix then
        if is_loc then
          vim.cmd "lopen"
        else
          vim.cmd "copen"
        end
      end
    elseif open_type == "v" then
      vim.cmd "vertical split"
      -- is_new_tab_win = "nw"
    elseif open_type == "h" then
      vim.cmd "split"
      -- is_new_tab_win = "nw"
    end

    -- Execute open command
    if use_open then
      vim.cmd(qf_open_cmd .. " " .. idx)
    else
      vim.cmd(qf_open_cmd)
    end

    -- Apply policy
    local policy = opts.prevtabwin_policy
    -- local apply_qf_policy = policy == "qf" and cmd == "open" or (policy == "legacy" and open_type == "t")
    local apply_qf_policy = policy == "qf" and not is_only or (policy == "legacy" and open_type == "t")
    if apply_qf_policy then
      -- vim.api.nvim_set_current_win(qf_winid)
      vim.cmd "wincmd p"
    end
  end
end

local function go_first_line()
  vim.cmd "normal! gg"
end

local function go_last_line()
  vim.cmd "normal! G"
end

function M.go_next_prev_fold(is_jump_prev, is_toggle)
  is_toggle = is_toggle or false
  local count = vim.v.count1
  local cnt = 0
  local lnum
  if is_jump_prev then
    local curLnum = vim.api.nvim_win_get_cursor(0)[1]
    for i = curLnum - 1, 1, -1 do
      if fold_closed(0, i) == i then
        cnt = cnt + 1
        lnum = i
        if cnt == count then
          break
        end
      end
    end

    if lnum then
      vim.cmd "norm! m`"
      vim.api.nvim_win_set_cursor(0, { lnum, 0 })

      if is_toggle then
        if vim.fn.foldclosed(vim.fn.line ".") ~= -1 then
          vim.cmd "normal! zMzvzz"
        end
      end
    else
      vim.cmd "norm! zk"
    end
  else
    local curLnum = vim.api.nvim_win_get_cursor(0)[1]
    local lineCount = vim.api.nvim_buf_line_count(0)
    for i = curLnum + 1, lineCount do
      if fold_closed(0, i) == i then
        cnt = cnt + 1
        lnum = i
        if cnt == count then
          break
        end
      end
    end

    if lnum then
      vim.cmd "norm! m`"
      vim.api.nvim_win_set_cursor(0, { lnum, 0 })

      if is_toggle then
        if vim.fn.foldclosed(vim.fn.line ".") ~= -1 then
          vim.cmd "normal! zMzvzz"
        end
      end
    else
      vim.cmd "norm! zj"
    end
  end
end

function M.handle_qf_open(is_jump_prev, qf_mode, is_only)
  is_only = is_only or false
  qf_mode = qf_mode or "open"

  local cmd_direction, nav_key
  local allowed_modes = { "open", "only", "cnext", "cprev", "lnext", "lprev" }

  if not vim.tbl_contains(allowed_modes, qf_mode) then
    ---@diagnostic disable-next-line: undefined-field
    RUtils.warn("Mode yang tersedia: `" .. table.concat(allowed_modes, ", ") .. "`")
    return
  end

  local opts = {
    exclude_filetypes = {},
    prevtabwin_policy = "qf",
    enable_autoquickfix = true,
  }

  local is_loclist = RUtils.qf.is_loclist()

  if is_loclist then
    cmd_direction = is_jump_prev and "lprevious" or "lnext"
    nav_key = cmd_direction == "lnext" and "Down" or "Up"
    qf_mode = cmd_direction
  else
    cmd_direction = is_jump_prev and "cprevious" or "cnext"
    nav_key = cmd_direction == "cnext" and "Down" or "Up"
  end

  local total_items = vim.api.nvim_buf_line_count(0)
  local current_idx = RUtils.qf.get_current_idx_qf(is_loclist)

  local is_nav_disabled = false

  -- If the cursor is at the very bottom line
  if tonumber(total_items) == current_idx and nav_key == "Down" and not is_only then
    go_first_line()
    is_nav_disabled = true

    if is_loclist then
      qf_mode = "open"
    end
  end

  -- If the cursor is at the very top line
  if current_idx == 1 and nav_key == "Up" and not is_only then
    go_last_line()
    is_nav_disabled = true

    if is_loclist then
      qf_mode = "open"
    end
  end

  if not is_nav_disabled then
    if not is_loclist and qf_mode ~= "only" then
      RUtils.map.feedkey("<" .. nav_key .. ">", "n")
    end
  end

  vim.schedule(function()
    local indices = { vim.fn.line "." }
    open_qf_items(qf_mode, indices, opts, is_only)
  end)
end

function M.magic_jump_qf_or_fold(is_jump_prev)
  is_jump_prev = is_jump_prev or false

  if vim.tbl_contains(ft_disabled, vim.bo[0].filetype) then
    if is_jump_prev then
      return RUtils.map.feedkey("<c-p>", "n")
    end
    return RUtils.map.feedkey("<c-n>", "n")
  end

  if vim.wo.diff then
    if is_jump_prev then
      return RUtils.map.feedkey("[c", "n")
    else
      return RUtils.map.feedkey("]c", "n")
    end
  end

  if vim.bo.filetype == "qf" and not qf_mode ~= "only" then
    M.handle_qf_open(is_jump_prev)
    return
  end

  if vim.bo[0].filetype == "markdown" then
    if is_jump_prev then
      return RUtils.markdown.go_to_heading(nil, {})
    end
    return RUtils.markdown.go_to_heading(nil)
  end

  M.go_next_prev_fold(is_jump_prev, false)
end

function M.magic_nextprev_list_qf_or_buf(is_next)
  is_next = is_next or false
  local cmd_msg

  local ft = vim.bo.filetype

  if ft ~= "qf" then
    cmd_msg = "bnext"
    if is_next then
      cmd_msg = "bprev"
    end
    vim.cmd(cmd_msg)
  elseif ft == "qf" then
    if not RUtils.qf.is_loclist() then
      cmd_msg = "cnewer"
      if is_next then
        cmd_msg = "colder"
      end
    else
      cmd_msg = "lnewer"
      if is_next then
        cmd_msg = "lolder"
      end
    end
    vim.schedule(function()
      local _, err = pcall(function()
        vim.fn.execute(cmd_msg)
      end)

      if err and (string.match(err, "E380") or string.match(err, "E381")) then
        local msg = string.format("stack qf %s, sudah mentok", cmd_msg)
        ---@diagnostic disable-next-line: undefined-field
        RUtils.warn(msg, { title = "Quickfix" })
        return
      end
    end)
  end
end

local fold_levels = { 0, 1, 2, 3, 99 }
local current_index = 1

function M.cycle_fold_level()
  current_index = current_index + 1
  if current_index > #fold_levels then
    current_index = 1
  end
  local new_level = fold_levels[current_index]
  vim.o.foldlevel = new_level
  -- if new_level == 0 then
  ---@diagnostic disable-next-line: undefined-field
  RUtils.info("Fold level set to: " .. new_level, { title = "Folds" })
  -- end
end

return M
