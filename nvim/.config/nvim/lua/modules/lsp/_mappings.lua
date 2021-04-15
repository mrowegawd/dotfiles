local k = require("astronauta.keymap")
local nnoremap = k.nnoremap
local inoremap = k.inoremap
local api = vim.api

local M = {}

local hover = require("lspsaga.hover")
local signature = require("lspsaga.signaturehelp")
local rename = require("lspsaga.rename")
local diagnostic = require("lspsaga.diagnostic")
local provider = require("lspsaga.provider")


M.lsp_mappings = function()
  api.nvim_buf_set_option(0, "omnifunc", "v:lua.vim.lsp.omnifunc")

  local mappings = {
    -- LSP
    ["<C-g>"] = signature.signature_help,
    ["K"] = hover.render_hover_doc,
    ["gD"] = provider.preview_definition,
    ["gd"] = vim.lsp.buf.definition,
    ["gr"] = require("telescope.builtin").lsp_references,
    ["gR"] = rename.rename,
    ["gh"] = provider.lsp_finder,
    ["gf"] = "<cmd>lua vim.lsp.buf.formatting()<CR>",
    ["ga"] = require("plugins._telescope").code_actions,

    -- Workspace
    ["<leader>wl"] = "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>",

    -- Diagnostic
    ["<leader>D"] = diagnostic.show_line_diagnostics,
    ["<S-DOWN>"] = diagnostic.lsp_jump_diagnostic_next,
    ["<S-UP>"] = diagnostic.lsp_jump_diagnostic_prev,
  }

  for j, v in pairs(mappings) do
    nnoremap({ j, v, { silent = true } })
  end

  inoremap({ "<C-g>", signature.signature_help, { silent = true } })

end

return M
