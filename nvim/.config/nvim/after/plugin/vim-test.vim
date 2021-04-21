if !PluginLoaded('vim-test')
  finish
endif

if has('nvim')
  let test#strategy = "neovim"
else
  let test#strategy = "vimterminal"
endif

let test#neovim#term_position = "vert botright"

" keymap: [plugin][vim-test] Run a test nearest to the cursor
nmap <silent> <localleader>tf :TestFile<CR>

" keymap: [plugin][vim-test] Run tests for the current file
nmap <silent> <localleader>tn :TestNearest -strategy=ToggleTerm<CR>

" keymap: [plugin][vim-test] Run all test for all projects command
nmap <silent> <localleader>ts :TestSuite<CR>

" keymap: [plugin][vim-test] Run the last test command
nmap <silent> <localleader>tl :TestLast<CR>

" keymap: [plugin][vim-test] Open the last run test in the current buffer
nmap <silent> <localleader>tg :TestVisit<CR>

" nnoremap <silent> t<C-n> :w <BAR> TestNearest<CR>

" nnoremap <silent> t<C-f> :w <BAR> TestFile<CR>

" keymap: [plugin][vim-test] TestSuite --verbose
" nnoremap <silent> t<C-s> :w <BAR> TestSuite --verbose<CR>

" keymap: [plugin][vim-test] TestLast
" nnoremap <silent> t<C-l> :w <BAR> TestLast<CR>

" keymap: [plugin][vim-test] TestVisit
" nnoremap <silent> t<C-g> :w <BAR> TestVisit<CR>
