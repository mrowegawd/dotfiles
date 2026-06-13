local is_setup_mapping_session

return {
  --  ╭──────────────────────────────────────────────────────────╮
  --  │                         SESSION                          │
  --  ╰──────────────────────────────────────────────────────────╯
  -- RESSESSION.NVIM
  {
    "stevearc/resession.nvim",
    event = "VeryLazy",
    keys = {
      "<Leader>st",
      "<Leader>sl",
      "<Leader>sL",
      "<Leader>sd",
    },
    opts = {
      autosave = {
        enabled = true,
        -- interval = 15, -- How often to save (in seconds)
        notify = false,
      },
      buf_filter = function(bufnr)
        local name = vim.api.nvim_buf_get_name(bufnr)
        if name:match "^fugitive://" then
          return false
        end

        if vim.bo.filetype == "git" then
          return false
        end

        if vim.bo.filetype == "help" then
          return true
        end

        -- save terminal
        if vim.bo[bufnr].buftype == "terminal" then
          --- ignore tclock
          local bufname = vim.api.nvim_buf_get_name(bufnr)
          if bufname:match ":tclock" then
            return false
          elseif bufname:match ":timr" then
            return false
          end
          return true
        end

        if vim.bo.filetype == "trouble" then
          return false
        end

        if not require("resession").default_buf_filter(bufnr) then
          return false
        end

        return true
      end,
      extensions = { qforlf = {} },
      options = { -- remove `cmdheight` from this
        "binary",
        "bufhidden",
        "buflisted",
        "cmdheight",
        "diff",
        "filetype",
        "modifiable",
        "previewwindow",
        "readonly",
        "scrollbind",
        "winfixheight",
        "winfixwidth",
      },
    },
    config = function(_, opts)
      local resession = require "resession"
      resession.setup(opts)

      if not is_setup_mapping_session then
        is_setup_mapping_session = true

        RUtils.map.nnoremap("<Leader>qS", function()
          vim.ui.input({ prompt = "Session name" }, function(selected)
            if selected then
              resession.save(selected, {})
            end
          end)
        end, { desc = "Session: save session with name [resession.nvim]" })

        RUtils.map.nnoremap("<Leader>qs", function()
          resession.save(RUtils.sessions.last_session_name())
        end, { desc = "Session: save last session (per CWD) [resession.nvim]" })

        RUtils.map.nnoremap("<Leader>qw", function()
          local last_session_name = RUtils.sessions.last_session_name()
          RUtils.info("Load session: `" .. last_session_name .. "`")
          resession.load(last_session_name, { silence_errors = true })
        end, { desc = "Session: load last session (per CWD) [resession.nvim]" })

        RUtils.map.nnoremap("<Leader>qW", function()
          local home = os.getenv "HOME"
          local session_path = vim.fs.joinpath(home, ".local", "share", "nvim", "session")

          require("fzf-lua").files(RUtils.fzflua.open_center_small_wide {
            cwd = session_path,
            prompt = RUtils.fzflua.padding_prompt(),
            no_header = true, -- disable default header
            winopts = {
              title = RUtils.fzflua.format_title("Load Session", "󰈙"),
              fullscreen = false,
              preview = {
                hidden = true,
              },
            },
            fzf_opts = { ["--header"] = [[^x:delete]] },
            cmd = "fd -d 1 -e json --exec stat --format '%Z %n' {} | sort -nr | cut -d' ' -f2- | sed 's/.json$//' | sed 's/\\.\\///'",
            actions = {
              ["default"] = RUtils.sessions.fzf.mappings.default(resession),
              ["ctrl-x"] = RUtils.sessions.fzf.mappings.delete(session_path),
            },
          })
        end, { desc = "Session: load session from lists [resession.nvim]" })

        RUtils.map.nnoremap("<Leader>qD", function()
          resession.detach()
          RUtils.warn "Session detach now!"
        end, { desc = "Session: detach [resession.nvim]" })
      end

      if vim.tbl_contains(resession.list(), "__quicksave__") then
        vim.defer_fn(function()
          resession.load("__quicksave__", { attach = false })
          local ok, err = pcall(resession.delete, "__quicksave__")
          if not ok then
            vim.notify(string.format("Error deleting quicksave session: %s", err), vim.log.levels.WARN)
          end
        end, 50)
      end

      RUtils.map.augroup("AUResession", {
        event = "VimEnter",
        command = function()
          -- Only load the session if nvim was started with no args
          if vim.fn.argc(-1) == 0 then
            -- Save these to a different directory, so our manual sessions don't get polluted
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
          resession.save(RUtils.sessions.last_session_name()) -- per-CWD
        end,
      })
    end,
  },

  --  ╭──────────────────────────────────────────────────────────╮
  --  │                         PROJECTS                         │
  --  ╰──────────────────────────────────────────────────────────╯
  -- PROJECTS.NVIM
  {
    "DrKJeff16/project.nvim",
    cmd = { "Project" },
    keys = {
      {
        "<Leader>pp",
        function()
          local fzf_lua = RUtils.cmd.reqcall "fzf-lua"
          local history = require "project.util.history"
          fzf_lua.fzf_exec(
            function(cb)
              local results = history.get_recent_projects()
              for _, e in ipairs(results) do
                cb(e.path)
              end
              cb()
            end,
            RUtils.fzflua.open_dock_bottom {
              fzf_opts = { ["--header"] = [[^x:delete  ^o:show config]] },
              winopts = { title = RUtils.fzflua.format_title("Project.nvim Lists", RUtils.config.icons.misc.bookmark) },
              actions = {
                ["default"] = function(selected)
                  fzf_lua.files { cwd = selected[1] }
                end,
                ["ctrl-o"] = function()
                  vim.cmd "Project! config"
                end,
                ["ctrl-x"] = {
                  function(selected)
                    history.delete_project { value = selected[1] }

                    require("fzf-lua").actions.resume()
                  end,
                },
              },
            }
          )
        end,
        desc = "Project: select/delete and show config projects [project.nvim]",
      },
      {
        "<Leader>ps",
        function()
          vim.cmd "Project root"

          local cwd = vim.uv.cwd()
          if cwd then
            local dir_cwd = vim.fn.fnamemodify(cwd, ":t")
            ---@diagnostic disable-next-line: undefined-field
            RUtils.info(string.format("`%s` project saved", dir_cwd), { title = "Projects.nvim" })
          end
        end,
        desc = "Project: save [project.nvim]",
      },
    },
    opts = {
      show_hidden = true,
      history = { save_dir = string.format("%s/data.programming.forprivate", RUtils.config.path.dropbox_path) },
      telescope = {
        disable_file_picker = true,
        prefer_file_browser = true,
      },
    },
  },
}
