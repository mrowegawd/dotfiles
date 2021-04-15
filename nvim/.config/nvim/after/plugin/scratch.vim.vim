if !PluginLoaded('scratch.vim')
  finish
endif

" persist scratch file for project session
let g:scratch_persistence_file = '.scratch.note'

" nmap <silent> <leader>sP :ScratchPreview<CR>
" nmap <silent> <leader>se :Scratch<CR>
" nmap <silent> <leader>si <plug>(scratch-insert-reuse)
" nmap <silent> <leader>sc <plug>(scratch-insert-clear)
" xmap <silent> <leader>sr <plug>(scratch-selection-reuse)
" xmap <silent> <leader>sC <plug>(scratch-selection-clear)
