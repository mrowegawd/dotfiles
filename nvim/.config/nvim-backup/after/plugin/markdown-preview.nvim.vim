if !PluginLoaded('markdown-preview.nvim')
  finish
endif

" let g:markdown_fenced_languages = [
"       \ 'html',
"       \ 'bash=sh',
"       \ 'css',
"       \ 'python',
"       \ 'javascript',
"       \ 'js=javascript',
"       \ 'typescript',
"       \ 'awk',
"       \ 'lua',
"       \ 'vim',
"       \ 'help',
"       \ 'yaml',
"       \ 'go'
"       \]

" keymap: [plugin][markdown-preview][toggle] open
" nnoremap <buffer> <F2> :MarkdownPreviewToggle<cr>

" keymap: [plugin][Markdown-preview] stop preview
" nnoremap <buffer> <F4> :MarkdownPreviewStop<cr>
"
function! s:markdownPreview() abort
  if has('nvim')
    nmap <buffer> <leader>c<F2>   :MarkdownPreview<cr>
    nmap <buffer> <leader>c<F4>   :MarkdownPreviewStop<cr>
  endif
endfunction

augroup MarkdownPrev
  autocmd!
  au FileType vimwiki call s:markdownPreview()
augroup END
