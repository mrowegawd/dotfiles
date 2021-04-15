scriptencoding UTF-8    " Default encoding for current script.

if !PluginLoaded('vimwiki')
  finish
endif

" keymap: [plugin][vimwiki] open index
nmap <silent> <localleader>ww :VimwikiIndex<CR>

" keymap: [plugin][vimwiki] diary index
nmap <buffer> <silent> <localleader>wdi <Plug>VimwikiDiaryIndex
