setl noautoindent
setl nocindent
setl nosmartindent
setl indentexpr=
" setl conceallevel=1
" setl foldlevel=1

" let g:vim_markdown_folding_disabled =

" setlocal spell
setlocal linebreak
setlocal nolist
setlocal formatlistpat=^\\s*\\d\\+[.\)]\\s\\+\\\|^\\s*[*+~-]\\s\\+\\\|^\\(\\\|[*#]\\)\\[^[^\\]]\\+\\]:\\s
setlocal comments=n:>
setlocal formatoptions+=cn

" keymap: [markdown] open markdown preview
nnoremap <buffer><silent> <F4> :MarkdownPreview<CR>

" # vim-markdownfmt ----------------------------
" let g:markdownfmt_command = 'markdownfmt'
" let g:markdownfmt_options = ''
" let g:markdownfmt_autosave = 0
" let g:markdownfmt_fail_silently = 0


" setlocal spell
" setlocal syntax=markdown.pandoc

let g:pandoc#modules#disabled               = ["folding"]
let g:pandoc#filetypes#handled              = ["pandoc", "markdown"]
let g:pandoc#filetypes#pandoc_markdown      = 1
let g:pandoc#syntax#conceal#use             = 0
let g:pandoc#syntax#conceal#urls            = 0
let g:pandoc#keyboard#sections#header_style = "a"
let g:pandoc#keyboard#use_default_mappings  = 1
let g:pandoc#compiler#command               = "pandoc"
let g:pandoc#formatting#textwidth           = 79
let g:pandoc#formatting#mode                = "hA"
