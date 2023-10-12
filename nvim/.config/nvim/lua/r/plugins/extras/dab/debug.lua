local highlight, icons, fn, border = as.highlight, as.ui.icons, vim.fn, as.ui.border

local palette = as.ui.palette

return {
  -- NVIM-DAP
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      {
        "theHamsta/nvim-dap-virtual-text",
        opts = {
          commented = true,
    },
      },
      -- { "LiadOz/nvim-dap-repl-highlights", opts = {} },
      {
        "rcarriga/nvim-dap-ui",
    -- stylua: ignore
    keys = {
      { "<Leader>dtt", function() require("dapui").toggle() end, desc = "Debug(dapui): toggle UI (dapui)" },
      { "<Leader>dr", function() return require("dapui").open { reset = true } end, desc = "Debug(dapui): reset UI (dapui)" },
      { "<Leader>de", function() require("dapui").eval() end, mode = { "v", "n" }, desc = "Debug(dapui): evaluate" },
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
              "console",
            },
            size = 0.25, -- 25% of total lines
            position = "bottom",
          },
        },
        floating = {
          max_height = nil, -- These can be integers or a float between 0 and 1.
          max_width = nil, -- Floats will be treated as percentage of your screen.
          border = border.rectangle, -- Border style. Can be "single", "double" or "rounded"
          mappings = {
            close = { "q", "<Esc>" },
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
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close {}
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close {}
      end
        end,
      },
    },
    -- stylua: ignore
    keys = {
      --  +----------------------------------------------------------+
      --    Breakpoints
      --  +----------------------------------------------------------+
      { "<Leader>db", function() require("dap").toggle_breakpoint() end, desc = "Debug(dap): breakpoint (toggle)" },
      { "<Leader>dB", function() require("dap").clear_breakpoints() end, desc = "Debug(dap): clear all breakpoints" },
      { "<Leader>dC", function() require("dap").set_breakpoint(fn.input "Breakpoint condition: ") end, desc = "Debug(dap): breakpoint with condition" },
      -- { "<Leader>dL", function() require("dap").set_breakpoint( nil, nil, fn.input "Log point message: ") end, desc = "Debug(dap): log breakpoint", },
      --  +----------------------------------------------------------+
      --    DAP commands
      --  +----------------------------------------------------------+
      { "<Leader>dR", function() require("dap").run_to_cursor() end, desc = "Debug(dap): run to cursor" },
      { "<Leader>dl", function() require("dap").run_last() end, desc = "Debug(dap): run last" },
      -- { "<Leader>dr", function() require "dap".repl.toggle(nil, "botright split") end, desc = "Dap: toggle REPL" },
      { "<Leader>dS", function() print(require "dap".session()) end, desc = "Debug(dap): get session" },
      --  +----------------------------------------------------------+
      --    Close and run debug
      --  +----------------------------------------------------------+
      { "<Leader>dd", function() if #as.status_dap() > 0 then return require("dap").disconnect() else return require("dap").continue() end end, desc = "Debug(dap): run or disconnect", },
      { "<Leader>dc", function() if #as.status_dap() > 0 then return require("dap").close() end end, desc = "Debug(dap): closing or quit debug", },
      --  +----------------------------------------------------------+
      --    Step-in, step-out, step-over
      --    For definition of these, check: https://stackoverflow.com/questions/3580715/what-is-the-difference-between-step-into-and-step-over-in-a-debugger
      --  +----------------------------------------------------------+
      { "<s-right>", function() require "dap".step_into() end, desc = "Debug(dap): step-into" },
      { "<s-left>",  function() require "dap".step_out() end,  desc = "Debug(dap): step-out" },
      { "<s-down>",  function() require "dap".step_over() end, desc = "Debug(dap): step-over" },
    },
    config = function()
      highlight.plugin("dapHi", {
        { DapBreakpoint = { fg = palette.light_red } },
        { DapStopped = { fg = palette.green } },
      })

      fn.sign_define {
        {
          name = "DapBreakpoint",
          text = icons.dap.breakpoint,
          texthl = "DapBreakpoint",
          linehl = "",
          numhl = "",
        },
        {
          name = "DapStopped",
          text = icons.dap.breakpoint_stoped,
          texthl = "DapStopped",
          linehl = "",
          numhl = "",
        },
      }
    end,
  },
  -- MASON-DAP-NVIM
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
