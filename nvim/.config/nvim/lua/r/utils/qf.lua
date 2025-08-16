---@class r.utils.qf
local M = {}

local results = {
  quickfix = {},
  location = {},
}

-- example use; M.is_loclist() and "Location List" or "Quickfix List"
function M.is_loclist(buf)
  buf = buf or 0
  return vim.fn.getloclist(buf, { filewinid = 1 }).filewinid ~= 0
end

function M.get_qf_cursor_idx()
  local cur_list = {}
  local count = vim.v.count

  if count == 0 then
    count = 1
  end

  if count > #cur_list then
    count = #cur_list
  end

  local item = api.nvim_win_get_cursor(0)[1]
  for _ = item, item + count - 1 do
    table.remove(cur_list, item)
  end

  return vim.fn.getqflist()[item]
end

function M.get_title_qf(is_loc)
  is_loc = is_loc or false
  if not is_loc then
    return vim.fn.getqflist({ title = 0 }).title
  end

  return vim.fn.getloclist(0, { title = 0 }).title
end

function M.get_list_qf(is_loc)
  is_loc = is_loc or false
  if not is_loc then
    return vim.fn.getqflist()
  end

  local winid = vim.api.nvim_get_current_win()
  return vim.fn.getloclist(winid)
end

function M.get_data_qf(is_loc)
  is_loc = is_loc or false

  if not is_loc then
    local qf_list = M.get_list_qf()
    if #qf_list > 0 then
      results.quickfix.items = vim.tbl_map(function(item)
        return {
          filename = item.bufnr and vim.api.nvim_buf_get_name(item.bufnr),
          bufnr = item.bufnr,
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

    return results
  end

  local loc_list = M.get_list_qf(true)
  if #loc_list > 0 then
    results.location.items = vim.tbl_map(function(item)
      return {
        filename = item.bufnr and vim.api.nvim_buf_get_name(item.bufnr),
        bufnr = item.bufnr,
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

  return results
end

function M.save_to_qf(items, title, is_loc, winid)
  is_loc = is_loc or false

  if not is_loc then
    vim.fn.setqflist({}, " ", { items = items, title = title })
    return
  end

  winid = winid or vim.api.nvim_get_current_win()
  vim.fn.setloclist(winid, {}, " ", { items = items, title = title })
end

function M.save_to_qf_and_auto_open_qf(items, title, is_loc, winid)
  is_loc = is_loc or false

  M.save_to_qf(items, title, is_loc, winid)

  if not is_loc then
    vim.cmd(RUtils.cmd.quickfix.copen)
    return
  end

  vim.cmd(RUtils.cmd.quickfix.lopen)
end

return M
