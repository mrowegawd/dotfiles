local diagnostic = vim.diagnostic
local Util = require "r.utils"

local M = {}

M._keys = nil

function M.get()
  if M._keys then
    return M._keys
  end

  -- stylua: ignore
  M._keys = {
    --  +----------------------------------------------------------+
    --  LSP Stuff
    --  +----------------------------------------------------------+
    { "K", vim.lsp.buf.hover, desc = "Hover" },
    { "gK", vim.lsp.buf.signature_help, desc = "Signature Help", has = "signatureHelp" },
    { "<c-k>", vim.lsp.buf.signature_help, mode = "i", desc = "Signature Help", has = "signatureHelp" },
    { "gd", function() require("telescope.builtin").lsp_definitions { reuse_win = false } end, desc = "LSP(fzflua): definitions", has = "definition" },
    { "gr", "<cmd>FzfLua lsp_finder<cr>", desc = "LSP(fzflua): finder" },
    { "gT", "<cmd>FzfLua lsp_typedefs<cr>", desc = "LSP(fzflua): peek type definitions" },
    -- { "gD", vim.lsp.buf.declaration, desc = "Goto Declaration" },
    { "gI", "<CMD>FzfLua outgoing_calls<CR>", desc = "LSP(fzflua): outgoing calls" },
    { "gi", "<CMD>FzfLua incoming_calls<CR>", desc = "LSP(fzflua): incoming calls" },
    { "gy", function() require("telescope.builtin").lsp_type_definitions { reuse_win = true } end, desc = "Goto T[y]pe Definition" },
    { "<leader>ca", vim.lsp.buf.code_action, desc = "Code Action", mode = { "n", "v" }, has = "LSP: codeAction" },
    {
      "<leader>cA",
      function()
        vim.lsp.buf.code_action {
          context = {
            only = {
              "source",
            },
            diagnostics = {},
          },
        }
      end,
      desc = "Source Action",
      has = "codeAction",
    },

    --  +----------------------------------------------------------+
    --  Toggle
    --  +----------------------------------------------------------+
    { "gtd", Util.toggle.diagnostics, desc = "LSP(diagnostic): toggle diagnostics" },
    { "gti", Util.toggle.inlay_hints, desc = "LSP: toggle inlay hint" },
    { "gtc", Util.toggle.codelens, desc = "LSP: toggle codelens" },
    { "gtF", Util.format.toggle, desc = "LSP: toggle autoformat" },
    { "gtf", function() Util.format.toggle(true) end, desc = "LSP: toggle autoformat buffer" },
    { "gtl", Util.toggle.number, desc = "LSP: toggle number" },
    { "gts", Util.toggle.semantic_tokens, desc = "LSP: toggle semantic tokens" },

    --  +----------------------------------------------------------+
    --  Diagnostics
    --  +----------------------------------------------------------+
    { "gtd", Util.toggle.diagnostics, desc = "LSP(diagnostic): toggle diagnostics" },
    { "dn", function() diagnostic.goto_next { float = false } end, desc = "LSP(diagnostic): next item" },
    { "dp", function() diagnostic.goto_prev { float = false } end, desc = "LSP(diagnostic): prev item" },
    { "dP", function() vim.diagnostic.open_float({ scope = "line", border = "rounded", focusable = true }) end, desc = "LSP(diagnostic): open float preview" },
    { "dq",
      function()
        if #vim.diagnostic.get() > 0 then
          Util.info("Open diagnostic setqflist", "Diagnostic")
          return vim.diagnostic.setqflist()
        else
          Util.info("Document its clean..", "Diagnostic")
        end
      end,
      desc = "LSP(diagnostic): sending to qf",
    },
  }

  if require("r.utils").has "goto-preview" then
    M._keys[#M._keys + 1] =
      { "gP", require("goto-preview").goto_preview_definition, desc = "LSP(goto-preview): preview definitions" }
    -- else
    --   M._keys[#M._keys + 1] = { "gP", "<cmd>FzfLua lsp_finder<cr>", desc = "Rename", has = "rename" }
  end

  if require("r.utils").has "inc-rename.nvim" then
    M._keys[#M._keys + 1] = {
      "gR",
      function()
        local inc_rename = require "inc_rename"
        return ":" .. inc_rename.config.cmd_name .. " " .. vim.fn.expand "<cword>"
      end,
      expr = true,
      desc = "Rename",
      has = "rename",
    }
  else
    M._keys[#M._keys + 1] = { "gR", vim.lsp.buf.rename, desc = "Rename", has = "rename" }
  end
  return M._keys
end

---@param method string
function M.has(buffer, method)
  method = method:find "/" and method or "textDocument/" .. method
  local clients = require("r.utils").lsp.get_clients { bufnr = buffer }
  for _, client in ipairs(clients) do
    if client.supports_method(method) then
      return true
    end
  end
  return false
end

function M.resolve(buffer)
  local Keys = require "lazy.core.handler.keys"
  if not Keys.resolve then
    return {}
  end
  local spec = M.get()
  local opts = require("r.utils").opts "nvim-lspconfig"
  local clients = require("r.utils").lsp.get_clients { bufnr = buffer }
  for _, client in ipairs(clients) do
    local maps = opts.servers[client.name] and opts.servers[client.name].keys or {}
    vim.list_extend(spec, maps)
  end
  return Keys.resolve(spec)
end

function M.on_attach(_, buffer)
  local Keys = require "lazy.core.handler.keys"
  local keymaps = M.resolve(buffer)

  for _, keys in pairs(keymaps) do
    if not keys.has or M.has(buffer, keys.has) then
      local opts = Keys.opts(keys)
      opts.has = nil
      opts.silent = opts.silent ~= false
      opts.buffer = buffer
      vim.keymap.set(keys.mode or "n", keys.lhs, keys.rhs, opts)
    end
  end
end

return M
