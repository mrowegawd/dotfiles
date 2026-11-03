local add = require("vim-pack").add

local lazy = require("utils.plugin").require_lazy

local UtilKey = lazy "utils.map"
local UtilSession = lazy "utils.session"
local UtilAugroup = lazy("utils.map").augroup

local Log = lazy "utils.log"

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

          if not lazy("resession").default_buf_filter(bufnr) then
            return false
          end

          return true
        end,
        -- extensions = { qforlf = {} },
      }
    end,
    on_setup = function()
      local resession = lazy "resession"

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
        lazy("utils.session").select_session()
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
            Log.warn(string.format("Error deleting quicksave session: %s", err))
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
