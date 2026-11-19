local add_on_file_type = require("vim-pack").add_on_file_type
local lazy = require("utils.plugin").require_lazy

add_on_file_type("rust", {
  {
    src = "mrcjkb/rustaceanvim",
    version = vim.version.range "^9",
    on_setup = function()
      local opts = {
        server = {
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
              -- -- Add clippy lints for Rust if using rust-analyzer
              -- checkOnSave = diagnostics == 'rust-analyzer',
              -- -- Enable diagnostics if using rust-analyzer
              -- diagnostics = {
              --   enable = diagnostics == 'rust-analyzer',
              -- },
              procMacro = {
                enable = true,
                ignored = {
                  ["async-trait"] = { "async_trait" },
                  ["napi-derive"] = { "napi" },
                  ["async-recursion"] = { "async_recursion" },
                },
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
            },
          },
        },
      }

      local codelldb = vim.fn.exepath "codelldb"
      local codelldb_lib_ext = io.popen("uname"):read "*l" == "Linux" and ".so" or ".dylib"
      local library_path = vim.fn.expand("$MASON/opt/lldb/lib/liblldb" .. codelldb_lib_ext)
      opts.dap = {
        adapter = lazy("rustaceanvim.config").get_codelldb_adapter(codelldb, library_path),
      }

      vim.g.rustaceanvim = vim.tbl_deep_extend("keep", vim.g.rustaceanvim or {}, opts or {})
    end,
  },
})
