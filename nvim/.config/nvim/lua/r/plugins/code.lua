local cmd, api = vim.cmd, vim.api

local isIronActive = false

_G.OverseerConfig = {} -- to store error formats

OverseerConfig.fnpane_run = 0
OverseerConfig.fnpane_runtest = 0
OverseerConfig.fnpane_runmisc = 0

return {
  -- COPILOT (disabled)
  {
    "zbirenbaum/copilot.lua",
    enabled = false,
    config = function()
      require("copilot").setup {}
    end,
  },
  -- NVIM-COVERAGE
  {
    "andythigpen/nvim-coverage", -- Display test coverage information
    dependencies = "nvim-lua/plenary.nvim",
    cmd = {
      "Coverage",
      "CoverageSummary",
      "CoverageLoad",
      "CoverageShow",
      "CoverageHide",
      "CoverageToggle",
      "CoverageClear",
    },
    config = function()
      require("coverage").setup {
        commands = false,
        highlights = {
          covered = { fg = "green" },
          uncovered = { fg = "red" },
        },
      }
    end,
  },
  -- OVERSEER
  {
    "stevearc/overseer.nvim", -- Task runner and job management
    -- cmd = {
    --   "OverseerToggle",
    --   "OverseerOpen",
    --   "OverseerInfo",
    --   "OverseerRun",
    --   "OverseerBuild",
    --   "OverseerClose",
    --   "OverseerLoadBundle",
    --   "OverseerSaveBundle",
    --   "OverseerDeleteBundle",
    --   "OverseerRunCmd",
    --   "OverseerQuickAction",
    --   "OverseerTaskAction",
    -- },
    init = function()
      -- as.augroup("RunOverseerTasks", {
      --   event = { "FileType" },
      --   pattern = as.lspfiles,
      --   command = function()
      --     -- vim.keymap.set("n", "<F4>", function()
      --     --   local overseer = require "overseer"
      --     --   local tasks = overseer.list_tasks {
      --     --     recent_first = true,
      --     --   }
      --     --
      --     --   if vim.tbl_isempty(tasks) then
      --     --     return vim.notify("No tasks found", vim.log.levels.WARN)
      --     --   else
      --     --     return overseer.run_action(tasks[1], "restart")
      --     --   end
      --     -- end, {
      --     --   desc = "Task(overseer): run or restart the task",
      --     --   buffer = api.nvim_get_current_buf(),
      --     -- })
      --
      --     vim.keymap.set("n", "<F1>", function()
      --       if vim.bo.filetype ~= "OverseerList" then
      --         return cmd "OverseerRun"
      --       end
      --       return cmd "OverseerQuickAction"
      --     end, {
      --       desc = "Task(overseer): run quick action",
      --       buffer = api.nvim_get_current_buf(),
      --     })
      --   end,
      -- })
    end,
    -- keys = {
    --   {
    --     "rt",
    --     function()
    --       require("r.utils.tiling").force_win_close({ "neo-tree", "undotree" }, false)
    --       return cmd "OverseerToggle!"
    --     end,
    --     desc = "Task(overseer): toggle",
    --   },
    -- },
    config = function()
      require("overseer").setup {
        templates = { "builtin", "user" },
        component_aliases = {
          log = {
            {
              type = "echo",
              level = vim.log.levels.WARN,
            },
            {
              type = "file",
              filename = "overseer.log",
              level = vim.log.levels.DEBUG,
            },
          },
        },
        task_list = {
          default_detail = 1,
          direction = "bottom",
          min_height = 25,
          max_height = 25,
          bindings = {
            ["<S-tab>"] = "ScrollOutputUp",
            ["<tab>"] = "ScrollOutputDown",
            ["q"] = function()
              vim.cmd "OverseerClose"
            end,
            ["<c-k>"] = false,
            ["<c-j>"] = false,
          },
        },
      }
    end,
  },
  -- LUAPAD
  {
    "rafcamlet/nvim-luapad",
    cmd = { "Luapad" },
    config = true,
  },
  -- IRON.NVIM
  {
    "Vigemus/iron.nvim",
    -- enabled = false,
    init = function()
      vim.g.iron_map_defaults = 0
      vim.g.iron_map_extended = 0
    end,
    event = "VeryLazy",
    cmd = { "IronRepl", "IronRestart", "IronHide" },
    -- keys = {
    --   {
    --     "rR",
    --     function()
    --       if isIronActive then
    --         vim.cmd.IronRestart()
    --         isIronActive = false
    --       else
    --         vim.cmd.IronRepl()
    --         isIronActive = true
    --       end
    --     end,
    --     desc = "Task(iron): restart repl",
    --   },
    --   -- {
    --   --   "rm",
    --   --   function()
    --   --     require("iron.core").run_motion "send_motion"
    --   --   end,
    --   --   desc = "Task(iron): send motion",
    --   -- },
    --   {
    --     "rl",
    --     function()
    --       require("iron.core").visual_send()
    --
    --       if not isIronActive then
    --         isIronActive = true
    --       end
    --
    --       -- require("iron.core").send(nil, string.char(13))
    --     end,
    --     desc = "Task(iron): send visual",
    --     mode = { "v" },
    --   },
    --   {
    --     "rl",
    --     function()
    --       require("iron.core").send_line()
    --
    --       if not isIronActive then
    --         isIronActive = true
    --       end
    --     end,
    --     desc = "Task(iron): send line",
    --   },
    --   {
    --     "rL",
    --     function()
    --       require("iron.core").send_until_cursor()
    --
    --       if not isIronActive then
    --         isIronActive = true
    --       end
    --     end,
    --     desc = "Task(iron): send line and run until cursor",
    --   },
    --   -- {
    --   --   "rf",
    --   --   function()
    --   --     require("iron.core").send_file()
    --   --
    --   --     if not isIronActive then
    --   --       isIronActive = true
    --   --     end
    --   --   end,
    --   --   desc = "Task(iron): send file",
    --   -- },
    --   {
    --     "rj",
    --     function()
    --       require("iron.core").send(nil, string.char(13))
    --
    --       if not isIronActive then
    --         isIronActive = true
    --       end
    --     end,
    --     desc = "Task(iron): send (ENTER)",
    --   },
    --   {
    --     "rI",
    --     function()
    --       require("iron.core").send(nil, string.char(03))
    --
    --       if not isIronActive then
    --         isIronActive = true
    --       end
    --     end,
    --     desc = "Task(iron): send (interrupt)",
    --   },
    --
    --   -- {
    --   --     "rc",
    --   --     function()
    --   --         require("iron.core").send(nil, string.char(12))
    --   --     end,
    --   --     desc = "Task(iron): clear",
    --   -- },
    -- },
    config = function()
      require("iron.core").setup {
        config = {
          -- Whether a repl should be discarded or not
          scratch_repl = true,
          -- Your repl definitions come here
          repl_definition = {
            sh = {
              command = { "zsh" },
            },
            python = require("iron.fts.python").python,
          },

          repl_open_cmd = "vertical botright 80 split",
          buflisted = false,
        },
        -- If the highlight is on, you can change how it looks
        -- For the available options, check nvim_set_hl
        highlight = {
          italic = true,
        },

        -- keymaps = {
        --     send_motion = "rl",
        --     visual_send = "sl",
        --     send_file = "<space>sf",
        --     send_line = "<space>sl",
        --     send_until_cursor = "<space>su",
        --     send_mark = "<space>sm",
        --     mark_motion = "<space>mc",
        --     mark_visual = "<space>mc",
        --     remove_mark = "<space>md",
        --     cr = "<space>s<cr>",
        --     interrupt = "<space>s<space>",
        --     exit = "<space>sq",
        --     clear = "<space>cl",
        -- },
        ignore_blank_lines = true, -- ignore blank lines when sending visual select lines
      }
    end,
  },
  -- SCRATCH
  {
    "LintaoAmons/scratch.nvim",
    cmd = { "Scratch", "ScratchOpen" },
    keys = {

      {
        "<Localleader>oS",
        "<CMD>Scratch<CR>",
        desc = "Open(scratch): open with select language",
      },
      {
        "<Localleader>os",
        "<CMD>ScratchOpen<CR>",
        desc = "Open(scratch): open",
      },
    },
  },
  -- REFACTORING.NVIM (disabled)
  {
    "ThePrimeagen/refactoring.nvim",
    enabled = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    opts = {},
    config = function(_, opts)
      require("refactoring").setup(opts)
      require("telescope").load_extension "refactoring"
    end,
    keys = {

      {
        "<leader>rs",
        function()
          require("telescope").extensions.refactoring.refactors()
        end,
        mode = { "v" },
        desc = "Refactor",
      },
      {
        "<leader>ri",
        function()
          require("refactoring").refactor "Inline Variable"
        end,
        mode = { "n", "v" },
        desc = "Inline Variable",
      },
      -- { "<leader>rb", function() require('refactoring').refactor('Exract Block') end, mode = {"n"}, desc = "Extract Block" },
      {
        "<leader>rf",
        function()
          require("refactoring").refactor "Exract Block To File"
        end,
        mode = { "n" },
        desc = "Extract Block to File",
      },
      {
        "<leader>rP",
        function()
          require("refactoring").debug.printf { below = false }
        end,
        mode = { "n" },
        desc = "Debug Print",
      },
      {
        "<leader>rp",
        function()
          require("refactoring").debug.print_var { normal = true }
        end,
        mode = { "n" },
        desc = "Debug Print Variable",
      },
      {
        "<leader>rc",
        function()
          require("refactoring").debug.cleanup {}
        end,
        mode = { "n" },
        desc = "Debug Cleanup",
      },
      {
        "<leader>rf",
        function()
          require("refactoring").refactor "Extract Function"
        end,
        mode = { "v" },
        desc = "Extract Function",
      },
      {
        "<leader>rF",
        function()
          require("refactoring").refactor "Extract Function to File"
        end,
        mode = { "v" },
        desc = "Extract Function to File",
      },
      {
        "<leader>rx",
        function()
          require("refactoring").refactor "Extract Variable"
        end,
        mode = { "v" },
        desc = "Extract Variable",
      },
      {
        "<leader>rp",
        function()
          require("refactoring").debug.print_var {}
        end,
        mode = { "v" },
        desc = "Debug Print Variable",
      },
    },
    --  ╭──────────────────────────────────────────────────────────╮
    --  │                        MY PLUGINS                        │
    --  ╰──────────────────────────────────────────────────────────╯
    {
      dir = "~/.local/src/nvim_plugins/runmux",
      keys = {
        { "rf", "<Cmd>RmuxRunFile<cr>" },
        { "rP", "<Cmd>RmuxSetPane<cr>" },
        { "rR", "<Cmd>RmuxREPL<cr>" },
        { "rl", "<Cmd>RmuxSendline<cr>" },
        { "rl", "<Cmd>VRemuxSendline<cr>", mode = { "v" } },
        { "ri", "<Cmd>RmuxSendInterrupt<cr>" },
        { "rI", "<Cmd>RmuxSendInterruptAll<cr>" },
        { "rt", "<Cmd>RmuxTargetPane<cr>" },
        { "rL", "<Cmd>RmuxLOADConfig<cr>" },
        { "rC", "<Cmd>RmuxKillAllPanes<cr>" },
      },
      opts = {},
      config = function(_, opts)
        require("rmux").setup(opts)
      end,
    },
  },
}
