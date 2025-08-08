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

  local is_qf_opened = RUtils.cmd.windows_is_opened { "qf" }
  if vim.bo.filetype == "qf" and is_qf_opened.found then
    local cmd_next_or_prev, cmd_go_first_or_last

    if not RUtils.qf.is_loclist() then
      cmd_next_or_prev = "cnext"
      cmd_go_first_or_last = "cfirst"

      if is_jump_prev then
        cmd_next_or_prev = "cprevious"
        cmd_go_first_or_last = "clast"
      end
    else
      cmd_next_or_prev = "lnext"
      cmd_go_first_or_last = "lfirst"

      if is_jump_prev then
        cmd_next_or_prev = "lprevious"
        cmd_go_first_or_last = "llast"
      end
    end

    vim.schedule(function()
      local _, err = pcall(function()
        vim.cmd(cmd_next_or_prev)
        vim.cmd "normal! zz"

        -- RUtils.info(cmd_next_or_prev)

        local buf = vim.api.nvim_get_current_buf()
        if vim.bo[buf].filetype ~= "qf" then
          vim.cmd "wincmd p"
        end
      end)

      if err and string.match(err, "E553") then
        -- vim.cmd [[normal! gg]]
        -- RUtils.map.feedkey("<CR>", "n")

        -- RUtils.info(cmd_go_first_or_last)
        vim.cmd(cmd_go_first_or_last)
        vim.cmd "wincmd p"
      end
      --
      -- TESTE
      --

      -- local _, err = pcall(function()
      --   -- simpan jendela aktif sebelum loncat
      --
      --   local current_win = vim.api.nvim_get_current_win()
      -- RUtils.warn(current_win .. " >> " .. cmd_next_or_prev)

      -- jalankan perintah loncat quickfix
      --     vim.cmd(cmd_next_or_prev)
      --     vim.cmd "normal! zz"
      --
      --     -- ambil buffer aktif setelah loncat
      --     local new_buf = vim.api.nvim_get_current_buf()
      --
      --     -- cek apakah jendela sekarang buffer-nya quickfix
      --     if vim.bo[new_buf].filetype ~= "qf" then
      --       -- cek apakah buffer ini juga sudah terbuka di jendela lain
      --       local wins = vim.api.nvim_list_wins()
      --       local found = false
      --
      --       for _, win in ipairs(wins) do
      --         if win ~= current_win then
      --           local buf_in_win = vim.api.nvim_win_get_buf(win)
      --           if buf_in_win == new_buf then
      --             found = true
      --             break
      --           end
      --         end
      --       end
      --
      --       -- kalau buffer ditemukan di jendela lain, jangan tukar kembali
      --       if not found then
      --         -- kembali ke jendela sebelumnya
      --         vim.cmd "wincmd p"
      --       end
      --       vim.cmd "wincmd p"
      --     end
      --   end)
      --
      --   if err and string.match(err, "E553") then
      --     -- tidak ada entry lagi di quickfix/liste
      --     vim.cmd(cmd_go_first_or_last)
      --     vim.cmd "wincmd p"
      --   end
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
        local msg = "stack qf list sudah mentok"
        ---@diagnostic disable-next-line: undefined-field
        RUtils.warn(msg, { title = "Quickfix" })
        return
      end

      -- if vim.tbl_contains({ "bnext", "lnext", "cnewer", "colder" }, cmd_msg) then
      --   ---@diagnostic disable-next-line: undefined-field
      --   RUtils.info(cmd_msg, { title = "QF" })
      -- end
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
  if new_level == 0 then
    ---@diagnostic disable-next-line: undefined-field
    RUtils.info("Fold level set to: " .. new_level, { title = "Folds" })
  end
end

return M
