---@class r.utils.session
local M = {}

---@param last? boolean
function M.load_session_from_dashboard(last)
  last = last or false

  local has_persistent = RUtils.has "persistence.nvim"
  local has_resession = RUtils.has "resession.nvim"
  local has_auto_session = RUtils.has "auto-session"

  if has_persistent then
    vim.schedule(function()
      -- require("qfsilet.note").get_todo()
      require("persistence").load()
      vim.cmd "silent! :e"
    end)
  end

  if has_auto_session then
    if last then
      vim.cmd "SessionRestore last"
    else
      vim.cmd "SessionSearch"
    end
  end

  if has_resession then
    if last then
      require("resession").load "last"
    else
      require("resession").load()
    end

    if #RUtils.qf.get_list_qf() > 0 then
      vim.cmd(RUtils.qf.copen)
      vim.cmd [[wincmd p]]
      vim.cmd [[set cmdheight=0]]
    end
  end

  if not has_auto_session and not has_persistent and not has_resession then
    ---@diagnostic disable-next-line: undefined-field
    RUtils.warn("Unable to load the session. The required plugins may not be installed..", { title = "Sessions" })
  end
end

return M
