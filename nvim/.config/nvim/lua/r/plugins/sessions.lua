return {
  --  ╭──────────────────────────────────────────────────────────╮
  --  │                         SESSION                          │
  --  ╰──────────────────────────────────────────────────────────╯
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
        if vim.bo.filetype == "help" then
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

      vim.keymap.set("n", "<Leader>sS", function()
        vim.ui.input({ prompt = "Session name" }, function(selected)
          if selected then
            resession.save(selected, {})
          end
        end)
      end, { desc = "Session: save with session name [resession.nvim]" })
      --stylua: ignore
      vim.keymap.set("n", "<Leader>ss", function() resession.save() end, { desc = "Session: save session with current name [resession.nvim]" })
      --stylua: ignore
      vim.keymap.set("n", "<Leader>st", function() resession.save_tab() end, { desc = "Session: save session tab [resession.nvim]" })
      --stylua: ignore
      vim.keymap.set("n", "<Leader>sl", function() resession.load() end, { desc = "Session: load from list sessions [resession.nvim]" })
      --stylua: ignore
      -- vim.keymap.set("n", "<Leader>sl", function() resession.load "last" end, { desc = "Misc: load last session [resession.nvim]" })
      vim.keymap.set("n", "<Leader>sd", resession.delete, { desc = "Session: session delete [resession.nvim]" })

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
          vim.cmd [[set cmdheight=0]]
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
