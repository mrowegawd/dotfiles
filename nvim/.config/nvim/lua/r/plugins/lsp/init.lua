local Util = require "r.utils"

local max_width = math.min(math.floor(vim.o.columns * 0.7), 100)
local max_height = math.min(math.floor(vim.o.lines * 0.3), 30)

return {
  -- MASON NVIM
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    build = ":MasonUpdate",
    opts = {
      ensure_installed = { "shfmt" },
      ui = { border = require("r.config").icons.border.rectangle, height = 0.8 },
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
      { "rmagatti/goto-preview", config = true },
      -- { "folke/neodev.nvim", opts = {} },
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    opts = {
      -- options for vim.diagnostic.config()
      diagnostics = {
        underline = true,
        update_in_insert = false,
        virtual_text = {
          spacing = 4,
          source = "if_many",
          prefix = "●",
        },
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
          border = require("r.config").icons.border.rectangle,
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
      inlay_hints = { enabled = false },
      -- add any global capabilities here
      capabilities = {},
      -- options for vim.lsp.buf.format
      -- `bufnr` and `filter` is handled by the LazyVim formatter,
      -- but can be also overridden when specified
      format = { formatting_options = nil, timeout_ms = nil },
      servers = {
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
      },
    },
    config = function(_, opts)
      if Util.has "neoconf.nvim" then
        local plugin = require("lazy.core.config").spec.plugins["neoconf.nvim"]
        require("neoconf").setup(require("lazy.core.plugin").values(plugin, "opts", false))
      end

      Util.format.register(Util.lsp.formatter())

      -- deprectaed options
      if opts.autoformat ~= nil then
        vim.g.autoformat = opts.autoformat
        Util.error("nvim-lspconfig.opts.autoformat", "vim.g.autoformat")
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

      -- setup formatting and keymaps
      Util.lsp.on_attach(function(client, bufnr)
        require("r.plugins.lsp.keymaps").on_attach(client, bufnr)

        if client.server_capabilities[provider.CODELENS] then
          Util.cmd.augroup("LspCodelensRefresh", {
            event = { "BufEnter", "InsertLeave", "BufWritePost" },
            desc = "LSP: Code Lens",
            buffer = bufnr,
            command = function()
              if not has_capability("textDocument/codeLens", { bufnr = bufnr }) then
                Util.cmd.del_buffer_autocmd("LspCodelensRefresh", bufnr)
                return
              end
              if vim.g.codelens_enabled then
                vim.lsp.codelens.refresh()
              end
            end,
          })
        end
      end)

      local register_capability = vim.lsp.handlers["client/registerCapability"]

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

      local inlay_hint = vim.lsp.buf.inlay_hint or vim.lsp.inlay_hint

      if opts.inlay_hints.enabled and inlay_hint then
        Util.lsp.on_attach(function(client, buffer)
          if client.supports_method "textDocument/inlayHint" then
            if vim.fn.has "nvim-0.10" == 1 then
              inlay_hint.enable(buffer, true)
            else
              inlay_hint(buffer, true)
            end
          end
        end)
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

      if Util.lsp.get_config "denols" and Util.lsp.get_config "tsserver" then
        local is_deno = require("lspconfig.util").root_pattern("deno.json", "deno.jsonc")
        Util.lsp.lsp_disable("tsserver", is_deno)
        Util.lsp.lsp_disable("denols", function(root_dir)
          return not is_deno(root_dir)
        end)
      end
    end,
  },
}
