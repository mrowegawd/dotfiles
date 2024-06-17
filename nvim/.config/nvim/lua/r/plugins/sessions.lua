local visible_buffers = {}

return {
  --  ╭──────────────────────────────────────────────────────────╮
  --  │                         SESSION                          │
  --  ╰──────────────────────────────────────────────────────────╯
  {
    "stevearc/resession.nvim",
    event = "LazyFile",
    dependencies = {
      dir = "~/.local/src/nvim_plugins/qfsilet",
    },
    opts = {
      autosave = {
        enabled = true,
        notify = false,
      },
      buf_filter = function(bufnr)
        if not require("resession").default_buf_filter(bufnr) then
          return false
        end
        return visible_buffers[bufnr]
      end,
      extensions = { quickfix = {} },
    },
    config = function(_, opts)
      local resession = require "resession"
      resession.setup(opts)

      resession.add_hook("pre_save", function()
        visible_buffers = {}
        for _, winid in ipairs(vim.api.nvim_list_wins()) do
          if vim.api.nvim_win_is_valid(winid) then
            visible_buffers[vim.api.nvim_win_get_buf(winid)] = winid
          end
        end
      end)

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
          -- resession.save(vim.fn.getcwd(), { dir = "dirsession", notify = false })
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
    end,
  },
}
