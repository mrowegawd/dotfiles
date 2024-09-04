-- if lazyvim_docs then
-- LSP Server to use for Python.
-- Set to "basedpyright" to use basedpyright instead of pyright.
vim.g.lazyvim_python_lsp = "pyright"
vim.g.lazyvim_python_ruff = "ruff_lsp"
-- end

local lsp = vim.g.lazyvim_python_lsp or "pyright"
local ruff = vim.g.lazyvim_python_ruff or "ruff_lsp"

return {
  recommended = function()
    return RUtils.extras.wants {
      ft = "python",
      root = {
        "pyproject.toml",
        "setup.py",
        "setup.cfg",
        "requirements.txt",
        "Pipfile",
        "pyrightconfig.json",
      },
    }
  end,
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "ninja", "rst" } },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        pyright = {
          enabled = lsp == "pyright",
        },
        basedpyright = {
          enabled = lsp == "basedpyright",
        },
        [lsp] = {
          enabled = true,
        },
        ruff_lsp = {
          enabled = ruff == "ruff_lsp",
        },
        ruff = {
          enabled = ruff == "ruff",
        },
        [ruff] = {
          keys = {
            {
              "<leader>co",
              RUtils.lsp.action["source.organizeImports"],
              desc = "Action: organize imports",
            },
          },
        },
      },
      setup = {
        [ruff] = function()
          RUtils.lsp.on_attach(function(client, _)
            -- Disable hover in favor of Pyright
            client.server_capabilities.hoverProvider = false
          end, ruff)
        end,
      },
    },
  },
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
  -- Ensure debugpy tools are installed
  {
    "williamboman/mason.nvim",
    opts = { ensure_installed = { "debugpy" } },
  },
  {
    "mfussenegger/nvim-dap",
    optional = true,
    dependencies = {
      "mfussenegger/nvim-dap-python",
      -- stylua: ignore
      keys = {
        { "<leader>dPt", function() require('dap-python').test_method() end, desc = "Debug Method", ft = "python" },
        { "<leader>dPc", function() require('dap-python').test_class() end, desc = "Debug Class", ft = "python" },
      },
      config = function()
        if vim.fn.has "win32" == 1 then
          require("dap-python").setup(RUtils.get_pkg_path("debugpy", "/venv/Scripts/pythonw.exe"))
        else
          require("dap-python").setup(RUtils.get_pkg_path("debugpy", "/venv/bin/python"))
        end
      end,
    },
  },
  {
    "linux-cultist/venv-selector.nvim",
    branch = "regexp", -- Use this branch for the new version
    cmd = "VenvSelect",
    opts = {
      settings = {
        options = {
          notify_user_on_venv_activation = true,
        },
      },
    },
    --  Call config for python files and load the cached venv automatically
    ft = "python",
    keys = {
      { "<Leader>cv", "<cmd>:VenvSelect<cr>", desc = "Action: select virtualenv [venv-selector]", ft = "python" },
    },
  },
  {
    "yioneko/nvim-cmp",
    opts = function(_, opts)
      opts.auto_brackets = opts.auto_brackets or {}
      table.insert(opts.auto_brackets, "python")
    end,
  },

  -- Don't mess up DAP adapters provided by nvim-dap-python
  {
    "jay-babu/mason-nvim-dap.nvim",
    optional = true,
    opts = {
      handlers = {
        python = function() end,
      },
    },
  },
}
