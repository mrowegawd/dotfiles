return {
  --  ╭──────────────────────────────────────────────────────────╮
  --  │                         SESSION                          │
  --  ╰──────────────────────────────────────────────────────────╯
  -- AUTO-SESSION
  {
    "rmagatti/auto-session",
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
