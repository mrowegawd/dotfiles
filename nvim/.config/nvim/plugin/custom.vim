
let g:vsnip_filetypes = {}
let g:vsnip_filetypes['typescript'] = ['javascript']
let g:vsnip_filetypes['svelte'] = ['javascript', 'typescript', 'html']

"  convert this mapping into lua
autocmd! FileType qf nnoremap <buffer> <leader><Enter> <C-w><Enter><C-w>L
