local max_width = math.min(math.floor(vim.o.columns * 0.7), 100)
local max_height = math.min(math.floor(vim.o.lines * 0.3), 30)

return {
  -- COC
  {
    "neoclide/coc.nvim",
    branch = "master",
    build = "npm ci",
    lazy = false,

    config = function()
      vim.opt.backup = false
      vim.opt.writebackup = false
      vim.opt.updatetime = 300
      vim.opt.signcolumn = "yes"

      local keyset = vim.keymap.set
      -- Autocomplete
      function _G.check_back_space()
        local col = vim.fn.col "." - 1
        return col == 0 or vim.fn.getline("."):sub(col, col):match "%s" ~= nil
      end

      vim.g.coc_global_extensions = {
        "coc-json",
        "@yaegassy/coc-tailwindcss3",
        "coc-stylua",
        "coc-lua",
        "coc-css",
        "coc-prettier",
        "coc-highlight",
        "coc-rust-analyzer",
        "coc-go",
        "coc-html",
      }

      -- Use Tab for trigger completion with characters ahead and navigate
      -- NOTE: There's always a completion item selected by default, you may want to enable
      -- no select by setting `"suggest.noselect": true` in your configuration file
      -- NOTE: Use command ':verbose imap <tab>' to make sure Tab is not mapped by
      -- other plugins before putting this into your config
      local opts = { silent = true, noremap = true, expr = true, replace_keycodes = false }
      keyset(
        "i",
        "<c-n>",
        'coc#pum#visible() ? coc#pum#next(1) : v:lua.check_back_space() ? "<c-n>" : coc#refresh()',
        opts
      )
      keyset("i", "<c-p>", [[coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"]], opts)

      -- Make <CR> to accept selected completion item or notify coc.nvim to format
      -- <C-g>u breaks current undo, please make your own choice
      keyset("i", "<cr>", [[coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"]], opts)

      -- Use <c-j> to trigger snippets
      keyset("i", "<tab>", "<Plug>(coc-snippets-expand-jump)")

      -- Use <c-space> to trigger completion
      keyset("i", "<c-y>", "coc#refresh()", { silent = true, expr = true })

      -- Use `[g` and `]g` to navigate diagnostics
      -- Use `:CocDiagnostics` to get all diagnostics of current buffer in location list
      keyset("n", "dp", "<Plug>(coc-diagnostic-prev)", { silent = true })
      keyset("n", "dn", "<Plug>(coc-diagnostic-next)", { silent = true })

      -- GoTo code navigation
      keyset("n", "gd", "<Plug>(coc-definition)", { silent = true })
      -- keyset("n", "gy", "<Plug>(coc-type-definition)", { silent = true })
      -- keyset("n", "gi", "<Plug>(coc-implementation)", { silent = true })
      keyset("n", "gr", "<Plug>(coc-references)", { silent = true })

      -- Use K to show documentation in preview window
      function _G.show_docs()
        local cw = vim.fn.expand "<cword>"
        if vim.fn.index({ "vim", "help" }, vim.bo.filetype) >= 0 then
          vim.api.nvim_command("h " .. cw)
        elseif vim.api.nvim_eval "coc#rpc#ready()" then
          vim.fn.CocActionAsync "doHover"
        else
          vim.api.nvim_command("!" .. vim.o.keywordprg .. " " .. cw)
        end
      end

      keyset("n", "K", "<CMD>lua _G.show_docs()<CR>", { silent = true })
      -- keyset("n", "K", "<CMD>Lspsaga hover_doc<CR>", { silent = true })

      -- Highlight the symbol and its references on a CursorHold event(cursor is idle)
      vim.api.nvim_create_augroup("CocGroup", {})
      vim.api.nvim_create_autocmd("CursorHold", {
        group = "CocGroup",
        command = "silent call CocActionAsync('highlight')",
        desc = "Highlight symbol under cursor on CursorHold",
      })

      -- Symbol renaming
      keyset("n", "<leader>rn", "<Plug>(coc-rename)", { silent = true })

      -- Formatting selected code
      keyset("x", "<leader>f", "<Plug>(coc-format-selected)", { silent = true })
      keyset("n", "<leader>f", "<Plug>(coc-format-selected)", { silent = true })

      -- Setup formatexpr specified filetype(s)
      vim.api.nvim_create_autocmd("FileType", {
        group = "CocGroup",
        pattern = "typescript,json",
        command = "setl formatexpr=CocAction('formatSelected')",
        desc = "Setup formatexpr specified filetype(s).",
      })

      -- Update signature help on jump placeholder
      vim.api.nvim_create_autocmd("User", {
        group = "CocGroup",
        pattern = "CocJumpPlaceholder",
        command = "call CocActionAsync('showSignatureHelp')",
        desc = "Update signature help on jump placeholder",
      })

      -- Apply codeAction to the selected region
      -- Example: `<leader>aap` for current paragraph
      opts = { silent = true, nowait = true }
      keyset("x", "<leader>a", "<Plug>(coc-codeaction-selected)", opts)
      keyset("n", "<leader>a", "<Plug>(coc-codeaction-selected)", opts)

      -- Remap keys for apply code actions at the cursor position.
      keyset("n", "<leader>ca", "<Plug>(coc-codeaction-cursor)", opts)
      -- Remap keys for apply code actions affect whole buffer.
      keyset("n", "<leader>cs", "<Plug>(coc-codeaction-source)", opts)
      -- Remap keys for applying codeActions to the current buffer
      keyset("n", "<leader>cA", "<Plug>(coc-codeaction)", opts)
      -- Apply the most preferred quickfix action on the current line.
      keyset("n", "<leader>cf", "<Plug>(coc-fix-current)", opts)

      keyset("n", "df", "<CMD>CocList diagnostics<CR>", opts)

      -- Remap keys for apply refactor code actions.
      keyset("n", "<leader>re", "<Plug>(coc-codeaction-refactor)", { silent = true })
      keyset("x", "<leader>r", "<Plug>(coc-codeaction-refactor-selected)", { silent = true })
      keyset("n", "<leader>r", "<Plug>(coc-codeaction-refactor-selected)", { silent = true })

      -- Run the Code Lens actions on the current line
      keyset("n", "<leader>cl", "<Plug>(coc-codelens-action)", opts)

      -- Map function and class text objects
      -- NOTE: Requires 'textDocument.documentSymbol' support from the language server
      keyset("x", "if", "<Plug>(coc-funcobj-i)", opts)
      keyset("o", "if", "<Plug>(coc-funcobj-i)", opts)
      keyset("x", "af", "<Plug>(coc-funcobj-a)", opts)
      keyset("o", "af", "<Plug>(coc-funcobj-a)", opts)
      keyset("x", "ic", "<Plug>(coc-classobj-i)", opts)
      keyset("o", "ic", "<Plug>(coc-classobj-i)", opts)
      keyset("x", "ac", "<Plug>(coc-classobj-a)", opts)
      keyset("o", "ac", "<Plug>(coc-classobj-a)", opts)

      -- Remap <C-f> and <C-b> to scroll float windows/popups
      ---@diagnostic disable-next-line: redefined-local
      local opts = { silent = true, nowait = true, expr = true }
      keyset("n", "<C-f>", 'coc#float#has_scroll() ? coc#float#scroll(1) : "<C-f>"', opts)
      keyset("n", "<C-b>", 'coc#float#has_scroll() ? coc#float#scroll(0) : "<C-b>"', opts)
      keyset("i", "<C-f>", 'coc#float#has_scroll() ? "<c-r>=coc#float#scroll(1)<cr>" : "<Right>"', opts)
      keyset("i", "<C-b>", 'coc#float#has_scroll() ? "<c-r>=coc#float#scroll(0)<cr>" : "<Left>"', opts)
      keyset("v", "<C-f>", 'coc#float#has_scroll() ? coc#float#scroll(1) : "<C-f>"', opts)
      keyset("v", "<C-b>", 'coc#float#has_scroll() ? coc#float#scroll(0) : "<C-b>"', opts)

      -- Use CTRL-S for selections ranges
      -- Requires 'textDocument/selectionRange' support of language server
      keyset("n", "<C-s>", "<Plug>(coc-range-select)", { silent = true })
      keyset("x", "<C-s>", "<Plug>(coc-range-select)", { silent = true })

      -- Add `:Format` command to format current buffer
      vim.api.nvim_create_user_command("Format", "call CocAction('format')", {})

      -- " Add `:Fold` command to fold current buffer
      vim.api.nvim_create_user_command("Fold", "call CocAction('fold', <f-args>)", { nargs = "?" })

      -- Add `:OR` command for organize imports of the current buffer
      vim.api.nvim_create_user_command("OR", "call CocActionAsync('runCommand', 'editor.action.organizeImport')", {})

      -- Add (Neo)Vim's native statusline support
      -- NOTE: Please see `:h coc-status` for integrations with external plugins that
      -- provide custom statusline: lightline.vim, vim-airline

      -- Mappings for CoCList
      -- code actions and coc stuff
      ---@diagnostic disable-next-line: redefined-local
      -- local opts = {silent = true, nowait = true}
      -- -- Show all diagnostics
      -- keyset("n", "<space>a", ":<C-u>CocList diagnostics<cr>", opts)
      -- -- Manage extensions
      -- keyset("n", "<space>e", ":<C-u>CocList extensions<cr>", opts)
      -- -- Show commands
      -- keyset("n", "<space>c", ":<C-u>CocList commands<cr>", opts)
      -- -- Find symbol of current document
      -- keyset("n", "<space>o", ":<C-u>CocList outline<cr>", opts)
      -- -- Search workspace symbols
      -- keyset("n", "<space>s", ":<C-u>CocList -I symbols<cr>", opts)
      -- -- Do default action for next item
      -- keyset("n", "<space>j", ":<C-u>CocNext<cr>", opts)
      -- -- Do default action for previous item
      -- keyset("n", "<space>k", ":<C-u>CocPrev<cr>", opts)
      -- -- Resume latest coc list
      -- keyset("n", "<space>p", ":<C-u>CocListResume<cr>", opts)
    end,
  },
  -- MASON NVIM (disabled)
  {
    "williamboman/mason.nvim",
    enabled = false,
    cmd = "Mason",
    build = ":MasonUpdate",
    opts = {
      ensure_installed = {
        -- lua
        "stylua",

        -- ts,js,react
        -- "prettier",
        -- "prettierd",
        "typescript-language-server",
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
        -- "marksman",

        -- docker
        "hadolint",
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
  -- LSPCONFIG (disabled)
  {
    "neovim/nvim-lspconfig",
    enabled = false,
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
          border = RUtils.config.icons.border.line,
          source = "always",
          header = "",
          prefix = function(diag)
            local level = vim.diagnostic.severity[diag.severity]
            local prefix = string.format(
              "%s ",
              RUtils.config.icons.diagnostics[string.gsub(level:lower(), [[(%a)([%w_']*)]], function(first, rest)
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
        dockerls = {},
        docker_compose_language_service = {},
        rust_analyzer = {},
        -- html = {},
        -- cssls = { -- ini berat yo
        --   settings = {
        --     css = {
        --       lint = {
        --         unknownAtRules = "ignore",
        --       },
        --     },
        --     scss = {
        --       lint = {
        --         unknownAtRules = "ignore",
        --       },
        --     },
        --   },
        -- },
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
        -- eslint = {
        --   settings = {
        --     -- helps eslint find the eslintrc when it's placed in a subfolder instead of the cwd root
        --     -- workingDirectory = { mode = "auto" },
        --     workingDirectories = { mode = "auto" },
        --   },
        -- },
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
          settings = {
            json = {
              format = {
                enable = true,
              },
              validate = { enable = true },
            },
          },
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
          -- exclude a filetype from the default_config
          filetypes_exclude = { "markdown" },
          -- add additional filetypes to the default_config
          filetypes_include = {},
          -- to fully override the default_config, change the below
          -- filetypes = {}
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
      if RUtils.has "neoconf.nvim" then
        local plugin = require("lazy.core.config").spec.plugins["neoconf.nvim"]
        require("neoconf").setup(require("lazy.core.plugin").values(plugin, "opts", false))
      end

      RUtils.format.register(RUtils.lsp.formatter())

      -- deprecated options
      if opts.autoformat ~= nil then
        vim.g.autoformat = opts.autoformat
        RUtils.error("nvim-lspconfig.opts.autoformat", "vim.g.autoformat")
      end

      local function has_capability(capability, filter)
        for _, client in ipairs(vim.lsp.get_clients(filter)) do
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
        return ret
      end

      -- Uncomment this if you are not using 'noice.nvim'
      -- vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
      --   border = border,
      -- })

      -- Diagnostics
      for name, icon in pairs(RUtils.config.icons.diagnostics) do
        name = "DiagnosticSign" .. name
        vim.fn.sign_define(name, { text = icon, texthl = name, numhl = name })
      end

      if type(opts.diagnostics.virtual_text) == "table" and opts.diagnostics.virtual_text.prefix == "icons" then
        opts.diagnostics.virtual_text.prefix = vim.fn.has "nvim-0.10.0" == 0 and "●"
          or function(diagnostic)
            for d, icon in pairs(RUtils.config.icons.diagnostics) do
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

      if RUtils.lsp.get_config "denols" and RUtils.lsp.get_config "tsserver" then
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
}
