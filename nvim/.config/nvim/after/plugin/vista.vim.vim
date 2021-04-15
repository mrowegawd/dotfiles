scriptencoding utf-8

if !PluginLoaded('vista.vim')
  finish
endif

" keymap: [plugin][vista][toggle] open
nnoremap <silent> <localleader>av      :Vista!!<cr>

let g:vista_icon_indent          = ['╰─▸ ', '├─▸ ']
let g:vista_vimwiki_executive    = 'markdown'
let g:vista_sidebar_keepalt      = 1
let g:vista#renderer#enable_icon = 1
let g:vista_disable_statusline   = 1
let g:vista_echo_cursor_strategy = 'floating_win'

" let g:vista_default_executive    = 'nvim_lsp'
" let g:vista_sidebar_position     = 'vertical topright 15'
" let g:vista_fzf_preview          = ['right:100%']
let g:vista_keep_fzf_colors      = 1
