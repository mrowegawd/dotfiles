scriptencoding utf-8

if !has_key(g:plugs, 'vim-signify')
  finish
endif

let g:signify_vcs_list               = ['git']
" let g:signify_sign_change            = 'm'
" let g:signify_sign_add               = '＋'
" let g:signify_sign_delete            = '～'
" let g:signify_sign_delete_first_line = g:signify_sign_delete
" let g:signify_sign_show_count        = 0

let g:signify_sign_add = '▋'
let g:signify_sign_change = '▋'
let g:signify_sign_delete = '▋'
let g:signify_sign_delete_first_line = '▘'
let g:signify_sign_show_count = 0

" keymap: [plugin][git][signify] show hunk git
nnoremap <silent> <localleader>gh          :SignifyHunkDiff<CR>

" keymap: [plugin][git][signify] undo hunk git
nnoremap <silent> <localleader>gU          :SignifyHunkUndo<CR>

" keymap: [plugin][git][signify] find next hunk git
nmap <silent> <A-DOWN>                     <plug>(signify-next-hunk):normal zz<CR>

" keymap: [plugin][git][signify] find prev hunk git
nmap <silent> <A-UP>                       <plug>(signify-prev-hunk):normal zz<CR>
