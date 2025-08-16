---@param config {type?:string, args?:string[]|fun():string[]?}
local function get_args(config)
  local args = type(config.args) == "function" and (config.args() or {}) or config.args or {} --[[@as string[] | string ]]
  local args_str = type(args) == "table" and table.concat(args, " ") or args --[[@as string]]

  config = vim.deepcopy(config)
  ---@cast args string[]
  config.args = function()
    local new_args = vim.fn.expand(vim.fn.input("Run with args: ", args_str)) --[[@as string]]
    if config.type and config.type == "java" then
      ---@diagnostic disable-next-line: return-type-mismatch
      return new_args
    end
    return require("dap.utils").splitstr(new_args)
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
    --stylua: ignore
    keys = {
      {
        "<Leader>dB",
        function()
          local dap = require "dap"

          -- Search for an existing breakpoint on this line in this buffer
          ---@return dap.SourceBreakpoint bp that was either found, or an empty placeholder
          local function find_bp()
            local buf_bps = require("dap.breakpoints").get(vim.fn.bufnr())[vim.fn.bufnr()]
            ---@type dap.SourceBreakpoint
            local bp = { condition = "", logMessage = "", hitCondition = "", line = vim.fn.line "." }
            for _, candidate in ipairs(buf_bps) do
              if candidate.line and candidate.line == vim.fn.line "." then
                bp = candidate
                break
              end
            end
            return bp
          end

          -- Elicit customization via a UI prompt
          ---@param bp dap.SourceBreakpoint a breakpoint
          local function customize_bp(bp)
            local props = {
              ["Condition"] = {
                value = bp.condition,
                setter = function(v)
                  bp.condition = v
                end,
              },
              ["Hit Condition"] = {
                value = bp.hitCondition,
                setter = function(v)
                  bp.hitCondition = v
                end,
              },
              ["Log Message"] = {
                value = bp.logMessage,
                setter = function(v)
                  bp.logMessage = v
                end,
              },
            }
            local menu_options = {}
            for k, v in pairs(props) do
              table.insert(menu_options, ("%s: %s"):format(k, v.value))
            end
            vim.ui.select(menu_options, {
              prompt = "Edit Breakpoint",
            }, function(choice)
              local prompt = (tostring(choice)):gsub(":.*", "")
              props[prompt].setter(vim.fn.input {
                prompt = prompt,
                default = props[prompt].value,
              })

              -- Set breakpoint for current line, with customizations (see h:dap.set_breakpoint())
              dap.set_breakpoint(bp.condition, bp.hitCondition, bp.logMessage)
            end)
          end

          customize_bp(find_bp())
        end,
        desc = "Debug: breakpoint condition",
      },
      -- { "<Leader>dB", function() require("dap").set_breakpoint(vim.fn.input "Breakpoint condition: ") end, desc = "Debug: breakpoint with condition" },
      { "<Leader>db", function() require("dap").toggle_breakpoint() end, desc = "Debug: toggle breakpoint" },
      { "<Leader>dC", function() require("dap").clear_breakpoints() end, desc = "Debug: clear all breakpoints" },

      { "<Leader>dd", function() require("dap").continue() end, desc = "Debug: run/continue [dd]" },
      { "<Leader>da", function() require("dap").continue { before = get_args } end, desc = "Debug: run with args" },

      { "<Leader>dg", function() require("dap").goto_() end, desc = "Debug: go to line (no execute)" },
      { "<Leader>ed", function() require("dap").run_to_cursor() end, desc = "Debug: run to cursor" },
      { "<Leader>dl", function() require("dap").run_last() end, desc = "Debug: run last" },

      { "<leader>dr", function() require("dap").repl.toggle() end, desc = "Debug: toggle REPL" },
      { "<Leader>ds", function() require("dap").session() end, desc = "Debug: session" },
      { "<Leader>dc", function() require("dap").terminate() end, desc = "Debug: terminate" },

      -- +----------------------------------------------------------+
      -- Step-in, step-out, step-over | Stack-up Stack-down
      -- For definition of these, check: https://stackoverflow.com/questions/3580715/what-is-the-difference-between-step-into-and-step-over-in-a-debugger
      -- +----------------------------------------------------------+
      { "<Leader>dj", function() require("dap").down() end, desc = "Debug: step down" },
      { "<S-Up>", function() require("dap").up() end, desc = "Debug: setup up" },

      {
        "H",
        function()
          local function status_dap(req)
            return req.status()
          end

          if #status_dap(require "dap") > 0 then
            require("dap").step_out()
          else
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("H", true, true, true), "n", true)
          end
        end,
        desc = "Debug: step out",
      },

      {
        "L",
        function()
          local function status_dap(req)
            return req.status()
          end

          if #status_dap(require "dap") > 0 then
            require("dap").step_into()
          else
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("L", true, true, true), "n", true)
          end
        end,
        desc = "Debug: step into",
      },

      {
        "J",
        function()
          local function status_dap(req)
            return req.status()
          end

          if #status_dap(require "dap") > 0 then
            require("dap").step_over()
          else
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("J", true, true, true), "n", true)
          end
        end,
        desc = "Debug: step over",
      },

      -- +----------------------------------------------------------+
      -- Run and close the debug
      -- +----------------------------------------------------------+
      { "<Leader><F5>", function() require("dap").terminate() require("dapui").close() end, desc = "Debug: close/quit" },
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
              -- return require("osv").run_this()
              return require("osv").launch { port = 8086 }
            end
            -- if RUtils.has "mrcjkb/rustaceanvim" and vim.bo.filetype == "rust" then
            --   return vim.cmd.RustLsp "debuggables"
            -- end
            return require("dap").continue()
          end
        end,
        desc = "Debug: run/continue [F5]",
      },
      -- +----------------------------------------------------------+
      -- Misc commands
      -- +----------------------------------------------------------+
      {
        "<Leader>df",
        function()
          RUtils.fzflua.open_cmd_bulk({
            ["Breakpoint"] = function()
              return require("dap").set_breakpoint(vim.fn.input "Breakpoint condition: ")
            end,
            ["Breakpoint clear all"] = function()
              return require("dap").clear_breakpoints()
            end,
            ["Breakpoint list qf"] = function()
              return require("dap").list_breakpoints(true)
            end,
            ["Run at cursor"] = function()
              return require("dap").run_to_cursor()
            end,
            ["Run last"] = function()
              return require("dap").run_last()
            end,
            ["Run or continue"] = function()
              return require("dap").continue()
            end,
            ["Print out the session"] = function()
              return RUtils.info(vim.inspect(require("dap").session()))
            end,
            ["Quit or close"] = function()
              require("dap").terminate()
              require("dapui").close()
            end,
            ["GUI toggle"] = function()
              return require("dapui").toggle()
            end,
            ["GUI reset"] = function()
              return require("dapui").open { reset = true }
            end,
          }, { winopts = { title = RUtils.config.icons.misc.bug .. " Debug" } })
        end,
        desc = "Bulk: debug cmds",
      },
    },
    config = function()
      -- load mason-nvim-dap here, after all adapters have been setup
      if RUtils.has "mason-nvim-dap.nvim" then
        require("mason-nvim-dap").setup(RUtils.opts "mason-nvim-dap.nvim")
      end

      vim.fn.sign_define {
        {
          name = "DapBreakpoint",
          texthl = "DapBreakpoint",
          text = RUtils.config.icons.dap.Breakpoint,
        },
        {
          name = "DapStopped",
          texthl = "DapStoppedIcon",
          numhl = "DapStopped",
          linehl = "DapStopped",
          text = RUtils.config.icons.dap.Stopped,
        },
      }

      -- setup dap config by VsCode launch.json file
      local vscode = require "dap.ext.vscode"
      local json = require "plenary.json"
      ---@diagnostic disable-next-line: duplicate-set-field
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
      { "<Leader>dt", function() require("dapui").toggle() end, desc = "Debug: toggle UI [dapui]" },
      { "<Leader>dr", function() return require("dapui").open { reset = true } end, desc = "Debug: reset UI [dapui]" },
      { "<Leader>dK", function() require("dap.ui.widgets").hover() end, desc = "Debug: hover [dapui]" },
    },
    dependencies = { "nvim-neotest/nvim-nio" },
    opts = {
      -- expand_lines = fn.has "nvim-0.7",
      mappings = {
        expand = { "<CR>", "<2-LeftMouse>", "<TAB>" },
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
          expand = { "<CR>", "<2-LeftMouse>", "<TAB>" },
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
    -- mason-nvim-dap is loaded when nvim-dap loads
    config = function() end,
  },
}
