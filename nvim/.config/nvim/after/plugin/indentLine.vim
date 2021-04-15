scriptencoding UTF-8    " Default encoding for current script.

" keymap: [plugin][indentguide][toggle] show line indent
nnoremap <localleader>ai :IndentLinesToggle<CR>

if !PluginLoaded('indentLine')
  finish
endif

let g:ExcludeIndentFileType_Universal       = [ 'startify', 'nerdtree', 'codi', 'help', 'man', 'coc-explorer', 'defx', 'LuaTree']
let g:ExcludeIndentFileType_Special         = [ 'markdown', 'json' ]
let g:indentLine_bufTypeExclude             = ['help', 'terminal', 'nofile', 'vimwiki']
let g:indentLine_color_gui                  = '#413d55'
let g:indentLine_concealcursor              = 'inc'
let g:indentLine_conceallevel               = 2
let g:indentLine_char                       = "\ue621"  " ¦┆│⎸ ▏  e621
let g:indentLine_leadingSpaceChar           = '·'
let g:indentLine_fileTypeExclude            = g:ExcludeIndentFileType_Universal + g:ExcludeIndentFileType_Special
let g:indentLine_setColors                  = 0  " disable overwrite with grey by default, use colorscheme instead

" function! s:initindentguides()
"   let g:indent_guides_enable_on_vim_startup = 0
"   let g:indent_guides_exclude_filetypes     = g:ExcludeIndentFileType_Universal
"   let g:indent_guides_color_change_percent  = 10
"   let g:indent_guides_guide_size            = 1
"   let g:indent_guides_default_mapping       = 0
" endfunction

" let s:hasloadindentguides = 0

" function! g:Toggleindent()
"   if s:hasloadindentguides == 0
"     call s:initindentguides()
"     execute 'IndentGuidesToggle'
"     let s:hasloadindentguides = 1
"   else
"     execute 'IndentGuidesToggle'
"   endif
" endfunction
