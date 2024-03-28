local max_width = math.min(math.floor(vim.o.columns * 0.7), 100)
local max_height = math.min(math.floor(vim.o.lines * 0.3), 30)

return {
  -- COQ
  {
    "ms-jpq/coq_nvim",
    dependencies = {
      "mendes-davi/coq_luasnip",
      { "ms-jpq/coq.thirdparty", branch = "3p" },
    },
    branch = "coq",
    lazy = false,
    init = function()
      vim.g.coq_settings = {

        auto_start = true,
        keymap = {
          -- manual_complete = "<c-cr>",
          bigger_preview = "null",
          jump_to_mark = "null",
        },
        clients = {
          snippets = { enabled = false }, -- disable coq snippets
        },
      }
    end,
    config = function()
      require "coq"
    end,
  },
  -- MASON
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    build = ":MasonUpdate",
    opts = {
      ensure_installed = { "shfmt" },
      ui = { border = require("r.config").icons.border.line, height = 0.8 },
    },
    config = function(_, opts)
      require("mason").setup(opts)
      local mr = require "mason-registry"
      mr:on("package:install:success", function()
        vim.defer_fn(function()
          -- trigger FileType event to possibly load this newly installed LSP server
          require("lazy.core.handler.event").trigger {
            event = "FileType",
            buf = vim.api.nvim_get_current_buf(),
          }
        end, 100)
      end)

      local function ensure_installed()
        for _, tool in ipairs(opts.ensure_installed) do
          local p = mr.get_package(tool)
          if not p:is_installed() then
            p:install()
          end
        end
      end
      if mr.refresh then
        mr.refresh(ensure_installed)
      else
        ensure_installed()
      end
    end,
  },
  -- LSPCONFIG
  {
    "neovim/nvim-lspconfig",
    event = "LazyFile",
    dependencies = {
      {
        "folke/neoconf.nvim",
        cmd = "Neoconf",
        dependencies = { "nvim-lspconfig" },
        opts = {
          library = { plugins = { "neotest", "nvim-dap-ui" }, types = true },
        },
      },
      -- { "folke/neodev.nvim", opts = {} },
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    opts = {
      diagnostics = {
        underline = true,
        update_in_insert = false,
        virtual_text = false,
        -- virtual_text = false {
        --   spacing = 4,
        --   source = "if_many",
        --   prefix = "●",
        -- },
        severity_sort = true,
        float = {
          max_width = max_width,
          max_height = max_height,
          title = {
            { "  ", "DiagnosticFloatTitleIcon" },
            { "Problems  ", "DiagnosticFloatTitle" },
          },
          focusable = false,
          style = "minimal",
          border = require("r.config").icons.border.line,
          source = "always",
          header = "",
          prefix = function(diag)
            local level = vim.diagnostic.severity[diag.severity]
            local prefix = string.format(
              "%s ",
              require("r.config").icons.diagnostics[string.gsub(level:lower(), [[(%a)([%w_']*)]], function(first, rest)
                return first:upper() .. rest:lower()
              end)]
            )
            return prefix, "Diagnostic" .. level:gsub("^%l", string.upper)
          end,
        },
      },
      -- Enable this to enable the builtin LSP inlay hints on Neovim >= 0.10.0
      -- Be aware that you also will need to properly configure your LSP server to
      -- provide the inlay hints.
      inlay_hints = { enabled = true },
      -- add any global capabilities here
      capabilities = {},
      -- options for vim.lsp.buf.format
      -- `bufnr` and `filter` is handled by the LazyVim formatter,
      -- but can be also overridden when specified
      format = { formatting_options = nil, timeout_ms = nil },
      servers = {

        -- unocss = {},
        tailwindcss = {
          -- exclude a filetype from the default_config
          filetypes_exclude = { "markdown" },
          -- add additional filetypes to the default_config
          -- filetypes_include = {},
          -- to fully override the default_config, change the below
          -- filetypes = {}
        },
        eslint = {
          settings = {
            -- helps eslint find the eslintrc when it's placed in a subfolder instead of the cwd root
            -- workingDirectory = { mode = "auto" },
            workingDirectories = { mode = "auto" },
          },
        },
        lua_ls = {
          settings = {
            Lua = {
              codeLens = { enable = true },
              workspace = { checkThirdParty = false },
              completion = { callSnippet = "Replace" },
              telemetry = { enable = false },
              hint = { enable = false },
              diagnostics = {
                globals = { "vim", "it", "describe", "before_each", "after_each", "a" },
                undefined_global = false, -- remove this from diag!
                missing_parameters = false, -- missing fields :)
              },
            },
          },
        },
      },
      setup = {
        -- example to setup with typescript.nvim
        -- tsserver = function(_, opts)
        --   require("typescript").setup({ server = opts })
        --   return true
        -- end,
        -- Specify * to use this function as a fallback for any server
        -- ["*"] = function(server, opts) end,
        -- unocss = {
        --   filetypes = { "typescriptreact" },
        -- },
        tailwindcss = function(_, opts)
          local tw = require "lspconfig.server_configurations.tailwindcss"
          opts.filetypes = opts.filetypes or {}

          -- Add default filetypes
          vim.list_extend(opts.filetypes, tw.default_config.filetypes)

          -- Remove excluded filetypes
          --- @param ft string
          opts.filetypes = vim.tbl_filter(function(ft)
            return not vim.tbl_contains(opts.filetypes_exclude or {}, ft)
          end, opts.filetypes)

          -- Add additional filetypes
          vim.list_extend(opts.filetypes, opts.filetypes_include or {})
        end,
        eslint = function()
          local function get_client(buf)
            return RUtils.lsp.get_clients({ name = "eslint", bufnr = buf })[1]
          end

          local formatter = RUtils.lsp.formatter {
            name = "eslint: lsp",
            primary = false,
            priority = 200,
            filter = "eslint",
          }

          -- Use EslintFixAll on Neovim < 0.10.0
          if not pcall(require, "vim.lsp._dynamic") then
            formatter.name = "eslint: EslintFixAll"
            formatter.sources = function(buf)
              local client = get_client(buf)
              return client and { "eslint" } or {}
            end
            formatter.format = function(buf)
              local client = get_client(buf)
              if client then
                local diag = vim.diagnostic.get(buf, { namespace = vim.lsp.diagnostic.get_namespace(client.id) })
                if #diag > 0 then
                  vim.cmd "EslintFixAll"
                end
              end
            end
          end

          -- register the formatter with LazyVim
          RUtils.format.register(formatter)
        end,
      },
    },
    config = function(_, opts)
      if RUtils.has "neoconf.nvim" then
        local plugin = require("lazy.core.config").spec.plugins["neoconf.nvim"]
        require("neoconf").setup(require("lazy.core.plugin").values(plugin, "opts", false))
      end

      RUtils.format.register(Util.lsp.formatter())

      -- deprecated options
      if opts.autoformat ~= nil then
        vim.g.autoformat = opts.autoformat
        RUtils.error("nvim-lspconfig.opts.autoformat", "vim.g.autoformat")
      end

      local function has_capability(capability, filter)
        for _, client in ipairs(vim.lsp.get_active_clients(filter)) do
          if client.supports_method(capability) then
            return true
          end
        end
        return false
      end

      local provider = {
        HOVER = "hoverProvider",
        RENAME = "renameProvider",
        CODELENS = "codeLensProvider",
        CODEACTIONS = "codeActionProvider",
        FORMATTING = "documentFormattingProvider",
        REFERENCES = "documentHighlightProvider",
        DEFINITION = "definitionProvider",
      }

      -- Setup formatting and keymaps
      RUtils.lsp.on_attach(function(client, bufnr)
        require("r.plugins.lsp.keymaps").on_attach(client, bufnr)

        if client.server_capabilities[provider.CODELENS] then
          RUtils.cmd.augroup("LspCodelensRefresh", {
            event = { "BufEnter", "InsertLeave", "BufWritePost" },
            desc = "LSP: Code Lens",
            buffer = bufnr,
            command = function()
              if not has_capability("textDocument/codeLens", { bufnr = bufnr }) then
                RUtils.cmd.del_buffer_autocmd("LspCodelensRefresh", bufnr)
                return
              end
              if vim.g.codelens_enabled then
                vim.lsp.codelens.refresh()
              end
            end,
          })
        end

        if client.server_capabilities[provider.REFERENCES] then
          RUtils.cmd.augroup(("LspReferences%d"):format(bufnr), {
            event = { "CursorHold", "CursorHoldI" },
            buffer = bufnr,
            desc = "LSP: References",
            command = function()
              vim.lsp.buf.document_highlight()
            end,
          }, {
            event = "CursorMoved",
            desc = "LSP: References Clear",
            buffer = bufnr,
            command = function()
              vim.lsp.buf.clear_references()
            end,
          })
        end

        if opts.inlay_hints.enabled then
          if client.supports_method "textDocument/inlayHint" then
            RUtils.toggle.inlay_hints(bufnr, true)
          end
        end
      end)

      local register_capability = vim.lsp.handlers["client/registerCapability"]

      ---@diagnostic disable-next-line: duplicate-set-field
      vim.lsp.handlers["client/registerCapability"] = function(err, res, ctx)
        local ret = register_capability(err, res, ctx)
        local client_id = ctx.client_id
        local client = vim.lsp.get_client_by_id(client_id)
        local buffer = vim.api.nvim_get_current_buf()
        require("r.plugins.lsp.keymaps").on_attach(client, buffer)
        return ret
      end

      -- Uncomment this if you are not using 'noice.nvim'
      -- vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
      --   border = border,
      -- })

      -- Diagnostics
      for name, icon in pairs(require("r.config").icons.diagnostics) do
        name = "DiagnosticSign" .. name
        vim.fn.sign_define(name, { text = icon, texthl = name, numhl = "" })
      end

      if type(opts.diagnostics.virtual_text) == "table" and opts.diagnostics.virtual_text.prefix == "icons" then
        opts.diagnostics.virtual_text.prefix = vim.fn.has "nvim-0.10.0" == 0 and "●"
          or function(diagnostic)
            for d, icon in pairs(require("r.config").icons.diagnostics) do
              if diagnostic.severity == vim.diagnostic.severity[d:upper()] then
                return icon
              end
            end
          end
      end

      vim.diagnostic.config(vim.deepcopy(opts.diagnostics))

      local servers = opts.servers
      local has_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
      local capabilities = vim.tbl_deep_extend(
        "force",
        {},
        vim.lsp.protocol.make_client_capabilities(),
        has_cmp and cmp_nvim_lsp.default_capabilities() or {},
        opts.capabilities or {}
      )

      local function setup(server)
        local server_opts = vim.tbl_deep_extend("force", {
          capabilities = vim.deepcopy(capabilities),
        }, servers[server] or {})

        if opts.setup[server] then
          if opts.setup[server](server, server_opts) then
            return
          end
        elseif opts.setup["*"] then
          if opts.setup["*"](server, server_opts) then
            return
          end
        end
        require("lspconfig")[server].setup(server_opts)
      end

      -- get all the servers that are available through mason-lspconfig
      local have_mason, mlsp = pcall(require, "mason-lspconfig")
      local all_mslp_servers = {}
      if have_mason then
        all_mslp_servers = vim.tbl_keys(require("mason-lspconfig.mappings.server").lspconfig_to_package)
      end

      local ensure_installed = {} ---@type string[]
      for server, server_opts in pairs(servers) do
        if server_opts then
          server_opts = server_opts == true and {} or server_opts
          -- run manual setup if mason=false or if this is a server that cannot be installed with mason-lspconfig
          if server_opts.mason == false or not vim.tbl_contains(all_mslp_servers, server) then
            setup(server)
          else
            ensure_installed[#ensure_installed + 1] = server
          end
        end
      end

      if have_mason then
        mlsp.setup { ensure_installed = ensure_installed, handlers = { setup } }
      end

      if RUtils.lsp.get_config "denols" and Util.lsp.get_config "tsserver" then
        RUtils.lsp.on_attach(function(client, _)
          client.server_capabilities.semanticTokensProvider = nil
        end)
        --   local is_deno = require("lspconfig.util").root_pattern("deno.json", "deno.jsonc")
        --   RUtils.lsp.lsp_disable("tsserver", is_deno)
        --   RUtils.lsp.lsp_disable("denols", function(root_dir)
        --     return not is_deno(root_dir)
        -- end)
      end
    end,
  },
  -- MASON
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      table.insert(opts.ensure_installed, "prettierd")
    end,
  },
  -- NONE-LS
  {
    "nvimtools/none-ls.nvim",
    optional = true,
    opts = function(_, opts)
      local nls = require "null-ls"
      opts.sources = opts.sources or {}
      table.insert(opts.sources, nls.builtins.formatting.prettierd)
    end,
  },
  -- CONFORM
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        ["javascript"] = { { "prettierd", "prettier" } },
        ["javascriptreact"] = { { "prettierd", "prettier" } },
        ["typescript"] = { { "prettierd", "prettier" } },
        ["typescriptreact"] = { { "prettierd", "prettier" } },
        ["vue"] = { { "prettierd", "prettier" } },
        ["css"] = { { "prettierd", "prettier" } },
        ["scss"] = { { "prettierd", "prettier" } },
        ["less"] = { { "prettierd", "prettier" } },
        ["html"] = { { "prettierd", "prettier" } },
        ["json"] = { { "prettierd", "prettier" } },
        ["jsonc"] = { { "prettierd", "prettier" } },
        ["yaml"] = { { "prettierd", "prettier" } },
        ["markdown"] = { { "prettierd", "prettier" } },
        ["markdown.mdx"] = { { "prettierd", "prettier" } },
        ["graphql"] = { { "prettierd", "prettier" } },
        ["handlebars"] = { { "prettierd", "prettier" } },
      },
    },
  },
  -- BETTER-TS-ERRORS
  {
    "OlegGulevskyy/better-ts-errors.nvim",
    dependencies = { "MunifTanjim/nui.nvim" },
    keys = { "dg", "dG" },
    opts = {
      keymaps = {
        toggle = "dg", -- default '<leader>dd'
        go_to_definition = "dG", -- Go to problematic type from popup window
        --   go_to_definition = "<leader>dx",
      },
    },
  },
  -- NVIM-TREESITTER
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "javascript", "typescript", "tsx" })
      end
    end,
  },
  -- MASON.NVIM
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { "typescript-language-server", "js-debug-adapter" })
    end,
  },
  -- TYPESCRIPT-TOOLS
  {
    "pmizio/typescript-tools.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "neovim/nvim-lspconfig",
    },
    opts = {
      tsserver_file_preferences = {
        -- Inlay Hints
        includeInlayParameterNameHints = "all",
        includeInlayParameterNameHintsWhenArgumentMatchesName = true,
        includeInlayFunctionParameterTypeHints = true,
        includeInlayVariableTypeHints = true,
        includeInlayVariableTypeHintsWhenTypeMatchesName = true,
        includeInlayPropertyDeclarationTypeHints = true,
        includeInlayFunctionLikeReturnTypeHints = true,
        includeInlayEnumMemberValueHints = true,
      },
    },
    config = function(_, opts)
      RUtils.lsp.on_attach(function(client, bufnr)
        -- stylua: ignore
        if client.name == "tsserver" then
          vim.keymap.set("n", "<Leader>co", "<cmd>TSToolsOrganizeImports<cr>",
            { buffer = bufnr, desc = "Organize Imports" })
          vim.keymap.set("n", "<Leader>cO", "<cmd>TSToolsSortImports<cr>", { buffer = bufnr, desc = "Sort Imports" })
          vim.keymap.set("n", "<Leader>cu", "<cmd>TSToolsRemoveUnused<cr>", { buffer = bufnr, desc = "Removed Unused" })
          vim.keymap.set("n", "<Leader>lz", "<cmd>TSToolsGoToSourceDefinition<cr>",
            { buffer = bufnr, desc = "Go To Source Definition" })
          vim.keymap.set("n", "<Leader>cR", "<cmd>TSToolsRemoveUnusedImports<cr>",
            { buffer = bufnr, desc = "Removed Unused Imports" })
          vim.keymap.set("n", "<Leader>lF", "<cmd>TSToolsFixAll<cr>", { buffer = bufnr, desc = "Fix All" })
          vim.keymap.set("n", "<Leader>cM", "<cmd>TSToolsAddMissingImports<cr>",
            { buffer = bufnr, desc = "Add Missing Imports" })
        end
      end)
      require("typescript-tools").setup(opts)
    end,
  },
  -- DAP
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
}
