---@class r.utils.session
local M = {}

function M.load_ses()
  local MS = require "mini.sessions"
  local branch_name = "temp"
  local path_cwd = vim.uv.cwd()

  local cwd = ""
  if type(path_cwd) == "string" then
    cwd = vim.fn.fnameescape(path_cwd)
  end

  local session_name = string.format("%s_%s", branch_name, cwd)
  -- -- replace slash, space, backslash, dot etc specifical char in session_name to underscore
  session_name = string.gsub(session_name, "[/\\ .]", "_")
  local _, err = pcall(MS.read, session_name, {
    -- do not delete unsaved buffer.
    force = false,
    verbose = true,
  })
  if err then
    vim.notify("Load session fail: " .. session_name, vim.log.levels.ERROR)
  end
end

function M.load_ses_dashboard(last)
  last = last or false
  local has_persistent = RUtils.has "persistence.nvim"
  local has_auto_session = RUtils.has "auto-session"
  local has_resession = RUtils.has "resession.nvim"

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
  end

  if #RUtils.qf.get_list_qf() > 0 then
    vim.cmd(RUtils.cmd.quickfix.copen)
    vim.cmd [[wincmd p]]
    vim.cmd [[set cmdheight=0]]
  end

  if not has_auto_session and not has_persistent and not has_resession then
    ---@diagnostic disable-next-line: undefined-field
    RUtils.warn("Unable to load the session. The required plugins may not be installed..", { title = "Sessions" })
  end
end

return M
