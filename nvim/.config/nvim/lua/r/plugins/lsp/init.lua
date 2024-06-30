return {
  -- NVIM-LSPCONFIG
  {
    "neovim/nvim-lspconfig",
    event = "LazyFile",
    dependencies = {
      "mason.nvim",
      { "williamboman/mason-lspconfig.nvim", config = function() end },
    },
    ---@class PluginLspOpts
    opts = function()
      local max_width = math.min(math.floor(vim.o.columns * 0.7), 100)
      local max_height = math.min(math.floor(vim.o.lines * 0.3), 30)

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
        inlay_hints = {
          enabled = false,
          exclude = { "vue" }, -- filetypes for which you don't want to enable inlay hints
        },
        codelens = { enabled = false },
        document_highlight = { enabled = true },
        -- add any global capabilities here
        capabilities = {
          workspace = {
            fileOperations = {
              didRename = true,
              willRename = true,
            },
          },
        },
        format = { formatting_options = nil, timeout_ms = nil },
        -- LSP Server Settings
        ---@type lspconfig.options
        servers = {
          lua_ls = {
            -- mason = false, -- set to false if you don't want this server to be installed with mason
            -- keys = {},
            settings = {
              Lua = {
                workspace = {
                  checkThirdParty = false,
                },
                codeLens = {
                  enable = true,
                },
                completion = {
                  callSnippet = "Replace",
                },
                doc = {
                  privateName = { "^_" },
                },
                hint = {
                  enable = true,
                  setType = false,
                  paramType = true,
                  paramName = "Disable",
                  semicolon = "Disable",
                  arrayIndex = "Disable",
                },
              },
            },
          },
        },
        -- you can do any additional lsp server setup here
        -- return true if you don't want this server to be setup with lspconfig
        ---@type table<string, fun(server:string, opts:_.lspconfig.options):boolean?>
        setup = {
          -- example to setup with typescript.nvim
          -- tsserver = function(_, opts)
          --   require("typescript").setup({ server = opts })
          --   return true
          -- end,
          -- Specify * to use this function as a fallback for any server
          -- ["*"] = function(server, opts) end,
        },
      }
    end,
    ---@param opts PluginLspOpts
    config = function(_, opts)
      RUtils.format.register(RUtils.lsp.formatter())

      -- setup keymaps
      RUtils.lsp.on_attach(function(client, bufnr)
        require("r.keymaps.lsp").on_attach(client, bufnr)
      end)

      RUtils.lsp.setup()
      RUtils.lsp.on_dynamic_capability(require("r.keymaps.lsp").on_attach)

      RUtils.lsp.words.setup(opts.document_highlight)

      if vim.fn.has "nvim-0.10" == 1 then
        -- inlay hints
        if opts.inlay_hints.enabled then
          RUtils.lsp.on_supports_method("textDocument/inlayHint", function(client, buffer)
            if
              vim.api.nvim_buf_is_valid(buffer)
              and vim.bo[buffer].buftype == ""
              and not vim.tbl_contains(opts.inlay_hints.exclude, vim.bo[buffer].filetype)
            then
              RUtils.toggle.inlay_hints(buffer, true)
            end
          end)
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

      if type(opts.diagnostics.virtual_text) == "table" and opts.diagnostics.virtual_text.prefix == "icons" then
        opts.diagnostics.virtual_text.prefix = vim.fn.has "nvim-0.10.0" == 0 and "●"
          or function(diagnostic)
            local icons = require("r.config").icons.diagnostics
            for d, icon in pairs(icons) do
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
        RUtils.lsp.disable("denols", function(root_dir, config)
          if not is_deno(root_dir) then
            config.settings.deno.enable = false
          end
          return false
        end)
      end
    end,
  },
  -- MASON NVIM
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    build = ":MasonUpdate",
    opts_extend = { "ensure_installed" },
    opts = {
      ensure_installed = {
        -- lua
        "stylua",
        "shfmt",
      },
      ui = { border = RUtils.config.icons.border.line, height = 0.8 },
    },
    ---@param opts MasonSettings | {ensure_installed: string[]}
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

      mr.refresh(function()
        for _, tool in ipairs(opts.ensure_installed) do
          local p = mr.get_package(tool)
          if not p:is_installed() then
            p:install()
          end
        end
      end)
    end,
  },
  --  ╭──────────────────────────────────────────────────────────╮
  --  │   MISC                                                   │
  --  ╰──────────────────────────────────────────────────────────╯
  -- LOG SYNTAX
  {
    "fei6409/log-highlight.nvim",
    event = "BufRead *.log",
    opts = {},
  },
  -- TASKWARRIOR SYNTAX
  {
    "framallo/taskwarrior.vim",
    ft = "taskrc",
  },
}
