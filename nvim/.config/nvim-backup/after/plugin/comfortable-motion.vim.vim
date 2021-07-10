if !PluginLoaded('comfortable-motion.vim')
  finish
endif

" -----------------------------------------------------------------------------
" ABOUT: Smooth scrolling to the Vim world!
" -----------------------------------------------------------------------------

let g:comfortable_motion_no_default_key_mappings = 1
let g:comfortable_motion_friction = 80.0
let g:comfortable_motion_air_drag = 2.0

" keymap: [scroll] go down
nnoremap <silent> <pagedown> :<C-u>call comfortable_motion#flick(130)<CR>
" keymap: [scroll] go up
nnoremap <silent> <pageup>   :<C-u>call comfortable_motion#flick(-130)<CR>
" keymap: [scroll] go down
nnoremap <silent> <C-d>      :<C-u>call comfortable_motion#flick(120)<CR>
" keymap: [scroll] go up
nnoremap <silent> <C-u>      :<C-u>call comfortable_motion#flick(-120)<CR>
