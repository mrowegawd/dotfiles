local function status_dap()
  local ok, dap = pcall(require, "dap")

  if not ok then
    return ""
  end

  return dap.status()
end

return {
  -- NVIM-TREESITTER
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "ron", "rust", "toml" })
      end
    end,
  },
  -- MASON.NVIM
  {
    "williamboman/mason.nvim",
    optional = true,
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "codelldb" })
      end
    end,
  },
  -- RUST-TOOLS
  {
    "simrat39/rust-tools.nvim",
    dependencies = {
      "rust-lang/rust.vim",
    },
    lazy = true,
    opts = function()
      local ok, mason_registry = pcall(require, "mason-registry")
      local adapter ---@type any
      if ok then
        -- rust tools configuration for debugging support
        local codelldb = mason_registry.get_package "codelldb"
        local extension_path = codelldb:get_install_path() .. "/extension/"
        local codelldb_path = extension_path .. "adapter/codelldb"
        local liblldb_path = vim.fn.has "mac" == 1 and extension_path .. "lldb/lib/liblldb.dylib"
          or extension_path .. "lldb/lib/liblldb.so"
        adapter = require("rust-tools.dap").get_codelldb_adapter(codelldb_path, liblldb_path)
      end
      return {
        dap = {
          adapter = adapter,
        },
        tools = {
          hover_actions = {
            auto_focus = true,
          },
          inlay_hints = {
            auto = false,
          },
        },
      }
    end,
    config = function() end,
  },
  -- NVIM-LSPCONFIG
  {
    "neovim/nvim-lspconfig",
    optional = true,
    opts = {
      servers = {
        rust_analyzer = {
          settings = {
            ["rust-analyzer"] = {
              cargo = {
                allFeatures = true,
                loadOutDirsFromCheck = true,
                runBuildScripts = true,
              },
              -- Add clippy lints for Rust.
              checkOnSave = {
                allFeatures = true,
                command = "clippy",
                extraArgs = { "--no-deps" },
              },
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
        taplo = {
          keys = {
            {
              "K",
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
      setup = {
        rust_analyzer = function(_, opts)
          local function locopts(name)
            local plugin = require("lazy.core.config").plugins[name]
            if not plugin then
              return {}
            end
            local Plugin = require "lazy.core.plugin"
            return Plugin.values(plugin, "opts", false)
          end

          local rust_tools_opts = locopts "rust-tools.nvim"

          require("rust-tools").setup(vim.tbl_deep_extend("force", rust_tools_opts or {}, { server = opts }))

          local lsp_utils = require "r.plugins.lsp.utils"
          lsp_utils.on_attach(function(client, buffer)
            if client.name == "rust_analyzer" then
              vim.keymap.set("n", "<localleader>dd", function()
                if #status_dap() > 0 then
                  require("dap").disconnect()
                  return require("dapui").close()
                else
                  return vim.cmd.RustDebuggables()
                end
              end, {
                desc = "Debug(rust): RustDebuggables",
                buffer = buffer,
              })

              vim.keymap.set("n", "K", function()
                return vim.cmd.RustHoverActions()
              end, {
                desc = "LSP(rust): RustHoverActions",
                buffer = buffer,
              })
            end
          end)
          return true
        end,
      },
    },
  },
  -- NEOTEST RUST
  {
    "nvim-neotest/neotest",
    optional = true,
    dependencies = {
      "rouge8/neotest-rust",
    },
    opts = {
      adapters = {
        ["neotest-rust"] = {},
      },
    },
  },
}
