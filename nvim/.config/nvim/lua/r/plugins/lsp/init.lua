if not as.use_lsp_native then
  return {}
end

local border = as.ui.border.rectangle
local max_width = math.min(math.floor(vim.o.columns * 0.7), 100)
local max_height = math.min(math.floor(vim.o.lines * 0.3), 30)
local icons = as.ui.icons
-- local augroup = as.augroup

-- local prettier = { "prettierd", "prettier" }
local prettier = { "prettier" }
local uv = vim.uv or vim.loop

return {
  -- GOTO-PREVIEW
  { "rmagatti/goto-preview", config = true },
  -- MASON NVIM
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    build = ":MasonUpdate",
    opts = {
      ensure_installed = { "shfmt" },
      ui = { border = as.ui.border.rectangle, height = 0.8 },
    },
    config = function(_, opts)
      require("mason").setup(opts)
      local mr = require "mason-registry"
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
    event = "BufReadPost",
    dependencies = {
      { "folke/neoconf.nvim", cmd = "Neoconf", config = false, dependencies = { "nvim-lspconfig" } },
      { "folke/neodev.nvim", opts = {} },
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
          -- this will set set the prefix to a function that returns the diagnostics icon based on the severity
          -- this only works on a recent 0.10.0 build. Will be set to "●" when not supported
          -- prefix = "icons",
        },
        severity_sort = true,
        float = {
          max_width = max_width,
          max_height = max_height,
          title = "",
          -- title = {
          --     { "  ", "DiagnosticFloatTitleIcon" },
          --     { "Problems  ", "DiagnosticFloatTitle" },
          -- },
          focusable = false,
          style = "minimal",
          border = border, -- "rounded"
          source = "always",
          header = "",
          prefix = function(diag)
            local level = vim.diagnostic.severity[diag.severity]
            local prefix = string.format("%s ", icons.diagnostics[level:lower()])
            return prefix, "Diagnostic" .. level:gsub("^%l", string.upper)
          end,
        },
      },
      -- Enable this to enable the builtin LSP inlay hints on Neovim >= 0.10.0
      -- Be aware that you also will need to properly configure your LSP server to
      -- provide the inlay hints.
      inlay_hints = {
        enabled = false,
      },
      -- add any global capabilities here
      capabilities = {},
      -- Automatically format on save
      autoformat = true,
      -- options for vim.lsp.buf.format
      -- `bufnr` and `filter` is handled by the LazyVim formatter,
      -- but can be also overridden when specified
      format = {
        formatting_options = nil,
        timeout_ms = nil,
      },
      servers = {
        lua_ls = {
          -- keys = {},
          settings = {
            Lua = {
              -- codeLens = { enable = true },
              workspace = {
                checkThirdParty = false,
              },
              completion = {
                callSnippet = "Replace",
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
      local lsp_utils = require "r.plugins.lsp.utils"

      if as.has "neoconf.nvim" then
        local plugin = require("lazy.core.config").spec.plugins["neoconf.nvim"]
        require("neoconf").setup(require("lazy.core.plugin").values(plugin, "opts", false))
      end

      require("r.plugins.lsp.format").setup(opts)

      -- local provider = {
      --   HOVER = "hoverProvider",
      --   RENAME = "renameProvider",
      --   CODELENS = "codeLensProvider",
      --   CODEACTIONS = "codeActionProvider",
      --   FORMATTING = "documentFormattingProvider",
      --   REFERENCES = "documentHighlightProvider",
      --   DEFINITION = "definitionProvider",
      -- }

      -- setup formatting and keymaps
      lsp_utils.on_attach(function(client, bufnr)
        require("r.plugins.lsp.keymaps").on_attach(client, bufnr)

        -- if client.server_capabilities[provider.CODELENS] then
        --   augroup(("LspCodeLens%d"):format(bufnr), {
        --     event = { "BufEnter", "InsertLeave", "BufWritePost" },
        --     desc = "LSP: Code Lens",
        --     buffer = bufnr,
        --     -- call via vimscript so that errors are silenced
        --     command = "silent! lua vim.lsp.codelens.refresh()",
        --   })
        -- end
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

      -- Hover
      vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
        border = border,
      })

      -- Diagnostics
      for name, icon in pairs(icons.diagnostics) do
        name = "DiagnosticSign" .. name
        vim.fn.sign_define(name, { text = icon, texthl = name, numhl = "" })
      end

      local inlay_hint = vim.lsp.buf.inlay_hint or vim.lsp.inlay_hint

      if opts.inlay_hints.enabled and inlay_hint then
        lsp_utils.on_attach(function(client, buffer)
          if client.supports_method "textDocument/inlayHint" then
            inlay_hint(buffer, true)
          end
        end)
      end

      if type(opts.diagnostics.virtual_text) == "table" and opts.diagnostics.virtual_text.prefix == "icons" then
        opts.diagnostics.virtual_text.prefix = vim.fn.has "nvim-0.10.0" == 0 and "●"
          or function(diagnostic)
            for d, icon in pairs(icons.diagnostics) do
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

      if as.lsp_get_config "denols" and as.lsp_get_config "tsserver" then
        local is_deno = require("lspconfig.util").root_pattern("deno.json", "deno.jsonc")
        as.lsp_disable("tsserver", is_deno)
        as.lsp_disable("denols", function(root_dir)
          return not is_deno(root_dir)
        end)
      end
    end,
  },
  -- NVIM-LINT
  {
    "mfussenegger/nvim-lint",
    event = "VimEnter",
    opts = {
      linters_by_ft = {
        ["javascript.jsx"] = { "eslint_d" },
        ["typescript.tsx"] = { "eslint_d" },
        go = { "golangcilint" },
        javascript = { "eslint_d" },
        javascriptreact = { "eslint_d" },
        lua = { "selene" },
        python = { "mypy", "pylint" },
        rst = { "rstlint" },
        sh = { "shellcheck" },
        typescript = { "eslint_d" },
        typescriptreact = { "eslint_d" },
        vim = { "vint" },
        yaml = { "yamllint" },
      },
      linters = {},
    },
    config = function(_, opts)
      local lint = require "lint"
      lint.linters_by_ft = opts.linters_by_ft
      for k, v in pairs(opts.linters) do
        lint.linters[k] = v
      end
      local timer = assert(uv.new_timer())
      local DEBOUNCE_MS = 500
      local aug = vim.api.nvim_create_augroup("Lint", { clear = true })
      vim.api.nvim_create_autocmd({ "BufWritePost", "TextChanged", "InsertLeave" }, {
        group = aug,
        callback = function()
          local bufnr = vim.api.nvim_get_current_buf()
          timer:stop()
          timer:start(
            DEBOUNCE_MS,
            0,
            vim.schedule_wrap(function()
              if vim.api.nvim_buf_is_valid(bufnr) then
                vim.api.nvim_buf_call(bufnr, function()
                  lint.try_lint(nil, { ignore_errors = true })
                end)
              end
            end)
          )
        end,
      })
      lint.try_lint(nil, { ignore_errors = true })
    end,
  },
  -- CONFORM.NVIM
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
      {
        "<Leader>lf",
        function()
          require("conform").format { async = true, lsp_fallback = true }
        end,
        desc = "Lang(conform): Format buffer",
      },
    },
    opts = {
      formatters_by_ft = {
        javascript = prettier,
        typescript = prettier,
        javascriptreact = prettier,
        typescriptreact = prettier,
        css = prettier,
        html = prettier,
        json = prettier,
        jsonc = prettier,
        yaml = prettier,
        markdown = prettier,
        graphql = prettier,
        lua = { "stylua" },
        sh = { "shfmt" },
        ["_"] = { "trim_whitespace", "trim_newlines" },
        python = {
          formatters = { "isort", "black" },
          run_all_formatters = true,
        },
      },
      format_on_save = { timeout_ms = 500, lsp_fallback = true },
      log_level = vim.log.levels.DEBUG,
    },
    config = function(_, opts)
      if vim.g.started_by_firenvim then
        opts.format_on_save = false
      end
      require("conform").setup(opts)
    end,
  },
  -- NONE-LS
  {
    "nvimtools/none-ls.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "mason.nvim" },
    opts = function()
      local nls = require "null-ls"
      return {
        root_dir = require("null-ls.utils").root_pattern(".null-ls-root", ".neoconf.json", "Makefile", ".git"),
        sources = {
          nls.builtins.diagnostics.fish,
          nls.builtins.formatting.fish_indent,
          -- nls.builtins.formatting.stylua,
          -- nls.builtins.formatting.shfmt,
          -- nls.builtins.diagnostics.flake8,
        },
      }
    end,
  },
}
