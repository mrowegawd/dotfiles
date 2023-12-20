local Util = require "r.utils"
local icons = require("r.config").icons

local max_width = math.min(math.floor(vim.o.columns * 0.7), 100)
local max_height = math.min(math.floor(vim.o.lines * 0.3), 30)

return {
  -- MASON NVIM
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    build = ":MasonUpdate",
    opts = {
      ensure_installed = {
        -- lua
        "stylua",

        -- ts,js,react
        "prettierd",
        -- "typescript-language-server", -- do not install this, let typescript-tools handle this,
        "js-debug-adapter",

        -- golang
        "gomodifytags",
        "impl",
        "goimports",
        "gofumpt",
        "delve",
        "golangci-lint",

        -- bash
        "beautysh",
        "shfmt",

        -- python
        "black",
        "ruff",
        "debugpy",

        -- cmake
        "cmakelang",
        "cmakelint",

        "markdownlint",
        "marksman",

        -- docker
        "hadolint",
      },
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
  -- NVIM-LSPCONFIG
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

      {
        "b0o/SchemaStore.nvim",
        version = false, -- last release is way too old
      },
    },
    opts = {
      diagnostics = {
        underline = true,
        update_in_insert = false,
        virtual_text = {
          spacing = 4,
          source = "if_many",
          prefix = "■", -- "●"
        },
        severity_sort = true,
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = icons.diagnostics.Error,
            [vim.diagnostic.severity.WARN] = icons.diagnostics.Warn,
            [vim.diagnostic.severity.HINT] = icons.diagnostics.Hint,
            [vim.diagnostic.severity.INFO] = icons.diagnostics.Info,
          },
        },
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
              icons.diagnostics[string.gsub(level:lower(), [[(%a)([%w_']*)]], function(first, rest)
                return first:upper() .. rest:lower()
              end)]
            )
            return prefix, "Diagnostic" .. level:gsub("^%l", string.upper)
          end,
        },
      },
      inlay_hints = { enabled = false },
      capabilities = {},
      format = { formatting_options = nil, timeout_ms = nil },
      servers = {
        zls = {},
        dockerls = {},
        docker_compose_language_service = {},
        rust_analyzer = {},
        html = {},
        cssls = {
          settings = {
            css = { lint = { unknownAtRules = "ignore" } },
            scss = { lint = { unknownAtRules = "ignore" } },
          },
        },
        yamlls = {
          -- Have to add this for yamlls to understand that we support line folding
          capabilities = {
            textDocument = {
              foldingRange = {
                dynamicRegistration = false,
                lineFoldingOnly = true,
              },
            },
          },
          -- lazy-load schemastore when needed
          on_new_config = function(new_config)
            new_config.settings.yaml.schemas = vim.tbl_deep_extend(
              "force",
              new_config.settings.yaml.schemas or {},
              require("schemastore").yaml.schemas()
            )
          end,
          settings = {
            redhat = { telemetry = { enabled = false } },
            yaml = {
              keyOrdering = false,
              format = {
                enable = true,
              },
              validate = true,
              schemaStore = {
                -- Must disable built-in schemaStore support to use
                -- schemas from SchemaStore.nvim plugin
                enable = false,
                -- Avoid TypeError: Cannot read properties of undefined (reading 'length')
                url = "",
              },
            },
          },
        },
        eslint = {
          settings = {
            -- workingDirectory = { mode = "location" },
            -- workingDirectory = { mode = "auto" },
            -- onIgnoredFiles = "off",
            codeAction = {
              disableRuleComment = {
                enable = true,
                location = "separateLine",
              },
              showDocumentation = {
                enable = true,
              },
            },
            codeActionOnSave = {
              enable = false,
              mode = "all",
            },
            format = true,
            nodePath = "",
            onIgnoredFiles = "off",
            -- packageManager = "npm",
            quiet = false,
            rulesCustomizations = {},
            run = "onType",
            useESLintClass = false,
            validate = "on",
            workingDirectory = {
              mode = "location",
            },
          },
        },
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
        jsonls = {
          -- lazy-load schemastore when needed
          on_new_config = function(new_config)
            new_config.settings.json.schemas = new_config.settings.json.schemas or {}
            vim.list_extend(new_config.settings.json.schemas, require("schemastore").json.schemas())
          end,
          settings = { json = { format = { enable = true }, validate = { enable = true } } },
        },
        bashls = {},
        gopls = {
          settings = {
            gopls = {
              gofumpt = true,
              codelenses = {
                gc_details = false,
                generate = true,
                regenerate_cgo = true,
                run_govulncheck = true,
                test = true,
                tidy = true,
                upgrade_dependency = true,
                vendor = true,
              },
              hints = {
                assignVariableTypes = true,
                compositeLiteralFields = true,
                compositeLiteralTypes = true,
                constantValues = true,
                functionTypeParameters = true,
                parameterNames = true,
                rangeVariableTypes = true,
              },
              analyses = {
                fieldalignment = true,
                nilness = true,
                unusedparams = true,
                unusedwrite = true,
                useany = true,
              },
              usePlaceholders = true,
              completeUnimported = true,
              staticcheck = true,
              directoryFilters = {
                "-.git",
                "-.vscode",
                "-.idea",
                "-.vscode-test",
                "-node_modules",
              },
              semanticTokens = true,
            },
          },
        },
        neocmake = {},
        tailwindcss = {
          filetypes = { "html", "mdx", "javascript", "javascriptreact", "typescriptreact", "vue", "svelte" },
          -- https://github.com/neovim/neovim/issues/19118#issuecomment-1221522853
          -- Atm LSP ini berat dengan cmp (check pengaturan cmp /code.lua),
          -- tapi LSP ini tidak begitu dengan coq dan coc
          filetypes_exclude = { "markdown" },
          filetypes_include = {},
          root_dir = function(...)
            return require("lspconfig.util").root_pattern ".git"(...)
          end,
        },
        lua_ls = {
          settings = {
            Lua = {
              runtime = {
                version = "LuaJIT", -- diperlukan define LuaJIT ini, kalau tidak warning lua version (contoh unpack)
              },
              codeLens = { enable = true },
              workspace = {
                checkThirdParty = false,
                -- library = {
                -- [vim.fn.expand "$HOME/moxconf/contrib/neovim/runtime/lua"] = true,
                --   [vim.fn.stdpath "config" .. "/lua"] = true,
                -- },
              },
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
        eslint = function()
          local function get_client(buf)
            return Util.lsp.get_clients({ name = "eslint", bufnr = buf })[1]
          end

          local formatter = Util.lsp.formatter {
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
          Util.format.register(formatter)
        end,
        yamlls = function()
          -- Neovim < 0.10 does not have dynamic registration for formatting
          if vim.fn.has "nvim-0.10" == 0 then
            Util.lsp.on_attach(function(client, _)
              if client.name == "yamlls" then
                client.server_capabilities.documentFormattingProvider = true
              end
            end)
          end
        end,
        ruff_lsp = function()
          Util.lsp.on_attach(function(client, _)
            if client.name == "ruff_lsp" then
              -- Disable hover in favor of Pyright
              client.server_capabilities.hoverProvider = false
            end
          end)
        end,
        gopls = function()
          -- workaround for gopls not supporting semanticTokensProvider
          -- https://github.com/golang/go/issues/54531#issuecomment-1464982242
          Util.lsp.on_attach(function(client, _)
            if client.name == "gopls" then
              if not client.server_capabilities.semanticTokensProvider then
                local semantic = client.config.capabilities.textDocument.semanticTokens
                client.server_capabilities.semanticTokensProvider = {
                  full = true,
                  legend = {
                    tokenTypes = semantic.tokenTypes,
                    tokenModifiers = semantic.tokenModifiers,
                  },
                  range = true,
                }
              end
            end
          end)
        end,
        tailwindcss = function(_, opts)
          local tw = require "lspconfig.server_configurations.tailwindcss"
          opts.filetypes = opts.filetypes or {}

          -- Add default filetypes
          vim.list_extend(opts.filetypes, tw.default_config.filetypes)

          -- Remove excluded filetypes
          --- @param ft string
          opts.filetypev = vim.tbl_filter(function(ft)
            return not vim.tbl_contains(opts.filetypes_exclude or {}, ft)
          end, opts.filetypes)

          -- Add additional filetypes
          vim.list_extend(opts.filetypes, opts.filetypes_include or {})
        end,
      },
    },
    config = function(_, opts)
      if Util.has "neoconf.nvim" then
        local plugin = require("lazy.core.config").spec.plugins["neoconf.nvim"]
        require("neoconf").setup(require("lazy.core.plugin").values(plugin, "opts", false))
      end

      Util.format.register(Util.lsp.formatter())

      -- deprecated options
      if opts.autoformat ~= nil then
        vim.g.autoformat = opts.autoformat
        Util.error("nvim-lspconfig.opts.autoformat", "vim.g.autoformat")
      end

      -- local function has_capability(capability, filter)
      --   for _, client in ipairs(vim.lsp.get_active_clients(filter)) do
      --     if client.supports_method(capability) then
      --       return true
      --     end
      --   end
      --   return false
      -- end

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
      Util.lsp.on_attach(function(client, bufnr)
        require("r.keymaps.lsp").on_attach(client, bufnr)

        -- if client.server_capabilities[provider.CODELENS] then
        --   Util.cmd.augroup("LspCodelensRefresh", {
        --     event = { "BufEnter", "InsertLeave", "BufWritePost" },
        --     desc = "LSP: Code Lens",
        --     buffer = bufnr,
        --     command = function()
        --       if not has_capability("textDocument/codeLens", { bufnr = bufnr }) then
        --         Util.cmd.del_buffer_autocmd("LspCodelensRefresh", bufnr)
        --         return
        --       end
        --       if vim.g.codelens_enabled then
        --         vim.lsp.codelens.refresh()
        --       end
        --     end,
        --   })
        -- end

        if client.server_capabilities[provider.REFERENCES] then
          Util.cmd.augroup(("LspReferences%d"):format(bufnr), {
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
            Util.toggle.inlay_hints(bufnr, true)
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
        require("r.keymaps.lsp").on_attach(client, buffer)
        return ret
      end

      -- Uncomment this if you are not using 'noice.nvim'
      -- vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
      --   border = border,
      -- })

      -- Diagnostics
      -- for name, icon in pairs(icons.diagnostics) do
      --   name = "DiagnosticSign" .. name
      --   vim.fn.sign_define(name, { text = icon, texthl = name, numhl = name })
      -- end

      -- if type(opts.diagnostics.virtual_text) == "table" and opts.diagnostics.virtual_text.prefix == "icons" then
      --   opts.diagnostics.virtual_text.prefix = vim.fn.has "nvim-0.10.0" == 0 and "●"
      --     or function(diagnostic)
      --       for d, icon in pairs(icons.diagnostics) do
      --         if diagnostic.severity == vim.diagnostic.severity[d:upper()] then
      --           return icon
      --         end
      --       end
      --     end
      -- end

      vim.diagnostic.config(vim.deepcopy(opts.diagnostics))

      local servers = opts.servers
      local has_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
      local capabilities = vim.tbl_deep_extend(
        "keep",
        {},
        vim.lsp.protocol.make_client_capabilities(),
        has_cmp and cmp_nvim_lsp.default_capabilities() or {},
        {
          -- See: https://github.com/neovim/neovim/issues/23291
          -- ram eater!!! check berkala pada issue ini
          workspace = {
            didChangeWatchedFiles = {
              dynamicRegistration = true,
            },
          },
          textDocument = {
            foldingRange = {
              dynamicRegistration = false,
              lineFoldingOnly = true,
            },
          },
        },
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

      if Util.lsp.get_config "denols" and Util.lsp.get_config "tsserver" then
        local is_deno = require("lspconfig.util").root_pattern("deno.json", "deno.jsonc")
        Util.lsp.lsp_disable("tsserver", is_deno)
        Util.lsp.lsp_disable("denols", function(root_dir)
          return not is_deno(root_dir)
        end)

        ---@diagnostic disable-next-line: unused-local
        -- Util.lsp.on_attach(function(client, bufnr)
        --   if client.name == "tsserver" then
        --     client.server_capabilities.documentFormattingProvider = false
        --     client.server_capabilities.documentRangeFormattingProvider = false
        --   end
        -- end)
      end
    end,
  },
  --  ╭──────────────────────────────────────────────────────────╮
  --  │   CMAKE                                                  │
  --  ╰──────────────────────────────────────────────────────────╯
  -- CMAKE-TOOLS
  {
    "civitasv/cmake-tools.nvim",
    event = "LazyFile",
    opts = {},
  },
  --  ╭──────────────────────────────────────────────────────────╮
  --  │   RUST                                                   │
  --  ╰──────────────────────────────────────────────────────────╯
  -- RUSTACEANVIM
  {
    "mrcjkb/rustaceanvim",
    version = "^3",
    ft = { "rust" },
    opts = {
      -- LSP configuration
      --
      -- REFERENCE:
      -- https://github.com/rust-analyzer/rust-analyzer/blob/master/docs/user/generated_config.adoc
      -- https://rust-analyzer.github.io/manual.html#configuration
      -- https://rust-analyzer.github.io/manual.html#features
      --
      -- NOTE: The configuration format is `rust-analyzer.<section>.<property>`.
      --       <section> should be an object.
      --       <property> should be a primitive.
      server = {
        on_attach = function(client, bufnr)
          -- require("illuminate").on_attach(client)
          require("r.keymaps.lsp").on_attach(client, bufnr)

          local bufopts = {
            noremap = true,
            silent = true,
            buffer = bufnr,
          }
          vim.keymap.set("n", "<leader><leader>rr", "<Cmd>RustLsp runnables<CR>", bufopts)
          vim.keymap.set("n", "K", "<Cmd>RustLsp hover actions<CR>", bufopts)
        end,
        settings = {
          -- rust-analyzer language server configuration
          ["rust-analyzer"] = {
            assist = {
              importEnforceGranularity = true,
              importPrefix = "create",
            },
            cargo = {
              allFeatures = true,
              loadOutDirsFromCheck = true,
              runBuildScripts = true,
            },
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
            inlayHints = {
              lifetimeElisionHints = {
                enable = true,
                useParameterNames = true,
              },
            },
          },
        },
      },
    },
    config = function(_, opts)
      vim.g.rustaceanvim = vim.tbl_deep_extend("force", {}, opts or {})
    end,
  },
  --  ╭──────────────────────────────────────────────────────────╮
  --  │   TYPESCRIPT                                             │
  --  ╰──────────────────────────────────────────────────────────╯
  -- TYPESCRIPT-TOOLS
  {
    "pmizio/typescript-tools.nvim",
    -- enabled = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "neovim/nvim-lspconfig",
    },
    ft = {
      "typescript",
      "typescriptreact",
      "javascript",
      "javascriptreact",
    },
    opts = {
      settings = {
        -- spawn additional tsserver instance to calculate diagnostics on it
        separate_diagnostic_server = true,
        -- "change"|"insert_leave" determine when the client asks the server about diagnostic
        publish_diagnostic_on = "insert_leave",
        -- string|nil -specify a custom path to `tsserver.js` file, if this is nil or file under path
        -- not exists then standard path resolution strategy is applied
        tsserver_path = nil,
        -- specify a list of plugins to load by tsserver, e.g., for support `styled-components`
        -- (see 💅 `styled-components` support section)
        tsserver_plugins = {},
        -- this value is passed to: https://nodejs.org/api/cli.html#--max-old-space-sizesize-in-megabytes
        -- memory limit in megabytes or "auto"(basically no limit)
        tsserver_max_memory = "auto",
        -- described below
        tsserver_format_options = {},
        tsserver_file_preferences = {},
      },
      tsserver_max_memory = 8096, -- 4096 | "auto"
      -- tsserver_max_memory = 4096, -- 4096 | "auto"
      -- code_lens = "off",
      separate_diagnostic_server = true,
      publish_diagnostic_on = "insert_leave",
      expose_as_code_action = { "organize_imports", "remove_unused" },
      tsserver_file_preferences = {
        -- Inlay Hints
        -- includeInlayParameterNameHints = "all",
        -- includeInlayParameterNameHintsWhenArgumentMatchesName = true,
        -- includeInlayFunctionParameterTypeHints = true,
        -- includeInlayVariableTypeHints = true,
        -- includeInlayVariableTypeHintsWhenTypeMatchesName = true,
        -- includeInlayPropertyDeclarationTypeHints = true,
        -- includeInlayFunctionLikeReturnTypeHints = true,
        -- includeInlayEnumMemberValueHints = true,

        includeInlayParameterNameHints = "literal",
        includeInlayParameterNameHintsWhenArgumentMatchesName = false,
        includeInlayVariableTypeHintsWhenTypeMatchesName = false,
        includeInlayFunctionParameterTypeHints = true,
        includeInlayVariableTypeHints = true,
        includeInlayFunctionLikeReturnTypeHints = false,
        includeInlayPropertyDeclarationTypeHints = true,
        includeInlayEnumMemberValueHints = true,
      },
      root_dir = function(fname)
        local util = require "lspconfig.util"
        -- Disable tsserver on js files when a flow project is detected
        if not string.match(fname, ".tsx?$") and util.root_pattern ".flowconfig"(fname) then
          return nil
        end
        local ts_root = util.root_pattern "tsconfig.json"(fname)
          or util.root_pattern("package.json", "jsconfig.json", ".git")(fname)
        if ts_root then
          return ts_root
        end
        if vim.g.started_by_firenvim then
          return util.path.dirname(fname)
        end
        return nil
      end,
    },
    config = function(_, opts)
      Util.lsp.on_attach(function(client, bufnr)
        require("twoslash-queries").attach(client, bufnr)
      end)
      require("typescript-tools").setup(opts)
      vim.api.nvim_exec_autocmds("FileType", {})
    end,
  },
  -- BETTER-TS-ERRORS
  {
    "oleggulevskyy/better-ts-errors.nvim",
    dependencies = { "MunifTanjim/nui.nvim" },
    keys = { "dg" },
    opts = {
      keymaps = {
        toggle = "dg", -- default '<leader>dd'
        -- go_to_definition = "dG", -- go to problematic type from popup window
        --   go_to_definition = "<leader>dx",
      },
    },
  },
  -- TWOSLASH-QUERIESN
  {
    -- use like //        ^?
    "marilari88/twoslash-queries.nvim",
    ft = {
      "typescript",
      "typescriptreact",
      "javascript",
      "javascriptreact",
    },
    opts = {
      highlight = "Type",
      multi_line = true,
    },
  },
  -- TSC.NVIM
  {
    -- Type checking typescript
    "dmmulroy/tsc.nvim",
    cmd = { "TSC" },
    ft = {
      "typescript",
      "typescriptreact",
      "javascript",
      "javascriptreact",
    },
    config = function()
      require("tsc").setup()
      vim.api.nvim_exec_autocmds("FileType", {})
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
  --  ╭──────────────────────────────────────────────────────────╮
  --  │   GOLANG                                                 │
  --  ╰──────────────────────────────────────────────────────────╯
  -- GOPHER
  {
    "olexsmir/gopher.nvim",
    ft = "go",
    dependencies = { "nvim-lua/plenary.nvim", "nvim-treesitter/nvim-treesitter" },
  },
  --  ╭──────────────────────────────────────────────────────────╮
  --  │   MARKDOWN                                               │
  --  ╰──────────────────────────────────────────────────────────╯
  -- MARKDOWN-PREVIEW
  {
    "iamcco/markdown-preview.nvim",
    ft = { "markdown", "md" },
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    build = function()
      vim.fn["mkdp#util#install"]()
    end,
  },
  --  ╭──────────────────────────────────────────────────────────╮
  --  │   MISC                                                   │
  --  ╰──────────────────────────────────────────────────────────╯
  -- RASI
  {
    "Fymyte/rasi.vim",
    ft = "rasi",
  },
  -- LOG SYNTAX
  {
    "mtdl9/vim-log-highlighting",
    ft = "log",
  },
  -- TASKWARRIOR SYNTAX
  {
    "framallo/taskwarrior.vim",
    ft = "taskrc",
  },
}
