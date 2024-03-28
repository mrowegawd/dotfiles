return {
  -- NVIM-TREESITTER
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { "python", "ninja", "rst", "toml" })
    end,
  },
  -- MASON.NVIM
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { "debugpy", "black", "ruff" })
    end,
  },
  -- NVIM-LSPCONFIG"
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        pyright = {},
        ruff_lsp = {
          keys = {
            {
              "<leader>co",
              function()
                vim.lsp.buf.code_action {
                  apply = true,
                  context = {
                    only = { "source.organizeImports" },
                    diagnostics = {},
                  },
                }
              end,
              desc = "LSP(python): organize Imports",
            },
          },
        },
      },
      setup = {
        ruff_lsp = function()
          RUtils.lsp.on_attach(function(client, _)
            if client.name == "ruff_lsp" then
              -- Disable hover in favor of Pyright
              client.server_capabilities.hoverProvider = false
            end
          end)
        end,
      },
    },
  },
  -- NEOTEST
  {
    "nvim-neotest/neotest",
    optional = true,
    dependencies = {
      "nvim-neotest/neotest-python",
    },
    opts = {
      adapters = {
        ["neotest-python"] = {
          -- Here you can specify the settings for the adapter, i.e.
          -- runner = "pytest",
          -- python = ".venv/bin/python",
        },
      },
    },
  },
  -- NVIM-DAP
  {
    "mfussenegger/nvim-dap",
    optional = true,
    dependencies = {
      "mfussenegger/nvim-dap-python",
      -- stylua: ignore
      -- keys = { } -- Use ftplugin/python
      config = function()
        local path = require("mason-registry").get_package("debugpy"):get_install_path()
        require("dap-python").setup(path .. "/venv/bin/python")
      end,
    },
  },
  --  ╭──────────────────────────────────────────────────────────╮
  --  │ Related                                                  │
  --  ╰──────────────────────────────────────────────────────────╯
  -- VENV-SELECTOR
  {
    "linux-cultist/venv-selector.nvim",
    cmd = "VenvSelect",
    opts = function(_, opts)
      if require("r.util").has "nvim-dap-python" then
        opts.dap_enabled = true
      end
      return vim.tbl_deep_extend("force", opts, {
        name = { "venv", ".venv", "env", ".env" },
      })
    end,
    -- keys = { } -- Use ftplugin/python
  },
}
