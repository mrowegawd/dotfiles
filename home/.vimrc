" --------------------------------
"░█░█░▀█▀░█▄█░█▀▄░█▀▀░░░░█▀▄░█▀▀ +
"░▀▄▀░░█░░█░█░█▀▄░█░░░░░░█▀▄░█░░ +
"░░▀░░▀▀▀░▀░▀░▀░▀░▀▀▀░▀░░▀░▀░▀▀▀ +
" --------------------------------

set encoding=utf-8
scriptencoding utf-8
set linespace=5

" FIRSTLOAD ----------------------------------------------------------------- {{{
let $VARPATH = expand(($XDG_CACHE_HOME ? $XDG_CACHE_HOME : '~/.cache').'/vim')

if !isdirectory(expand($VARPATH))
  call mkdir($VARPATH. '/sessions', 'p')
  call mkdir($VARPATH. '/undo', 'p')
  call mkdir($VARPATH. '/backup', 'p')
  call mkdir($VARPATH. '/swap', 'p')
  call mkdir($VARPATH. '/view', 'p')
endif

" some plugin seems to search for something at startup, so this fixes that.
silent! nohlsearch

syntax enable
"
" }}}

exec 'source ' . $HOME . '/.config/vimlocal/settings.vim'
exec 'source ' . $HOME . '/.config/vimlocal/mapping.vim'
exec 'source ' . $HOME . '/.config/vimlocal/abbrevations.vim'

set background=dark
