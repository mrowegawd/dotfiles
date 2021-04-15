if !PluginLoaded('vim-test')
  finish
endif

if has('nvim')
  let test#strategy = "neovim"
else
  let test#strategy = "vimterminal"
endif
let test#neovim#term_position = "vert botright"

" keymap: [plugin][vim-test] TestFile
nnoremap <silent> <localleader>tf :TestFile<CR>

" keymap: [plugin][vim-test] TestNearest
nnoremap <silent> <localleader>tn :TestNearest<CR>

" keymap: [plugin][vim-test] TestSuite --verbose
nnoremap <silent> <localleader>ts :TestSuite<CR>

" Vim-test
" nnoremap <silent> t<C-n> :w <BAR> TestNearest<CR>

" nnoremap <silent> t<C-f> :w <BAR> TestFile<CR>

" keymap: [plugin][vim-test] TestSuite --verbose
" nnoremap <silent> t<C-s> :w <BAR> TestSuite --verbose<CR>

" keymap: [plugin][vim-test] TestLast
" nnoremap <silent> t<C-l> :w <BAR> TestLast<CR>

" keymap: [plugin][vim-test] TestVisit
" nnoremap <silent> t<C-g> :w <BAR> TestVisit<CR>
