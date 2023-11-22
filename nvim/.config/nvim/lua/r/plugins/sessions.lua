local cmd, fn = vim.cmd, vim.fn

local ignore_fts_session = { "gitcommit", "gitrebase", "alpha", "norg", "org", "orgmode", "conf", "markdown" }

local Util = require "r.utils"

return {
  --  ╭──────────────────────────────────────────────────────────╮
  --  │                         SESSION                          │
  --  ╰──────────────────────────────────────────────────────────╯
  -- PERSISTED NVIM (disabled)
  {
    "olimorris/persisted.nvim",
    enabled = false,
    event = "BufEnter",
    init = function()
      Util.cmd.augroup("PersistedEvents", {
        event = "User",
        pattern = "PersistedSavePre",
        -- Arguments are always persisted in a session and can't be removed using 'sessionoptions'
        -- so remove them when saving a session
        command = function()
          cmd "%argdelete"
        end,
      })
    end,
    -- stylua: ignore
    keys = {
      { "<Leader>pl", function() return cmd.SessionLoadLast() end,                                         { desc =
      "Misc(persisted): load a session" }, },
      { "<Leader>ps", function()
        cmd.SessionStart()
        return vim.notify "Sessions persisted: Started.."
      end,                                                                                                 { desc =
      "Misc(persisted): start a session" }, },
    },
    config = function()
      require("persisted").setup {
        autoload = true,
        autosave = true,
        use_git_branch = true,
        ignored_dirs = {
          fn.stdpath "data",
        },
        should_autosave = function()
          for _, bufnr in pairs(vim.api.nvim_list_bufs()) do
            if vim.fn.buflisted(bufnr) == 1 then
              if vim.tbl_contains(ignore_fts_session, vim.api.nvim_get_option_value("filetype", { buf = bufnr })) then
                vim.api.nvim_buf_delete(bufnr, {})
              end
            end
          end
        end,
      }
    end,
  },
  -- NVIM-POSSESSION (disabled)
  {
    "gennaro-tedesco/nvim-possession",
    enabled = false,
    event = "BufEnter",
    priority = 100,
    dependencies = {
      "ibhagwan/fzf-lua",
      "nvim-neorg/neorg",
    },
    -- stylua: ignore
    keys = {
      { "<Leader>pl", function()
        local possession = require "nvim-possession"
        return possession.list()
      end,                                                                                                    desc =
      "Misc(possession): load a session", },
      { "<Leader>ps", function()
        local possession = require "nvim-possession"
        return possession.new()
      end,                                                                                                    desc =
      "Misc(possession): start or save a session name", },
      { "<Leader>pu", function()
        local possession = require "nvim-possession"
        return possession.update()
      end,                                                                                                    desc =
      "Misc(possession): save a new session or overwrite it", },
    },
    opts = {
      autoload = true, -- whether to autoload sessions in the cwd at startup
      autosave = true, -- whether to autosave loaded sessions before quitting
      autoswitch = {
        enable = false, -- default false
      },
      save_hook = function()
        for _, bufnr in pairs(vim.api.nvim_list_bufs()) do
          if vim.fn.buflisted(bufnr) == 1 then
            if vim.tbl_contains(ignore_fts_session, vim.api.nvim_get_option_value("filetype", { buf = bufnr })) then
              vim.api.nvim_buf_delete(bufnr, {})
            end
          end
        end
      end,
    },
    config = function(_, opts)
      require("nvim-possession").setup(opts)
    end,
  },
  -- RESESSION (disabled)
  {
    "stevearc/resession.nvim",
    enabled = false,
    event = "VeryLazy",
    dependencies = {
      "stevearc/aerial.nvim",
      "stevearc/overseer.nvim",
      -- "stevearc/three.nvim",
      "stevearc/oil.nvim",
    },
    keys = {
      {
        "<Leader>pl",
        function()
          local resession = require "resession"
          return resession.load(nil, { reset = false })
        end,
        desc = "Misc(possession): load a session",
      },
      {
        "<Leader>ps",
        function()
          local resession = require "resession"
          return resession.save()
        end,
        desc = "Misc(possession): start a session",
      },
      {
        "<Leader>pu",
        function()
          local possession = require "nvim-possession"
          return possession.update()
        end,
        desc = "Misc(possession): save a new session or overwrite it",
      },
    },
    config = function()
      local resession = require "resession"

      -- local aug = vim.api.nvim_create_augroup("StevearcResession", {})

      local visible_buffers = {}

      resession.setup {
        autosave = {
          enabled = true,
          notify = false,
        },
        tab_buf_filter = function(tabpage, bufnr)
          local dir = vim.fn.getcwd(-1, vim.api.nvim_tabpage_get_number(tabpage))
          if dir ~= nil then
            return vim.startswith(vim.api.nvim_buf_get_name(bufnr), dir)
          end
        end,
        buf_filter = function(bufnr)
          if not resession.default_buf_filter(bufnr) then
            return false
          end
          return visible_buffers[bufnr] or require("three").is_buffer_in_any_tab(bufnr)
        end,
        extensions = {
          aerial = {},
          overseer = {},
          quickfix = {},
          three = {},
          config_local = {},
          -- oil = {},
        },
      }
    end,
  },
  -- NEOVIM-SESSION-MANAGER (disabled)
  {
    "Shatur/neovim-session-manager",
    enabled = false,
    event = "BufEnter",
    cmd = "SessionManager",
    -- stylua: ignore
    keys = {
      { "<Leader>pl", "<cmd>SessionManager! load_last_session<cr>",
                                                                         { desc =
        "Misc(nvim-session-manager): load a session" }, },
      { "<Leader>ps", "<cmd>SessionManager! save_current_session<cr>",
                                                                         { desc =
        "Misc(nvim-session-manager): save session" }, },
      { "<Leader>pL", "<cmd>SessionManager! load_session<cr>",         { desc =
      "Misc(nvim-session-manager): list session" }, },
    },
    opts = {
      -- autoload_mode = require("session_manager.config").AutoloadMode.Disabled, -- Do not autoload on startup.
      autoload_mode = true, -- Do not autoload on startup.
      autosave_last_session = true, -- Don't auto save session on exit vim.
      autosave_only_in_session = true, -- Allow overriding sessions.
      autosave_ignore_dirs = {}, -- A list of directories where the session will not be autosaved.
      autosave_ignore_filetypes = { -- All buffers of these file types will be closed before the session is saved.
        "gitcommit",
        "gitrebase",
        "norg",
        "org",
      },
    },
    config = function(_, opts)
      local session_manager = require "session_manager"
      session_manager.setup(opts)

      -- Auto save session only on write buffer.
      -- This avoid inconsistencies when closing multiple instances of the same session.
      local augroup = vim.api.nvim_create_augroup
      local autocmd = vim.api.nvim_create_autocmd
      autocmd({ "BufWritePost" }, {
        group = augroup("session_manager_autosave_on_write", { clear = true }),
        callback = function()
          if vim.bo.filetype ~= "git" and not vim.bo.filetype ~= "gitcommit" and not vim.bo.filetype ~= "gitrebase" then
            session_manager.save_current_session()
          end
        end,
      })
    end,
  },
  -- PERSISTANCE NVIM
  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    opts = {
      opts = { options = vim.opt.sessionoptions:get() },
      pre_save = function()
        for _, bufnr in pairs(vim.api.nvim_list_bufs()) do
          if vim.fn.buflisted(bufnr) == 1 then
            if vim.tbl_contains(ignore_fts_session, vim.api.nvim_get_option_value("filetype", { buf = bufnr })) then
              vim.api.nvim_buf_delete(bufnr, {})
            end
          end
        end
      end,
    },
    -- stylua: ignore
    keys = {
      { "<Leader>sl", function() require("persistence").load() end, desc = "Misc(persistence): restore session" },
      { "<Leader>sL", function() require("persistence").load { last = true } end, desc = "Misc(persistence): restore last session" },
      { "<Leader>ss", function() require("persistence").stop() end, desc = "Misc(persistence): don't save current session" },
    },
  },
  --  ╭──────────────────────────────────────────────────────────╮
  --  │                         PROJECTS                         │
  --  ╰──────────────────────────────────────────────────────────╯
  -- PROJECTS.NVIM
  {
    "ahmedkhalf/project.nvim",
    event = "BufWinEnter",
    keys = {
      {
        "<Leader>fP",
        "<CMD> ProjectRoot <CR>",
        desc = "Projects(project.nvim): save project",
      },
      {
        "<Leader>fp",
        function()
          local contents = require("project_nvim").get_recent_projects()
          local reverse = {}
          for i = #contents, 1, -1 do
            reverse[#reverse + 1] = contents[i]
          end
          return require("fzf-lua").fzf_exec(reverse, {
            fzf_opts = {
              ["--header"] = [[Ctrl-d:'del cwd']],
            },
            actions = {
              ["default"] = function(e)
                vim.cmd.cd(e[1])
              end,
              ["ctrl-d"] = function(x)
                -- local choice = vim.fn.confirm("Delete '" .. #x .. "' projects? ", "&Yes\n&No", 2)
                -- if choice == 1 then
                local history = require "project_nvim.utils.history"
                for _, v in ipairs(x) do
                  history.delete_project(v)
                end
                -- end
              end,
            },
          })
        end,
        desc = "Projects(project.nvim): open project lists",
      },
    },
    opts = {
      manual_mode = true,
      detection_methods = { "pattern" },
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
