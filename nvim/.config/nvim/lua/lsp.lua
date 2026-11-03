local add = require("vim-pack").add

local lazy = require("utils.plugin").require_lazy

local UtilKey = lazy "utils.map"
local Log = lazy "utils.log"

---@param mode string  Trouble mode, e.g. "lsp_definitions"
---@param extra? string
local function trouble(mode, extra)
  return function()
    lazy("vim-pack").load_now "trouble.nvim"
    vim.cmd(("Trouble %s toggle focus=true auto_refresh=false%s"):format(mode, extra and (" " .. extra) or ""))
  end
end

local ALLOWED_SYMBOL_KINDS = {
  Class = true,
  Constructor = true,
  Enum = true,
  Function = true,
  Interface = true,
  Method = true,
  Module = true,
  Namespace = true,
  Struct = true,
}

local function document_symbols_to_loclist()
  vim.lsp.buf.document_symbol {
    on_list = function(opts)
      local items = opts.items or {}

      if next(ALLOWED_SYMBOL_KINDS) then
        items = vim.tbl_filter(function(item)
          return ALLOWED_SYMBOL_KINDS[item.kind] == true
        end, items)
      end

      if #items == 0 then
        Log.warn "No symbols found"
        return
      end

      vim.fn.setloclist(0, {}, " ", { title = "Document Symbols", items = items })
      vim.cmd "lopen"
    end,
  }
end

local function code_action()
  if vim.bo.filetype == "rust" then
    return vim.cmd.RustLsp "codeAction"
  end
  if lazy("utils.plugin").has_module "tiny-code-action.nvim" then
    return lazy("tiny-code-action").code_action {}
  end
  vim.lsp.buf.code_action()
end

---@param scope? "line"|"cursor"
local function diagnostic_float_markdown(scope)
  scope = scope or "line"
  local pos = vim.api.nvim_win_get_cursor(0)
  local lnum, col = pos[1] - 1, pos[2]

  local diags = vim.diagnostic.get(0, { lnum = lnum })
  if scope == "cursor" then
    diags = vim.tbl_filter(function(d)
      local end_col = (d.end_lnum == d.lnum) and d.end_col or math.huge
      return col >= d.col and col <= math.max(end_col, d.col)
    end, diags)
  end

  if #diags == 0 then
    Log.info "No diagnostics here"
    return
  end

  table.sort(diags, function(a, b)
    return a.severity < b.severity
  end)

  local icons = lazy("icons").diagnostics
  local S = vim.diagnostic.severity
  local label = {
    [S.ERROR] = { "Error", icons.Error },
    [S.WARN] = { "Warn", icons.Warn },
    [S.INFO] = { "Info", icons.Info },
    [S.HINT] = { "Hint", icons.Hint },
  }

  local lines = {}
  for i, d in ipairs(diags) do
    local l = label[d.severity] or label[S.INFO]
    local meta = {}
    if d.source then
      meta[#meta + 1] = ("`%s`"):format(d.source)
    end
    if d.code then
      meta[#meta + 1] = ("`%s`"):format(d.code)
    end

    lines[#lines + 1] = ("**%s %s**  %s"):format(l[2], l[1], table.concat(meta, " "))
    lines[#lines + 1] = ""
    vim.list_extend(lines, vim.split(d.message, "\n", { plain = true, trimempty = true }))

    if i < #diags then
      vim.list_extend(lines, { "", "---", "" })
    end
  end

  local _, winnr = vim.lsp.util.open_floating_preview(lines, "markdown", {
    border = "rounded",
    focus_id = "lsp_diagnostic_float",
    max_width = math.floor(vim.o.columns * 0.6),
    close_events = { "CursorMoved", "InsertEnter", "BufHidden" },
  })

  if winnr and vim.api.nvim_win_is_valid(winnr) then
    vim.wo[winnr].conceallevel = 2
    vim.wo[winnr].wrap = true
  end
end

---@return LspKeySpec[]
local function get_keys()
  local diag = UtilKey.lsp.diagnostic_goto

  return {
    -- Nav
    { "<Leader>ld", trouble "lsp_definitions", has = "definition", desc = "LSP: definitions [trouble]" },
    {
      "<Leader>lv",
      trouble("lsp_definitions", "open_mode=vsplit"),
      has = "definition",
      desc = "LSP: definitions vsplit [trouble]",
    },
    { "<Leader>lt", trouble "lsp_type_definitions", has = "typeDefinition", desc = "LSP: type definitions [trouble]" },
    { "<Leader>lr", trouble "lsp_references", has = "references", desc = "LSP: references [trouble]", nowait = true },
    { "<Leader>lR", trouble "lsp", desc = "LSP: lsp stuff [trouble]", nowait = true },
    { "gO", document_symbols_to_loclist, has = "documentSymbol", desc = "LSP: document symbols to location list" },

    -- Hover
    { "K", vim.lsp.buf.hover, has = "hover", desc = "LSP: Hover" },
    {
      "<C-c>ls",
      function()
        lazy("utils.hover_eldoc").show "float"
      end,
      has = "hover",
      desc = "LSP: show hover [hover_eglot]",
    },
    {
      "<C-c>lS",
      function()
        lazy("utils.hover_eldoc").toggle "float"
      end,
      has = "hover",
      desc = "LSP: toggle hover [hover_eglot]",
    },
    {
      "<C-s>",
      function()
        lazy("utils.hover_eldoc").toggle_auto_hover()
      end,
      has = "hover",
      desc = "LSP: show signature [hover_eglot]",
      mode = { "i", "v" },
    },

    -- Code actions & rename
    { "<Leader>ca", code_action, mode = { "n", "x" }, has = "codeAction", desc = "Action: source action" },
    { "<Leader>cr", vim.lsp.buf.rename, has = "rename", desc = "Action: rename" },

    -- Diagnostics (doesn't need `has`, still attached to buffers with LSP)
    { "dn", diag(1), desc = "Diagnostic: next item" },
    { "dp", diag(-1), desc = "Diagnostic: prev item" },
    {
      "dP",
      function()
        diagnostic_float_markdown "line"
      end,
      desc = "Diagnostic: open float peek (markdown)",
    },
    {
      "dK",
      function()
        diagnostic_float_markdown "cursor"
      end,
      desc = "Diagnostic: float at cursor (markdown)",
    },
  }
end

local function setup_diagnostics()
  local icons = lazy("icons").diagnostics
  local S = vim.diagnostic.severity

  vim.diagnostic.config {
    underline = true,
    update_in_insert = false,
    virtual_text = false,
    virtual_lines = false,
    severity_sort = true,
    signs = {
      text = {
        [S.ERROR] = icons.Error,
        [S.WARN] = icons.Warn,
        [S.HINT] = icons.Hint,
        [S.INFO] = icons.Info,
      },
      numhl = {
        [S.ERROR] = "DiagnosticsErrorNumHl",
        [S.WARN] = "DiagnosticsWarnNumHl",
        [S.HINT] = "DiagnosticsHintNumHl",
        [S.INFO] = "DiagnosticsInfoNumHl",
      },
    },
  }
end

local function disable_default_keymaps()
  for _, lhs in ipairs { "grn", "gri", "grr", "grt", "gO" } do
    pcall(vim.keymap.del, "n", lhs)
  end
  pcall(vim.keymap.del, { "n", "x" }, "gra")
  for _, mode in ipairs { "i", "s" } do
    pcall(vim.keymap.del, mode, "<C-s>")
  end
end

local function setup_global_lsp_config()
  local capabilities = vim.tbl_deep_extend("force", vim.lsp.protocol.make_client_capabilities(), {
    textDocument = {
      completion = {
        completionItem = {
          documentationFormat = { "markdown", "plaintext" },
          snippetSupport = true,
          preselectSupport = true,
          insertReplaceSupport = true,
          labelDetailsSupport = true,
          deprecatedSupport = true,
          commitCharactersSupport = true,
          tagSupport = { valueSet = { 1 } },
          resolveSupport = { properties = { "documentation", "detail", "additionalTextEdits" } },
        },
      },
    },
  })

  vim.lsp.config("*", {
    capabilities = capabilities,
    on_init = function(client)
      -- PERFORMANCE: disable semantic tokens
      client.server_capabilities.semanticTokensProvider = nil
    end,
  })
end

local servers = {
  lua_ls = {
    settings = {
      Lua = {
        workspace = { checkThirdParty = false },
        codeLens = { enable = true },
        hint = { enable = true, arrayIndex = "Disable" },
        runtime = { version = "LuaJIT" },
        format = { enable = false }, -- use stylua
        completion = { callSnippet = "Replace" },
        doc = { privateName = { "^_" } },
      },
    },
  },
}

add {
  { src = "mason-org/mason.nvim" },
  { src = "mason-org/mason-lspconfig.nvim" },
  { src = "WhoIsSethDaniel/mason-tool-installer.nvim" },
  {
    src = "neovim/nvim-lspconfig",
    setup = false,
    on_setup = function()
      lazy("mason").setup()
      lazy("mason-lspconfig").setup()
      lazy("mason-tool-installer").setup {
        ensure_installed = { "lua_ls", "cbfmt", "stylua", "markdownlint-cli2", "markdown-toc", "cspell" },
      }

      setup_diagnostics()
      disable_default_keymaps()
      setup_global_lsp_config()

      -- Config per server, then enable explicitly (safe even if mason-lspconfig
      -- auto-enables too)
      for name, opts in pairs(servers) do
        vim.lsp.config(name, opts)
      end
      vim.lsp.enable(vim.tbl_keys(servers))

      -- Keymaps: attached buffer-local on LspAttach, ONCE for all servers
      UtilKey.lsp.setup_keymaps(get_keys())

      -- Only relevant for nvim < 0.11
      if vim.fn.has "nvim-0.11" == 0 then
        local buf_request = vim.lsp.buf_request
        ---@diagnostic disable-next-line: duplicate-set-field
        vim.lsp.buf_request = function(bufnr, method, params, handler)
          return buf_request(bufnr, method, params, handler, function() end)
        end
      end
    end,
  },
}
