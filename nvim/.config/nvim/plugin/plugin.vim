scriptencoding UTF-8    " Default encoding for current script.

" Vimwiki ------------------------------------------------------------------- {{{
let g:wiki_path = isdirectory(expand('$HOME/Dropbox/vimwiki')) ?
      \ $HOME.'/Dropbox/vimwiki' : $HOME . '/wiki'

let g:vimwiki_list           = [{
      \ 'path': g:wiki_path,
      \ 'index': 'home',
      \ 'auto_diary_index': 1,
      \ 'automatic_nested_syntaxes': 1,
      \ 'syntax': 'markdown',
      \ 'template_default': 'markdown',
      \ 'ext': '.md'
      \}]

" Disable ALL Vimwiki key mappings
let g:vimwiki_key_mappings      = {'all_maps': 0,}
let g:vimwiki_table_mappings    = 0
let g:vimwiki_folding           = 'expr'
let g:vimwiki_global_ext        = 0
let g:vimwiki_hl_cb_checked     = 1
let g:vimwiki_hl_headers        = 1
" let g:vimwiki_listsyms          = '✗○◐●✓'
let g:vimwiki_markdown_link_ext = 1
"
" }}}
" Emmet --------------------------------------------------------------------- {{{
" ------------
" press double comma to expand emmet mode
" default emmet leader <C-y><leader>
" let g:user_emmet_leader_key=','
let g:user_emmet_settings = {
      \  'javascript.jsx' : {
      \      'extends' : 'jsx',
      \  },
      \}
"}}}
" Ultisnips ----------------------------------------------------------------- {{{
"
if exists('g:loaded_ultisnip')
  " let g:UltiSnipsSnippetDirectories  = [$HOME.'/moxconf/data.programming.forprivate/ultisnips']
  let g:UltiSnipsSnippetDirectories  = [$HOME.'/Dropbox/data.programming.forprivate/ultisnips']

  let g:UltiSnipsEditSplit           = 'vertical'
  let g:ultisnips_python_style       = 'google'

  let g:UltiSnipsExpandTrigger       = '<TAB>'
  let g:UltiSnipsJumpForwardTrigger  = '<TAB>'
  let g:UltiSnipsJumpBackwardTrigger = '<S-TAB>'
endif
"
" }}}
" Vsnip --------------------------------------------------------------------- {{{
"
" let g:vsnip_snippet_dir = getenv('HOME') . '/moxconf/data.programming.forprivate/vsnip'
let g:vsnip_snippet_dir = getenv('HOME') . '/Dropbox/data.programming.forprivate/vsnip'
let g:vsnip_filetypes = {}
let g:vsnip_filetypes['typescript'] = ['javascript']
let g:vsnip_filetypes['svelte'] = ['javascript', 'typescript', 'html']
" let g:vsnip_filetypes['javascript'] = ['javascript', 'typescript']
"
" }}}
" LuaInit ------------------------------------------------------------------- {{{
"
if PluginLoaded('nvim-lspconfig')
  " luafile ~/.config/nvim/lua/mylsp.lua
  if has('nvim') && exists('*luaeval')
    lua require 'init'
  endif
endif
"
" }}}
" Rainbow ------------------------------------------------------------------- {{{
"
let g:rainbow_active = 1
"
" }}}
" Table-mode ---------------------------------------------------------------- {{{
"
" let g:table_mode_delimiter = ','
" default map <leader>tt (table-mode) conflict dengan mapping `toggle terminal`,
" jadi agar tidak conflict, mengganti <leader>tt ke lain
let g:table_mode_tableize_map = '<Leader>T'
" let g:toggle-mode-options-toggle-map = ''
"
" }}}
" Vim-maximizer ------------------------------------------------------------- {{{
"
" Disable Vim-maximizer default mapping, i hate it
let g:maximizer_set_default_mapping = 0
let g:maximizer_default_mapping_key = '<c-m>'
"
" }}}
" Vim-indent-guides --------------------------------------------------------- {{{

let g:indent_guides_default_mapping = 0
"
" }}}
" Scratch.vim --------------------------------------------------------------- {{{
"
let g:scratch_no_mappings = 1
let g:scratch_insert_autohide = 0
let g:scratch_filetype = 'scratch'
"
" }}}
" Auto-Pairs ---------------------------------------------------------------- {{{
"
" Dont make another plugin change my default mappings!
let g:AutoPairsMapCh = 0
let g:AutoPairsFlyMode = 0
let g:AutoPairsShortcutToggle = ''
let g:AutoPairsShortcutJump = ''
"
" }}}
" FixCursorHold ------------------------------------------------------------- {{{
"
if PluginLoaded('FixCursorHold.nvim')
  " in millisecond, used for both CursorHold and CursorHoldI,
  " use updatetime instead if not defined
  let g:cursorhold_updatetime = 100
endif
"
" }}}
" Obvious-resize ------------------------------------------------------------ {{{
"
let g:obvious_resize_default = 7
let g:obvious_resize_run_tmux = 1
"
" }}}
" Vim-tmux-navigator -------------------------------------------------------- {{{
"
" Disable tmux navigator when zooming the Vim pane
let g:tmux_navigator_disable_when_zoomed = 1
"
" }}}
" Auto-pairs ----------------------------------------------------------- {{{
"
" Plugin 'jiangmiao/auto-pairs'
let g:AutoPairsMapBS = 0
"
" }}}

command! Pomotoggle lua require'modules._tools'.pomorun('toggle')
command! PomotogglePause lua require'modules._tools'.pomorun('pausetoggle')

command! Gentab lua require'modules._tools'.gentab('newtab')
