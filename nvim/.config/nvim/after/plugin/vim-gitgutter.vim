if !PluginLoaded('vim-gitgutter')
  finish
endif

let g:gitgutter_map_keys = 0

" keymap: [plugin][git][gitgutter] show/preview hunk
nnoremap <silent> <localleader>gP         :GitGutterPreviewHunk<CR>

" keymap: [plugin][git][gitgutter] undo hunk
nnoremap <silent> <localleader>gU         :GitGutterUndoHunk<CR>

" keymap: [plugin][git][gitgutter] next hunk
nnoremap <silent> <A-DOWN>                :GitGutterNextHunk<CR>

" keymap: [plugin][git][gitgutter] prev hunk
nnoremap <silent> <A-UP>                  :GitGutterPrevHunk<CR>
