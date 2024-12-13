---@class r.utils.session
local M = {}

function M.save_ses()
  local MS = require "mini.sessions"
  local branch_name = "temp"
  local path_cwd = vim.uv.cwd()

  local cwd = ""
  if type(path_cwd) == "string" then
    cwd = vim.fn.fnameescape(path_cwd)
  end
  local session_name = string.format("%s_%s", branch_name, cwd)
  -- replace slash, space, backslash, dot etc specifical char in session_name to underscore
  session_name = string.gsub(session_name, "[/\\ .]", "_")
  MS.write(session_name, {
    force = true,
  })
end

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

function M.load_ses_dashboard()
  local uv = vim.loop

  local ses_plugin = "resession.nvim"

  if RUtils.has(ses_plugin) then
    local resession = require "resession"
    resession.load "last"

    if #vim.fn.getqflist() > 0 then
      vim.cmd [[copen]]
      vim.cmd [[wincmd p]]
    end

    local async
    async = uv.new_async(vim.schedule_wrap(function()
      if async ~= nil then
        require("qfsilet.note").get_todo()
        async:close()
      end
    end))

    if async ~= nil then
      async:send()
    end

    -- if sessions are not loaded, dont run this command
    if vim.bo[0].filetype ~= "dashboard" then
      if vim.bo[0].filetype == "" then
        return
      end
      vim.cmd [[edit!]]
    end

    if not vim.env.TMUX then
      RUtils.terminal.clock_mode()
    end

    vim.cmd [[set cmdheight=0]]
  else
    RUtils.warn("can't find your" .. ses_plugin .. " !", { title = "Sessions" })
  end
end

return M
