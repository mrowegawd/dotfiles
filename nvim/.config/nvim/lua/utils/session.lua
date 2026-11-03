local M = {}

local lazy = require("utils.plugin").require_lazy

local Log = lazy "utils.log"

local function session_path()
  local home = os.getenv "HOME"
  return vim.fs.joinpath(home, ".local", "share", "nvim", "session")
end

local mappings = {}

mappings.default = function(session)
  return function(sel)
    local selection = sel[1]
    selection = lazy("utils.cmd").__strip_str(selection)
    session.load(selection)
  end
end

mappings.delete = function(ses_path)
  return function(sel)
    local fname = sel[1]
    local file_path = ses_path .. "/" .. fname .. ".json"

    if vim.fn.filereadable(file_path) ~= 1 then
      Log.error("File not found: `" .. file_path .. "`")
      return
    end

    local ok, err = os.remove(file_path)
    if not ok then
      Log.error("Failed to delete file: " .. err)
      return
    end
    Log.info("Session delete `" .. file_path .. "`")
    lazy("fzf-lua").resume()
  end
end

function M.last_session_name()
  local cwd = vim.uv.cwd() or ""
  local safe = cwd:gsub("[^%w%-_]", "_"):gsub("_+", "_"):gsub("^_", ""):gsub("_$", "")
  return "last__" .. safe
end

local function pick(plugin_name_session, ses_path)
  lazy("fzf-lua").files {
    cwd = ses_path,
    no_header = true, -- disable default header
    winopts = {
      title = "Select Load Session",
      fullscreen = false,
      preview = {
        hidden = true,
      },
    },
    fzf_opts = { ["--header"] = [[^x:delete]] },
    cmd = "fd -d 1 -e json --exec stat --format '%Z %n' {} | sort -nr | cut -d' ' -f2- | sed 's/.json$//' | sed 's/\\.\\///'",
    actions = {
      ["default"] = mappings.default(plugin_name_session),
      ["ctrl-x"] = mappings.delete(ses_path),
    },
  }
end

function M.select_session()
  -- Nanti next day pakai resession, session.nvim, or whatever
  local resession = lazy "resession"

  local ses_path = session_path()

  pick(resession, ses_path)
end

return M
