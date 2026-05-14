---@class r.utils.sessions

local M = {
  fzf = {
    mappings = {
      default = {},
      delete = {},
    },
  },
}

-- ╭─────────────────────────────────────────────────────────╮
-- │ FZF MAPPING                                             │
-- ╰─────────────────────────────────────────────────────────╯

M.fzf.mappings.default = function(session)
  return function(sel)
    local selection = sel[1]
    session.load(selection)
  end
end

M.fzf.mappings.delete = function(session_path)
  return function(sel)
    local fname = sel[1]
    local file_path = session_path .. "/" .. fname .. ".json"

    if vim.fn.filereadable(file_path) ~= 1 then
      RUtils.error("File not found: `" .. file_path .. "`")
      return
    end

    local ok, err = os.remove(file_path)
    if not ok then
      RUtils.error("Failed to delete file: " .. err)
      return
    end
    RUtils.info("Session delete `" .. file_path .. "`")
  end
end

-- ╭─────────────────────────────────────────────────────────╮
-- │ HELPER                                                  │
-- ╰─────────────────────────────────────────────────────────╯

function M.last_session_name()
  -- buat nama session "last" yang unik per direktori
  local cwd = vim.uv.cwd() or ""
  local safe = cwd:gsub("[^%w%-_]", "_"):gsub("_+", "_"):gsub("^_", ""):gsub("_$", "")
  return "last__" .. safe
end

-- ╭─────────────────────────────────────────────────────────╮
-- │ CALLER                                                  │
-- ╰─────────────────────────────────────────────────────────╯

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
      require("resession").load(M.last_session_name(), { silence_errors = true })
    else
      require("resession").load()
    end

    local qflist = RUtils.qf.get_list_qf()
    if #qflist.items > 0 then
      vim.cmd(RUtils.qf.copen)
      vim.cmd [[wincmd p]]
      vim.cmd [[set cmdheight=0]]
      return
    end

    local loclist = RUtils.qf.get_list_qf(true)
    if #loclist.items > 0 then
      vim.cmd(RUtils.qf.lopen)
      vim.cmd [[wincmd p]]
      vim.cmd [[set cmdheight=0]]
      return
    end
  end

  if not has_auto_session and not has_persistent and not has_resession then
    ---@diagnostic disable-next-line: undefined-field
    RUtils.warn("Unable to load the session. The required plugins may not be installed..", { title = "Sessions" })
  end
end

return M
