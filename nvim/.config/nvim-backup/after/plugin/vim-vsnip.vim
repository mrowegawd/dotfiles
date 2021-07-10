scriptencoding utf-8

if !PluginLoaded('vim-vsnip')
  finish
endif

" imap <expr> <C-j> vsnip#available(1) ? '<Plug>(vsnip-expand-or-jump)' : '<C-k>'
" smap <expr> <C-j> vsnip#available(1) ? '<Plug>(vsnip-expand-or-jump)' : '<C-k>'
" imap <expr> <C-k> vsnip#available(-1) ? '<Plug>(vsnip-jump-prev)' : '<C-j>'
" smap <expr> <C-k> vsnip#available(-1) ? '<Plug>(vsnip-jump-prev)' : '<C-j>'

" keymap: [plugin][vsnip][insert] expand or jump forward
" imap <expr> <Tab> vsnip#available(1)      ?    '<Plug>(vsnip-expand-or-jump)' : '<Tab>'

" keymap: [plugin][vsnip][selection] expand or jump forward
" smap <expr> <Tab> vsnip#available(1)      ?    '<Plug>(vsnip-expand-or-jump)' : '<Tab>'

" keymap: [plugin][vsnip][insert] expand or jump backward
" imap <expr> <S-Tab> vsnip#available(-1)   ?    '<Plug>(vsnip-jump-prev)'      : '<S-Tab>'

" keymap: [plugin][vsnip][selection] expand or jump backward
" smap <expr> <S-Tab> vsnip#available(-1)   ?    '<Plug>(vsnip-jump-prev)'      : '<S-Tab>'

" imap <expr> <Tab> pumvisible() ? "\<C-n>" : vsnip#jumpable(1) ? '<Plug>(vsnip-jump-next)' : '<Tab>'
" smap <expr> <Tab> pumvisible() ? "\<C-n>" : vsnip#jumpable(1) ? '<Plug>(vsnip-jump-next)' : '<Tab>'
" imap <expr> <S-Tab> pumvisible() ? "\<C-p>" : vsnip#jumpable(-1) ? '<Plug>(vsnip-jump-prev)' : '<S-Tab>'
" smap <expr> <S-Tab> pumvisible() ? "\<C-p>" : vsnip#jumpable(-1) ? '<Plug>(vsnip-jump-prev)' : '<S-Tab>'


" let g:vsnip_filetypes.typescriptreact = ['typescript']
