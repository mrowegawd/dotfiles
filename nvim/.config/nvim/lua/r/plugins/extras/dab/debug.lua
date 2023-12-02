local fn = vim.fn

local Util = require "r.utils"

return {
  -- NVIM-DAP
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      { "LiadOz/nvim-dap-repl-highlights", opts = {} },
      { "theHamsta/nvim-dap-virtual-text", opts = { commented = true } },
      {
        "rcarriga/nvim-dap-ui",

        -- stylua: ignore
        keys = {
          { "<Leader>dt", function() require("dapui").toggle() end, desc = "Debug(dapui): toggle UI" },
          { "<Leader>dr", function() return require("dapui").open { reset = true } end, desc = "Debug(dapui): reset UI" },
          { "<leader>dP", function() require("dap.ui.widgets").hover() end, desc = "Debug(dapui): hover" },
        },
        opts = {
          -- expand_lines = fn.has "nvim-0.7",
          mappings = {
            expand = { "<CR>", "<2-LeftMouse>" },
            open = "o",
            remove = "d",
            edit = "e",
            repl = "r",
            toggle = "t",
          },
          layouts = {
            {
              elements = {
                -- Elements can be strings or table with id and size keys.
                { id = "scopes", size = 0.25 },
                "breakpoints",
                "stacks",
                "watches",
              },
              size = 40, -- 40 columns
              position = "right",
            },
            {
              elements = {
                "repl",
                -- "console",
              },
              size = 0.25, -- 25% of total lines
              position = "bottom",
            },
          },
          floating = {
            max_height = nil, -- These can be integers or a float between 0 and 1.
            max_width = nil, -- Floats will be treated as percentage of your screen.
            border = "single", -- Border style. Can be "single", "double" or "rounded"
            mappings = {
              close = { "q", "<Esc>" },
              edit = "e",
              expand = { "<CR>", "<2-LeftMouse>" },
              open = "o",
              remove = "d",
              repl = "r",
              toggle = "t",
            },
          },
          windows = { indent = 1 },
          render = {
            max_type_length = nil, -- Can be integer or nil.
          },
        },
        config = function(_, opts)
          -- setup dap config by VsCode launch.json file
          -- require("dap.ext.vscode").load_launchjs()
          local dap = require "dap"
          local dapui = require "dapui"
          dapui.setup(opts)
          dap.listeners.after.event_initialized["dapui_config"] = function()
            dapui.open {}
          end
          -- dap.listeners.before.event_terminated["dapui_config"] = function()
          --   dapui.close {}
          -- end
          -- dap.listeners.before.event_exited["dapui_config"] = function()
          --   dapui.close {}
          -- end
        end,
      },
    },
    -- stylua: ignore
    keys = {
      --  +----------------------------------------------------------+
      --    DAP commands
      --  +----------------------------------------------------------+
      -- { "<Leader>dR", function() require("dap").run_to_cursor() end, desc = "Debug(dap): run to cursor" },
      -- { "<Leader>dL", function() require("dap").run_last() end, desc = "Debug(dap): run last" },
      -- { "<Leader>dr", function() require "dap".repl.toggle(nil, "botright split") end, desc = "Dap: toggle REPL" },
      -- { "<Leader>dS", function() print(vim.inspect(require("dap").session())) end, desc = "Debug(dap): get session" },
      --  +----------------------------------------------------------+
      --    Breakpoints
      --  +----------------------------------------------------------+
      -- { "<Leader>dc", function() require("dap").set_breakpoint(fn.input "Breakpoint condition: ") end, desc = "Debug(dap): breakpoint with condition" },
      -- { "<Leader>dB", function() require("dap").clear_breakpoints() end, desc = "Debug(dap): clear all breakpoints" },
      -- { "<Leader>dbl", function() require("dap").set_breakpoint( nil, nil, fn.input "Log point message: ") end, desc = "Debug(dap): log breakpoint", },
      -- { "<Leader>dD", function() require("dap").list_breakpoints(true) end, desc = "Debug(dap): list breakpoint qf", },
      { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Debug(dap): breakpoint (toggle)" },
      {
        "<Leader>df",
        function()
          Util.fzflua.send_cmds {
            breakpoint_set = function()
              return require("dap").set_breakpoint(fn.input "Breakpoint condition: ")
            end,
            breakpoint_clear_all = function()
              return require("dap").clear_breakpoints()
            end,
            breakpoint_lists = function()
              return require("dap").list_breakpoints(true)
            end,
            dap_run_to_cursor = function()
              return require("dap").run_to_cursor()
            end,
            dap_run_last = function()
              return require("dap").run_last()
            end,
            dap_continue_or_run = function()
              return require("dap").continue()
            end,
            dap_close_or_quit = function()
              require("dap").terminate()
              require("dapui").close()
            end,
            dap_printout_session = function()
              return print(vim.inspect(require("dap").session()))
            end,
          }
        end,
        desc = "Debug(dap): list of debugging dap commands",
      },
      --  +----------------------------------------------------------+
      --    Run and close the debug
      --  +----------------------------------------------------------+
      -- { "<Leader>dR", function() require("dap").restart_frame() end, desc = "Debug(dap): restart" },
      -- { "<Leader>dq", function() return require("dap").terminate() end, desc = "Debug(dap): closing or quit debug", },
      {
        "<Leader>dd",
        function()
          local function status_dap(req)
            local ok, _ = pcall(require, req)

            if not ok then
              return ""
            end

            return req.status()
          end

          if #status_dap(require "dap") > 0 then
            return require("dap").disconnect()
          else
            if Util.has "one-small-step-for-vimkind" and vim.bo.filetype == "lua" then
              require("osv").run_this()
            else
              return require("dap").continue()
            end
          end
        end,
        desc = "Debug(dap): run or disconnect",
      },
      --  +----------------------------------------------------------+
      --    Step-in, step-out, step-over | Stack-up Stack-down
      --    For definition of these, check: https://stackoverflow.com/questions/3580715/what-is-the-difference-between-step-into-and-step-over-in-a-debugger
      --  +----------------------------------------------------------+
      { "<s-right>", function() require("dap").step_into() end, desc = "Debug(dap): step-into" },
      { "<s-left>", function() require("dap").step_out() end, desc = "Debug(dap): step-out" },
      { "<s-down>", function() require("dap").step_over() end, desc = "Debug(dap): step-over" },

      { "<leader>dk", function() require("dap").up() end, desc = "Debug(dap): stack up" },
      { "<leader>dj", function() require("dap").down() end, desc = "Debug(dap): stack down" },
    },
    config = function()
      local Config = require "r.config"
      local highlight = require "r.config.highlights"
      highlight.plugin("dapHi", {
        { DapBreakpoint = { fg = { from = "Error", attr = "fg" }, bg = { from = "ColorColumn", attr = "bg" } } },
        { DapStopped = { fg = { from = "@field", attr = "fg" }, bg = { from = "ColorColumn", attr = "bg" } } },
      })

      fn.sign_define {
        {
          name = "DapBreakpoint",
          texthl = "DapBreakpoint",
          text = Config.icons.dap.Breakpoint,
          linehl = "",
          numhl = "",
        },
        { name = "DapStopped", texthl = "DapStopped", text = Config.icons.dap.Stopped[1], linehl = "", numhl = "" },
      }
    end,
  },
  -- MASON-NVIM-DAP.NVIM
  {
    "jay-babu/mason-nvim-dap.nvim",
    dependencies = "mason.nvim",
    cmd = { "DapInstall", "DapUninstall" },
    opts = {
      automatic_setup = true,
      handlers = {},
      ensure_installed = {},
      automatic_installation = true,
    },
  },
}
