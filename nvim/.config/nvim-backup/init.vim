scriptencoding UTF-8    " Default encoding for current script.

if v:progname ==? 'vi'
  set noloadplugins
endif

" set encoding=UTF-8      " Default encoding. (vim-only)
" set fileformats=unix    " Only use Unix end-of-line format.


let g:mytheme = 'base16-gruvbox-dark-medium'
let g:myguibg_active = '#282828'
let g:myguibg_non = '#1f1f1f'
let g:vim_dir                                = $HOME . '/.config/nvim'
let g:mycache_dir                            = $HOME . '/.cache'

if has('nvim')
  let g:mysess_dir                           = g:mycache_dir . '/nvim/sessions'
endif

let plugpath                                 = expand('~/.local/share/nvim/site/autoload/plug.vim')

if has('nvim')
  let g:python_host_prog                     = $HOME . '/.config/neovim2/bin/python'
  let g:python3_host_prog                    = $HOME . '/.config/neovim3/bin/python'

  let $VARPATH                               = expand(($XDG_CACHE_HOME ? $XDG_CACHE_HOME : '~/.cache') . '/nvim')
else
  let $VARPATH                               = expand(($XDG_CACHE_HOME ? $XDG_CACHE_HOME : '~/.cache') . '/vim')
endif

runtime plugins.vim
exec 'source ' . $HOME . '/.config/vimlocal/settings.vim'
exec 'source ' . $HOME . '/.config/vimlocal/mapping.vim'
exec 'source ' . $HOME . '/.config/vimlocal/abbrevations.vim'

execute 'colorscheme '. g:mytheme
set background=dark
