local ran_once = false

return {
  recommended = function()
    return RUtils.extras.wants {
      ft = "rust",
      root = { "Cargo.toml", "rust-project.json" },
    }
  end,

  -- Extend auto completion
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      {
        "Saecki/crates.nvim",
        event = { "BufRead Cargo.toml" },
        opts = {
          completion = {
            cmp = { enabled = true },
          },
        },
      },
    },
    ---@param opts cmp.ConfigSchema
    opts = function(_, opts)
      opts.sources = opts.sources or {}
      table.insert(opts.sources, { name = "crates" })
    end,
  },

  -- Add Rust & related to treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "rust", "ron" } },
  },

  -- Ensure Rust debugger is installed
  {
    "williamboman/mason.nvim",
    optional = true,
    opts = { ensure_installed = { "codelldb" } },
  },

  {
    "mrcjkb/rustaceanvim",
    version = "^4", -- Recommended
    ft = { "rust" },
    keys = {
      {
        "<Leader>fH",
        function()
          vim.cmd.RustLsp "openDocs"
        end,
        desc = "LPS: open rust docs [rustaceanvim]",
        ft = "rust",
      },
      --   {
      --     "<Leader>ca",
      --     function()
      --       vim.cmd.RustLsp "codeAction"
      --     end,
      --     desc = "LSP: code action [rustaceanvim]",
      --     ft = "rust",
      --   },
      {
        "<F5>",
        function()
          vim.cmd.RustLsp "debuggables"
        end,
        desc = "Debug: debuggables [rustaceanvim]",
        ft = "rust",
      },
    },
    opts = {
      tools = {
        float_win_config = {
          border = RUtils.config.icons.border.line,
        },
      },
      server = {
        handlers = {
          ["experimental/serverStatus"] = function(_, result, ctx, _)
            if result.quiescent and not ran_once then
              for _, bufnr in ipairs(vim.lsp.get_buffers_by_client_id(ctx.client_id)) do
                if ran_once then
                  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
                end
              end
              ran_once = true
            end
          end,
        },
        -- on_attach = function(_, bufnr)
        -- vim.keymap.set("n", "<leader>cR", function()
        --   vim.cmd.RustLsp "codeAction"
        -- end, { desc = "Code Action", buffer = bufnr })
        -- vim.keymap.set("n", "<leader>dr", function()
        --   vim.cmd.RustLsp "debuggables"
        -- end, { desc = "Rust Debuggables", buffer = bufnr })
        -- end,
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
            -- Add clippy lints for Rust.
            checkOnSave = true,
            procMacro = {
              enable = true,
              ignored = {
                ["async-trait"] = { "async_trait" },
                ["napi-derive"] = { "napi" },
                ["async-recursion"] = { "async_recursion" },
              },
            },
          },
        },
      },
    },
    config = function(_, opts)
      vim.g.rustaceanvim = vim.tbl_deep_extend("keep", vim.g.rustaceanvim or {}, opts or {})
      if vim.fn.executable "rust-analyzer" == 0 then
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
        taplo = {
          keys = {
            {
              "gk",
              function()
                if vim.fn.expand "%:t" == "Cargo.toml" and require("crates").popup_available() then
                  require("crates").show_popup()
                else
                  vim.lsp.buf.hover()
                end
              end,
              desc = "Show Crate Documentation",
            },
          },
        },
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
}
