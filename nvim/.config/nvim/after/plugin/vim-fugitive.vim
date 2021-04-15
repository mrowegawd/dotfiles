if !PluginLoaded('vim-fugitive')
  finish
endif

" keymap: [plugin][git][fugitive] open GitStatus
nnoremap <silent> <localleader>gs    :G<CR>gg<c-n>

" keymap: [plugin][git][fugitive] open git split vertial
nnoremap <silent> <localleader>gS    :Gvdiffsplit<CR><c-w>w

" keymap: [plugin][git][fugitive] open git split vertial
" nnoremap <silent> <localleader>gfs   :FzfGitStatus<CR>

if PluginLoaded('git-messenger.vim')
  " keymap: [plugin][git][fugitive][visual] open Gblame short
  nnoremap <silent> <localleader>gP   :GitMessenger<CR>
endif

" keymap: [plugin][git][fugitive] close from diff fugitive
nmap <silent> <localleader>gq    <c-w>h<c-w>c

" keymap: [plugin][git][fugitive][quickfix] open gclog
nnoremap <silent> <localleader>gcl   :Gclog<CR>

" keymap: [plugin][git][fugitive][quickfix] open gclog commit current file
nnoremap <silent> <localleader>gcc   :Gclog -- %<CR>

" keymap: [plugin][git][fugitive][quickfix] open gclog history current file
nnoremap <silent> <localleader>gcf   :0Gclog<CR>

" keymap: [plugin][git][fugitive] open Gblame
nnoremap <silent> <localleader>gbl   :Gblame<CR>

" keymap: [plugin][git][fugitive][visual] open Gblame short
vnoremap <silent> <localleader>gbv   :Gblame --date=short<CR>

" command! -bang FzfGitStatus  call fzf#vim#gitfiles('?', { "placeholder": "", "options": ["--preview-window", "right:60%"] }, <bang>0)
command! GpushF :Gpush --force-with-lease
command! -nargs=0 Gcm :G checkout master
command! -nargs=1 Gcb :G checkout -b <q-args>

function! s:fugitive_settings() abort
  setlocal nonumber
  " keymap: [plugin][git][fugitive][inside] filter next
  nnoremap <expr> <buffer> } filter([search('\%(\_^#\?\s*\_$\)\\|\%$', 'W'), line('$')], 'v:val')[0].'G'
  " keymap: [plugin][git][fugitive][inside] filet prev
  nnoremap <expr> <buffer> { max([1, search('\%(\_^#\?\s*\_$\)\\|\%^', 'bW')]).'G'
  " keymap: [plugin][git][fugitive][inside] help
  nmap <silent> <buffer> <leader>? :<C-U>call <SID>fugitivehelp()<CR>

  if expand('%') =~# 'COMMIT_EDITMSG'
    setlocal spell
    " delete the commit message storing it in "g, and go back to Gstatus
    " keymap: [plugin][[git]fugitive][inside] delete commit msg storing t in "g
    nnoremap <silent> <buffer> Q gg"gd/#<cr>:let @/=''<cr>:<c-u>wq<cr>:Gstatus<cr>:call histdel('search', -1)<cr>
    " Restore register "g
    " keymap: [plugin][git][fugitive][inside] restore register "g
    nnoremap <silent> <buffer> <leader>u gg"gP
  endif
endfunction

function! s:fugitivehelp()
  echo "\n"
  echo '====Stagging===='
  echo ' a                     unstaging/stagged'
  echo ' U                     unstagging everything'
  echo ' u                     stagging: set as unstagging (reset) hunk'
  echo ' =                     toggle inline diff'
  echo "\n"
  echo '====Diff===='
  echo ' dd/dv                 open diff split'
  echo ' d?                    show help commands diff'
  echo ' <localleader>gq       quit from diff (inside diff window)'
  echo "\n"
  echo '====Commit===='
  echo ' cc                    commit git'
  echo "\n"
  echo '====Misc===='
  echo ' <anyNumber>gI         add to .gitignore (from under cursor)'
  echo "\n"
  echo ' <leader>?             show help'
  echo "\n"
endfunction

augroup vimrc_fugitive
  autocmd!
  autocmd FileType fugitive call s:fugitive_settings()
  autocmd BufReadPost fugitive:///*//2/*,fugitive:///*//3/* setlocal nomodifiable readonly
augroup END
