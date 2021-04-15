if !PluginLoaded('vim-mundo')
  finish
endif

let g:mundo_width = 60
let g:mundo_preview_height = 30
let g:mundo_right = 0                         " open mundo on the left side
let g:mundo_help = 1

" keymap: [plugin][mundo][toggle] open
nnoremap <localleader>am :MundoToggle<CR>
