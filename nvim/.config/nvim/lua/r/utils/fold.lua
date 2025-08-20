---@class r.utils.fold
local M = {}

---@param winid number
---@param f fun(): any
---@return any
local function winCall(winid, f)
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
  return winCall(winid, function()
    return vim.fn.foldclosed(lnum)
  end)
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

  -- local is_qf_opened = RUtils.cmd.windows_is_opened { "qf" }
  -- if vim.bo.filetype == "qf" or is_qf_opened.found then
  if vim.bo.filetype == "qf" then
    local cmd_next_or_prev, cmd_go_first_or_last

    if not RUtils.qf.is_loclist() then
      cmd_next_or_prev = is_jump_prev and "cprevious" or "cnext"
      cmd_go_first_or_last = is_jump_prev and "clast" or "cfirst"
    else
      cmd_next_or_prev = is_jump_prev and "lprevious" or "lnext"
      cmd_go_first_or_last = is_jump_prev and "llast" or "lfirst"
    end

    vim.schedule(function()
      local current_win = vim.api.nvim_get_current_win() -- ⬅ Simpan window aktif
      local current_buf = vim.api.nvim_get_current_buf()

      local _, err = pcall(function()
        vim.cmd(cmd_next_or_prev)
        vim.cmd "normal! zz"

        -- RUtils.info(cmd_next_or_prev)

        -- local buf = vim.api.nvim_get_current_buf()
        -- if vim.bo[buf].filetype ~= "qf" then
        --   vim.cmd "wincmd p"
        -- end

        -- Pastikan kita kembali ke window semula jika berpindah
        if vim.api.nvim_get_current_win() ~= current_win then
          vim.api.nvim_set_current_win(current_win)
          vim.api.nvim_set_current_buf(current_buf)
        end
      end)

      if err and string.match(err, "E553") then
        -- vim.cmd [[normal! gg]]
        -- RUtils.map.feedkey("<CR>", "n")

        -- RUtils.info(cmd_go_first_or_last)
        vim.cmd(cmd_go_first_or_last)
        vim.cmd "wincmd p"
      end
    end)
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
