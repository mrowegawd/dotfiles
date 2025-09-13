vim.g.lazyvim_rust_diagnostics = "rust-analyzer"
local diagnostics = vim.g.lazyvim_rust_diagnostics or "rust-analyzer"

return {
  recommended = function()
    return RUtils.extras.wants {
      ft = "rust",
      root = { "Cargo.toml", "rust-project.json" },
    }
  end,

  -- LSP for Cargo.toml
  {
    "Saecki/crates.nvim",
    event = { "BufRead Cargo.toml" },
    opts = {
      completion = {
        crates = {
          enabled = true,
        },
      },
      lsp = {
        enabled = true,
        actions = true,
        completion = true,
        hover = true,
      },
    },
  },

  -- Add Rust & related to treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "rust", "ron" } },
  },

  -- Ensure Rust debugger is installed
  {
    "mason-org/mason.nvim",
    optional = true,
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "codelldb" })
      if diagnostics == "bacon-ls" then
        vim.list_extend(opts.ensure_installed, { "bacon", "bacon-ls" })
      end
    end,
  },

  {
    "mrcjkb/rustaceanvim",
    version = vim.fn.has "nvim-0.10.0" == 0 and "^4" or false,
    ft = { "rust" },
    -- keys = {
    --   {
    --     "<Leader>fH",
    --     function()
    --       vim.cmd.RustLsp "openDocs"
    --     end,
    --     desc = "LPS: open rust docs [rustaceanvim]",
    --     ft = "rust",
    --   },
    --   --   {
    --   --     "<Leader>ca",
    --   --     function()
    --   --       vim.cmd.RustLsp "codeAction"
    --   --     end,
    --   --     desc = "Action: code action [rustaceanvim]",
    --   --     ft = "rust",
    --   --   },
    --   {
    --     "<F5>",
    --     function()
    --       vim.cmd.RustLsp "debuggables"
    --     end,
    --     desc = "Debug: debuggables [rustaceanvim]",
    --     ft = "rust",
    --   },
    -- },
    opts = {
      tools = {
        float_win_config = {
          border = RUtils.config.icons.border.line,
        },
      },
      server = {
        on_attach = function(_, bufnr)
          vim.keymap.set("n", "<leader>cR", function()
            vim.cmd.RustLsp "codeAction"
          end, { desc = "Action: code action", buffer = bufnr })
          vim.keymap.set("n", "<leader>dr", function()
            vim.cmd.RustLsp "debuggables"
          end, { desc = "Rust Debuggables", buffer = bufnr })
        end,
        default_settings = {
          -- rust-analyzer language server configuration
          ["rust-analyzer"] = {
            cargo = {
              allFeatures = true,
              loadOutDirsFromCheck = true,
              buildScripts = {
                enable = true,
              },
            },
            -- Add clippy lints for Rust if using rust-analyzer
            checkOnSave = diagnostics == "rust-analyzer",
            -- Enable diagnostics if using rust-analyzer
            diagnostics = {
              enable = diagnostics == "rust-analyzer",
              disabled = { "proc-macro-disabled" },
            },
            procMacro = {
              enable = true,
            },
            files = {
              excludeDirs = {
                ".direnv",
                ".git",
                ".github",
                ".gitlab",
                "bin",
                "node_modules",
                "target",
                "venv",
                ".venv",
              },
            },
            -- Avoid Roots Scanned hanging, see https://github.com/rust-lang/rust-analyzer/issues/12613#issuecomment-2096386344
            watcher = "client",
          },
        },
      },
    },
    config = function(_, opts)
      if RUtils.has "mason.nvim" then
        local codelldb = vim.fn.exepath "codelldb"
        local codelldb_lib_ext = io.popen("uname"):read "*l" == "Linux" and ".so" or ".dylib"
        local library_path = vim.fn.expand("$MASON/opt/lldb/lib/liblldb" .. codelldb_lib_ext)
        opts.dap = {
          adapter = require("rustaceanvim.config").get_codelldb_adapter(codelldb, library_path),
        }
      end
      vim.g.rustaceanvim = vim.tbl_deep_extend("keep", vim.g.rustaceanvim or {}, opts or {})
      if vim.fn.executable "rust-analyzer" == 0 then
        ---@diagnostic disable-next-line: undefined-field
        RUtils.error(
          "**rust-analyzer** not found in PATH, please install it.\nhttps://rust-analyzer.github.io/",
          { title = "rustaceanvim" }
        )
      end
    end,
  },

  -- Correctly setup lspconfig for Rust 🚀
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        bacon_ls = {
          enabled = diagnostics == "bacon-ls",
        },
        rust_analyzer = { enabled = false },
      },
    },
  },

  {
    "nvim-neotest/neotest",
    optional = true,
    opts = {
      adapters = {
        ["rustaceanvim.neotest"] = {},
      },
    },
  },

  -- Show `impl` blocks in outline.nvim
  {
    "MadKuntilanak/outline.nvim",
    -- dir = "~/.local/src/nvim_plugins/outline.nvim",
    optional = true,
    opts = {
      symbols = {
        filter = {
          rust = vim.list_extend(vim.deepcopy(RUtils.config.kind_filter["default"]), { "Object" }),
        },
      },
    },
  },
}
