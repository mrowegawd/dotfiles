scriptencoding utf-8

if !PluginLoaded('completion-nvim')
  finish
endif

" keymap: [plugin][completion][insert] next source
imap <c-x><c-n> <Plug>(completion_next_source)

" keymap: [plugin][completion][insert] prev source
imap <c-x><c-p> <Plug>(completion_prev_source)

" function! <SID>check_back_space() abort
"   let l:col = col('.') - 1
"   return !l:col || getline('.')[l:col - 1]  =~# '\s'
" endfunction

" keymap: [plugin][completion][insert] next|trigger completion
" inoremap <silent><expr> <TAB>
"       \ pumvisible() ? "\<C-n>" :
"       \ <SID>check_back_space() ? "\<TAB>" :
"       \ completion#trigger_completion()

" keymap: [plugin][completion][insert] prev completion
" inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

" keymap: [plugin][completion][insert] trigger completion
inoremap <silent> <expr> <c-space> completion#trigger_completion()

" keymap: [plugin][completion][insert] expand/confirm completion
imap <expr> <TAB>  pumvisible() ?
      \ complete_info()["selected"] != "-1" ?
      \ "\<Plug>(completion_confirm_completion)" : "\<TAB>" :
      \ "\<TAB>"

" VSNIP
if PluginLoaded('vim-vsnip')
  " keymap: [plugin][vsnip][insert][visual] next jump snip|completion
  imap <expr> <c-f> vsnip#jumpable(1)   ?
        \ '<Plug>(vsnip-jump-next)'      : '<c-f>'

  smap <expr> <c-f> vsnip#jumpable(1)   ?
        \ '<Plug>(vsnip-jump-next)'      : '<c-f>'

  " keymap: [plugin][vsnip][insert][visual] prev jump(snip)|completion
  imap <expr> <c-b> vsnip#jumpable(-1)  ?
        \ '<Plug>(vsnip-jump-prev)'      : '<c-b>'

  smap <expr> <c-b> vsnip#jumpable(-1)  ?
        \ '<Plug>(vsnip-jump-prev)'      : '<c-b>'
endif

let g:completion_enable_auto_popup      = 1
let g:completion_trigger_on_delete      = 1

" Change the completion source automatically if no completion availabe
let g:completion_auto_change_source     = 1

let g:completion_enable_auto_paren      = 1
let g:completion_matching_ignore_case   = 1
let g:completion_max_items              = 20
let g:completion_enable_snippet         = 'vim-vsnip'
let g:completion_matching_strategy_list = ['exact', 'substring', 'fuzzy']
" let g:completion_trigger_character      = ['.', '::', '/', '->']

let g:completion_chain_complete_list = {
      \ 'default': {
      \   'default' : [
      \     {'complete_items': ['lsp', 'snippet', 'buffers', 'path']},
      \     {'mode': '<c-p>'},
      \     {'mode': '<c-n>'}
      \   ],
      \   'string' : [
      \       {'complete_items': ['path']}
      \   ]
      \ }
      \}

" This config enable in completion-nvim plugin
let g:completion_customize_lsp_label    = {
      \ 'Function'      : ' [function]',
      \ 'Method'        : ' [method]',
      \ 'Variable'      : ' [variable]',
      \ 'Constant'      : ' [constant]',
      \ 'Struct'        : 'פּ [struct]',
      \ 'Class'         : ' [class]',
      \ 'Interface'     : ' [interface]',
      \ 'Text'          : 'ﮜ [text]',
      \ 'Enum'          : ' [enum]',
      \ 'EnumMember'    : ' [enumMember]',
      \ 'Module'        : ' [module]',
      \ 'Color'         : ' [color]',
      \ 'Property'      : ' [property]',
      \ 'Field'         : '料[field]',
      \ 'Unit'          : ' [unit]',
      \ 'File'          : ' [file]',
      \ 'Value'         : ' [value]',
      \ 'Event'         : '鬒[event]',
      \ 'Folder'        : ' [folder]',
      \ 'Keyword'       : ' [keyword]',
      \ 'Snippet'       : ' [snippet]',
      \ 'Operator'      : ' [operator]',
      \ 'vim-vsnip'     : ' [vim-vsnip]',
      \ 'Reference'     : ' [refrence]',
      \ 'TypeParameter' : ' [typeParameter]',
      \ 'Default'       : ' [default]'
      \}



augroup CompleteDonePumvisbile
  au!
  au Filetype c,cpp         setl omnifunc=v:lua.vim.lsp.omnifunc
  au Filetype python        setl omnifunc=v:lua.vim.lsp.omnifunc
  au Filetype rust          setl omnifunc=v:lua.vim.lsp.omnifunc
  au Filetype go            setl omnifunc=v:lua.vim.lsp.omnifunc
  au Filetype plantuml      setl omnifunc=v:lua.vim.lsp.omnifunc
  au Filetype lua           setl omnifunc=v:lua.vim.lsp.omnifunc
  au Filetype vim           setl omnifunc=v:lua.vim.lsp.omnifunc
  au Filetype kotlin        setl omnifunc=v:lua.vim.lsp.omnifunc
  au FileType sh            setl omnifunc=v:lua.vim.lsp.omnifunc
  au FileType html          setl omnifunc=v:lua.vim.lsp.omnifunc
  au FileType svelte        setl omnifunc=v:lua.vim.lsp.omnifunc
  au FileType javascript    setl omnifunc=v:lua.vim.lsp.omnifunc
  au FileType typescript    setl omnifunc=v:lua.vim.lsp.omnifunc
  au FileType dockerfile    setl omnifunc=v:lua.vim.lsp.omnifunc
  au FileType css,scss,sass setl omnifunc=v:lua.vim.lsp.omnifunc
  au FileType json          setl omnifunc=v:lua.vim.lsp.omnifunc

  au CompleteDone * if pumvisible() == 0 | pclose | endif
augroup END
