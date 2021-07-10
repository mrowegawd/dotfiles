" turn on highlight syntax code block
" packadd vim-polyglot

setl spelllang=id,en
setl spell

setl noautoindent
setl nocindent smarttab
setl nosmartindent

setl indentexpr=
setl conceallevel=1
setl concealcursor=
setl foldlevel=1

setl foldlevel=1
setl foldenable
setl foldmethod=expr
setl foldexpr=Fold(v:lnum)
" setlocal nonumber norelativenumber

let g:vimwiki_fold_blank_lines = 0  " set to 1 to fold blank lines
let g:vimwiki_header_type = '#'     " set to '=' for wiki syntax

command! ClearTabs call s:clearTabs()

augroup callToggle
  autocmd!

  if PluginLoaded('vim-rainbow')
    au WinEnter,BufEnter,VimEnter *.md call s:turnOfToggle()
  end

  " au BufFilePost *.md set ft=markdown
augroup END

function! s:turnOfToggle() abort
  exec ':RainbowToggleOff'
endfunction

function! s:clearTabs() abort
  exec ':%s/\t/  /g'
endfunction

" keymap: [plugin][vimwiki] follow link
nmap <buffer> <silent> <CR> <Plug>VimwikiFollowLink

" keymap: [plugin][vimwiki] open link in tertical
nmap <buffer> <silent> <C-CR> <Plug>VimwikiSplitLink

" keymap: [plugin][vimwiki] go back prev visited wiki page
nmap <buffer> <silent> <Backspace> <Plug>VimwikiGoBackLink

" keymap: [plugin][vimwiki] delete
nmap <buffer> <silent> <localleader>wD <Plug>VimwikiDeleteFile

" keymap: [plugin][vimwiki] rename
nmap <buffer> <silent> <localleader>wR <Plug>VimwikiRenameFile

" keymap: [plugin][vimwiki] open volume vertical
nmap <buffer> <silent> <localleader>wv <Plug>VimwikiVSplitLink

" keymap: [plugin][vimwiki] diary index
nmap <buffer> <silent> <localleader>wdm <Plug>VimwikiMakeDiaryNote

" keymap: [plugin][vimwiki] toggle list
nmap <buffer> <silent> <C-space> <Plug>VimwikiToggleListItem

" nnoremap <buffer> <silent> <localleader>fg :ZettelOpen<cr>

" keymap: [plugin][vimwiki] search keyword with zettel
nnoremap <buffer> <silent> <localleader>fg :GrepWikis<CR>

" keymap: [plugin][vimwiki] find wiki files
nnoremap <buffer> <silent> <localleader>ff :FindWikis<CR>

command! FindWikis lua require'plugins._telescope'.findWikis()
command! GrepWikis lua require'plugins._telescope'.grepWikisPrompt()

function! Fold(lnum)
  let fold_level = strlen(matchstr(getline(a:lnum), '^' . g:vimwiki_header_type . '\+'))
  if (fold_level)
    return '>' . fold_level  " start a fold level
  endif
  if getline(a:lnum) =~? '\v^\s*$'
    if (strlen(matchstr(getline(a:lnum + 1), '^' . l:vimwiki_header_type . '\+')) > 0 && !g:vimwiki_fold_blank_lines)
      return '-1' " don't fold last blank line before header
    endif
  endif
  return '=' " return previous fold level
endfunction
