if exists("g:__loaded_git")
  finish
endif

let g:__loaded_git = 1

augroup aug_git_integration
  au!

  " Show Fugitive status window in separate tab
  autocmd BufEnter */.git/index
        \ if !exists('b:created') && get(b:, 'fugitive_type', '') == 'index' |
        \   let b:created = 1 |
        \   wincmd T |
        \ endif

  " Collapse status window when viewing diff or editing commit message
  autocmd BufLeave */.git/index call _#fugitive#OnStatusBufferEnterOrLeave(0)
  autocmd BufEnter */.git/index call _#fugitive#OnStatusBufferEnterOrLeave(1)

  " Delete fugitive buffers automatically on leave
  autocmd BufReadPost fugitive://* set bufhidden=wipe

augroup END

if get(b:, 'fugitive_type', '') =~# 'commit'
  " Open snapshot of file under the cursor. Equivalent to ":Gedit <commit>:<file>"
  " NOTE: only when cursor is placed over file diff row in a commit buffer
  nnoremap <buffer> ge :call _#fugitive#OpenFileSnapshotInCommitBuffer()<CR>

  " Redefine mappings to jump between files
  nmap <buffer> ]f ]m
  nmap <buffer> [f [m
endif

nnoremap hH :diffget //2<CR>
nnoremap hL :diffget //3<CR>
