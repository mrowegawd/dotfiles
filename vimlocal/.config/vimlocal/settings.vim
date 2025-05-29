" vim: foldmethod=marker foldlevel=0

scriptencoding utf-8
set linespace=5

" Base ----------------------- {{{
" -----------------
" General
set autoread
set hidden
" Disable bell.
set t_vb=
set novisualbell
set belloff=all
set noerrorbells

" set dictionary=/usr/share/dict/words

if has('linebreak')
  let &showbreak='↳ '                 " DOWNWARDS ARROW WITH TIP RIGHTWARDS (U+21B3, UTF-8: E2 86 B3)
endif

set mouse=
set lazyredraw                        " don't bother updating screen during macro playback

if has('ttyfast')
  set ttyfast
endif

if has('mac')
  let g:clipboard = {
        \   'name': 'macOS-clipboard',
        \   'copy': {
        \      '+': 'pbcopy',
        \      '*': 'pbcopy',
        \    },
        \   'paste': {
        \      '+': 'pbpaste',
        \      '*': 'pbpaste',
        \   },
        \   'cache_enabled': 0,
        \ }
endif

if has('clipboard')
  set clipboard& clipboard+=unnamedplus
endif

if has('wsl')
  " To make copy/paste mode from wsl/windows vice-versa working
  " this set-option must be set to `unnamedplus`.
  " Issue from github: https://github.com/neovim/neovim/issues/12092
  " Read: https://github.com/neovim/neovim/wiki/FAQ#how-to-use-the-windows-clipboard-from-wsl
  set clipboard=unnamedplus
endif

if has('nvim')
  " Go away, netrw!
  augroup hide_netrw
    autocmd!
    au FileType netrw setl bufhidden=wipe
    " auto nohl when enter or saving files
    " au BufWritePre,BufEnter * :call feedkeys(":nohls\n")

    " au CmdlineEnter /,\? :set hlsearch
    " au CmdlineLeave /,\? :set nohlsearch
  augroup END
endif
"
" }}}
" Wildmenus ------------------ {{{
" -----------------
if has('wildmenu')
  " set wildmode=list:longest,full        " tampilan wildmode akan seperti default
  set wildmode=full                       " tampilan wildmode akan menjadi popup
  set wildoptions=tagfile
  set wildignorecase
  set wildignore+=.git,.hg,.svn,.stversions,*.pyc,*.spl,*.o,*.out,*~,%*
  set wildignore+=*.jpg,*.jpeg,*.png,*.gif,*.zip,**/tmp/**,*.DS_Store
  set wildignore+=**/node_modules/**,**/bower_modules/**,*/.sass-cache/*
  set wildignore+=application/vendor/**,**/vendor/ckeditor/**,media/vendor/**
  set wildignore+=__pycache__,*.egg-info
  set wildignore+=*vim/backups*
endif

" }}}
" Vim Directories ------------ {{{
" ---------------
" Turn backup off
set nobackup
set nowritebackup
set noswapfile
" set viminfo=

set undofile
set undodir=$VARPATH/undo//

" History saving
set history=250

if has('nvim')
  "  ShaDa/viminfo:
  "   ' - Maximum number of previously edited files marks
  "   < - Maximum number of lines saved for each register
  "   @ - Maximum number of items in the input-line history to be
  "   s - Maximum size of an item contents in KiB
  "   h - Disable the effect of 'hlsearch' when loading the shada
  " set shada='300,<50,@100,s10,h
  " set shada=!,'1000,<50,s10,h  " Store 1000 entries on oldfiles
  set inccommand=split
  " set wildoptions+=pum
  set pumblend=30  " transparency

  set shell=zsh                          " shell to use for `!`, `:!`, `system()` etc.
endif

" Tabs and Indents ----------- {{{
" ----------------
"
set smarttab          " Tab respects 'tabstop', 'shiftwidth', and 'softtabstop'
set tabstop=2         " The number of spaces a tab is
set softtabstop=2     " While performing editing operations
set shiftwidth=2      " Number of spaces to use in auto(indent)
set autoindent        " Use same indenting on new lines
set expandtab         " Don't expand tabs to spaces.
set smartindent       " Smart autoindenting on new lines
set shiftround        " Round indent to multiple of 'shiftwidth'
"
" }}}
" Timing --------------------- {{{
" ------
set updatetime=300    " Idle time to write swap and trigger CursorHold
set ttimeout
set ttimeoutlen=100   " Time out on mappings
set timeoutlen=500

" }}}
" Searching ------------------ {{{
" ---------
set ignorecase      " Search ignoring case
set smartcase       " Keep case when searching with *
set infercase       " Adjust case in insert completion mode
set incsearch       " Incremental search
set hlsearch        " Highlight search results
set wrapscan        " Searches wrap around the end of the file
set showmatch       " Jump to matching bracket
set matchpairs+=<:> " Add HTML brackets to pair matching
set matchtime=1     " Tenths of a second to show the matching paren
set cpoptions-=m    " showmatch will wait 0.5s or until a char is typed

" }}}
" Behavior ------------------- {{{
" --------
set nowrap                      " No wrap by default
set linebreak                   " Break long lines at 'breakat'
set breakat=\ \	;:,!?           " Long lines break chars
set nostartofline               " Cursor in same column for few commands
set whichwrap+=h,l,<,>,[,],~    " Move to following line on certain keys
set splitbelow splitright     " Splits open bottom right
set switchbuf=useopen,usetab    " Jump to the first open window in any tab
" set switchbuf+=uselast          " Switch buffer behavior to vsplit or uselast
set backspace=indent,eol,start  " Intuitive backspacing in insert mode
" set diffopt=filler,iwhite     " Diff mode: show fillers, ignore white
" set diffopt=horizontal,iwhite       " Diff mode: show fillers, ignore white
" set diffopt=internal,filler,vertical,context:5,foldcolumn:1,indent-heuristic,algorithm:patience

set showfulltag                 " Show tag and tidy search in completion
set complete=.,w,b,u,t,k        " No wins, buffs, tags, include scanning
set completeopt=menu
set completeopt+=menuone        " Show menu even for one item
set completeopt+=noselect       " Do not select a match in the menu
set completeopt+=noinsert

set textwidth=80      " Text width maximum chars before wrapping

if exists('+inccommand')
  set inccommand=nosplit
endif

" dont change cursor shapes
" set guicursor=n-v-c:block-Cursor/lCursor,i-ci-ve:ver25-Cursor2/lCursor2,r-cr:hor20,o:hor20
set guicursor=n-v-c:block-Cursor
set guicursor+=i:ver100-iCursor
set guicursor+=n-v-c:blinkon0
set guicursor+=i:blinkwait10

" see help 'formatoptions'
set formatoptions=
set formatoptions+=c " Format comments
set formatoptions+=r " Continue comments by default
set formatoptions+=o " Make comment when using o or O from comment line
set formatoptions+=q " Format comments with gq
set formatoptions+=n " Recognize numbered lists
set formatoptions+=2 " Use indent from 2nd line of a paragraph
set formatoptions+=l " Don't break lines that are already long
set formatoptions+=1 " Break before 1-letter words
" }}}
" Editor UI Appearance ------- {{{
" --------------------
" set shortmess+=A                          " ignore annoying swapfile messages
" set shortmess+=I                          " no splash screen
" set shortmess+=O                          " file-read message overwrites previous
" set shortmess+=T                          " truncate non-file messages in middle
" set shortmess+=W                          " don't echo"[w]"/"[written]" when writing
" set shortmess+=a                          " use abbreviations in messages eg. `[RO]` instead of `[readonly]`
" if has('patch-7.4.314')
"   set shortmess+=c                        " completion messages
" endif
" set shortmess+=o                          " overwrite file-written messages
" set shortmess+=t                          " truncate file messages at start
set shortmess=aoOTIcF

set scrolloff=2                           " Keep at least 2 lines above/below
set sidescrolloff=5                       " Keep at least 5 lines left/right

if exists('+relativenumber')
  set number rnu                          " Set relativenumber and current numberline

  set noruler                             " Disable default status ruler

  set nolist                              " show whitespace
  set listchars=nbsp:⦸                    " CIRCLED REVERSE SOLIDUS (U+29B8, UTF-8: E2 A6 B8)
  set listchars+=tab:▷┅                   " WHITE RIGHT-POINTING TRIANGLE (U+25B7, UTF-8: E2 96 B7)
  " + BOX DRAWINGS HEAVY TRIPLE DASH HORIZONTAL (U+2505, UTF-8: E2 94 85)
  set listchars+=extends:»                " RIGHT-POINTING DOUBLE ANGLE QUOTATION MARK (U+00BB, UTF-8: C2 BB)
  set listchars+=precedes:«               " LEFT-POINTING DOUBLE ANGLE QUOTATION MARK (U+00AB, UTF-8: C2 AB)
  set listchars+=trail:•                  " BULLET (U+2022, UTF-8: E2 80 A2)
endif

" set listchars=tab:▷┅,eol:¬,trail:•,extends:,precedes:

set showtabline=2                         " Always show the tabs line
if has('nvim')
  set tabline=%!gitmox#settings#tabline() " Custom tabline modifier function.
endif
set noshowcmd                             " Disable displaying key presses at the right bottom.
set noshowmode                            " Disable native mode indicator.
set cmdheight=1                           " Height of the command line
set cmdwinheight=5                        " Command-line lines
set noequalalways                         " Don't resize windows on split or close
set laststatus=2                          " Always show a status line
set display=lastline

" For snippet_complete marker
" if has('conceal')
"   set conceallevel=2 concealcursor=niv
" endif

" }}}
" Misc ----------------------- {{{
"
if exists('+termguicolors')
  " enable italic comments
  let &t_ZH="\e[3m"
  let &t_ZR="\e[23m"

  set termguicolors
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
endif

if has('nvim')
  " https://sunaku.github.io/vim-256color-bce.html
  if &term =~? '256color'
    set t_ut=
  endif

  let &t_ti .= "\e[?2004h"
  let &t_te .= "\e[?2004l"
  let &pastetoggle = "\e[201~"

  function! XTermPasteBegin(ret) abort
    setlocal paste
    return a:ret
  endfunction

  " Required for vim-workspace or any session plugins
  " See https://github.com/thaerkh/vim-workspace/issues/11
  " What is going to be save in session
  " + buffers,curdir,tabpages,winsize,terminal
  set sessionoptions-=folds
  set sessionoptions-=options
  set sessionoptions-=help
  set sessionoptions-=blank

  set wildoptions+=pum
endif

" }}}
" Fold ----------------------- {{{
"
"
function! NeatFoldText() "{{{
  let line = ' ' . substitute(getline(v:foldstart), '^\s*"\?\s*\|\s*"\?\s*{{' . '{\d*\s*', '', 'g') . ' '
  let lines_count = v:foldend - v:foldstart + 1
  let lines_count_text = '| ' . printf('%10s', lines_count . ' lines') . ' |'
  let foldchar = matchstr(&fillchars, 'fold:\zs.')
  let foldtextstart = strpart('+' . repeat(foldchar, v:foldlevel*2) . line, 0, (winwidth(0)*2)/3)
  let foldtextend = lines_count_text . repeat(foldchar, 8)
  let foldtextlength = strlen(substitute(foldtextstart . foldtextend, '.', 'x', 'g')) + &foldcolumn
  return foldtextstart . repeat(foldchar, winwidth(0)-foldtextlength) . foldtextend
endfunction
set foldtext=NeatFoldText()

if has('folding')
  if has('windows')
    " By default vertical split dibatasi dengan line or dot-line,
    "       but you can set your own.
    " - how to:
    " check example:
    "   :set fillchars+=vertsplit:+
    "   :set fillchars+=vertsplit:-
    set fillchars=diff:∙                " BULLET OPERATOR (U+2219, UTF-8: E2 88 99)
    set fillchars+=fold:·               " MIDDLE DOT (U+00B7, UTF-8: C2 B7)
    set fillchars+=vert:┃               " BOX DRAWINGS HEAVY VERTICAL (U+2503, UTF-8: E2 94 83)
    " set fillchars+=vert:\|
  endif

  if has('nvim-0.3.1')
    set fillchars+=eob:\                " suppress ~ at EndOfBuffer
  endif

  set foldmethod=indent                 " not as cool as syntax, but faster
  set foldlevelstart=99                 " start unfolded
  " set foldtext=MyFoldText_2()
  set foldtext=NeatFoldText()
endif
"
" }}}
