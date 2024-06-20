local Highlight = require "r.settings.highlights"

---@param config {args?:string[]|fun():string[]?}
local function get_args(config)
  local args = type(config.args) == "function" and (config.args() or {}) or config.args or {}
  config = vim.deepcopy(config)
  ---@cast args string[]
  config.args = function()
    local new_args = vim.fn.input("Run with args: ", table.concat(args, " ")) --[[@as string]]
    return vim.split(vim.fn.expand(new_args) --[[@as string]], " ")
  end
  return config
end

return {
  -- NVIM-DAP
  {
    "mfussenegger/nvim-dap",
    recommended = true,
    desc = "Debugging support. Requires language specific adapters to be configured. (see lang extras)",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      -- virtual text for the debugger
      {
        "theHamsta/nvim-dap-virtual-text",
        opts = {},
      },
    },
    -- stylua: ignore
    keys = {
      { "<Leader>dB", function() require("dap").set_breakpoint(fn.input "Breakpoint condition: ") end, desc = "Debug: breakpoint with condition" },
      { "<Leader>db", function() require("dap").toggle_breakpoint() end, desc = "Debug: toggle breakpoint" },
      -- { "<Leader>dB", function() require("dap").clear_breakpoints() end, desc = "Debug: clear all breakpoints" },
      { "<Leader>dc", function() require("dap").continue() end, desc = "Debug: continue" },
      { "<Leader>da", function() require("dap").continue({ before = get_args }) end, desc = "Debug: run with args" },
      { "<Leader>dg", function() require("dap").goto_() end, desc = "Debug: go to line (no execute)" },
      { "<Leader>dC", function() require("dap").run_to_cursor() end, desc = "Debug: run to cursor" },
      { "<Leader>dl", function() require("dap").run_last() end, desc = "Debug: run last" },

      { "<leader>dr", function() require("dap").repl.toggle() end, desc = "Debug: toggle REPL" },
      { "<Leader>ds", function() require("dap").session() end, desc = "Debug: session" },
      { "<Leader>dt", function() require("dap").terminate() end, desc = "Debug: terminate" },
      { "<Leader>dw", function() require("dap.ui.widgets").hover() end, desc = "Debug: widgets" },

      -- +----------------------------------------------------------+
      -- Step-in, step-out, step-over | Stack-up Stack-down
      -- For definition of these, check: https://stackoverflow.com/questions/3580715/what-is-the-difference-between-step-into-and-step-over-in-a-debugger
      -- +----------------------------------------------------------+
      { "<Leader>di", function() require("dap").step_into() end, desc = "Debug: step into" },
      { "<Leader>dj", function() require("dap").down() end, desc = "Debug: step down" },
      { "<Leader>dk", function() require("dap").up() end, desc = "Debug: setup up" },
      { "<Leader>do", function() require("dap").step_out() end, desc = "Debug: step out" },
      { "<Leader>dO", function() require("dap").step_over() end, desc = "Debug: step over" },
      -- +----------------------------------------------------------+
      -- Run and close the debug
      -- +----------------------------------------------------------+
      {
        "<Leader><F5>",
        function()
          require("dap").terminate()
          require("dapui").close()
        end,
        desc = "Debug: closing or quit debug [dap]",
      },
      {
        "<F5>",
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
            if RUtils.has "one-small-step-for-vimkind" and vim.bo.filetype == "lua" then
              return require("osv").run_this()
            end
            -- if RUtils.has "mrcjkb/rustaceanvim" and vim.bo.filetype == "rust" then
            --   return vim.cmd.RustLsp "debuggables"
            -- end
            return require("dap").continue()
          end
        end,
        desc = "Debug: run or disconnect [dap]",
      },
      -- +----------------------------------------------------------+
      -- Misc commands
      -- +----------------------------------------------------------+
      {
        "<Leader>df",
        function()
          local col, row = RUtils.fzflua.rectangle_win_pojokan()

          RUtils.fzflua.send_cmds({
            breakpoint_set = function()
              return require("dap").set_breakpoint(vim.fn.input "Breakpoint condition: ")
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
          }, { winopts = { title = RUtils.config.icons.misc.bug .. " Debug", row = row, col = col } })
        end,
        desc = "Debug: list commands of debug",
      },
    },
    config = function()
      Highlight.plugin("dapHi", {
        { DapBreakpoint = { fg = { from = "Error", attr = "fg" }, bg = "NONE" } },
        { DapStopped = { fg = { from = "Boolean", attr = "fg" }, bg = "NONE" } },
        { DapUiPlayPause = { bg = RUtils.colortbl.statusline_bg } },
        { DapUiStop = { bg = RUtils.colortbl.statusline_bg } },
        { DapUiRestart = { bg = RUtils.colortbl.statusline_bg } },
      })

      vim.fn.sign_define {
        {
          name = "DapBreakpoint",
          texthl = "DapBreakpoint",
          text = RUtils.config.icons.dap.Breakpoint,
        },
        {
          name = "DapStopped",
          texthl = "DapStopped",
          text = RUtils.config.icons.dap.Stopped,
        },
      }

      -- setup dap config by VsCode launch.json file
      local vscode = require "dap.ext.vscode"
      local json = require "plenary.json"
      vscode.json_decode = function(str)
        return vim.json.decode(json.json_strip_comments(str))
      end
    end,
  },
  -- NVIM-DAP-UI
  {
    "rcarriga/nvim-dap-ui",
    -- stylua: ignore
    keys = {
      { "<Leader>duu", function() require("dapui").toggle() end, desc = "Debug: toggle UI [dapui]" },
      { "<Leader>dr", function() return require("dapui").open { reset = true } end, desc = "Debug: reset UI [dapui]" },
      { "<Leader>dP", function() require("dap.ui.widgets").hover() end, desc = "Debug: hover [dapui]" },
    },
    dependencies = { "nvim-neotest/nvim-nio" },
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
            -- { id = "variable", size = 0.25 },
            "watches",
            "stacks",
            "breakpoints",
          },
          size = 40, -- 40 columns
          position = "left",
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

  -- MASON-NVIM-DAP.NVIM
  {
    "jay-babu/mason-nvim-dap.nvim",
    dependencies = "mason.nvim",
    cmd = { "DapInstall", "DapUninstall" },
    opts = {
      -- Makes a best effort to setup the various debuggers with
      -- reasonable debug configurations
      automatic_installation = true,

      -- You can provide additional configuration to the handlers,
      -- see mason-nvim-dap README for more information
      handlers = {},

      -- You'll need to check that you have the required things installed
      -- online, please don't ask me how to install them :)
      ensure_installed = {
        -- Update this to ensure that you have the debuggers for the langs you want
      },
    },
  },
}
