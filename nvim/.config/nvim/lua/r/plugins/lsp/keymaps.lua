local M = {}

local diagnostic = vim.diagnostic
local lsp_utils = require "r.plugins.lsp.utils"

-- stylua: ignore
function M.on_attach(client, bufnr)
  local self = M.new(client, bufnr)

  self:map("K", vim.lsp.buf.hover, { desc = "LSP: hover", has = "hover" })
  self:map("<c-s>", vim.lsp.buf.signature_help, { desc = "LSP: show signature", has = "signatureHelp", mode = { "i" } })
  self:map("gR", vim.lsp.buf.rename, { desc = "LSP: rename" })
  self:map("gd", "FzfLua lsp_definitions", { desc = "LSP(fzflua): definitions" })
  self:map("gr", "FzfLua lsp_finder", { desc = "LSP(fzflua): finder" })
  self:map("gT", "FzfLua lsp_typedefs", { desc = "LSP(fzflua): peek type definitions" })
  self:map("ga", "FzfLua lsp_code_actions", { desc = "LSP(fzflua): code actions", mode = { "n", "v" }, has = "codeAction" })
  self:map("gi", "FzfLua incoming_calls", { desc = "LSP(fzflua): incoming calls" })
  self:map("gI", "FzfLua outgoing_calls", { desc = "LSP(fzflua): outgoing calls" })
  if pcall(require, "goto-preview") then
    self:map("gP", require("goto-preview").goto_preview_definition, { desc = "LSP(goto-preview): preview definitions" })
  else
    self:map("gP", "Lspsaga peek_definition", { desc = "LSP(lspsaga): preview definitions" })
  end
  self:map("gti", function()
    vim.lsp.inlay_hint(0, nil)
  end, { desc = "LSP: toggle inlay hint" })

  --  +----------------------------------------------------------+
  --  Diagnostics
  --  +----------------------------------------------------------+
  self:map("gtd", lsp_utils.toggle_diagnostics, { desc = "LSP(diagnostic): toggle diagnostics" })
  self:map("dn", function() diagnostic.goto_next({ float = false }) end, { desc = "LSP(diagnostic): next item" })
  self:map("dp", function() diagnostic.goto_prev({ float = false }) end, { desc = "LSP(diagnostic): prev item" })
  self:map("dP", function() vim.diagnostic.open_float { focusable = true } end, { desc = "LSP(diagnostic): open float preview" })
  self:map("dq", function()
    if #vim.diagnostic.get() > 0 then
      as.info("Open diagnostic setqflist", "Diagnostic")
      return vim.diagnostic.setqflist()
    else
      as.info("Document its clean..", "Diagnostic")
    end
  end, { desc = "LSP(diagnostic): sending to qf" })


  --  +----------------------------------------------------------+
  --  MISC
  --  +----------------------------------------------------------+
  self:map("gts", function()
    return lsp_utils.toggle_buffer_semantic_tokens(vim.api.nvim_get_current_buf())
  end, { desc = "LSP: toggle semantic token" })

end

function M.new(client, buffer)
  return setmetatable({ client = client, buffer = buffer }, { __index = M })
end

function M:has(cap)
  return self.client.server_capabilities[cap .. "Provider"]
end

function M:map(lhs, rhs, opts)
  opts = opts or {}
  if opts.has and not self:has(opts.has) then
    return
  end
  vim.keymap.set(
    opts.mode or "n",
    lhs,
    type(rhs) == "string" and ("<cmd>%s<cr>"):format(rhs) or rhs,
    ---@diagnostic disable-next-line: no-unknown
    { silent = true, buffer = self.buffer, expr = opts.expr, desc = opts.desc }
  )
end

function M.rename()
  if pcall(require, "inc_rename") then
    return ":IncRename " .. vim.fn.expand "<cword>"
  else
    vim.lsp.buf.rename()
  end
end

function M.diagnostic_goto(next, severity)
  local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
  severity = severity and vim.diagnostic.severity[severity] or nil
  return function()
    go { severity = severity }
  end
end

return M
