scriptencoding utf-8

if !PluginLoaded('goyo.vim')
  finish
endif

let g:goyo_margin_top = 2
let g:goyo_margin_bottom = 2
" let g:goyo_width = '60%'
let g:goyo_width = 80

function! s:goyo_enter()
  if has('gui_running')
    set fullscreen
    set background=light
    set linespace=7
  elseif exists('$TMUX')
    silent !tmux set status off
  endif
  " Limelight
  let &l:statusline = '%M'
  hi StatusLine ctermfg=red guifg=red cterm=NONE gui=NONE
endfunction

function! s:goyo_leave()
  if has('gui_running')
    set nofullscreen
    set background=dark
    set linespace=0
  elseif exists('$TMUX')
    silent !tmux set status on
  endif
  " Limelight!
endfunction

augroup GoyoLeaveEnter
  autocmd!
  autocmd! User GoyoLeave nested call <SID>goyo_leave()
  autocmd! User GoyoEnter nested call <SID>goyo_enter()
augroup END

" keymap: [plugin][goyo][toggle] open
nnoremap <silent> <localleader>ag :Goyo<CR>

" function! s:auto_goyo() abort
"   let fts = ['markdown', 'vimwiki']
"   if index(fts, &filetype) >= 0
"     Goyo 120
"   elseif exists('#goyo')
"     let bufnr = bufnr('%')
"     Goyo!
"     call execute('buffer '.bufnr)
"     doautocmd ColorScheme,BufEnter,WinEnter
"   endif
" endfunction

" augroup automatic_goyo
"   autocmd!
  " BUG:
  " 1. s:auto_goyo cannot be called in a nested autocommand
  " as this causes an infinite loop because of a FileType autocommand
  " so the function manually triggers necessary autocommands
  " 2. Floating windows cause this to break BADLY
  " autocmd BufEnter * call s:auto_goyo()
" augroup END
