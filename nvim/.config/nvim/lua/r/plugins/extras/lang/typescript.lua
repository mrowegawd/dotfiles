return {
  -- TREESITTER
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "typescript", "tsx" })
      end
    end,
  },
  -- LSPCONFIG
  {
    "neovim/nvim-lspconfig",
    opts = {
      -- make sure mason installs the server
      servers = {
        tsserver = {
          keys = {
            {
              "<leader>co",
              function()
                vim.lsp.buf.code_action {
                  apply = true,
                  context = {
                    only = { "source.organizeImports.ts" },
                    diagnostics = {},
                  },
                }
              end,
              desc = "LSP(typescript): organize imports",
            },
            {
              "<leader>cR",
              function()
                vim.lsp.buf.code_action {
                  apply = true,
                  context = {
                    only = { "source.removeUnused.ts" },
                    diagnostics = {},
                  },
                }
              end,
              desc = "LSP(typescript): remove unused imports",
            },
          },
          settings = {
            typescript = {
              format = {
                indentSize = vim.o.shiftwidth,
                convertTabsToSpaces = vim.o.expandtab,
                tabSize = vim.o.tabstop,
              },
            },
            javascript = {
              format = {
                indentSize = vim.o.shiftwidth,
                convertTabsToSpaces = vim.o.expandtab,
                tabSize = vim.o.tabstop,
              },
            },
            completions = {
              completeFunctionCalls = true,
            },
          },
        },
      },
    },
  },
  -- NVIM-DAP
  {
    "mfussenegger/nvim-dap",
    optional = true,
    dependencies = {
      {
        "williamboman/mason.nvim",
        opts = function(_, opts)
          opts.ensure_installed = opts.ensure_installed or {}
          table.insert(opts.ensure_installed, "js-debug-adapter")
        end,
      },
    },
    opts = function()
      local dap = require "dap"
      if not dap.adapters["pwa-node"] then
        require("dap").adapters["pwa-node"] = {
          type = "server",
          host = "localhost",
          port = "${port}",
          executable = {
            command = "node",
            -- 💀 Make sure to update this path to point to your installation
            args = {
              require("mason-registry").get_package("js-debug-adapter"):get_install_path()
                .. "/js-debug/src/dapDebugServer.js",
              "${port}",
            },
          },
        }
      end
      for _, language in ipairs { "typescript", "javascript", "typescriptreact", "javascriptreact" } do
        if not dap.configurations[language] then
          dap.configurations[language] = {
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
          }
        end
      end
    end,
  },

  --         ╭──────────────────────────────────────────────────────────╮
  --         │                         Related                          │
  --         ╰──────────────────────────────────────────────────────────╯

  -- TSC.NVIM
  {
    -- Type checking typescript
    "dmmulroy/tsc.nvim",
    cmd = { "TSC" },
    keys = { { "<leader>lv", [[<CMD> TSC <CR>]], desc = "LSP(tsc): run TSC" } },
    config = function()
      require("tsc").setup()
    end,
  },
  -- PACKAGE-INFO.NVIM
  {
    "vuki656/package-info.nvim",
    enabled = false,
    event = "BufEnter package.json",
    config = function()
      local Config = require "r.config"

      require("package-info").setup {
        colors = {
          up_to_date = "#3C4048", -- Text color for up to date package virtual text
          outdated = "#fc514e", -- Text color for outdated package virtual text
        },
        icons = {
          enable = true, -- Whether to display icons
          style = {
            up_to_date = Config.misc.check, -- Icon for up to date packages
            outdated = Config.git.remove, -- Icon for outdated packages
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
