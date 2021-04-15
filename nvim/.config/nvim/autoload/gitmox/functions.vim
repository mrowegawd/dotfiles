function! gitmox#functions#check_filetype() abort
  if (index(['vim', 'help'], &filetype) >= 0)
    return 0
  else
    return 1
  end
endfunction

function! gitmox#functions#foldall() abort
  if &foldlevel
    set foldlevel=0
  else
    set foldlevel=99
  endif
endfunction

let s:test_list = 1
function! gitmox#functions#setlist() abort
  if s:test_list
    set nolist
    :echom 'list disabled'
    let s:test_list = 0
  else
    set list
    :echom 'list enabled'
    let g:test_list = 1
  endif
endfunction


let s:hidden_all = 0
function! gitmox#functions#hidestatusline() abort
  if s:hidden_all  == 0
    let s:hidden_all = 1
    set noshowmode
    set noruler
    set laststatus=0
    set noshowcmd
  else
    let s:hidden_all = 0
    set showmode
    set ruler
    set laststatus=2
    set showcmd
  endif
endfunction

" Loosely based on: http://vim.wikia.com/wiki/Make_views_automatic
" from https://github.com/wincent/wincent/blob/c87f3e1e127784bb011b0352c9e239f9fde9854f/roles/dotfiles/files/.vim/autoload/autocmds.vim#L20-L37
function! gitmox#functions#should_mkview() abort
  return &buftype ==# '' &&
        \ getcmdwintype() ==# '' &&
        \ index(g:ColorColumnFileTypeBlacklist, &filetype) == -1 &&
        \ !exists('$SUDO_USER') " Don't create root-owned files.
endfunction

function! gitmox#functions#mkview() abort
  if exists('*haslocaldir') && haslocaldir()
    " We never want to save an :lcd command, so hack around it...
    cd -
    mkview
    lcd -
  else
    mkview
  endif
endfunction
