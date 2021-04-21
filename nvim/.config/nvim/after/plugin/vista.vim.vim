scriptencoding utf-8

if !PluginLoaded('vista.vim')
  finish
endif

" keymap: [plugin][vista][toggle] open
nnoremap <silent> <leader>b      :Vista!!<cr>

" nnoremap <silent> <localleader>av      :Vista!!<cr>

let g:vista_icon_indent            = ['╰─▸ ', '├─▸ ']
let g:vista_vimwiki_executive      = 'markdown'
let g:vista_update_on_text_changed = 1
let g:vista_disable_statusline     = 1
let g:vista_close_on_jump = 1

let g:vista_keep_fzf_colors        = 1
