local icons = as.ui.icons

return {
  -- NVIM-TREESITTER
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { "javascript", "typescript" })
    end,
  },
  -- MASON.NVIM
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { "js-debug-adapter" }) -- TODO: To configure debugging
    end,
  },
  -- TYPESCRIPT-TOOLS
  {
    "pmizio/typescript-tools.nvim",
    event = { "BufReadPre", "BufNewFile" },
    ft = { "typescript", "typescriptreact" },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "neovim/nvim-lspconfig",
    },
    config = function()
      require("typescript-tools").setup {
        on_attach = function(client, bufnr)
          if vim.fn.has "nvim-0.10" then
            -- Enable inlay hints
            vim.lsp.inlay_hint(bufnr, true)
          end
        end,
        -- handlers = handlers,
        settings = {
          separate_diagnostic_server = true,
          tsserver_file_preferences = {
            includeInlayParameterNameHints = "literal",
            includeInlayParameterNameHintsWhenArgumentMatchesName = false,
            includeInlayVariableTypeHintsWhenTypeMatchesName = false,
            includeInlayFunctionParameterTypeHints = true,
            includeInlayVariableTypeHints = true,
            includeInlayFunctionLikeReturnTypeHints = false,
            includeInlayPropertyDeclarationTypeHints = true,
            includeInlayEnumMemberValueHints = true,
          },
        },
      }
    end,
  },
  {
    "mfussenegger/nvim-dap",
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
  },
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/neotest-jest",
      "marilari88/neotest-vitest",
      "thenbe/neotest-playwright",
    },
    opts = function(_, opts)
      vim.list_extend(opts.adapters, {
        require "neotest-jest",
        require "neotest-vitest",
        require("neotest-playwright").adapter {
          options = {
            persist_project_selection = true,
            enable_dynamic_test_discovery = true,
          },
        },
      })
    end,
  },
  --         ╭──────────────────────────────────────────────────────────╮
  --         │                         Related                          │
  --         ╰──────────────────────────────────────────────────────────╯
  -- IMPORT-COST.NVIM
  {
    -- Display javascript import costs inside of neovim
    "barrett-ruth/import-cost.nvim",
    build = "sh install.sh yarn",
    ft = {
      "javascript",
      "typescript",
      "javascriptreact",
      "typescriptreact",
    },
    config = true,
  },
  -- TEMPLATE-STRING
  {
    "axelvc/template-string.nvim",
    event = "InsertEnter",
    ft = {
      "javascript",
      "typescript",
      "javascriptreact",
      "typescriptreact",
    },
    config = true, -- run require("template-string").setup()
  },
  -- TSC.NVIM
  {
    -- Type checking typescript
    "dmmulroy/tsc.nvim",
    cmd = { "TSC" },
    config = function()
      require("tsc").setup()
    end,
  },
  -- PACKAGE-INFO.NVIM
  {
    "vuki656/package-info.nvim",
    event = "BufEnter package.json",
    config = function()
      require("package-info").setup {
        colors = {
          up_to_date = "#3C4048", -- Text color for up to date package virtual text
          outdated = "#fc514e", -- Text color for outdated package virtual text
        },
        icons = {
          enable = true, -- Whether to display icons
          style = {
            up_to_date = icons.misc.check, -- Icon for up to date packages
            outdated = icons.git.remove, -- Icon for outdated packages
          },
        },
        autostart = true, -- Whether to autostart when `package.json` is opened
        hide_up_to_date = true, -- It hides up to date versions when displaying virtual text
        hide_unstable_versions = true, -- It hides unstable versions from version list e.g next-11.1.3-canary3

        -- Can be `npm` or `yarn`. Used for `delete`, `install` etc...
        -- The plugin will try to auto-detect the package manager based on
        -- `yarn.lock` or `package-lock.json`. If none are found it will use the
        -- provided one,                              if nothing is provided it will use `yarn`
        package_manager = "yarn",
      }
    end,
  },
}
