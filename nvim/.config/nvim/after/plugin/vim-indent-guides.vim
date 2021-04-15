if !PluginLoaded('vim-indent-guides')
  finish
endif

" keymap: [plugin][indentguide][toggle] show block indent
nmap <silent> <localleader>aI <Plug>IndentGuidesToggle
