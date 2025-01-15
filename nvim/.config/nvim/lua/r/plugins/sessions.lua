return {
  --  ╭──────────────────────────────────────────────────────────╮
  --  │                         SESSION                          │
  --  ╰──────────────────────────────────────────────────────────╯
  -- AUTO-SESSION
  {
    "rmagatti/auto-session",
    lazy = false,
    keys = {
      -- Will use Telescope if installed or a vim.ui.select picker otherwise
      { "<Leader>sl", "<cmd>SessionSearch<CR>", desc = "Session search" },
      {
        "<Leader>sS",
        function()
          vim.ui.input({ prompt = "Save session name" }, function(name_ses)
            if name_ses then
              vim.cmd("SessionSave " .. name_ses)
            end
          end)
        end,
        desc = "Misc: save with session name [auto-session.nvim]",
      },
      { "<Leader>ss", "<cmd>SessionSave<CR>", desc = "Misc: save session with current name [auto-session.nvim]" },
      { "<Leader>sd", "<cmd>SessionDelete<CR>", desc = "Misc: session delete [auto-session.nvim]" },
      { "<Leader>st", "<cmd>SessionToggleAutoSave<CR>", desc = "Misc: toggle stop/run session [auto-session.nvim]" },
    },

    ---enables autocomplete for opts
    ---@module "auto-session"
    ---@type AutoSession.Config
    opts = {
      auto_restore = false, -- Enables/disables auto restoring session on start
      -- ⚠️ This will only work if Telescope.nvim is installed
      -- The following are already the default values, no need to provide them if these are already the settings you want.
      session_lens = {
        -- If load_on_setup is false, make sure you use `:SessionSearch` to open the picker as it will initialize everything first
        load_on_setup = false,
        previewer = false,
        mappings = {
          -- Mode can be a string or a table, e.g. {"i", "n"} for both insert and normal mode
          delete_session = { "i", "<C-x>" },
          alternate_session = { "i", "<C-S>" },
          copy_session = { "i", "<C-Y>" },
        },
        -- Can also set some Telescope picker options
        -- For all options, see: https://github.com/nvim-telescope/telescope.nvim/blob/master/doc/telescope.txt#L112
        theme_conf = {
          border = true,
          -- layout_config = {
          --   width = 0.8, -- Can set width and height as percent of window
          --   height = 0.5,
          -- },
        },
      },
    },
    config = function(_, opts)
      require("auto-session").setup(opts)

      RUtils.cmd.augroup("AutoSessionLeave", {
        event = { "VimLeavePre" },
        command = function()
          vim.cmd [[SessionSave last]]
        end,
      })
    end,
  },
  -- PERSISTED.NVIM (disabled)
  {
    "olimorris/persisted.nvim",
    enabled = false,
    lazy = false, -- make sure the plugin is always loaded at startup
    config = true,
  },
  -- PERSISTENCE.NVIM (disabled)
  {
    "folke/persistence.nvim",
    enabled = false,
    event = "BufReadPre",
    opts = {},
    -- stylua: ignore
    keys = {
      { "<leader>ss", function() require("persistence").load() end, desc = "Restore Session" },
      { "<leader>sL", function() require("persistence").select() end,desc = "Select Session" },
      { "<leader>sl", function() require("persistence").load({ last = true }) end, desc = "Restore Last Session" },
      { "<leader>sS", function() require("persistence").stop() end, desc = "Don't Save Current Session" },
    },
  },
  -- RESESSION.NVIM (disabled)
  {

    "stevearc/resession.nvim",
    enabled = false,
    event = "LazyFile",
    opts = {
      autosave = {
        enabled = true,
        notify = false,
      },
      buf_filter = function(bufnr)
        local disabled_filetypes = { "markdown", "org" }
        -- I have to disable markdown because of an error when loading the session: `attempt to index local 'info'`.
        if
          not require("resession").default_buf_filter(bufnr) or vim.tbl_contains(disabled_filetypes, vim.bo.filetype)
        then
          return false
        end
        return true
      end,
      extensions = { quickfix = {} },
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
        vim.ui.input({ prompt = "Save session name" }, function(selected)
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
