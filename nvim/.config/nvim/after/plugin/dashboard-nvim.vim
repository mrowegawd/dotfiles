scriptencoding utf-8

if !PluginLoaded('dashboard-nvim')
  finish
endif

" keymap: [plugin][dashboard] open
nnoremap <silent> <localleader>yy :Dashboard<cr>

" keymap: [plugin][dashboard][session] save
nmap <localleader>ss :<C-U>SessionSave<CR>

" keymap: [plugin][dashboard][session] load
nmap <localleader>sl :<C-U>SessionLoad<CR>

" let g:dashboard_preview_file = $HOME . '/.config/nvim/static/neovim.cat'
" let g:dashboard_preview_file_height = 12
" let g:dashboard_preview_command = 'cat'
" let g:dashboard_preview_pipeline = 'lolcat'
" let g:dashboard_preview_file_width = 80

let g:dashboard_custom_header = [
      \'  ██████╗ ██╗████████╗███╗   ███╗ ██████╗ ██╗  ██╗',
      \' ██╔════╝ ██║╚══██╔══╝████╗ ████║██╔═══██╗╚██╗██╔╝',
      \' ██║  ███╗██║   ██║   ██╔████╔██║██║   ██║ ╚███╔╝',
      \' ██║   ██║██║   ██║   ██║╚██╔╝██║██║   ██║ ██╔██╗',
      \' ╚██████╔╝██║   ██║   ██║ ╚═╝ ██║╚██████╔╝██╔╝ ██╗',
      \'  ╚═════╝ ╚═╝   ╚═╝   ╚═╝     ╚═╝ ╚═════╝ ╚═╝  ╚═╝'
      \]

" let g:dashboard_custom_footer = ['chrisatmachine.com']
let g:dashboard_custom_shortcut = {
      \ 'last_session'       : 'SPC s l',
      \ 'find_history'       : 'SPC f h',
      \ 'find_file'          : 'SPC f f',
      \ 'new_file'           : 'SPC c n',
      \ 'change_colorscheme' : 'SPC t c',
      \ 'find_word'          : 'SPC f a',
      \ 'book_marks'         : 'SPC f b',
      \ }
