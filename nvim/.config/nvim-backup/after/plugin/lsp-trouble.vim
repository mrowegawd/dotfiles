scriptencoding utf-8

if !PluginLoaded('lsp-trouble.nvim')
  finish
endif

" keymap: [plugin][lsp-trouble][toggle] open lsptrouble
nnoremap <silent> <leader>D :LspTroubleToggle<CR>
