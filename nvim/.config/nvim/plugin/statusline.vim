set encoding=UTF-8      " Default encoding. (vim-only)
scriptencoding UTF-8    " Default encoding for current script.
set fileformats=unix    " Only use Unix end-of-line format.

augroup MyAuGrup
  autocmd!

  " Add trigger auto completion for nvim-dap
  if PluginLoaded('nvim-dap')
    au FileType dap-repl lua require('dap.ext.autocompl').attach()
  end

  if PluginLoaded('nvim-toggleterm.lua')
    au FileType ToggleTerm setlocal nonumber norelativenumber
  end

  au FileType vista setlocal winhl=Normal:ColorColumn

  " Disable tabline when enter startify
  " au FileType startify,dashboard set showtabline=0 | au WinLeave <buffer> set showtabline=2

  " Automatically strip trailing spaces on save..
  au BufWritePre * :%s/\s\+$//e

  " Forcing bufwrite .vimrc source %
  au BufNewFile,BufRead,InsertLeave * silent! match ExtraWhitespace /\s\+$/

  " Automatically set read-only for files being edited elsewhere
  au SwapExists * nested let v:swapchoice='o'

  " Check if file changed when its window is focus, more eager than 'autoread'
  " au WinEnter,FocusGained * checktime
  au Syntax * if 5000 < line('$') | syntax sync minlines=200 | endif

  " Open help window auto vertical
  au BufEnter *.txt if &buftype == 'help' | wincmd L | endif

  " Update filetype on save if empty
  au BufWritePost * nested
        \ if &l:filetype ==# '' || exists('b:ftdetect')
        \ |   unlet! b:ftdetect
        \ |   filetype detect
        \ | endif

  " Uncomment the following to have Vim jump to the last position when
  " reopening a file
  if has('autocmd')
    " au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

    " Like the autocmd described in `:h last-position-jump` but we add `:foldopen!`.
    autocmd BufWinEnter * if line("'\"") > 1 && line("'\"") <= line('$') |
          \ execute "normal! g`\"" |
          \ execute 'silent! ' . line("'\"") . 'foldopen!' |
          \ endif
  else
    autocmd BufWinEnter * if line("'\"") > 1 && line("'\"") <= line('$') |
          \ execute "normal! g`\"" |
          \ endif
  endif

  " Disable paste and/or update diff when leaving insert mode
  au InsertLeave *
        \ if &paste | setlocal nopaste mouse=a | echo 'nopaste' | endif |
      \ if &l:diff | diffupdate | endif

  au TabLeave * let g:lasttab = tabpagenr()

  " Automatically make splits equal in size
  au VimResized * exe "normal! \<c-w>="

  " http://vim.wikia.com/wiki/Detect_window_creation_with_WinEnter
  au VimEnter * autocmd WinEnter * let w:created=1

  " Highlight TODO, FIXME, NOTE, etc.
  au Syntax * call matchadd('Todo', '\W\zs\(TODO\|FIXME\|CHANGED\|BUG\|HACK\)')
  au Syntax * call matchadd('Debug', '\W\zs\(NOTE\|INFO\|IDEA\)')

  " Statusline
  if has('nvim')
    " Make current window more obvious by turning off/adjusting some features in non-current windows.
    if exists('+winhighlight')
      au BufEnter,FocusGained,VimEnter,WinEnter * set winhighlight=
      au FocusLost,WinLeave * set winhighlight=CursorLineNr:LineNr,IncSearch:ColorColumn,Normal:ColorColumn,NormalFloat:Normal,SignColumn:ColorColumn,EndOfBuffer:ColorColumn,
      " NormalNC:ColorColumn,

      if exists('+colorcolumn')
        au BufEnter,FocusGained,VimEnter,WinEnter * if gitmox#themes#shouldcolumn() |
              \ let &l:colorcolumn='+' . join(range(0, 254), ',+') |
              \ else |
              \ call gitmox#themes#color_EndOfFIle() |
              \ endif
      endif

    elseif exists('+colorcolumn')
      au BufEnter,FocusGained,VimEnter,WinEnter * if gitmox#themes#shouldcolumn() |
            \ let &l:colorcolumn='+' . join(range(0, 254), ',+') |
            \ else |
            \ call gitmox#themes#color_EndOfFIle() |
            \ endif
    endif

    au BufEnter,FocusGained,VimEnter,WinEnter * if gitmox#themes#shouldcolumn() |
          \ setlocal cursorline                                                 |
          \ setlocal statusline=%!gitmox#themes#activeline()                    |
          \ call gitmox#themes#custom_quickfix_setcolor()                       |
          \ hi! link EndOfBuffer ColorColumn |
          \ else |
          \ hi! link EndOfBuffer Normal |
          \ endif

    au FocusLost,WinLeave * if gitmox#themes#shouldcolumn()                     |
          \ setlocal nocursorline                                               |
          \ setlocal statusline=%!gitmox#themes#inactiveline()                  |
          \ call gitmox#themes#custom_quickfix_backorigin()                     |
          \ endif
  endif
augroup END
