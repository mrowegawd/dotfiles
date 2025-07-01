return {
  -- NVIM-LSPCONFIG
  {
    "neovim/nvim-lspconfig",
    -- event = "VeryLazy", -- LazyFile
    event = vim.fn.has "nvim-0.11" == 1 and { "BufReadPre", "BufNewFile", "BufWritePre" } or "LazyFile",
    dependencies = {
      "mason.nvim",
      {
        "mason-org/mason-lspconfig.nvim",
        version = vim.fn.has "nvim-0.11" == 0 and "1.32.0" or false,
        config = function() end,
      },
    },
    opts = function()
      ---@class PluginLspOpts
      local ret = {
        -- options for vim.diagnostic.config()
        ---@type vim.diagnostic.Opts
        diagnostics = {
          underline = true,
          update_in_insert = false,
          -- virtual_text = {
          --   spacing = 4,
          --   source = "if_many",
          --   prefix = "■", -- "●"
          -- },
          virtual_text = false,
          severity_sort = true,
          virtual_lines = false,
          signs = {
            text = {
              [vim.diagnostic.severity.ERROR] = RUtils.config.icons.diagnostics.Error,
              [vim.diagnostic.severity.WARN] = RUtils.config.icons.diagnostics.Warn,
              [vim.diagnostic.severity.HINT] = RUtils.config.icons.diagnostics.Hint,
              [vim.diagnostic.severity.INFO] = RUtils.config.icons.diagnostics.Info,

              -- If you want to disable the sign column for diagnostics, uncomment these
              -- [vim.diagnostic.severity.ERROR] = "",
              -- [vim.diagnostic.severity.WARN] = "",
              -- [vim.diagnostic.severity.HINT] = "",
              -- [vim.diagnostic.severity.INFO] = "",
            },
            numhl = {
              [vim.diagnostic.severity.ERROR] = "DiagnosticsErrorNumHl",
              [vim.diagnostic.severity.WARN] = "DiagnosticsWarnNumHl",
              [vim.diagnostic.severity.HINT] = "DiagnosticsHintNumHl",
              [vim.diagnostic.severity.INFO] = "DiagnosticsInfoNumHl",
            },
          },
          float = {
            header = "",
            title = {
              { "  ", "DiagnosticFloatTitleIcon" },
              { "Problems ", "DiagnosticFloatTitle" },
            },
          },
        },
        inlay_hints = {
          enabled = false,
          exclude = { "vue" }, -- filetypes for which you don't want to enable inlay hints
        },
        codelens = {
          enabled = false,
        },
        -- add any global capabilities here
        capabilities = {
          workspace = {
            fileOperations = {
              didRename = true,
              willRename = true,
            },
          },
        },
        format = {
          formatting_options = nil,
          timeout_ms = nil,
        },
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
      return ret
    end,
    ---@param opts PluginLspOpts
    config = function(_, opts)
      -- setup autoformat
      RUtils.format.register(RUtils.lsp.formatter())

      -- disable default keybindings
      for _, bind in ipairs { "grn", "gra", "gri", "grr", "gO" } do
        vim.keymap.del("n", bind)
      end

      vim.keymap.del("s", "<C-s>")

      -- setup keymaps
      RUtils.lsp.on_attach(function(client, bufnr)
        require("r.keymaps.lsp").on_attach(client, bufnr)
      end)

      RUtils.lsp.setup()
      RUtils.lsp.on_dynamic_capability(require("r.keymaps.lsp").on_attach)

      -- diagnostics signs
      if vim.fn.has "nvim-0.10.0" == 0 then
        if type(opts.diagnostics.signs) ~= "boolean" then
          for severity, icon in pairs(opts.diagnostics.signs.text) do
            local name = vim.diagnostic.severity[severity]:lower():gsub("^%l", string.upper)
            name = "DiagnosticSign" .. name
            vim.fn.sign_define(name, { text = icon, texthl = name, numhl = name })
          end
        end
      end

      if vim.fn.has "nvim-0.10" == 1 then
        -- inlay hints
        if opts.inlay_hints.enabled then
          RUtils.lsp.on_supports_method("textDocument/inlayHint", function(client, buffer)
            if
              vim.api.nvim_buf_is_valid(buffer)
              and vim.bo[buffer].buftype == ""
              and not vim.tbl_contains(opts.inlay_hints.exclude, vim.bo[buffer].filetype)
            then
              vim.lsp.inlay_hint.enable(true, { bufnr = buffer })
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
            local icons = RUtils.config.icons.diagnostics
            for d, icon in pairs(icons) do
              if diagnostic.severity == vim.diagnostic.severity[d:upper()] then
                return icon
              end
            end
          end
      end

      --   vim.lsp.handlers["textDocument/signatureHelp"] =
      --     vim.lsp.with(require "noice.lsp.signature_help", { border = "rounded" })
      -- vim.lsp.buf.signature_help{}

      vim.diagnostic.config(vim.deepcopy(opts.diagnostics))

      local servers = opts.servers
      local has_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
      local has_blink, blink = pcall(require, "blink.cmp")
      local capabilities = vim.tbl_deep_extend(
        "force",
        {},
        vim.lsp.protocol.make_client_capabilities(),
        has_cmp and cmp_nvim_lsp.default_capabilities() or {},
        has_blink and blink.get_lsp_capabilities() or {},
        opts.capabilities or {}
      )

      -- local function setup(server)
      --   local server_opts = vim.tbl_deep_extend("force", {
      --     capabilities = vim.deepcopy(capabilities),
      --   }, servers[server] or {})
      --   if server_opts.enabled == false then
      --     return
      --   end
      --
      --   if opts.setup[server] then
      --     if opts.setup[server](server, server_opts) then
      --       return
      --     end
      --   elseif opts.setup["*"] then
      --     if opts.setup["*"](server, server_opts) then
      --       return
      --     end
      --   end
      --   require("lspconfig")[server].setup(server_opts)
      -- end

      -- get all the servers that are available through mason-lspconfig
      local have_mason, mlsp = pcall(require, "mason-lspconfig")
      local all_mslp_servers = {}
      if have_mason and vim.fn.has "nvim-0.11" == 1 then
        all_mslp_servers = vim.tbl_keys(require("mason-lspconfig").get_available_servers())
      elseif have_mason then
        all_mslp_servers = vim.tbl_keys(require("mason-lspconfig.mappings.server").lspconfig_to_package)
      end

      local exclude_automatic_enable = {} ---@type string[]

      local function configure(server)
        local server_opts = vim.tbl_deep_extend("force", {
          capabilities = vim.deepcopy(capabilities),
        }, servers[server] or {})

        if opts.setup[server] then
          if opts.setup[server](server, server_opts) then
            return true
          end
        elseif opts.setup["*"] then
          if opts.setup["*"](server, server_opts) then
            return true
          end
        end
        if vim.fn.has "nvim-0.11" == 1 then
          vim.lsp.config(server, server_opts)
        else
          require("lspconfig")[server].setup(server_opts)
        end

        -- manually enable if mason=false or if this is a server that cannot be installed with mason-lspconfig
        if server_opts.mason == false or not vim.tbl_contains(all_mslp_servers, server) then
          if vim.fn.has "nvim-0.11" == 1 then
            vim.lsp.enable(server)
          else
            configure(server)
          end
          return true
        end
        return false
      end

      local ensure_installed = {} ---@type string[]
      for server, server_opts in pairs(servers) do
        if server_opts then
          server_opts = server_opts == true and {} or server_opts
          if server_opts.enabled ~= false then
            -- run manual setup if mason=false or if this is a server that cannot be installed with mason-lspconfig
            if configure(server) then
              exclude_automatic_enable[#exclude_automatic_enable + 1] = server
            else
              ensure_installed[#ensure_installed + 1] = server
            end
          else
            exclude_automatic_enable[#exclude_automatic_enable + 1] = server
          end
        end
      end

      if have_mason then
        local setup_config = {
          -- mlsp.setup {
          ensure_installed = vim.tbl_deep_extend(
            "force",
            ensure_installed,
            RUtils.opts("mason-lspconfig.nvim").ensure_installed or {}
          ),
          handlers = { setup },
        }

        if vim.fn.has "nvim-0.11" == 1 then
          setup_config.automatic_enable = {
            exclude = exclude_automatic_enable,
          }
        else
          setup_config.handlers = { configure }
        end

        mlsp.setup(setup_config)
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
    "mason-org/mason.nvim",
    cmd = "Mason",
    version = vim.fn.has "nvim-0.11" == 0 and "1.11.0" or false,
    build = ":MasonUpdate",
    opts_extend = { "ensure_installed" },
    opts = {
      ensure_installed = {
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
  -- GARBAGE-DAY
  {
    "zeioth/garbage-day.nvim",
    event = "LspAttach",
    opts = {},
  },
}
