scriptencoding UTF-8    " Default encoding for current script.

let s:ColorColumnBufferNameBlacklist = ['__LanguageClient__']
let g:ColorColumnFileTypeBlacklist = [
        \ 'LspTrouble',
        \ 'LuaTree',
        \ 'NvimTree',
        \ 'TelescopePrompt',
        \ 'cekdulu',
        \ 'coc-explorer',
        \ 'command-t',
        \ 'dashboard',
        \ 'diff',
        \ 'fugitive',
        \ 'fugitiveblame',
        \ 'gitcommit',
        \ 'help',
        \ 'list',
        \ 'qf',
        \ 'sagahover',
        \ 'startify',
        \ 'tagbar',
        \ 'undotree',
        \ ]

function! gitmox#themes#color_EndOfFIle() abort
  setl colorcolumn=
  " hi! link EndOfBuffer Normal
endfunction

function! gitmox#themes#shouldcolumn() abort
  if index(s:ColorColumnBufferNameBlacklist, bufname(bufnr('%'))) != -1
    return 0
  endif
  return index(g:ColorColumnFileTypeBlacklist, &filetype) == -1
endfunction

function! gitmox#themes#extract_hi(group, fbbg) abort
  return synIDattr(synIDtrans(hlID(a:group)), a:fbbg)
endfunction

let s:CursorlineBlacklist = ['command-t']
function! gitmox#themes#should_cursorline() abort
  return index(s:CursorlineBlacklist, &filetype) == -1
endfunction

let s:custom_statusline = ['list', 'F', 'LuaTree']
function! gitmox#themes#custom_quickfix_setcolor() abort
  if (index(s:custom_statusline, &filetype)>= 0)
    exec 'hi! CursorLine guibg=grey'
  endif

endfunction

function! gitmox#themes#endbuffer() abort
  if (index(s:custom_statusline, &filetype)>= 0)
    exec 'hi! CursorLine guibg='.gitmox#themes#extract_hi('Normal', 'bg')
  endif
endfunction

function! gitmox#themes#custom_quickfix_backorigin() abort
  if (index(s:custom_statusline, &filetype)>= 0)
    exec 'hi! CursorLine guibg='.gitmox#themes#extract_hi('Normal', 'bg')
  endif
endfunction

function! gitmox#themes#inactiveline() abort
  return luaeval("require'modules._statusline'.inActiveLine()")
endfunction

function! gitmox#themes#activeline() abort
  return luaeval("require'modules._statusline'.activeLine()")
endfunction
