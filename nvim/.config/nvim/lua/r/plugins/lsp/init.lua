local lsp = RUtils.config.lsp_style

if lsp == "coc" then
  return require "r.plugins.lsp.coc"
elseif lsp == "coq" then
  return require "r.plugins.lsp.coq"
else
  return require "r.plugins.lsp.lspconfig"
end
