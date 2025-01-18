return {
  --  ╭──────────────────────────────────────────────────────────╮
  --  │                         SESSION                          │
  --  ╰──────────────────────────────────────────────────────────╯
  -- AUTO-SESSION (disabled)
  {
    "rmagatti/auto-session",
    enabled = false,
    lazy = false,
    cmd = { "SessionSave", "SessionSearch", "SessionDelete", "SessionRestore", "SessionToggleAutoSave", "Autosession" },
    keys = {
      {
        "<Leader>sl",
        function()
          vim.cmd [[SessionRestore last]]
        end,
        desc = "Misc: restore last session [auto-session.nvim]",
      },
      {
        "<Leader>sL",
        function()
          vim.cmd [[SessionSearch]]
        end,
        desc = "Misc: restore session with picker [auto-session.nvim]",
      },
      {
        "<Leader>sd",
        function()
          vim.cmd [[Autosession delete]]
        end,
        desc = "Misc: delete session with picker [auto-session.nvim]",
      },
      {
        "<Leader>sS",
        function()
          vim.ui.input({ prompt = "Save session name" }, function(selected)
            if selected then
              vim.cmd("SessionSave " .. selected)
            end
          end)
        end,
        desc = "Misc: save session with name [auto-session.nvim]",
      },
    },
    opts = function()
      RUtils.cmd.augroup("AutoSessionLeave", {
        event = { "VimLeavePre" },
        command = function()
          vim.cmd [[SessionSave last]]
        end,
      })

      return {
        auto_restore = false, -- Enables/disables auto restoring session on start
        -- suppressed_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
        -- log_level = 'debug',
        session_lens = {
          load_on_setup = true, -- Initialize on startup (requires Telescope)
          -- theme_conf = { -- Pass through for Telescope theme options
          --   -- layout_config = { -- As one example, can change width/height of picker
          --   --   width = 0.8,    -- percent of window
          --   --   height = 0.5,
          --   -- },
          -- },
          previewer = false, -- File preview for session picker
          mappings = {
            -- Mode can be a string or a table, e.g. {"i", "n"} for both insert and normal mode
            delete_session = { "i", "<C-x>" },
            alternate_session = { "i", "<C-S>" },
            copy_session = { "i", "<C-Y>" },
          },

          session_control = {
            control_dir = vim.fn.stdpath "data" .. "/auto_session/", -- Auto session control dir, for control files, like alternating between two sessions with session-lens
            control_filename = "session_control.json", -- File name of the session control file
          },
        },
      }
    end,
  },
  -- RESSESSION.NVIM
  {
    "stevearc/resession.nvim",
    event = "VeryLazy",
    opts = {
      autosave = {
        enabled = true,
        notify = false,
      },
      buf_filter = function(bufnr)
        if not require("resession").default_buf_filter(bufnr) then
          return false
        end
        return true
      end,
      -- extensions = { quickfix = {} },
      extensions = {},
      options = { -- remove `cmdheight` from this
        "binary",
        "bufhidden",
        "buflisted",
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

      vim.keymap.set("n", "<Leader>sS", function()
        vim.ui.input({ prompt = "Session name" }, function(selected)
          if selected then
            resession.save(selected, {})
          end
        end)
      end, { desc = "Misc: save with session name [resession.nvim]" })
      --stylua: ignore
      vim.keymap.set("n", "<Leader>ss", function() resession.save() end, { desc = "Misc: save session with current name [resession.nvim]" })
      --stylua: ignore
      vim.keymap.set("n", "<Leader>st", function() resession.save_tab() end, { desc = "Misc: save session tab [resession.nvim]" })
      --stylua: ignore
      vim.keymap.set("n", "<Leader>sl", function() resession.load() end, { desc = "Misc: load from list sessions [resession.nvim]" })
      --stylua: ignore
      -- vim.keymap.set("n", "<Leader>sl", function() resession.load "last" end, { desc = "Misc: load last session [resession.nvim]" })
      vim.keymap.set("n", "<Leader>sd", resession.delete, { desc = "Misc: session delete [resession.nvim]" })

      vim.api.nvim_create_user_command("SessionDetach", function()
        resession.detach()
      end, {})

      vim.api.nvim_create_autocmd("VimEnter", {
        callback = function()
          -- Only load the session if nvim was started with no args
          if vim.fn.argc(-1) == 0 then
            -- Save these to a different directory, so our manual sessions don't get polluted
            resession.load(vim.fn.getcwd(), { dir = "dirsession", silence_errors = true })
          end
        end,
      })

      if vim.tbl_contains(resession.list(), "__quicksave__") then
        vim.defer_fn(function()
          resession.load("__quicksave__", { attach = false })
          local ok, err = pcall(resession.delete, "__quicksave__")
          if not ok then
            vim.notify(string.format("Error deleting quicksave session: %s", err), vim.log.levels.WARN)
          end
        end, 50)
      end

      RUtils.cmd.augroup("ResessionLeave", {
        event = { "VimLeavePre" },
        command = function()
          resession.save "last"
        end,
      })
    end,
  },

  --  ╭──────────────────────────────────────────────────────────╮
  --  │                         PROJECTS                         │
  --  ╰──────────────────────────────────────────────────────────╯
  -- PROJECTS.NVIM
  {
    "ahmedkhalf/project.nvim",
    event = "LazyFile",
    cond = vim.g.neovide ~= nil or not vim.env.TMUX,
    opts = {
      manual_mode = true,
      detection_methods = { "pattern" },
      datapath = "~/Dropbox",
      silent_chdir = false,
      exclude_dirs = {
        "~/",
      },
    },
    config = function(_, opts)
      require("project_nvim").setup(opts)
      local history = require "project_nvim.utils.history"
      history.delete_project = function(project)
        for k, v in pairs(history.recent_projects) do
          if v == project.value then
            history.recent_projects[k] = nil
            return
          end
        end
      end
    end,
  },
}
