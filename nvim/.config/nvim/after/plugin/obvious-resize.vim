if !PluginLoaded('obvious-resize')
  finish
endif

noremap <silent> <A-S-k> :<C-U>ObviousResizeUp<CR>
noremap <silent> <A-S-j> :<C-U>ObviousResizeDown<CR>
noremap <silent> <A-S-h> :<C-U>ObviousResizeLeft<CR>
noremap <silent> <A-S-l> :<C-U>ObviousResizeRight<CR>
