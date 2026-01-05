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
        if vim.bo.filetype == "help" then
          return true
        end

        -- save terminal
        if vim.bo[bufnr].buftype == "terminal" then
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

      vim.keymap.set("n", "<Leader>qS", function()
        vim.ui.input({ prompt = "Session name" }, function(selected)
          if selected then
            resession.save(selected, {})
          end
        end)
      end, { desc = "Session: save with session name [resession.nvim]" })

      --stylua: ignore
      vim.keymap.set("n", "<Leader>qs", function() resession.save() end, { desc = "Session: save session with current name [resession.nvim]" })
      --stylua: ignore
      vim.keymap.set("n", "<Leader>qL", function() resession.load() end, { desc = "Session: load from list sessions [resession.nvim]" })
      --stylua: ignore
      vim.keymap.set("n", "<Leader>ql", function() resession.load "last" end, { desc = "Session: load last [resession.nvim]" })
      --stylua: ignore
      vim.keymap.set("n", "<Leader>qD", resession.delete, { desc = "Session: delete [resession.nvim]" })

      vim.api.nvim_create_user_command("SessionDetach", function()
        resession.detach()
      end, {})

      vim.api.nvim_create_autocmd("VimEnter", {
        callback = function()
          -- Only load the session if nvim was started with no args
          if vim.fn.argc(-1) == 0 then
            -- Save these to a different directory, so our manual sessions don't get polluted
            resession.load(vim.uv.cwd(), { dir = "dirsession", silence_errors = true })
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

      RUtils.map.augroup("ResessionLeave", {
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
    "DrKJeff16/project.nvim",
    cmd = {
      "Project",
      "ProjectAdd",
      "ProjectConfig",
      "ProjectDelete",
      "ProjectExportJSON",
      "ProjectImportJSON",
      "ProjectHealth",
      "ProjectHistory",
      "ProjectRecents",
      "ProjectRoot",
      "ProjectSession",
    },
    keys = {
      { "<Leader>pF", "<CMD>ProjectFzf<CR>", desc = "Project: find files in projects [project.nvim]" },
      { "<Leader>pf", "<CMD>FzfLua files<CR>", desc = "Project: find files current project [project.nvim]" },
      { "<Leader>pp", "<CMD>ProjectRecents<CR>", desc = "Project: switch project [project.nvim]" },
      { "<Leader>ph", "<CMD>ProjectConfig<CR>", desc = "Project: show configs [project.nvim]" },
      {
        "<Leader>ps",
        function()
          vim.cmd "ProjectRoot"

          local cwd = vim.uv.cwd()
          if cwd then
            local dir_cwd = vim.fn.fnamemodify(cwd, ":t")
            ---@diagnostic disable-next-line: undefined-field
            RUtils.info(string.format("`%s` project saved", dir_cwd), { title = "Projects.nvim" })
          end
        end,
        desc = "Project: save [project.nvim]",
      },
      { "<Leader>pd", "<CMD>ProjectDelete<CR>", desc = "Project: delete [project.nvim]" },
    },
    opts = {
      show_hidden = true,
      fzf_lua = { enabled = true },

      -- Path where project.nvim will store the project history
      -- datapath = vim.fn.stdpath "data" <-- the default
      datapath = string.format("%s/data.programming.forprivate", RUtils.config.path.dropbox_path),
    },
  },
}
