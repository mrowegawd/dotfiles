function! CreateCapture(window, ...)
  " if this file has a name
  if expand('%:p') !=# ''
    let g:temp_org_file=printf('file:%s:%d', expand('%:p') , line('.'))
    exec a:window . ' ' . g:org_refile
    exec '$read ' . globpath(&rtp, 'extra/org/template.org')
  elseif a:0 == 1 && a:1 == 'qutebrowser'
    exec a:window . ' ' . g:org_refile
    exec '$read ' . globpath(&rtp, 'extra/org/templateQUTE.org')
  else
    exec a:window . ' ' . g:org_refile
    exec '$read ' . globpath(&rtp, 'extra/org/templatenofile.org')
  endif
  " 	call feedkeys("i\<Plug>(minisnip)", 'i')
endfunction

map <silent>gO :e ~/Dropbox/vimwiki/org/todo.org<CR>
map <silent>gC :call CreateCapture('split')<CR>

command! -nargs=0 NGrep grep! ".*" ~/Dropbox/vimwiki/org/*.org
