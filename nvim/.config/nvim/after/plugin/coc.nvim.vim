if !PluginLoaded('coc.nvim')
  finish
endif

" function! s:websitesgo()
  let g:coc_global_extensions = [
        \   'coc-emmet',
        \   'coc-svelte',
        \   'coc-html',
        \   'coc-json',
        \   'coc-docker',
        \   'coc-yaml',
        \   'coc-vimlsp',
        \   'coc-pyright',
        \   'coc-lists',
        \   'coc-tailwindcss',
        \   'coc-tsserver',
        \ ]

  function! s:Showdocumentation() abort
    if (index(['vim', 'help'], &filetype) >= 0)
      execute 'h '.expand('<cword>')
    else
      call CocActionAsync('doHover')
    endif
  endfunction
  "
  function! s:cochover()
    if !coc#util#has_float() && g:Cochoverenable == 1
      call CocActionAsync('doHover')
      call CocActionAsync('showSignatureHelp')
    endif
  endfunction

  let g:Cochoverenable = 0
  nnoremap <silent> <leader>al :let g:Cochoverenable = g:Cochoverenable == 1 ? 0 : 1<CR>

  if has('autocmd')
    augroup Mycocgroup
      autocmd!
      " autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')

      " au CursorHold * silent call CocActionAsync('highlight')
      autocmd CursorHold * silent call s:cochover()
      " autocmd InsertEnter * call coc#util#float_hide()
      au VimEnter * inoremap <expr> <Tab> (pumvisible() ? "\<C-n>" : "\<Tab>")
    augroup END
  endif

  let g:coc_snippet_next = '<TAB>'

  " press enter to exec 'confirm' on completion
  inoremap <silent><expr> <CR> pumvisible() ? coc#_select_confirm() :
        \ "\<C-g>u\<CR>\<C-r>=coc#on_enter()\<CR>"

  " manual triggering completion
  inoremap <silent><expr> <c-space> coc#refresh()

  nmap <silent> <leader>ld <Plug>(coc-definition)
  nmap <silent> <leader>lt <Plug>(coc-type-definition)
  nmap <silent> <leader>li <Plug>(coc-implementation)
  " nmap <silent><leader>lh :call CocActionAsync('doHover')<CR>
  nmap <silent> K         :<C-U>call <SID>Showdocumentation()<CR>
  nmap <silent> <leader>ls :call CocActionAsync('showSignatureHelp')<CR>
  nmap <silent> <leader>lR <Plug>(coc-rename)
  nmap <silent> <leader>lf <Plug>(coc-format)
  nmap <silent> <leader>lr <Plug>(coc-references)
  nmap <silent> <leader>la <Plug>(coc-action)
  vmap <silent> <leader>lA <Plug>(coc-codeaction-selected)

  " nmap <silent><leader>ll <Plug>(coc-codelens-action)

  nnoremap <leader>lR :CocRestart<CR>

  nmap <silent> <leader>dj      <Plug>(coc-diagnostic-next)
  nnoremap <silent> <leader>do  :CocList diagnostics<cr>
  nmap <silent> <leader>dk      <Plug>(coc-diagnostic-prev)
  nmap <silent> <leader>di      <Plug>(coc-diagnostic-info)

  " Create mappings for function text object, requires document symbols feature of languageserver.
  xmap if <Plug>(coc-funcobj-i)
  xmap af <Plug>(coc-funcobj-a)
  omap if <Plug>(coc-funcobj-i)
  omap af <Plug>(coc-funcobj-a)

  nmap fcc :CocCommand<CR>
  nmap fcl :CocList<CR>
" endfunction
"
  call coc#config('languageserver', {
  \   'sumneko_lua': {
  \     'command': expand('~/.local/share/vim-lsp-settings/servers/sumneko-lua-language-server/extension/server/bin/Linux/lua-language-server'),
  \     'args': ['-E', expand('~/.local/share/vim-lsp-settings/servers/sumneko-lua-language-server/extension/server/main.lua')],
  \     'filetypes': ['lua'],
  \     'settings': {
  \       'Lua': {
  \         'completion': {
  \           'callSnippet': 'Replace',
  \         },
  \         'diagnostics': {
  \           'globals': ['vim']
  \         }
  \       }
  \     }
  \   }
  \ })

" augroup TestSvelte
"   au!
"   au FileType svelte,typescript call s:websitesgo()
"   au BufNewFile,BufRead coc-settings.json call s:websitesgo()
" augroup end

" git coc
" nmap <leader>gn <Plug>(coc-git-nextchunk)
" nmap <leader>gp <Plug>(coc-git-prevchunk)
"
" nmap <leader>gi <Plug>(coc-git-chunkinfo)
" nmap <silent> <leader>gt :CocCommand git.toggleGutters<CR>
"
" nmap <leader>gu :<C-u>CocCommand git.chunkUndo<CR>
" nmap <leader>ga :<C-u>CocCommand git.chunkStage<CR>
"
" nmap <leader>gz :<C-u>CocCommand git.foldUnchanged<CR>
"
" nmap <silent> <leader>gO :CocCommand git.browserOpen<CR>
