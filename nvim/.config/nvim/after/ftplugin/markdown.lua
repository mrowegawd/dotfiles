local opt = vim.opt_local

RUtils.map.nnoremap("rf", "<CMD>MarkdownPreviewToggle<CR>", { buffer = true, desc = "Markdown: preview toggle" })
RUtils.map.nnoremap("ri", "<CMD>ImgInsert<CR>", { buffer = true, desc = "Markdown: insert image" })
-- vim.cmd [[:%s/^#\+/\=repeat('*', len(submatch(0)))/]]

opt.wrap = false
opt.list = false
function _G.Mardownfoldtext()
  local line = vim.api.nvim_buf_get_lines(0, vim.v.foldstart - 1, vim.v.foldstart, true)[1]
  local idx = vim.v.foldstart + 1
  while string.find(line, "^%s*@") or string.find(line, "^%s*$") do
    line = vim.api.nvim_buf_get_lines(0, idx - 1, idx, true)[1]
    idx = idx + 1
  end
  local icon = " "
  local padding = string.rep(" ", string.find(line, "[^%s]") - 1)
  return string.format("%s%s %s   %d", padding, icon, line, vim.v.foldend - vim.v.foldstart + 1)
end

-- opt.foldtext = "v:lua.Mardownfoldtext()"
opt.foldtext = ""
opt.foldexpr = "nvim_treesitter#foldexpr()"
opt.foldmethod = "expr"
opt.foldlevel = 1
