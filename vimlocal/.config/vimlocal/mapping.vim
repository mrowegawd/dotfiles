set encoding=utf-8
scriptencoding utf-8

" basic ---------------------- {{{

" Use ',' instead of '\'.
"\<Space>"

" Use <leader> for basic mapping
let g:mapleader                              = "\<space>"

" Use <localleader> for mapping plugins
let g:maplocalleader                         = ','

" Release key mappings for plug-in.

imap     <F1>     <Nop>
nmap     <F1>     <Nop>
nnoremap ,        <Nop>
nnoremap <space>  <Nop>
nnoremap m        <Nop>

" Disable Ex-mode.
nnoremap Q  <Nop>
nnoremap q  <Nop>

" qq to record, q to quit macro, Q to replay
" keymap: [macro] run repeat the previous macro
" nnoremap Q @q

nmap <expr> j v:count ? 'j' : 'gj'
nmap <expr> k v:count ? 'k' : 'gk'

" Join lines and keep the cursor in place
nnoremap J mzJ`z

xnoremap . :normal .<CR>

" Allows you to visually select a section and then hit @ to run a macro on all lines
" https://medium.com/@schtoeffel/you-don-t-need-more-than-one-cursor-in-vim-2c44117d51db#.3dcn9prw6
xnoremap @ :<C-u>call ExecuteMacroOverVisualRange()<CR>

function! ExecuteMacroOverVisualRange()
  echo '@'.getcmdline()
  execute ":'<,'>normal @".nr2char(getchar())
endfunction

" keymap: [word] uppercase
vnoremap <leader>U gU$a

" keymap: [word] lowercase
vnoremap <leader>u gu$a

" For moving quickly up and down,
" Goes to the first line above/below that isn't whitespace
" Thanks to: http://vi.stackexchange.com/a/213
" nnoremap gj :let _=&lazyredraw<CR>:set lazyredraw<CR>/\%<C-R>=virtcol(".")<CR>v\S<CR>:nohl<CR>:let &lazyredraw=_<CR>
" nnoremap gk :let _=&lazyredraw<CR>:set lazyredraw<CR>?\%<C-R>=virtcol(".")<CR>v\S<CR>:nohl<CR>:let &lazyredraw=_<CR>

" keymap: [search] next, keep center
nnoremap <silent> n nzzzv:call <SID>BlinkCurrentMatch()<CR>

" keymap: [search] prev, keep center
nnoremap <silent> N Nzzzv:call <SID>BlinkCurrentMatch()<CR>

function! s:BlinkCurrentMatch()
  let target = '\c\%#'.@/
  let match = matchadd('ErrorMsg', target)
  redraw
  call matchdelete(match)
  sleep 50m
  redraw
endfunction

" keymap: [visual] select the contents but not indentation
nnoremap vv ^vg_

" keymap: [select] indent to right
vmap < <gv
" keymap: [select] indent to left
vmap > >gv

" keymap: [word][visual] move up
" vnoremap <A-j> :m '>+1<CR>gv=gv

" keymap: [word][visual] move down
" vnoremap <A-k> :m '<-2<CR>gv=gv

" Store relative line number jumps in the jumplist if they exceed a threshold.
" but this option will break go down/up when wrap is on
" nnoremap <expr> k (v:count > 5 ? "m'" . v:count : '') . 'k'
" nnoremap <expr> j (v:count > 5 ? "m'" . v:count : '') . 'j'

" keymap: [yank] copy line from current cursor to left
nnoremap Y y$

" keymap: [word] delete from current to last line
nnoremap D d$

" keymap: [word] spell check
nnoremap <Insert> :set spell!<CR>

" hh for escaping (insert and commandline)
inoremap hh <Esc>
" xnoremap hh <Esc>
cnoremap hh <C-C>

" keymap: [visual] open search
nmap / /\v
vmap / <Esc>/\%V

" keymap: [search] open search
nnoremap / /\v
vnoremap / <Esc>/\%V

" keymap: [search][quickfix] search current word (with quickfix)
" nmap <silent> <c-f> :exe 'vimgrep /\v'.expand('<cword>').'/g %'<CR>:copen<CR>

" keymap: [substitute] start search and replace
nmap <leader>sw :%s///g<left><left><left>

" keymap: [substitute] start search and replace current word
nmap <leader>sW :%s/<c-r><c-w>//g<left><left>

" keymap: [cursor] to right
nnoremap zL 10zl

" keymap: [cursor] to left
nnoremap zH 10zh

" keymap: [cursor] to left (far)
nmap zL z40l
" keymap: [cursor] to right (far)
nmap zH z40h

" keymap: [visual] toggle nohl
" nnoremap <silent> <leader>n :<C-u>nohlsearch<CR>:<C-u>call <SID>hier_clear()<CR>
nnoremap <silent> <leader>n :nohlsearch<CR>

" nnoremap <silent> <leader>n :<C-u>nohlsearch<CR>

" keymap: [visual] toggle nohl
" nnoremap <silent> <CR> :let @/=""<CR><CR>

" nnoremap <silent> <Esc><Esc> :<C-U>nohlsearch<CR>

" function! s:hier_clear() abort
"   if exists(':HierClear')
"     HierClear
"   endif
" endfunction

" Delete chars but don't save in clipboard
nnoremap x "_x
nnoremap X "_x

" Don't move on pressing *, let n mapping do the rest
nnoremap * *<c-o>

" quit window include buffers
" keymap: [window] close window
nnoremap <silent> <leader><TAB> :q<cr>

" keymap: [window] quite vim including buffers
nnoremap ZZ :qa<cr>

" <LocalLeader>p -- [P]rint the syntax highlighting group(s) that apply at the
" current cursor position.
"
" keymap: [window] quite vim including buffers
" Taken from: http://vim.wikia.com/wiki/Identify_the_syntax_highlighting_group_used_at_the_cursor
" nnoremap <LocalLeader>p :echo 'hi<' . synIDattr(synID(line('.'),col('.'),1),'name') . '> trans<'
"       \ . synIDattr(synID(line('.'),col('.'),0),'name') . '> lo<'
"       \ . synIDattr(synIDtrans(synID(line('.'),col('.'),1)),'name') . '>'<CR>

" keymap: [misc] show/check path current file
nnoremap <leader>p :echo expand('%')<CR>
" nnoremap <leader>P :echo expand('%:p:h:t')<CR>
nnoremap <leader>P :echo expand('%:p:h')<CR>

nnoremap <localleader>p :echo expand('%:t')<CR>

" keymap: [misc] open MYVIMRC
" noremap <leader>e :e $MYVIMRC<cr>

" keymap: [misc] got to current path of file
nnoremap <leader>cd :cd %:p:h<cr>

" keymap: [misc] format by vim
nnoremap <leader>f                gg=G``
"
" }}}
" insert mode ---------------- {{{
"
" keymap: [insert] delete line
" inoremap <c-u> <c-g>u<c-u>

" keymap: [insert] delete word by word
" inoremap <c-d> <c-g>u<c-w>

" keymap: [insert][cursor] move prev word
" inoremap <C-h> <C-\><C-o>h
inoremap <C-h> <esc><left>a

" keymap: [insert][cursor] move next word
inoremap <C-l> <esc><right>a

" keymap: [insert][cursor] go down
" inoremap <C-j> <C-\><C-o>j

" keymap: [insert][cursor] go up
" inoremap <C-k> <C-\><C-o>k

" keymap: [insert] move next word
" inoremap <C-w> <C-\><C-o>e

" keymap: [insert] move prev word
" imap <C-b> <C-\><C-o>b

" better vertical movement for wrapped lines
" inoremap <up> <c-o>gk
" inoremap <down> <c-o>gj
"
" }}}
" buffer, windows and tabs --- {{{
"
imap <up> <nop>
imap <down> <nop>
imap <left> <nop>
imap <right> <nop>

" keymap: [buffer] kill all buffers but not the current
map <silent> <c-w>o           :BufOnly!<cr>

" keymap: [tab][window] create new
nnoremap <silent> <c-w>t      :<C-U>tabnew<Space><CR>
" keymap: [tab][window] convert window to new tab
nnoremap <silent> <c-w>b      <C-w><S-t>

" keymap: [buffer] next
nnoremap <silent> <TAB>       :bnext<cr>zz
" keymap: [buffer] prev
nnoremap <silent> <S-TAB>     :bprev<cr>zz

" keymap: [tab] next
nnoremap <silent> <c-w>l      :tabn<cr>
" keymap: [tab] last next
nnoremap <silent> <c-w><s-l>  :tablast<cr>
" keymap: [tab] prev
nnoremap <silent> <c-w>h      :tabp<cr>
" keymap: [tab] first prev
nnoremap <silent> <c-w><s-h>  :tabfirst<cr>
" keymap: [tab] move tab to the next
" nnoremap <silent> <c-@>              <c-a>:+tabmove<cr>
" keymap: [tab] move tab to the next
" nnoremap <silent> <c-!>              <c-a>:-tabmove<cr>

" keymap: [window] size balance
nnoremap <leader>=            <C-w>=

function! s:maximazeWindow()
  if winnr('$') > 1
    tab split
  elseif len(filter(map(range(tabpagenr('$')), 'tabpagebuflist(v:val + 1)'),
        \ 'index(v:val, '.bufnr('').') >= 0')) > 1
    tabclose
  endif
endfunction

nnoremap <C-j> <C-W>j
nnoremap <C-k> <C-W>k
nnoremap <C-h> <C-W>h
nnoremap <C-l> <C-W>l

" nnoremap <silent> J    :resize -2<CR>
" nnoremap <silent> K    :resize +2<CR>
" nnoremap <silent> L    :vertical resize -2<CR>
" nnoremap <silent> H    :vertical resize +2<CR>

nnoremap <silent> <c-p> :call <sid>maximazeWindow()<cr>

" }}}
" toggle,quickfix,location --- {{{
" -----------------------
function! s:handleURL(pat,lucky)
  let s:uri = matchstr(getline('.'), '[a-z]*:\/\/[^ >,;")]*')
  if s:uri !=# ''
    echo 'open URL: '.s:uri
    silent!exec "!".$BROWSER." '".s:uri."'"
  else
    let q = '"'.substitute(a:pat, '["\n]', ' ', 'g').'"'
    echo 'Search keyword on browser: '.q
    let q = substitute(q, '[[:punct:] ]',
          \ '\=printf("%%%02X", char2nr(submatch(0)))', 'g')
    silent!call system(printf( $BROWSER . ' "https://www.google.com/search?%sq=%s"',
          \ a:lucky ? 'btnI&' : '', q))
  endif
  exec 'normal! \<esc>'
endfunction

function s:qf_loc_list_navigate(command)
  try
    exe a:command
  catch /E553/
    echohl WarningMsg
    echo 'No more items in a list'
    echohl None
    return
  endtry
  if &foldopen =~? 'quickfix' && foldclosed(line('.')) != -1
    normal! zv
  endif
  normal! zz
endfunction

" nmap <silent> <leader>oq :QFix<CR>
" command -bang -nargs=? QFix call QFixToggle(<bang>0)
" function! QFixToggle(forced)
"   if exists('g:qfix_win') && a:forced == 0
"     cclose
"     unlet g:qfix_win
"   else
"     copen 10
"     let g:qfix_win = bufnr('$')
"   endif
" endfunction

function! GetBufferList()
  redir =>buflist
  silent! ls!
  redir END
  return buflist
endfunction

function! ToggleList(bufname, pfx)
  let buflist = GetBufferList()
  for bufnum in map(filter(split(buflist, '\n'), 'v:val =~ "'.a:bufname.'"'), 'str2nr(matchstr(v:val, "\\d\\+"))')
    if bufwinnr(bufnum) != -1
      exec(a:pfx.'close')
      return
    endif
  endfor
  if a:pfx ==? 'l' && len(getloclist(0)) == 0
    echohl ErrorMsg
    echo 'Locationlist is Empty.'
    return
  endif
  let winnr = winnr()
  exec(a:pfx.'open')
  if winnr() != winnr
    wincmd p
  endif
endfunction

" keymap: [quickfix][toggle] open
nnoremap <silent> <leader>q   :call ToggleList("Quickfix List", 'c')<CR>
" keymap: [quickfix] next
nnoremap <silent> <leader>j   :cnext<CR>zz
" keymap: [quickfix] prev
nnoremap <silent> <leader>k   :cprev<CR>zz

" keymap: [locationlist][toggle] open
nnoremap <silent> <leader>Q   :call ToggleList("Quickfix List", 'l')<CR>
" keymap: [locationlist] next
nnoremap <silent> <a-j>       :lnext<cr>zz
" keymap: [locationlist] prev
nnoremap <silent> <a-k>       :lprev<cr>zz

" keymap: [browser] open browser from under cursor
nmap <silent> <leader>ob :call <SID>handleURL(expand('<cword>'),0)<cr>gv
" keymap: [browser][visual] open broser
xmap <silent> <leader>ob "gy:call <SID>handleURL(@g, 0)<cr>gv

if has('nvim')
  " keymap: [yank] copy current file path
  nmap <silent> <leader>% <Plug>Copypath
endif

"
" }}}
" netrw ---------------------- {{{
" ------------------------

if !has('nvim')
  let g:netrw_list_hide= '.*\.swp$,.*\.git$,*\.jshintrc$,*\.sass-lint\.yml'
  let g:netrw_banner = 0
  let g:netrw_liststyle = 3
  let g:netrw_browse_split = 4
  let g:netrw_altv = 1
  let g:netrw_winsize = 25

  let g:NetrwIsOpen=0

  function! ToggleNetrw()
    if g:NetrwIsOpen
      let i = bufnr('$')
      while (i >= 1)
        if (getbufvar(i, '&filetype') ==? 'netrw')
          silent exe 'bwipeout ' . i
        endif
        let i-=1
      endwhile
      let g:NetrwIsOpen=0
    else
      let g:NetrwIsOpen=1
      silent Lexplore
    endif
  endfunction

  " Toggle netrw
  noremap <silent> <leader>e :call ToggleNetrw()<CR>

  " Find file in current directory and edit it.
  function! FindNetrw(name)
    let l:list=system("find . -name '".a:name."' | perl -ne 'print \"$.\\t$_\"'")
    " replace above line with below one for gvim on windows
    " let l:list=system("find . -name ".a:name." | perl -ne \"print qq{$.\\t$_}\"")
    let l:num=strlen(substitute(l:list, '[^\n]', '', 'g'))
    if l:num < 1
      echo "'".a:name."' not found"
      return
    endif
    if l:num != 1
      echo l:list
      let l:input=input("Which ? (CR=nothing)\n")
      if strlen(l:input)==0
        return
      endif
      if strlen(substitute(l:input, '[0-9]', '', 'g'))>0
        echo 'Not a number'
        return
      endif
      if l:input<1 || l:input>l:num
        echo 'Out of range'
        return
      endif
      let l:line=matchstr("\n".l:list, "\n".l:input."\t[^\n]*")
    else
      let l:line=l:list
    endif
    let l:line=substitute(l:line, '^[^\t]*\t./', '', '')
    execute ':e '.l:line
  endfunction

  command! -nargs=1 FindNetrwc :call FindNetrw('<args>')

  nnoremap <leader>E :FindNetrwc<space>
end
" }}}
" commandline ---------------- {{{
"
" keymap: [commandline] sudo on
cnoremap w!! w !sudo tee % >/dev/null

" keymap: [commandline] history up
cnoremap <C-p> <Up>

" keymap: [commandline] history down
cnoremap <C-n> <Down>

" keymap: [commandline] move cursor to right
cnoremap <C-f> <Right>

" keymap: [commandline] move cursor to left
cnoremap <C-b> <Left>

" keymap: [commandline] back word
" cnoremap <C-b> <S-Left>

" keymap: [commandline] forward word
" cnoremap <C-w> <S-Right>

" keymap: [commandline] got to last line
cnoremap <C-a> <Home>

" keymap: [commandline] got to first line
cnoremap <C-e> <End>

" keymap: [commandline] delete word
cnoremap <C-d> <Del>

" keymap: [commandline] expand current path
cnoremap <C-t> <C-R>=expand("%:p:h") . "/" <CR>


"
" }}}
" jump ----------------------- {{{
"
" keymap: [jumplist][window] open last buffer
nnoremap <leader><leader> <c-^>
"
" }}}
" terminal ------------------- {{{
"
augroup MysetTerm
  autocmd!
  autocmd BufEnter * if &buftype == 'terminal' | :startinsert | endif
  autocmd BufEnter term://* startinsert
augroup END


" taken from: https://github.com/Shougo/shougo-s-github
if exists(':tnoremap')
  if has('nvim')

    if PluginLoaded('nvim-toggleterm.lua')
      " keymap: [terminal] open split
      nnoremap <silent> <leader>tt  :ToggleTerm<cr>

      " keymap: [terminal] open vertical
      " nnoremap <silent> <leader>tv  :TerminalV<cr>

      tnoremap <silent> <leader>tt  <C-\><C-n>:q<cr>
      tnoremap <ESC>                <C-\><C-n>

    else
      command! -nargs=* Terminal split | terminal <args>
      command! -nargs=* TerminalV vsplit | terminal <args>
      au TermOpen * set bufhidden=hide |
            \ :startinsert
      au TermOpen * :setl nonumber norelativenumber

      " keymap: [terminal] open split
      nnoremap <silent> <leader>tt :Terminal<cr>

      " keymap: [terminal] open vertical
      nnoremap <silent> <leader>tv  :TerminalV<cr>

      " keymap: [terminal] exit terminal
      tnoremap <silent> <leader>tt  <C-\><C-n>:q<cr>

      " keymap: [terminal] exit to normal mode
      tnoremap   <ESC>              <C-\><C-n>

    endif

  else
    nnoremap <silent> <leader>tt :vert term<cr>

    tnoremap <silent> <leader>tt exit<cr>

    tnoremap   <ESC><ESC>     <C-w>N
    tnoremap   <ESC>          <C-w>N

  endif
  " tnoremap   j<Space>   j
  " tnoremap <expr> ;  vimrc#sticky_func()
endif

tmap <c-t>v <c-a><CR>:vsplit term://zsh<CR>i
tmap <c-t>x <c-a><CR>:split term://zsh<CR>i
tmap <c-t>] <c-a>:+tabmove<cr>
tmap <c-t>[ <c-a>:-tabmove<cr>
tmap <a-h> <c-t><CR><c-w>h
tmap <a-j> <c-t><CR><c-w>j
tmap <a-k> <c-t><CR><C-w>k
tmap <a-l> <c-t><CR><c-w>l
tmap <c-t>J <c-t><CR><c-w>J
tmap <c-t>K <c-t><CR><c-w>K
tmap <c-t>H <c-t><CR><c-w>H
tmap <c-t>L <c-t><CR><c-w>L

"
" }}}
" folding -------------------- {{{
"
" keymap: [fold][toggle] open close fold
" nnoremap <Tab> za
" Enter key should repeat the last macro recorded or just act as enter
" nnoremap <silent><expr> <CR> empty(&buftype) ? '@@' : '<CR>'
" Evaluates whether there is a fold on the current line if so unfold it else return a normal space
" keymap: [fold][toggle] open close fold
" nnoremap <silent> <space> @=(foldlevel('.')?'za':"\<Space>")<CR>

" keymap: [fold][toggle] open close fold (recursive)
" nnoremap <silent> <c-space> @=(foldlevel('.')?'zA':"\<Space>")<CR>

" nnoremap <silent> zj :call fold#NextClosedFold('j')<cr>
" nnoremap <silent> zk :call fold#NextClosedFold('k')<cr>zo[z

let s:folded = 1

function! s:toggleFold()
    if( s:folded == 0 )
        exec 'normal! zM'
        let s:folded = 1
    else
        exec 'normal! zR'
        let s:folded = 0
    endif
endfunction

" keymap: [fold][toggle] open/close all folds
nmap <silent> 1 :call <SID>toggleFold()<CR>

nnoremap zj zjzz
nnoremap zk zkzz

" nnoremap <silent> <leader>zj :call NextClosedFold('j')<cr>
" nnoremap <silent> <leader>zk :call NextClosedFold('k')<cr>

" function! NextClosedFold(dir)
"     let cmd = 'norm!z' . a:dir
"     let view = winsaveview()
"     let [l0, l, open] = [0, view.lnum, 1]
"     while l != l0 && open
"         exe cmd
"         let [l0, l] = [l, line('.')]
"         let open = foldclosed(l) < 0
"     endwhile
"     if open
"         call winrestview(view)
"     endif
" endfunction

"
" }}}
" misc ----------------------- {{{
"
" profiling
function! s:profiling(bang)
  if a:bang
    profile pause
    noautocmd qall
  else
    profile start /tmp/profile.log
    profile func *
    profile file *
  endif
endfunction
" debugging vim
command! -bang Profiling call s:profiling(<bang>0)

" keymap: [visual] select content
" xnoremap <silent> ie gg0oG$
" onoremap <silent> ie :<C-U>execute "normal! m`"<Bar>keepjumps normal! ggVG<CR>

" keymap: [visual] don't make mistake
xnoremap <silent> il <Esc>^vg_
onoremap <silent> il :<C-U>normal! ^vg_<CR>

" keymap: [visual] go to up/down
xnoremap al $o0
onoremap al :<C-u>normal val<CR>

if !has('nvim')
  function! CleanTrailingWhites(command)
    " Preparation: save last search, and cursor position.
    let _s=@/
    let l = line('.')
    let c = col('.')
    " Do the business:
    execute a:command
    " Clean up: restore previous search history, and cursor position
    let @/=_s
    call cursor(l, c)
  endfunction

  " augroup DeleteTrailing
  "   autocmd!
  "   " Remove any leading spaces (not including tabs)
  "   " this line code make vim slow
  "   autocmd BufWritePre,FileAppendPre,FileWritePre,FilterWritePre * :call CleanTrailingWhites('%s/\\s\\+$//e')
  " augroup END
endif


" Improve scroll, credits: https://github.com/Shougo
" keymap: [scroll] center window
nnoremap <expr> zz (winline() == (winheight(0)+1) / 2) ?
      \ 'zt' : (winline() == 1) ? 'zb' : 'zz'

" keymap: [scroll] fast down
noremap <expr> <C-f> max([winheight(0) - 2, 1])
      \ ."\<C-d>".(line('w$') >= line('$') ? "L" : "M")

" keymap: [scroll] fast up
noremap <expr> <C-b> max([winheight(0) - 2, 1])
      \ ."\<C-u>".(line('w0') <= 1 ? "H" : "M")

" keymap: [scroll] go up
noremap <expr> <C-e> (line("w$") >= line('$') ? "2j" : "4\<C-e>")

" keymap: [scroll] go down
noremap <expr> <C-y> (line("w0") <= 1         ? "2k" : "4\<C-y>")
"
" }}}
" test mapping --------------- {{{
"
"
" }}}
