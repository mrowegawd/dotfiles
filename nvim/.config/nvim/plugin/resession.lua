local add = require("vim-pack").add

local UtilKey = require "utils.map"
local UtilSession = require "utils.session"
local UtilAugroup = require("utils.map").augroup

local Log = require "utils.log"

local mappings = {}

mappings.default = function(session)
  return function(sel)
    local selection = sel[1]
    session.load(selection)
  end
end

mappings.delete = function(session_path)
  return function(sel)
    local fname = sel[1]
    local file_path = session_path .. "/" .. fname .. ".json"

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
    require("fzf-lua").resume()
  end
end

add {
  {
    src = "stevearc/resession.nvim",
    opts = function()
      return {
        autosave = {
          enabled = true,
          notify = false,
        },
        buf_filter = function(bufnr)
          if vim.fn.getcmdwintype() ~= "" then
            return false
          end

          if vim.tbl_contains({ "git", "help", "trouble" }, vim.bo.filetype) then
            return false
          end

          if vim.bo[bufnr].buftype == "terminal" then
            local bufname = vim.api.nvim_buf_get_name(bufnr)
            if bufname:match ":tclock" then
              return false
            elseif bufname:match ":timr" then
              return false
            end
            return true
          end

          local name = vim.api.nvim_buf_get_name(bufnr)
          if name:match "^fugitive://" then
            return false
          end

          if not require("resession").default_buf_filter(bufnr) then
            return false
          end

          return true
        end,
        extensions = { qforlf = {} },
      }
    end,
    on_setup = function()
      local resession = require "resession"

      UtilKey.nnoremap("<Leader>sS", function()
        vim.ui.input({ prompt = "Session name" }, function(selected)
          if selected then
            resession.save(selected, {})
          end
        end)
      end, { desc = "Session: save session with name [resession.nvim]" })

      UtilKey.nnoremap("<Leader>ss", function()
        resession.save(UtilSession.last_session_name())
      end, { desc = "Session: save last session (per CWD) [resession.nvim]" })

      UtilKey.nnoremap("<Leader>sl", function()
        local last_sesname = UtilSession.last_session_name()
        ---@diagnostic disable-next-line: undefined-field
        Log.info("Load session: `" .. last_sesname .. "`")
        resession.load(last_sesname, { silence_errors = true })
      end, { desc = "Session: load last session (per CWD) [resession.nvim]" })

      UtilKey.nnoremap("<Leader>sL", function()
        local home = os.getenv "HOME"
        local session_path = vim.fs.joinpath(home, ".local", "share", "nvim", "session")

        Log.warn "not impelemented yet"

        require("fzf-lua").files {
          cwd = session_path,
          -- prompt = RUtils.fzflua.padding_prompt(),
          no_header = true, -- disable default header
          winopts = {
            -- title = RUtils.fzflua.format_title("Load Session", "󰈙"),
            fullscreen = false,
            preview = {
              hidden = true,
            },
          },
          fzf_opts = { ["--header"] = [[^x:delete]] },
          cmd = "fd -d 1 -e json --exec stat --format '%Z %n' {} | sort -nr | cut -d' ' -f2- | sed 's/.json$//' | sed 's/\\.\\///'",
          actions = {
            ["default"] = mappings.default(resession),
            ["ctrl-x"] = mappings.delete(session_path),
          },
        }
      end, { desc = "Session: load session from lists [resession.nvim]" })

      UtilKey.nnoremap("<Leader>sD", function()
        resession.detach()
        ---@diagnostic disable-next-line: undefined-field
        Log.warn "Session detach now!"
      end, { desc = "Session: detach [resession.nvim]" })

      if vim.tbl_contains(resession.list(), "__quicksave__") then
        vim.defer_fn(function()
          resession.load("__quicksave__", { attach = false })
          local ok, err = pcall(resession.delete, "__quicksave__")
          if not ok then
            vim.notify(string.format("Error deleting quicksave session: %s", err), vim.log.levels.WARN)
          end
        end, 50)
      end

      UtilAugroup("AUResession", {
        event = "VimEnter",
        once = true,
        command = function()
          if vim.fn.argc(-1) == 0 then
            resession.load(vim.uv.cwd(), { dir = "dirsession", silence_errors = true })
          end
        end,
      }, {
        event = { "VimLeavePre" },
        command = function()
          for _, buf in ipairs(vim.api.nvim_list_bufs()) do
            local name = vim.api.nvim_buf_get_name(buf)

            if name:match "^fugitive://" then
              vim.api.nvim_buf_delete(buf, { force = true })
            end
          end
          resession.save(UtilSession.last_session_name())
        end,
      })
    end,
  },
}
