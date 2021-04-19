" Install vim-plug if not exists
if !filereadable(plugpath)
  if !executable('curl')
    echoerr 'You have to install curl or first install vim-plug yourself!'
    execute 'q!'
  endif
  echo 'Installing Vim-Plug...'
  echo ''
  silent !\curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  let g:not_finish_vimplug = 'yes'

  augroup AutoPlugInstall
    autocmd!
    autocmd VimEnter * PlugInstall
  augroup END
endif

if !isdirectory(expand(g:mycache_dir . '/nvim'))
  if has('nvim')
    call mkdir(g:mycache_dir . '/nvim/sessions', 'p')
    call mkdir(g:mycache_dir . '/nvim/undo', 'p')
    call mkdir(g:mycache_dir . '/nvim/backup', 'p')
    call mkdir(g:mycache_dir . '/nvim/swap', 'p')
    call mkdir(g:mycache_dir . '/nvim/view', 'p')
  else
    call mkdir(g:mycache_dir . '/vim/sessions', 'p')
    call mkdir(g:mycache_dir . '/vim/undo', 'p')
    call mkdir(g:mycache_dir . '/vim/backup', 'p')
    call mkdir(g:mycache_dir . '/vim/swap', 'p')
    call mkdir(g:mycache_dir . '/vim/view', 'p')
  endif
endif

function! Cond(cond, ...)
  let l:opts = get(a:000, 0, {})
  return a:cond ? l:opts : extend(l:opts, { 'on': [], 'for': [] })
endfunction

function PluginLoaded(plugin_name) abort
  " return has_key(g:plugs, a:plugin_name) && stridx(&rtp, g:plugs[a:plugin_name].dir)
  return has_key(g:plugs, a:plugin_name) && stridx(&runtimepath, g:plugs[a:plugin_name].dir)
endfunction

syntax enable
call plug#begin('~/.local/share/nvim/plugged')

" AUTO COMPLETION -------------------------------------------------------------
Plug 'neovim/nvim-lspconfig' " -- Buildin lsp
  Plug 'glepnir/lspsaga.nvim' " -- Better UI for builtin LSP
  Plug 'alexaandru/nvim-lspupdate' " -- Updates installed LSP servers
Plug 'tjdevries/astronauta.nvim'
Plug 'mfussenegger/nvim-jdtls' " -- Extension LSP nvim for eclipse,java
Plug 'hrsh7th/nvim-compe'

Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim' " -- more stdlib for lua functions
  Plug 'nvim-telescope/telescope.nvim'
    Plug 'nvim-telescope/telescope-fzy-native.nvim'
    Plug 'nvim-telescope/telescope-media-files.nvim'
    " Plug 'nvim-telescope/telescope-frecency.nvim'

Plug 'nvim-lua/lsp-status.nvim'
Plug 'tjdevries/nlua.nvim'

Plug 'norcalli/nvim-colorizer.lua'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

" COLORS ----------------------------------------------------------------------
Plug 'rafi/awesome-vim-colorschemes'
Plug 'chriskempson/base16-vim'
Plug 'flazz/vim-colorschemes'
Plug 'connorholyday/vim-snazzy'
Plug 'mswift42/vim-themes'
Plug 'sainnhe/edge'
Plug 'sonph/onehalf', { 'rtp': 'vim' }

" GENERAL ---------------------------------------------------------------------
Plug 'vimwiki/vimwiki', {'branch': 'dev', 'on': ['VimwikiIndex', 'VimwikiDiaryIndex'] } " -- Local vimwiki
  " Plug 'tbabej/taskwiki' " -- Handling taskwarrior with vimwiki
  " Plug 'michal-h21/vim-zettel', { 'for': ['vimwiki'] } " -- FZF for Zettelkasten method [vimwiki]

Plug 'junegunn/goyo.vim', { 'on': 'Goyo' } " -- Distraction-free writing in Vim, :Goyo
Plug 'antoinemadec/FixCursorHold.nvim'  " -- Fix CursorHold Performance
Plug 'szw/vim-maximizer'  " -- :MaximizerToggle! window

" Plug 'glepnir/dashboard-nvim'
Plug 'mhinz/vim-startify' " -- The fancy start screen for Vim.

Plug 'kyazdani42/nvim-tree.lua' " -- File manager
Plug 'kyazdani42/nvim-web-devicons' " -- File icons support
" Plug 'yamatsum/nvim-nonicons' " NOTE: this not work on me, why lols

Plug 'akinsho/nvim-toggleterm.lua' " -- easly to manage terminal windows in lua

Plug 'brooth/far.vim' " -- Find and replace with vim,
                      " :Far {pattern} {replace-with} {file-mask} [params],
                      " :F {pattern} {file-mask} [params]
                      " :Fardo
" Plug 'junegunn/fzf.vim'
" Plug 'junegunn/fzf', {'dir': '~/.fzf', 'do': './install --all'} " -- Fuzzy finding

Plug 'editorconfig/editorconfig-vim'
" Plug 'myusuf3/numbers.vim'

Plug 'jiangmiao/auto-pairs' " -- Auto close tags
Plug 'windwp/nvim-autopairs' " -- Autopairs but its in lua
Plug 'AndrewRadev/splitjoin.vim' " -- Switch between single-line and multiline, gS,gJ
Plug 'itchyny/calendar.vim', {'on': 'Calendar'} " -- Calendar on vim, :Calendar
Plug 'talek/obvious-resize' " -- The easy way to resizing vim windows/splits
Plug 'Yggdroot/indentLine', {'on': 'IndentLinesToggle'} " -- Show me the block indent line
Plug 'nathanaelkane/vim-indent-guides' " -- Show me indent level block only
Plug 'liuchengxu/vim-which-key' " -- Sometime I forget the mappings..
Plug 'liuchengxu/vista.vim', {'on': ['Vista', 'Vista!!']} " -- Hey I got a tagbar!!
Plug 'simnalamburt/vim-mundo', {'on': 'MundoToggle'} " -- Lets undo, :MundoToggle
Plug 'mg979/vim-visual-multi', {'branch': 'master'} " -- Multiple cursor?!
Plug 'godlygeek/tabular'
Plug 'dhruvasagar/vim-table-mode' " -- VIM Table Mode for instant table creation
Plug 'tyru/open-browser.vim', {'for' : ['plantuml', 'pu']} " -- Open browser

" Plug 'mtth/scratch.vim' " -- A temporary scratch buffer to add notes, :Scratch
" Plug 'rmagatti/auto-session' " -- :SaveSession {path_session} :RestoreSession {path_session}

" Plug 'unblevable/quick-scope' -- " Fast left-right movement in vim, like f F
" Plug 'nvim-lua/completion-nvim'
" Plug 'steelsojka/completion-buffers'

" Text obj
" Plug 'justinmk/vim-ipmotion'                " improve paragraph motion
" Plug 'tommcdo/vim-exchange'
" Plug 'chaoren/vim-wordmotion'

" Quickfix and locationlist
" Plug 'kevinhwang91/nvim-bqf' " -- Better quickfix: open(o,t,T,c-x,c-v),close-preview(zp,p,P)
" Plug 'mvanderkamp/worklist.vim' " -- testing
Plug 'romainl/vim-qf'

" Hail Master Tpope :D
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-eunuch' " -- Delete, :Unlink: :Move: :Rename: :Move, :Chmod: :Mkdir:

" GIT -------------------------------------------------------------------------
Plug 'mhinz/vim-signify' " -- +/-/~ Signs in the gutter
Plug 'TimUntersberger/neogit' " -- Same as vim-fugitive, but its lua..
Plug 'rhysd/committia.vim'
Plug 'rhysd/git-messenger.vim' " -- Floating windows are awesome :)

" TMUX ------------------------------------------------------------------------
Plug 'christoomey/vim-tmux-navigator', Cond(exists('$TMUX'))
Plug 'tmux-plugins/vim-tmux', Cond(exists('$TMUX')) " -- better hi for tmux.conf

" =============================================================================
" TOOLS
" =============================================================================
" SNIPPETS --------------------------------------------------------------------
Plug 'hrsh7th/vim-vsnip'
Plug 'hrsh7th/vim-vsnip-integ'

" DEBUGGING -------------------------------------------------------------------
" Plug 'puremourning/vimspector'
Plug 'mfussenegger/nvim-dap'
  Plug 'mfussenegger/nvim-dap-python'
  Plug 'theHamsta/nvim-dap-virtual-text'

Plug 'vim-test/vim-test', {'on': ['TestFile', 'TestNearest', 'TestLatest']}

" Profiling output for startup.
" :Messages <- view messages in quickfix list
" :Verbose  <- view verbose output in preview window.
" :Time     <- measure how long it takes to run some stuff.
Plug 'tpope/vim-scriptease', {'on': ['Messages', 'Verbose']}
Plug 'dstein64/vim-startuptime'
" Plug 'tweekmonster/startuptime.vim'

" =============================================================================
" LANGUAGE
" =============================================================================
Plug 'aklt/plantuml-syntax', {'for' : ['plantuml', 'pu']} " -- Syntax highlight plantUML
Plug 'weirongxu/plantuml-previewer.vim', {'for' : ['plantuml', 'pu']} " -- preview plantUML

Plug 'Rican7/php-doc-modded', {'for': ['php'] } " -- Function to generate PHP document
Plug 'tpope/vim-dadbod' " -- Modern database interface for vim
Plug 'iamcco/markdown-preview.nvim', {'do': 'cd app & npm install',
      \ 'for': ['md', 'markdown', 'vimwiki', 'wiki']} " -- preview markdown

" Plug 'lervag/vimtex'
" Plug 'vim-pandoc/vim-pandoc'
" Plug 'vim-pandoc/vim-pandoc-syntax'

filetype plugin indent on
call plug#end()

" Disable netrw
if has('nvim')
  let g:loaded_netrw             = 1
  let g:loaded_netrwPlugin       = 1
  let g:loaded_netrwSettings     = 1
  let g:loaded_netrwFileHandlers = 1
end

function s:install_missing_plugins() abort
  if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
    PlugInstall --sync | q
  endif
endfunction

" Install any missing plugins on vim automatically
augroup AutoInstallPlugins
  au!
  au VimEnter * call s:install_missing_plugins()
  execute 'autocmd BufWritePost '. g:vim_dir . '/init.vim' .
        \ ' call <SID>install_missing_plugins()'
augroup END

if &loadplugins
  " Step: how to use packadd:
  " 1. for vim:
  " (create) mkdir -p ~/.vim/pack/test

  " 2. for neovim:
  " mkdir -p ~/.local/share/nvim/site/pack/*/opt        -- manual packadd
  " mkdir -p ~/.local/share/nvim/site/pack/*/start      -- autoload packages
  "
  " cd .../site/pack/*/opt; git clone https://github.com/your_awesome_plugins
  if has('packages')

    " Personal plugins ^_^V
    packadd! nvim-cekdulu
    packadd! nvim-relative
    packadd! nvim-cektmpl

  endif
endif
