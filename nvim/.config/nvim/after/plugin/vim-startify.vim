if !PluginLoaded('vim-startify')
  finish
endif

" keymap: [plugin][startify] open
nnoremap <silent> <localleader>yy :Startify<cr>

" keymap: [plugin][startify][session] load
nnoremap <localleader>sl :SLoad!<CR>

" keymap: [plugin][startify][session] save
nnoremap <localleader>ss :SSave!<CR>

" keymap: [plugin][startify][session] delete
nnoremap <localleader>sr :SDelete!<CR>

" keymap: [plugin][startify][session] close
nnoremap <localleader>sc :SClose!<CR>

function! ExplorerStartify()
  execute 'Startify'
  " execute 'call ToggleCocExplorer()'
endfunction

function! s:startify_mappings() abort
  " keymap: [plugin][startify][inside] open buffer
  nmap <silent> <buffer> o <CR>

  " keymap: [plugin][startify][inside] wincmd
  nmap <silent> <buffer> h :wincmd h<CR>
endfunction

if has_key(g:plugs, 'vim-startify')
  augroup startifyCustom
    autocmd VimEnter *
          \   if !argc()
          \ |   call ExplorerStartify()
          \ | endif
    autocmd FileType startify call s:startify_mappings()
    " on Enter
    " autocmd User Startified nmap <silent><buffer> <CR> <plug>(startify-open-buffers):call ToggleCocExplorer()<CR>
  augroup END
endif

let s:header = [
      \'  ██████╗ ██╗████████╗███╗   ███╗ ██████╗ ██╗  ██╗',
      \' ██╔════╝ ██║╚══██╔══╝████╗ ████║██╔═══██╗╚██╗██╔╝',
      \' ██║  ███╗██║   ██║   ██╔████╔██║██║   ██║ ╚███╔╝',
      \' ██║   ██║██║   ██║   ██║╚██╔╝██║██║   ██║ ██╔██╗',
      \' ╚██████╔╝██║   ██║   ██║ ╚═╝ ██║╚██████╔╝██╔╝ ██╗',
      \'  ╚═════╝ ╚═╝   ╚═╝   ╚═╝     ╚═╝ ╚═════╝ ╚═╝  ╚═╝'
      \]

" let s:footer = [
"       \ '+-------------------------------------------+',
"       \ '|            ThinkVim ^_^                   |',
"       \ '|    Talk is cheap Show me the code         |',
"       \ '+-------------------------------------------+',
"       \ ]

if has('nvim')
  " let g:startify_session_dir = g:mysess_dir . getcwd()
" else
  let g:startify_session_dir = expand('~/.cache/vim/sessions/')
endif

" Taken from: https://github.com/mhinz/vim-startify/issues/320
" make vim-startify and vim-obsession work together a bit more closely by letting vim-obsession write/handle the session after each save.
" One way is by replacing the SSave command:
if PluginLoaded('vim-obsession')
  command! -nargs=? -bar -bang -complete=customlist,startify#session_list SSave
        \ call startify#session_save(<bang>0, <f-args>) |
        \ if !empty(v:this_session) |
        \   execute "Obsession " . v:this_session |
        \ endif
endif

let g:startify_files_number           = 5
let g:startify_update_oldfiles        = 1
let g:startify_session_autoload       = 1
" let g:startify_session_persistence  = 1 " autoupdate sessions
let g:startify_session_delete_buffers = 1 " delete all buffers when loading or closing a session, ignore unsaved buffers
let g:startify_change_to_dir          = 0 " when opening a file or bookmark, change to its directory
let g:startify_fortune_use_unicode    = 1 " beautiful symbols
let g:startify_padding_left           = 3 " the number of spaces used for left padding
let g:startify_session_remove_lines   = ['setlocal', 'winheight'] " lines matching any of the patterns in this list, will be removed from the session file
let g:startify_session_sort           = 1 " sort sessions by alphabet or modification time

let g:startify_custom_indices         = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12', '13', '14', '15', '16', '17', '18'] " MRU indices

if has('nvim')

  let g:startify_commands = [
      \ {'pu': ['Update plugins',':PlugUpdate | PlugUpgrade']},
      \ {'ps': ['Plugins status', ':PlugStatus']},
      \ {'h':  ['Help', ':help']}
      \ ]
endif

let g:startify_lists = [
      \ { 'type': 'dir',       'header': [" \uf0f3 Current Files in ". getcwd()] },
      \ { 'type': 'files',     'header': [" \uf059 History"]            },
      \ { 'type': 'sessions',  'header': [" \ue62e Sessions"]       },
      \ { 'type': 'bookmarks', 'header': [" \uf5c2 Bookmarks"]      },
      \ { 'type': 'commands',  'header': [" \uf085 Commands"]       },
      \ ]

function! s:center(lines) abort
  let longest_line   = max(map(copy(a:lines), 'strwidth(v:val)'))
  let centered_lines = map(copy(a:lines),
        \ 'repeat(" ", (&columns / 4) - (longest_line / 1)) . v:val')
  return centered_lines
endfunction

let g:startify_custom_header = s:center(s:header)
" let g:startify_custom_footer = s:center(s:footer)

" list of commands to be executed before save a session
let g:startify_session_before_save = [
      \ 'echo "Cleaning up before saving.."',
      \ ]

" MRU skipped list, do not use ~
let g:startify_skiplist = [
      \ '/mnt/*',
      \ ]

" let g:startify_bookmarks = [
"             \ {'V': '~/moxconf/vimwiki/index.wiki'},
"             \ {'P': '~/Documents/PlayGround/'},
"             \ {'c': '~/.config/nvim/config/plugins.vim'},
"             \ {'c': '~/.tmux.conf'}
"             \ ]
