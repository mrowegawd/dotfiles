local M = {}

local result = {}

M.on_save = function()
  local qf_list = vim.fn.getqflist()
  if #qf_list > 0 then
    result.quickfix = vim.tbl_map(function(item)
      return {
        filename = item.bufnr and vim.api.nvim_buf_get_name(item.bufnr),
        module = item.module,
        lnum = item.lnum,
        end_lnum = item.end_lnum,
        col = item.col,
        end_col = item.end_col,
        vcol = item.vcol,
        nr = item.nr,
        pattern = item.pattern,
        text = item.text,
        type = item.type,
        valid = item.valid,
      }
    end, qf_list)
  end

  local winid = vim.api.nvim_get_current_win()
  local loc_list = vim.fn.getloclist(winid)
  if #loc_list > 0 then
    result.location = vim.tbl_map(function(item)
      return {
        filename = item.bufnr and vim.api.nvim_buf_get_name(item.bufnr),
        module = item.module,
        lnum = item.lnum,
        end_lnum = item.end_lnum,
        col = item.col,
        end_col = item.end_col,
        vcol = item.vcol,
        nr = item.nr,
        pattern = item.pattern,
        text = item.text,
        type = item.type,
        valid = item.valid,
      }
    end, loc_list)
  end

  return result
end

M.on_pre_load = function(data)
  if data.quickfix and #data.quickfix > 0 then
    vim.fn.setqflist({}, " ", { items = data.quickfix })
  end

  if data.location and #data.location > 0 then
    local winid = vim.api.nvim_get_current_win()
    vim.fn.setloclist(winid, {}, " ", { items = data.location })
  end
end

M.is_win_supported = function(winid, bufnr)
  return vim.bo[bufnr].buftype == "quickfix"
end

M.save_win = function(winid)
  return {}
end

M.load_win = function(winid, config)
  vim.api.nvim_set_current_win(winid)
  -- if #result.quickfix > 0 then
  --   vim.cmd "belowright copen"
  -- end
  -- if #result.location > 0 then
  --   vim.cmd "belowright lopen"
  -- end
  vim.api.nvim_win_close(winid, true)
  return vim.api.nvim_get_current_win()
end

return M
