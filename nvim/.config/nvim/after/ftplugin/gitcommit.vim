setlocal foldmethod=manual
setlocal spell nolist

augroup ft_gitcommit
  au! * <buffer>
  au! BufEnter COMMIT_EDITMSG

  " Automatically start insert mode for commit messages
  au BufEnter COMMIT_EDITMSG startinsert
augroup END
