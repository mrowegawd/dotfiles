local max_width = math.min(math.floor(vim.o.columns * 0.7), 100)
local max_height = math.min(math.floor(vim.o.lines * 0.3), 30)

local Highlight = require "r.settings.highlights"

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
        "gomodifytags", -- linter
        "impl", -- linter

        "delve", -- for debug

        "goimports",
        "gofumpt",
        "golangci-lint",

        -- bash,sh
        "shellcheck",
        "shfmt",

        -- python
        "black",
        -- "ruff", -- (use ruff insted of 'black' because its is rust, rust is fast!)
        "debugpy",

        -- rust
        "codelldb",

        -- cmake
        "cmakelang",
        "cmakelint",

        -- kotlin
        "ktlint",
        "kotlin-debug-adapter",

        -- markdown
        "markdownlint",
        "marksman",
        "codespell",
        "cbfmt",

        -- docker
        "hadolint",

        -- ansible
        "ansible-language-server",
        "ansible-lint",
      },
      ui = { border = RUtils.config.icons.border.line, height = 0.8 },
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
      -- {
      --   "folke/neoconf.nvim",
      --   cmd = "Neoconf",
      --   dependencies = { "nvim-lspconfig" },
      --   opts = {
      --     library = { plugins = { "neotest", "nvim-dap-ui" }, types = true },
      --   },
      -- },
      {
        "folke/neodev.nvim",
        ft = "lua",
        opts = { library = { plugins = { "nvim-dap-ui" } } },
      },
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      {
        "b0o/SchemaStore.nvim",
        version = false, -- last release is way too old
      },
      {
        -- TODO: check dan pakai plugin ini, kalau sudah di update error nya
        -- check langsung repo github nya
        "ray-x/lsp_signature.nvim",
        enabled = false,
        config = function()
          Highlight.plugin("lspSignatureUIcol", {
            { LspSignatureActiveParameter = { bg = "NONE", fg = "#ED9455" } },
          })

          require("lsp_signature").setup {
            hint_enable = false,
            hint_prefix = "● ",
            max_width = 80,
            max_height = 12,
            handler_opts = {
              border = "single",
            },
            timer_interval = 200,
          }
        end,
      },
    },
    opts = function()
      return {
        -- options for vim.diagnostic.config()
        ---@type vim.diagnostic.Opts
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
              [vim.diagnostic.severity.ERROR] = RUtils.config.icons.diagnostics.Error,
              [vim.diagnostic.severity.WARN] = RUtils.config.icons.diagnostics.Warn,
              [vim.diagnostic.severity.HINT] = RUtils.config.icons.diagnostics.Hint,
              [vim.diagnostic.severity.INFO] = RUtils.config.icons.diagnostics.Info,
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
            -- border = RUtils.config.icons.border.line,
            header = "",
            prefix = function(diag)
              local level = vim.diagnostic.severity[diag.severity]
              local prefix = string.format(
                " %s ",
                RUtils.config.icons.diagnostics[string.gsub(level:lower(), [[(%a)([%w_']*)]], function(first, rest)
                  return first:upper() .. rest:lower()
                end)]
              )
              return prefix, "DiagnosticFloating" .. level:gsub("^%l", string.upper)
            end,
          },
        },
        inlay_hints = { enabled = true },
        codelens = { enabled = false },
        document_highlight = {
          enabled = true,
        },
        capabilities = {},
        format = { formatting_options = nil, timeout_ms = nil },
        -- LSP Server Settings
        ---@type lspconfig.options
        servers = {
          kotlin_language_server = {},
          zls = {},
          tsserver = {
            enabled = false,
          },
          vtsls = {
            settings = {
              complete_function_calls = true,
              vtsls = {
                enableMoveToFileCodeAction = true,
              },
              typescript = {
                updateImportsOnFileMove = { enabled = "always" },
                experimental = {
                  completion = {
                    enableServerSideFuzzyMatch = true,
                  },
                },
                suggest = {
                  completeFunctionCalls = true,
                },
                inlayHints = {
                  enumMemberValues = { enabled = true },
                  functionLikeReturnTypes = { enabled = true },
                  parameterNames = { enabled = "literals" },
                  parameterTypes = { enabled = true },
                  propertyDeclarationTypes = { enabled = true },
                  variableTypes = { enabled = false },
                },
              },
            },
            keys = {
              {
                "gd",
                function()
                  require("vtsls").commands.goto_source_definition(0)
                end,
                desc = "LSP: goto source definition",
              },
              {
                "<leader>co",
                function()
                  require("vtsls").commands.organize_imports(0)
                end,
                desc = "LSP: organize imports",
              },
              {
                "<leader>cM",
                function()
                  require("vtsls").commands.add_missing_imports(0)
                end,
                desc = "LSP: add missing imports",
              },
              {
                "<leader>cD",
                function()
                  require("vtsls").commands.fix_all(0)
                end,
                desc = "LSP: fix all diagnostics",
              },
            },
          },
          dockerls = {},
          docker_compose_language_service = {},
          html = {},
          cssls = {
            settings = {
              css = { lint = { unknownAtRules = "ignore" } },
              scss = { lint = { unknownAtRules = "ignore" } },
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
                desc = "LSP: show crate documentation [taplo]",
              },
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
          pyright = {
            settings = {
              -- pyright = { disableLanguageServices = true },
              python = {
                analysis = {
                  autoSearchPaths = true,
                  typeCheckingMode = "strict",
                  -- diagnosticMode = "workspace",
                  diagnosticMode = "openFilesOnly",
                  useLibraryCodeForTypes = true,
                },
              },
            },
          },
          ruff_lsp = {
            keys = {
              {
                "<Leader>co",
                function()
                  vim.lsp.buf.code_action {
                    apply = true,
                    context = {
                      only = { "source.organizeImports" },
                      diagnostics = {},
                    },
                  }
                end,
                desc = "LSP: organize Imports [rustlsp]",
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
            -- filetypes = { "html", "mdx", "javascript", "javascriptreact", "typescriptreact", "vue", "svelte" },
            -- -- https://github.com/neovim/neovim/issues/19118#issuecomment-1221522853
            -- -- Atm LSP ini berat dengan cmp (check pengaturan cmp /code.lua),
            -- -- tapi LSP ini tidak begitu dengan coq dan coc
            -- filetypes_exclude = { "markdown" },
            filetypes_exclude = { "markdown" },
            filetypes_include = {},
            -- root_dir = function(...)
            --   return require("lspconfig.util").root_pattern ".git"(...)
            -- end,
          },
          lua_ls = {
            settings = {
              Lua = {
                runtime = { version = "LuaJIT" },
                codeLens = { enable = true },
                workspace = { checkThirdParty = false },
                doc = { privateName = { "^_" } },
                hint = {
                  enable = true,
                  -- setType = false,
                  -- paramType = true,
                  -- paramName = "Disable",
                  -- semicolon = "Disable",
                  arrayIndex = "Disable",
                },
                completion = { callSnippet = "Replace" },
                telemetry = { enable = false },
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
          yamlls = function()
            -- Neovim < 0.10 does not have dynamic registration for formatting
            if vim.fn.has "nvim-0.10" == 0 then
              RUtils.lsp.on_attach(function(client, _)
                if client.name == "yamlls" then
                  client.server_capabilities.documentFormattingProvider = true
                end
              end)
            end
          end,
          ruff_lsp = function()
            RUtils.lsp.on_attach(function(client, _)
              if client.name == "ruff_lsp" then
                -- Disable hover in favor of Pyright
                client.server_capabilities.hoverProvider = false
              end
            end)
          end,
          gopls = function()
            -- workaround for gopls not supporting semanticTokensProvider
            -- https://github.com/golang/go/issues/54531#issuecomment-1464982242
            RUtils.lsp.on_attach(function(client, _)
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
          tsserver = function()
            -- disable tsserver
            return true
          end,
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
        },
      }
    end,
    config = function(_, opts)
      opts.servers.vtsls.settings.javascript = vim.deepcopy(opts.servers.vtsls.settings.typescript)

      if RUtils.has "neoconf.nvim" then
        require("neoconf").setup(RUtils.opts "neoconf.nvim")
      end

      RUtils.format.register(RUtils.lsp.formatter())

      RUtils.lsp.setup()
      RUtils.lsp.on_dynamic_capability(require("r.keymaps.lsp").on_attach)

      RUtils.lsp.words.setup(opts.document_highlight)

      -- Setup formatting and keymaps
      RUtils.lsp.on_attach(function(client, bufnr)
        require("r.keymaps.lsp").on_attach(client, bufnr)
      end)

      if vim.fn.has "nvim-0.10" == 1 then
        -- inlay hints
        if not RUtils.has "symbol-usage.nvim" then
          if opts.inlay_hints.enabled then
            RUtils.lsp.on_supports_method("textDocument/inlayHint", function(client, buffer)
              if vim.api.nvim_buf_is_valid(buffer) and vim.bo[buffer].buftype == "" then
                RUtils.toggle.inlay_hints(buffer, true)
              end
            end)
          end
        end

        -- code lens
        if opts.codelens.enabled and vim.lsp.codelens then
          RUtils.lsp.on_supports_method("textDocument/codeLens", function(client, buffer)
            vim.lsp.codelens.refresh()
            vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
              buffer = buffer,
              callback = vim.lsp.codelens.refresh,
            })
          end)
        end
      end

      if vim.fn.has "nvim-0.10.0" == 0 then
        for severity, icon in pairs(opts.diagnostics.signs.text) do
          local name = vim.diagnostic.severity[severity]:lower():gsub("^%l", string.upper)
          name = "DiagnosticSign" .. name
          vim.fn.sign_define(name, { text = icon, texthl = name, numhl = "" })
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
          elseif server_opts.enabled ~= false then
            ensure_installed[#ensure_installed + 1] = server
          end
        end
      end

      if have_mason then
        mlsp.setup {
          ensure_installed = vim.tbl_deep_extend(
            "force",
            ensure_installed,
            RUtils.opts("mason-lspconfig.nvim").ensure_installed or {}
          ),
          handlers = { setup },
        }
      end

      if RUtils.lsp.is_enabled "denols" and RUtils.lsp.is_enabled "vtsls" then
        local is_deno = require("lspconfig.util").root_pattern("deno.json", "deno.jsonc")
        RUtils.lsp.disable("vtsls", is_deno)
        RUtils.lsp.disable("denols", function(root_dir)
          return not is_deno(root_dir)
        end)
      end
    end,
  },
  --  ╭──────────────────────────────────────────────────────────╮
  --  │   CMAKE                                                  │
  --  ╰──────────────────────────────────────────────────────────╯
  -- CMAKE-TOOLS (closed)
  -- {
  --   "civitasv/cmake-tools.nvim",
  --   event = "LazyFile",
  --   opts = {},
  -- },
  --  ╭──────────────────────────────────────────────────────────╮
  --  │   RUST                                                   │
  --  ╰──────────────────────────────────────────────────────────╯
  -- RUSTACEANVIM
  {
    -- install rust-analyzer: `rustup component add rust-analyzer` (dont need from Mason)
    "mrcjkb/rustaceanvim",
    version = "^4", -- Recommended
    ft = { "rust" },
    dependencies = {
      "neovim/nvim-lspconfig",
      {
        "nvim-neotest/neotest",
        optional = true,
        opts = function(_, opts)
          opts.adapters = opts.adapters or {}
          vim.list_extend(opts.adapters, {
            require "rustaceanvim.neotest",
          })
        end,
      },
    },
    opts = {
      server = {
        on_attach = function(_, bufnr)
          vim.keymap.set("n", "<leader>cR", function()
            vim.cmd.RustLsp "codeAction"
          end, { desc = "LSP: code action [rustaceanvim]", buffer = bufnr })
          vim.keymap.set("n", "<leader>dd", function()
            vim.cmd.RustLsp "debuggables"
          end, { desc = "Debug: rust debuggables [rustaceanvim]", buffer = bufnr })
        end,
        default_settings = {
          -- rust-analyzer language server configuration
          ["rust-analyzer"] = {
            rustfmt = {
              extraArgs = { "+nightly", "--unstable-features" },
            },
            cargo = {
              allFeatures = true,
              loadOutDirsFromCheck = true,
              buildScripts = {
                enable = true,
              },
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
  --  ╭──────────────────────────────────────────────────────────╮
  --  │   TYPESCRIPT                                             │
  --  ╰──────────────────────────────────────────────────────────╯
  -- NVIM-VTSLS
  {
    "yioneko/nvim-vtsls",
    lazy = true,
    opts = {},
    dependencies = {
      "nvim-lua/plenary.nvim",
      "neovim/nvim-lspconfig",
      -- BETTER-TS-ERRORS
      {
        "dmmulroy/ts-error-translator.nvim",
        config = true,
      },
      -- TSC.NVIM
      {
        "dmmulroy/tsc.nvim",
        cmd = { "TSC" },
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
                up_to_date = RUtils.config.icons.misc.check, -- Icon for up to date packages
                outdated = RUtils.config.icons.git.remove, -- Icon for outdated packages
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
    },
    ft = {
      "typescript",
      "typescriptreact",
      "javascript",
      "javascriptreact",
    },
    config = function(_, opts)
      -- add vtsls to lspconfig
      require("lspconfig.configs").vtsls = require("vtsls").lspconfig
      require("vtsls").config(opts)
    end,
  },
  --  ╭──────────────────────────────────────────────────────────╮
  --  │   GOLANG                                                 │
  --  ╰──────────────────────────────────────────────────────────╯
  -- GOPHER
  {
    "olexsmir/gopher.nvim",
    ft = "go",
    build = ":GoInstallDeps",
    dependencies = { "nvim-lua/plenary.nvim", "nvim-treesitter/nvim-treesitter" },
  },
  --  ╭──────────────────────────────────────────────────────────╮
  --  │   MARKDOWN                                               │
  --  ╰──────────────────────────────────────────────────────────╯
  -- MARKDOWN-PREVIEW
  {
    "iamcco/markdown-preview.nvim",
    ft = "markdown",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    build = function()
      vim.fn["mkdp#util#install"]()
    end,
  },

  --  ╭──────────────────────────────────────────────────────────╮
  --  │   PYTHON                                                 │
  --  ╰──────────────────────────────────────────────────────────╯
  {
    "wookayin/semshi", -- use a maintained fork
    ft = "python",
    build = ":UpdateRemotePlugins",
    init = function()
      -- Disabled these features better provided by LSP or other more general plugins
      vim.g["semshi#error_sign"] = false
      vim.g["semshi#simplify_markup"] = false
      vim.g["semshi#mark_selected_nodes"] = false
      vim.g["semshi#update_delay_factor"] = 0.001

      -- This autocmd must be defined in init to take effect
      vim.api.nvim_create_autocmd({ "VimEnter", "ColorScheme" }, {
        group = vim.api.nvim_create_augroup("SemanticHighlight", {}),
        callback = function()
          -- Only add style, inherit or link to the LSP's colors
          vim.cmd [[
            " highlight! link semshiGlobal  @none
            " highlight! link semshiImported @none
            highlight! link semshiParameter @lsp.type.parameter
            highlight! link semshiBuiltin @function.builtin
            highlight! link semshiAttribute @field
            highlight! link semshiSelf @lsp.type.selfKeyword
            " highlight! link semshiUnresolved @none
            " highlight! link semshiFree @none
            " highlight! link semshiAttribute @none
            highlight! link semshiParameterUnused @none
            ]]
        end,
      })
    end,
  },
  {
    "linux-cultist/venv-selector.nvim",
    cmd = "VenvSelect",
    keys = { { "<Leader>cv", "<cmd>:VenvSelect<cr>", desc = "Misc: select virtualenv [venv-selector]", ft = "python" } },
    opts = function(_, opts)
      if RUtils.has "nvim-dap-python" then
        opts.dap_enabled = true
      end
      return vim.tbl_deep_extend("force", opts, {
        name = {
          "venv",
          ".venv",
          "env",
          ".env",
        },
      })
    end,
  },
  --  ╭──────────────────────────────────────────────────────────╮
  --  │   MISC                                                   │
  --  ╰──────────────────────────────────────────────────────────╯
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
