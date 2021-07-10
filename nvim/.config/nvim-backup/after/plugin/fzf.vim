if !PluginLoaded('fzf.vim')
  finish
endif

" NOTE: Search syntax on fzf
"       https://github.com/junegunn/fzf#search-syntax
" sbtrkt    fuzzy-match                   Items that match sbtrkt
" 'wild     exact-match (quoted)          Items that include wild
" ^music    prefix-exact-match            Items that start with music
" .mp3$     suffix-exact-match            Items that end with .mp3
" !fire     inverse-exact-match           Items that do not include fire
" !^music   inverse-prefix-exact-match    Items that do not start with music
" !.mp3$    inverse-suffix-exact-match    Items that do not end with .mp3

" keymap: [plugin][fzf] open Files
nnoremap <silent> <localleader>ff      :Files<CR>

" keymap: [plugin][fzf] open Buffers
nnoremap <silent> <localleader>fb      :Buffers<CR>

" keymap: [plugin][fzf] open Maps
nnoremap <silent> <localleader>fm      :Maps<CR>

" keymap: [plugin][fzf] open rg
nnoremap <silent> <localleader>fg      :Rg<CR>

" keymap: [plugin][fzf] open rg with current word
nnoremap <silent> <localleader>fW      :exe ':Rg ' . expand('<cword>')<CR>

" keymap: [plugin][fzf] open commits
nnoremap <silent> <localleader>fc      :Commits<CR>

" keymap: [plugin][fzf] open commits
nnoremap <silent> <localleader>fC      :Colors<CR>

" keymap: [plugin][fzf] open Marks
nnoremap <silent> <localleader>f`      :Marks<CR>

" keymap: [plugin][fzf] show Helptags
nnoremap <silent> <localleader>fh      :Helptags<CR>

" keymap: [plugin][fzf] show command history
nnoremap <silent> <localleader>fH      :History:<CR>

" keymap: [plugin][fzf] show search history
nnoremap <silent> <localleader>f/      :History/<CR>

" keymap: [plugin][fzf][normal] check commmand mappings
nmap <localleader><tab> <plug>(fzf-maps-n)

" keymap: [plugin][fzf][visual] check commmand mappings
xmap <localleader><tab> <plug>(fzf-maps-x)

" keymap: [plugin][fzf][operator-pending] check commmand mappings
omap <localleader><tab> <plug>(fzf-maps-o)

" keymap: [plugin][fzf][insert] check commmand mappings
imap <localleader><tab> <plug>(fzf-maps-i)

" :grep + grepprg + quickfix list
" keymap: [plugin][fzf][script] manual grep + quickfix
nnoremap <localleader>GG
      \ :call gitmox#plugins#prepare_search_command("", "Grep")<CR>

" keymap: [plugin][fzf][script] grep current word + quickfix
nnoremap <localleader>GW
      \ :call gitmox#plugins#prepare_search_command("word", "Grep")<CR>

" keymap: [plugin][fzf][script] grep search history + quickfix
nnoremap <localleader>GS
      \ :call gitmox#plugins#prepare_search_command("search", "Grep")<CR>

" keymap: [plugin][fzf][visual][script] visual grep + quickfix
vnoremap <silent> <localleader>GV
      \ :call gitmox#plugins#prepare_search_command("selection", "Grep")<CR>

" fzf-vim + ripgrep
" keymap: [plugin][fzf][script] manual + fzf
nnoremap <localleader>FF
      \ :call gitmox#plugins#prepare_search_command("", "GrepFzf")<CR>

" keymap: [plugin][fzf][script] current word + fzf
nnoremap <localleader>FW
      \ :call gitmox#plugins#prepare_search_command("word", "GrepFzf")<CR>

" keymap: [plugin][fzf][script] search history + fzf
nnoremap <localleader>FS
      \ :call gitmox#plugins#prepare_search_command("search", "GrepFzf")<CR>

" keymap: [plugin][fzf][visual][script] visual mode + fzf
vnoremap <silent> <localleader>FV
      \ :call gitmox#plugins#prepare_search_command("selection", "GrepFzf")<CR>

" Border style (rounded / sharp / horizontal)
let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.6,
      \ 'highlight': 'Todo', 'border': 'sharp' } }

if has('win32')
  let g:fzf_history_dir = '$HOME/.local/share/fzf-history'
elseif has('nvim')
  let g:fzf_history_dir = '~/.cache/nvim/fzf-history'
else
  let g:fzf_history_dir = '~/.cache/fzf-history'
endif

let g:fzf_action = {
      \ 'ctrl-t': 'tab split',
      \ 'ctrl-s': 'split',
      \ 'ctrl-v': 'vsplit' }

function! s:fzf_statusline() abort
  setlocal statusline=%4*\ fzf\ %6*V:\ ctrl-v,\ H:\ ctrl-x,\ Tab:\ ctrl-t
endfunction

augroup fzf
  au!
  au! FileType fzf
  au  Filetype fzf setlocal winblend=7
  " au  FileType fzf set laststatus=0 noshowmode noruler
        " \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler
  au! User FzfStatusLine call <SID>fzf_statusline()
augroup END

" FZF
" --column: Show column number
" --line-number: Show line number
" --no-heading: Do not show file headings in results
" --fixed-strings: Search term as a literal string
" --ignore-case: Case insensitive search
" --no-ignore: Do not respect .gitignore, etc...
" --hidden: Search hidden files and folders
" --follow: Follow symlinks
" --glob: Additional conditions for search (in this case ignore everything in the .git/ folder)
" --color: Search color options
function! RipgrepFzf(query, fullscreen)
  let command_fmt = 'rg --column --hidden --line-number --no-heading
        \ --color=always --smart-case %s || true'
  let initial_command = printf(command_fmt, shellescape(a:query))
  let reload_command = printf(command_fmt, '{q}')
  let spec = {'options': ['--phony', '--query', a:query, '--bind',
        \ 'change:reload:'.reload_command], 'window': { 'width': 0.9, 'height': 0.6 }}
  call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
endfunction

command! -nargs=* -bang Rg
      \ call RipgrepFzf(<q-args>, <bang>0)

command! -nargs=? -bang -complete=dir Files
      \ call fzf#vim#files(<q-args>, <bang>0 ?
      \ fzf#vim#with_preview('up:60%') : {}, <bang>0)

" :sudo apt install fd-find"
command! -nargs=? -complete=dir AF
      \ call fzf#run(fzf#wrap(fzf#vim#with_preview({
      \   'source': 'fdfind --type f --hidden
      \ --follow --exclude .git --no-ignore . '.expand(<q-args>)
      \ })))

command! -bang -nargs=* CurrentWordRg
      \ call fzf#vim#grep(
      \   'rg --column --line-number --no-heading --color=always
      \ --smart-case '.shellescape(expand('<cword>')), 1,
      \   <bang>0 ? fzf#vim#with_preview('up:60%')
      \           : fzf#vim#with_preview('right:50%:hidden', '?'),
      \   <bang>0)

command! -bang -nargs=? -complete=dir CurrentBufferDir
      \ call fzf#vim#files(expand('%:p:h'), fzf#vim#with_preview(), <bang>0)

command! -bang -nargs=? -complete=dir FindWikis
      \ call fzf#vim#files(expand('~/Dropbox/vimwiki'), fzf#vim#with_preview(), <bang>0)

" command! -bang -nargs=* Finds
"       \ call fzf#vim#grep('rg --column --line-number --no-heading
"       \ --fixed-strings --ignore-case --no-ignore --hidden --follow
"       \ --glob "!.git/*" --color "always" '.shellescape(<q-args>).'| tr -d "\017"', 1, <bang>0)

function! s:plug_help_sink(line)
  let dir = g:plugs[a:line].dir
  for pat in ['doc/*.txt', 'README.md']
    let match = get(split(globpath(dir, pat), "\n"), 0, '')
    if len(match)
      execute 'tabedit' match
      return
    endif
  endfor
  tabnew
  execute 'Explore' dir
endfunction

command! PlugHelp call fzf#run(fzf#wrap({
  \ 'source': sort(keys(g:plugs)),
  \ 'sink':   function('s:plug_help_sink')}))

" CUSTOM FZF ==================================================================
function! s:todo() abort
  let entries = []
  " for cmd in ['git grep -nI --exclude-standard -e TODO -e FIXME 2> /dev/null',
  "           \ 'grep -rnI -e TODO -e FIXME * 2> /dev/null']

  for cmd in ['grep -rnI --exclude-dir=node_modules -e TODO -e FIXME * 2> /dev/null']
    let lines = split(system(cmd), '\n')

    if v:shell_error != 0 | continue | endif
    for line in lines
      let [fname, lno, text] = matchlist(line, '^\([^:]*\):\([^:]*\):\(.*\)')[1:3]
      call add(entries, { 'filename': fname, 'lnum': lno, 'text': text })
    endfor
    break
  endfor

  if !empty(entries)
    call setqflist(entries)
    copen
  endif
endfunction

command! Todo call s:todo()

" command! -bang WikiSearch
"       \ call fzf#vim#grep(g:wiki_path, fzf#vim#with_preview(), <bang>0)

" function! T(query, fullscreen)
"   let command_fmt = 'rg --column --line-number --no-heading --color=always --smart-case -- %s || true'
"   let initial_command = printf(command_fmt, shellescape(a:query). ' '. g:wiki_path)
"   " echomsg initial_command
"   " let reload_command = printf(command_fmt, '{q}')
"   " let spec = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
"   " call fzf#vim#grep(initial_command, 0, fzf#vim#with_preview(spec), a:fullscreen)

"   echomsg initial_command
"   call fzf#vim#grep(initial_command, 1, a:fullscreen)
" endfunction

if executable('rg')
  set grepprg=rg\ --vimgrep\ --no-heading\ --smart-case\ --hidden\ --follow
  set grepformat=%f:%l:%c:%m
else
  set grepprg=grep\ -n\ --with-filename\ -I\ -R
  set grepformat=%f:%l:%m
endif

command -nargs=* -bang -complete=file Grep
      \ call gitmox#plugins#execute_search('Grep', <q-args>, <bang>0, <bang>0)

command -nargs=* -bang -complete=file GrepFzf
      \ call gitmox#plugins#execute_search('GrepFzf', <q-args>, <bang>0, <bang>0)

command -nargs=* -bang -complete=file GrepWK
      \ call gitmox#plugins#execute_search($('GrepFzf', <q-args>, <bang>0, <bang>1)
