if !PluginLoaded('vim-workspace')
  finish
endif

let g:workspace_session_directory = g:mycache_dir . '/nvim/sessions/'
let g:workspace_undodir = g:mycache_dir . '/nvim/undo/'
let g:workspace_autosave = 0
let g:workspace_autosave_ignore = ['gitcommit', 'qf', 'tagbar', 'vista']
let g:workspace_session_disable_on_args = 1

" keymap: [plugin][workspace][toggle]
nnoremap <localleader>tw :ToggleWorkspace<CR>
