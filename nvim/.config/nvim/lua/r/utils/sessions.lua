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
    resession.load()

    vim.api.nvim_create_autocmd("BufWinEnter", {
      group = vim.api.nvim_create_augroup("ResessionLoadTest", { clear = true }),
      pattern = "*",
      once = true,
      callback = function()
        local ft = vim.bo[0].filetype
        vim.cmd [[set cmdheight=0]]
        if ft and ft ~= "fzf" then
          local async
          async = uv.new_async(vim.schedule_wrap(function()
            if async ~= nil then
              -- NOTE: terkadang error kalau item list session tidak kita select
              -- seharunya diperbaiki itu
              if #vim.fn.getqflist() > 0 then
                vim.cmd [[copen]]
                vim.cmd [[wincmd p]]
              end

              if vim.bo[0].filetype ~= "dashboard" then
                if vim.bo[0].filetype == "" then
                  return
                end
                vim.cmd [[edit!]]
              end

              require("qfsilet.note").get_todo()

              vim.cmd [[set cmdheight=0]]
              async:close()
            end
          end))

          if async ~= nil then
            async:send()
          end

          -- ensure treesitter loaded
          if vim.bo[0].filetype ~= "dashboard" then
            if vim.bo[0].filetype == "" then
              return
            end
            vim.cmd [[edit!]]
          end
        end
      end,
    })
  else
    RUtils.warn("Cannot load sessions, plugin " .. ses_plugin .. " error?", { title = "Sessions" })
  end
end

return M
