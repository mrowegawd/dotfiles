local fmt, diagnostic = string.format, vim.diagnostic

local border = as.ui.border.rectangle
local icons = as.ui.icons
local lsp_utils = require "r.plugins.lsp.utils"

-- vim.g.inlay_hints_enabled = false

local augroup = as.augroup

local M = {}

local max_width = math.min(math.floor(vim.o.columns * 0.7), 100)
local max_height = math.min(math.floor(vim.o.lines * 0.3), 30)

local function diagnostic_init()
  local signs = {
    { name = "DiagnosticSignError", text = icons.diagnostics.error },
    { name = "DiagnosticSignWarn", text = icons.diagnostics.warn },
    { name = "DiagnosticSignHint", text = icons.diagnostics.hint },
    { name = "DiagnosticSignInfo", text = icons.diagnostics.info },
  }
  for _, sign in ipairs(signs) do
    vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = sign.name })
  end

  local config = {
    diagnostic = {
      virtual_text = false and {
        spacing = 1,
        prefix = "",
        format = function(d)
          return fmt("%s %s", icons.misc.circle, d.message)
        end,
      },

      signs = {
        active = signs,
      },
      underline = false,
      update_in_insert = false,
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
          local level = diagnostic.severity[diag.severity]
          local prefix = fmt("%s ", icons.diagnostics[level:lower()])
          return prefix, "Diagnostic" .. level:gsub("^%l", string.upper)
        end,
      },
    },
  }

  -- Diagnostic configuration
  vim.diagnostic.config(config.diagnostic)

  -- Diagnostic configuration
  vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
    border = border,
  })
  -- Signature help configuration
  vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
    border = border,
  })
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

local function setup_autocommands(client, buf)
  -- show the line e.g "1 references"
  if client.server_capabilities[provider.CODELENS] then
    augroup(("LspCodeLens%d"):format(buf), {
      event = { "BufEnter", "InsertLeave", "BufWritePost" },
      desc = "LSP: Code Lens",
      buffer = buf,
      -- call via vimscript so that errors are silenced
      command = "silent! lua vim.lsp.codelens.refresh()",
    })
  end

  -- augroup(
  --   "LspSetupCommands",
  -- {
  --   event = "LspAttach",
  --   desc = "setup the language server autocommands",
  --   command = function(args)
  --     local client = lsp.get_client_by_id(args.data.client_id)
  --     if not client then
  --       return
  --     end
  --
  --     on_attach(client, args.buf)
  --
  --     local overrides = client_overrides[client.name]
  --     if not overrides or not overrides.on_attach then
  --       return
  --     end
  --     overrides.on_attach(client, args.buf)
  --   end,
  -- },
  --   {
  --     event = "DiagnosticChanged",
  --     desc = "Update the diagnostic locations",
  --     command = function(args)
  --       diagnostic.setloclist { open = true }
  --       if #args.data.diagnostics == 0 then
  --         vim.cmd "silent! lclose"
  --       end
  --     end,
  --   }
  -- )
end

local function on_attach(client, buffer)
  setup_autocommands(client, buffer)

  -- Setup inlay-hints
  if client.supports_method "textDocument/inlayHint" then
    if vim.b.inlay_hints_enabled == nil then
      vim.b.inlay_hints_enabled = vim.g.inlay_hints_enabled
    end

    if vim.b.inlay_hints_enabled then
      vim.lsp.inlay_hint(buffer, true)
    end

    vim.keymap.set("n", "gti", function()
      require("r.utils").inlayhints()
    end, { desc = "LSP: toggle inlay hints" })
  end

  if client.supports_method "textDocument/documentHighlight" then
    local group = vim.api.nvim_create_augroup("LspDocumentHighlight", { clear = true })
    vim.api.nvim_clear_autocmds { group = group, buffer = buffer }
    vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
      group = group,
      buffer = buffer,
      callback = function()
        vim.lsp.buf.document_highlight()
      end,
      desc = "[LSP] Document highlights for the current text position.",
    })
    vim.api.nvim_create_autocmd("CursorMoved", {
      group = group,
      buffer = buffer,
      callback = function()
        vim.lsp.buf.clear_references()
      end,
      desc = "[LSP] Turn off document highlights.",
    })
  end
end

function M.setup(_, opts)
  lsp_utils.on_attach(function(client, bufnr)
    require("r.plugins.lsp.keymaps").on_attach(client, bufnr)
    -- require("r.plugins.lsp.format").on_attach(client, bufnr)
  end)

  diagnostic_init() -- diagnostics, handlers

  lsp_utils.on_attach(function(client, buffer)
    on_attach(client, buffer)
  end)

  local servers = opts.servers
  local capabilities = lsp_utils.capabilities()

  local function setup(server)
    local server_opts = vim.tbl_deep_extend("force", {
      capabilities = capabilities,
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

  -- get all the servers that are available thourgh mason-lspconfig
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
    mlsp.setup { ensure_installed = ensure_installed }
    mlsp.setup_handlers { setup }
  end
end

return M
