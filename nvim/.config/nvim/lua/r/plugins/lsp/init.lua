return {
  -- NVIM-LSPCONFIG
  {
    "neovim/nvim-lspconfig",
    event = "LazyFile",
    dependencies = {
      "mason.nvim",
      { "mason-org/mason-lspconfig.nvim", config = function() end },
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
          enabled = true,
        },
        -- Enable this to enable the builtin LSP folding on Neovim.
        -- Be aware that you also will need to properly configure your LSP server to
        -- provide the folds.
        folds = {
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
        -- options for vim.lsp.buf.format
        -- `bufnr` and `filter` is handled by the LazyVim formatter,
        -- but can be also overridden when specified
        format = {
          formatting_options = nil,
          timeout_ms = nil,
        },
        -- LSP Server Settings
        ---@type table<string, vim.lsp.Config|{mason?:boolean, enabled?:boolean}|boolean>
        servers = {
          lua_ls = {
            -- mason = false, -- set to false if you don't want this server to be installed with mason
            -- Use this to add any additional keymaps
            -- for specific lsp servers
            -- ---@type LazyKeysSpec[]
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
        ---@type table<string, fun(server:string, opts: vim.lsp.Config):boolean?>
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
    config = vim.schedule_wrap(function(_, opts)
      -- setup autoformat
      RUtils.format.register(RUtils.lsp.formatter())

      -- disable default keybindings
      for _, bind in ipairs { "grn", "gra", "gri", "grr", "gO", "grt" } do
        vim.keymap.del("n", bind)
      end

      vim.keymap.del("s", "<C-s>")

      -- setup keymaps
      RUtils.lsp.on_attach(function(client, bufnr)
        require("r.keymaps.lsp").on_attach(client, bufnr)
      end)

      RUtils.lsp.setup()
      RUtils.lsp.on_dynamic_capability(require("r.keymaps.lsp").on_attach)

      local methods = vim.lsp.protocol.Methods

      -- inlay hints
      if opts.inlay_hints.enabled then
        RUtils.lsp.on_supports_method(methods.textDocument_inlayHint, function(client, buffer)
          if
            vim.api.nvim_buf_is_valid(buffer)
            and vim.bo[buffer].buftype == ""
            and not vim.tbl_contains(opts.inlay_hints.exclude, vim.bo[buffer].filetype)
          then
            vim.lsp.inlay_hint.enable(true, { bufnr = buffer })
          end
        end)
      end

      -- folds
      if opts.folds.enabled then
        RUtils.lsp.on_supports_method(methods.textDocument_foldingRange, function(client, buffer)
          local win = vim.api.nvim_get_current_win()
          vim.wo[win][0].foldexpr = "v:lua.vim.lsp.foldexpr()"
          vim.wo[win][0].foldmethod = "expr"
        end)
      end

      -- code lens
      if opts.codelens.enabled and vim.lsp.codelens then
        RUtils.lsp.on_supports_method(methods.textDocument_codeLens, function(_, buffer)
          vim.lsp.codelens.refresh()
          vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
            buffer = buffer,
            callback = vim.lsp.codelens.refresh,
          })
        end)
      end

      -- diagnostics
      if type(opts.diagnostics.virtual_text) == "table" and opts.diagnostics.virtual_text.prefix == "icons" then
        opts.diagnostics.virtual_text.prefix = function(diagnostic)
          local icons = RUtils.config.icons.diagnostics
          for d, icon in pairs(icons) do
            if diagnostic.severity == vim.diagnostic.severity[d:upper()] then
              return icon
            end
          end
          return "●"
        end
      end
      vim.diagnostic.config(vim.deepcopy(opts.diagnostics))

      if opts.capabilities then
        vim.lsp.config("*", { capabilities = opts.capabilities })
      end

      -- get all the servers that are available through mason-lspconfig
      local have_mason = RUtils.has "mason-lspconfig.nvim"
      local mason_all = have_mason
          and vim.tbl_keys(require("mason-lspconfig.mappings").get_mason_map().lspconfig_to_package)
        or {} --[[ @as string[] ]]

      local exclude_automatic_enable = {} ---@type string[]

      local function configure(server)
        local server_opts = opts.servers[server] or {}

        local setup = opts.setup[server] or opts.setup["*"]
        if setup and setup(server, server_opts) then
          return true -- lsp will be setup by the setup function
        end

        vim.lsp.config(server, server_opts)

        -- manually enable if mason=false or if this is a server that cannot be installed with mason-lspconfig
        if server_opts.mason == false or not vim.tbl_contains(mason_all, server) then
          vim.lsp.enable(server)
          return true
        end
        return false
      end

      local ensure_installed = {} ---@type string[]
      for server, server_opts in pairs(opts.servers) do
        server_opts = server_opts == true and {} or server_opts or false
        if server_opts and server_opts.enabled ~= false then
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

      if have_mason then
        require("mason-lspconfig").setup {
          ensure_installed = vim.tbl_deep_extend(
            "force",
            ensure_installed,
            RUtils.opts("mason-lspconfig.nvim").ensure_installed or {}
          ),
          automatic_enable = {
            exclude = exclude_automatic_enable,
          },
        }
      end

      if vim.lsp.is_enabled "denols" and vim.lsp.is_enabled "vtsls" then
        ---@param server string
        local resolve = function(server)
          local markers, root_dir = vim.lsp.config[server].root_markers, vim.lsp.config[server].root_dir
          vim.lsp.config(server, {
            root_dir = function(bufnr, on_dir)
              local is_deno = vim.fs.root(bufnr, { "deno.json", "deno.jsonc" }) ~= nil
              if is_deno == (server == "denols") then
                if root_dir then
                  return root_dir(bufnr, on_dir)
                elseif type(markers) == "table" then
                  local root = vim.fs.root(bufnr, markers)
                  return root and on_dir(root)
                end
              end
            end,
          })
        end
        resolve "denols"
        resolve "vtsls"
      end
    end),
  },
  -- MASON NVIM
  {
    "mason-org/mason.nvim",
    cmd = "Mason",
    keys = { { "<Leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
    build = ":MasonUpdate",
    opts_extend = { "ensure_installed" },
    ---@class MasonSettings
    opts = {
      ensure_installed = {
        "shfmt",
        "stylua",
      },
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
  -- LAZYDEV
  {
    "folke/lazydev.nvim",
    ft = "lua",
    cmd = "LazyDev",
    dependencies = {
      { "justinsgithub/wezterm-types", lazy = true },
    },
    opts = {
      library = {
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
        -- { path = "snacks.nvim", words = { "Snacks" } },
        -- { path = "wezterm-types", mods = { "wezterm" } },
        { path = "lazy.nvim", words = { "LazyVim" } },
        { path = "RUtils", words = { "RUtils" } },
      },
    },
  },
}
