---@class r.utils.session
local M = {}

function M.save_ses()
  local MS = require "mini.sessions"
  -- local branch_name = vim.fn["FugitiveHead"]() or "temp"
  -- local cwd = vim.fn.fnameescape(vim.cfg.runtime__starts_cwd)
  -- local session_name = string.format("%s_%s", branch_name, cwd)
  -- -- replace slash, space, backslash, dot etc specifical char in session_name to underscore
  -- local session_name = "fasfd"
  -- session_name = string.gsub(session_name, "[/\\ .]", "_")

  local branch_name = "temp"
  local cwd = vim.fn.fnameescape(vim.uv.cwd())
  local session_name = string.format("%s_%s", branch_name, cwd)
  -- -- replace slash, space, backslash, dot etc specifical char in session_name to underscore
  session_name = string.gsub(session_name, "[/\\ .]", "_")
  MS.write(session_name, {
    force = true,
  })
end

function M.load_ses()
  local MS = require "mini.sessions"
  -- local branch_name = vim.fn["FugitiveHead"]() or "temp"
  local branch_name = "temp"
  local cwd = vim.fn.fnameescape(vim.uv.cwd())
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

function M.load_ses_dashboard()
  if RUtils.has "resession.nvim" then
    require("resession").load(vim.fn.getcwd(), { dir = "dirsession", silence_errors = true })
    if #vim.fn.getqflist() > 0 then
      vim.cmd [[copen]]
      vim.cmd [[wincmd p]]
    end
  else
    RUtils.warn("Atm you have NONE session plugin?!", { title = "Sessions" })
  end
end

return M
