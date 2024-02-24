local fn = vim.fn

local Highlight = require "r.settings.highlights"
local Util = require "r.utils"

return {
  -- NVIM-DAP
  {
    "mfussenegger/nvim-dap",
    dependencies = {

      -- python
      {
        "mfussenegger/nvim-dap-python",
        -- dependencies = { "williamboman/mason.nvim" },
        config = function()
          -- local path = require("mason-registry").get_package("debugpy"):get_install_path()
          local path = vim.fn.stdpath "data" .. "/mason/packages/debugpy/venv/bin/python3"
          require("dap-python").setup(path)
        end,
      },
      -- golang
      {
        "leoluz/nvim-dap-go",
        opts = {},
      },

      { "theHamsta/nvim-dap-virtual-text", opts = { commented = true } },

      -- {
      --   "LiadOz/nvim-dap-repl-highlights",
      --   config = true,
      --   build = function()
      --     if not require("nvim-treesitter.parsers").has_parser "dap_repl" then
      --       vim.cmd ":TSInstall dap_repl"
      --     end
      --   end,
      -- },

      {
        "jbyuki/one-small-step-for-vimkind",
        -- keys = { } -- Use ftplugin/lua
        config = function()
          -- local dap = require "dap"
          -- dap.adapters.nlua = function(callback, config)
          --   callback { type = "server", host = config.host or "127.0.0.1", port = config.port or 8086 }
          -- end

          local dap = require "dap"
          dap.adapters.nlua = function(callback, conf)
            local adapter = {
              type = "server",
              host = conf.host or "127.0.0.1",
              port = conf.port or 8086,
            }
            if conf.start_neovim then
              local dap_run = dap.run
              dap.run = function(c)
                adapter.port = c.port
                adapter.host = c.host
              end
              require("osv").run_this()
              dap.run = dap_run
            end
            callback(adapter)
          end
          dap.configurations.lua = {
            {
              type = "nlua",
              request = "attach",
              name = "Run this file",
              start_neovim = {},
            },
            {
              type = "nlua",
              request = "attach",
              name = "Attach to running Neovim instance (port = 8086)",
              port = 8086,
            },
          }
        end,
      },
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
          local col, row = Util.fzflua.rectangle_win_pojokan()

          Util.fzflua.send_cmds ({
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
          }, { winopts = { title = require("r.config").icons.misc.bug .. " Debug", row = row, col = col } })
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
    opts = {
      setup = {
        vscode_js_debug = function()
          local function get_js_debug()
            local install_path = require("mason-registry").get_package("js-debug-adapter"):get_install_path()
            return install_path .. "/js-debug/src/dapDebugServer.js"
          end

          for _, adapter in ipairs { "pwa-node", "pwa-chrome", "pwa-msedge", "node-terminal", "pwa-extensionHost" } do
            require("dap").adapters[adapter] = {
              type = "server",
              host = "localhost",
              port = "${port}",
              executable = {
                command = "node",
                args = {
                  get_js_debug(),
                  "${port}",
                },
              },
            }
          end

          for _, language in ipairs { "typescript", "javascript" } do
            require("dap").configurations[language] = {
              {
                type = "pwa-node",
                request = "launch",
                name = "Launch file",
                program = "${file}",
                cwd = "${workspaceFolder}",
              },
              {
                type = "pwa-node",
                request = "attach",
                name = "Attach",
                processId = require("dap.utils").pick_process,
                cwd = "${workspaceFolder}",
              },
              {
                type = "pwa-node",
                request = "launch",
                name = "Debug Jest Tests",
                -- trace = true, -- include debugger info
                runtimeExecutable = "node",
                runtimeArgs = {
                  "./node_modules/jest/bin/jest.js",
                  "--runInBand",
                },
                rootPath = "${workspaceFolder}",
                cwd = "${workspaceFolder}",
                console = "integratedTerminal",
                internalConsoleOptions = "neverOpen",
              },
              {
                type = "pwa-chrome",
                name = "Attach - Remote Debugging",
                request = "attach",
                program = "${file}",
                cwd = vim.fn.getcwd(),
                sourceMaps = true,
                protocol = "inspector",
                port = 9222, -- Start Chrome google-chrome --remote-debugging-port=9222
                webRoot = "${workspaceFolder}",
              },
              {
                type = "pwa-chrome",
                name = "Launch Chrome",
                request = "launch",
                url = "http://localhost:5173", -- This is for Vite. Change it to the framework you use
                webRoot = "${workspaceFolder}",
                userDataDir = "${workspaceFolder}/.vscode/vscode-chrome-debug-userdatadir",
              },
            }
          end

          for _, language in ipairs { "typescriptreact", "javascriptreact" } do
            require("dap").configurations[language] = {
              {
                type = "pwa-chrome",
                name = "Attach - Remote Debugging",
                request = "attach",
                program = "${file}",
                cwd = vim.fn.getcwd(),
                sourceMaps = true,
                protocol = "inspector",
                port = 9222, -- Start Chrome google-chrome --remote-debugging-port=9222
                webRoot = "${workspaceFolder}",
              },
              {
                type = "pwa-chrome",
                name = "Launch Chrome",
                request = "launch",
                url = "http://localhost:5173", -- This is for Vite. Change it to the framework you use
                webRoot = "${workspaceFolder}",
                userDataDir = "${workspaceFolder}/.vscode/vscode-chrome-debug-userdatadir",
              },
            }
          end
        end,
      },
    },
    config = function()
      local Config = require "r.config"
      Highlight.plugin("dapHi", {
        {
          DapBreakpoint = {
            fg = { from = "Error", attr = "fg" },
            bg = { from = "Normal", attr = "bg" },
          },
        },
        {
          DapStopped = {
            fg = { from = "Boolean", attr = "fg" },
            bg = { from = "Normal", attr = "bg" },
          },
        },
      })

      fn.sign_define {
        {
          name = "DapBreakpoint",
          texthl = "DapBreakpoint",
          text = Config.icons.dap.Breakpoint,
        },
        {
          name = "DapStopped",
          texthl = "DapStopped",
          text = Config.icons.dap.Stopped,
        },
      }
    end,
  },
}
