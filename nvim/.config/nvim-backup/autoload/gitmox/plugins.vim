let g:search_ignore_dirs = ['.git', 'node_modules']

function! gitmox#plugins#get_selected_text() abort
  try
    let regb = @z
    normal! gv"zy
    return @z
  finally
    let @z = regb
  endtry
endfunction

" Echo warning message with highlighting enabled
function! gitmox#plugins#echo_warning(message) abort
  echohl WarningMsg
  echo a:message
  echohl None
endfunction

" Resolves variable value respecting window, buffer, global hierarchy
function! gitmox#plugins#get_var(...) abort
  let varName = a:1

  if exists('w:' . varName)
    return w:{varName}
  elseif exists('b:' . varName)
    return b:{varName}
  elseif exists('g:' . varName)
    return g:{varName}
  else
    return exists('a:2') ? a:2 : ''
  endif
endfunction

" taken and modified from : https://github.com/samoshkin/dotvim
" Execute search for particular command (Grep, GrepSF, GrepFzf)
function! gitmox#plugins#execute_search(command, args, is_relative, is_path) abort
  if empty(a:args)
    call gitmox#plugins#echo_warning('Search text not specified')
    return
  endif

  let extra_args = []
  let using_ripgrep = &grepprg =~? '^rg'

  " Set global mark to easily get back after we're done with a search
  normal! mF

  " Exclude well known ignore dirs
  " This is useful for GNU grep, that does not respect .gitignore
  let ignore_dirs = gitmox#plugins#get_var('search_ignore_dirs')
  for l:dir in ignore_dirs
    if using_ripgrep
      call add(extra_args, '--glob ' . shellescape(printf('!%s/', l:dir)))
    else
      call add(extra_args, '--exclude-dir ' . shellescape(printf('%s', l:dir)))
    endif
  endfor

  " Change cwd temporarily if search is relative to the current file
  if a:is_relative
    exe 'cd ' . expand('%:p:h')
  endif


  " Execute :grep + grepprg search, show results in quickfix list
  if a:command ==# 'Grep'
    " Perform search
    if a:is_path
      silent! exe 'grep! ' . join(extra_args) . g:wiki_path . ' ' . a:args
      redraw!
    else
      silent! exe 'grep! ' . join(extra_args) . ' ' . a:args
      redraw!
    endif

    " If matches are found, open quickfix list and focus first match
    " Do not open with copen, because we have qf list automatically open on search
    if len(getqflist())
      cc
    else
      cclose
      call gitmox#plugins#echo_warning('No match found')
    endif
  endif

  " Execute search using fzf.vim + grep/ripgrep
  if a:command ==# 'GrepFzf'
    " Run in fullscreen mode, with preview at the top
    if a:is_path
    call fzf#vim#grep(printf('%s %s --color=always %s ' . g:wiki_path, &grepprg, join(extra_args), a:args),
          \ 1,
          \ fzf#vim#with_preview('up:60%'),
          \ 1)
    else
    call fzf#vim#grep(printf('%s %s --color=always %s', &grepprg, join(extra_args), a:args),
          \ 1,
          \ fzf#vim#with_preview('up:60%'),
          \ 1)
    endif
  endif

  " Restore cwd back
  if a:is_relative
    exe 'cd -'
  endif
endfunction

" Initial search, prepare command using selected backend and context for the search
" Contexts are: word, selection, last search pattern
function! gitmox#plugins#prepare_search_command(context, backend) abort
  let text = a:context ==# 'word' ? expand('<cword>')
        \ : a:context ==# 'selection' ? gitmox#plugins#get_selected_text()
        \ : a:context ==# 'search' ? @/
        \ : ''

  " Properly escape search text
  " Remove new lines (when several lines are visually selected)
  let text = substitute(text, '\n', '', 'g')

  " Escape backslashes
  let text = escape(text, '\')

  " Put in double quotes
  let text = escape(text, '"')
  let text = empty(text) ? text : '"' . text . '"'

  " Grep/ripgrep args
  " Always search literally, without regexp
  " Use word boundaries when context is 'word'
  let args = [a:backend ==# 'GrepSF' ? '-L' : '-F']
  if a:context ==# 'word'
    call add(args, a:backend ==# 'GrepSF' ? '-W' : '-w')
  endif

  if a:backend ==# 'Grep'
    copen
  endif

  " Compose ':GrepXX' command to put on a command line
  let search_command = ":\<C-u>" . a:backend
  let search_command .= empty(args) ? ' ' : ' ' . join(args, ' ') . ' '
  let search_command .= '-- ' . text

  " Put actual command in a command line, but do not execute
  " User would initiate a search manually with <CR>
  call feedkeys(search_command, 'n')
endfunction
