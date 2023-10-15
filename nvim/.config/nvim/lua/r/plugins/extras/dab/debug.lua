local fn = vim.fn

local Util = require "r.utils"

local function status_dap(req)
  local ok, _ = pcall(require, req)

  if not ok then
    return ""
  end

  return req.status()
end

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
          { "<Leader>dtt", function() require("dapui").toggle() end, desc = "Debug(dapui): toggle UI" },
          { "<Leader>dr", function() return require("dapui").open { reset = true } end, desc = "Debug(dapui): reset UI" },
          { "<leader>dP", function() require("dap.ui.widgets").hover() end, desc = "Debug(dapui): hover" },
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
            border = "single", -- Border style. Can be "single", "double" or "rounded"
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
      { "<Leader>dS", function() print(require("dap").session()) end, desc = "Debug(dap): get session" },
      --  +----------------------------------------------------------+
      --    Close and run debug
      --  +----------------------------------------------------------+
      { "<Leader>dR", function() require("dap").restart_frame() end, desc = "Debug(dap): restart" },
      { "<Leader>dc", function() return require("dap").terminate() end, desc = "Debug(dap): closing or quit debug", },
      { "<Leader>dd",
        function()
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
      --    Step-in, step-out, step-over
      --    For definition of these, check: https://stackoverflow.com/questions/3580715/what-is-the-difference-between-step-into-and-step-over-in-a-debugger
      --  +----------------------------------------------------------+
      { "<s-right>", function() require("dap").step_into() end, desc = "Debug(dap): step-into" },
      { "<s-left>", function() require("dap").step_out() end, desc = "Debug(dap): step-out" },
      { "<s-down>", function() require("dap").step_over() end, desc = "Debug(dap): step-over" },
    },
    config = function()
      local Config = require "r.config"
      -- highlight.plugin("dapHi", {
      --   { DapBreakpoint = { fg = palette.light_red } },
      --   { DapStopped = { fg = palette.green } },
      -- })

      for name, sign in pairs(Config.icons.dap) do
        sign = type(sign) == "table" and sign or { sign }
        vim.fn.sign_define(
          "Dap" .. name,
          { text = sign[1], texthl = sign[2] or "DiagnosticInfo", linehl = sign[3], numhl = sign[3] }
        )
      end
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
