if !PluginLoaded('vim-visual-multi')
  finish
endif

let g:multi_cursor_use_default_mapping=0

let g:multi_cursor_next_key = '<C-n>'
let g:multi_cursor_prev_key = '<C-p>'
let g:multi_cursor_skip_key = '<C-b>'
let g:multi_cursor_quit_key = '<Esc>'

highlight multiple_cursors_cursor term=reverse cterm=reverse gui=reverse
highlight link multiple_cursors_visual Visual

function! Multiple_cursors_before()
  call AutoPairsToggle()
endfun

function! Multiple_cursors_after()
  call AutoPairsToggle()
endfun
