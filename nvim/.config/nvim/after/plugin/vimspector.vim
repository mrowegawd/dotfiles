scriptencoding utf-8

if !PluginLoaded('vimspector')
  finish
endif

sign define vimspectorBP text=綠 texthl=Normal
sign define vimspectorBPDisabled text=祿 texthl=Normal
sign define vimspectorPC text=->  texthl=SpellBad

let g:vimspector_enable_mappings = 'HUMAN'  " 'VISUAL_STUDIO' | 'HUMAN'

fun! GotoWindow(id)
  :call win_gotoid(a:id)
endfun

func! AddToWatch()
  let word = expand('<cexpr>')
  :echom word
  call vimspector#AddWatch(word)
endfunction

" keymap: [plugin][vimspector][debug] run debug under cursor
nmap <localleader>drc    <Plug>VimspectorRunToCursor

" keymap: [plugin][vimspector][debug] toggle breakpoint
nmap <leader>db          :call vimspector#ToggleBreakpoint()<CR>

" keymap: [plugin][vimspector][debug] clear breakpoint
nnoremap <leader>dB      :call vimspector#ClearBreakpoints()<CR>

" keymap: [plugin][vimspector][debug] toggle conditional breakpoint
nmap <leader>dc          <Plug>VimspectorToggleConditionalBreakpoint

" keymap: [plugin][vimspector][debug] launch or start
nmap <leader>da          <Plug>AttachDebug

" keymap: [plugin][vimspector][debug] exit debug
nmap <leader>dq          <Plug>AttachDebugExit

" nnoremap <localleader>dd :TestNearest -strategy=jest<CR>


nnoremap <Plug>AttachDebug
            \ :<C-U>call <SID>MapDebugCustom()<CR>

nnoremap <Plug>AttachDebugExit
            \ :<C-U>call <SID>UnMapDebugCustom()<CR>

function! s:UnMapDebugCustom() abort

  " unmap <localleader>dc
  " unmap <localleader>dv
  " unmap <localleader>dw
  " unmap <localleader>ds
  " unmap <localleader>do
  " unmap <localleader>d?

  unmap <a-o>
  unmap <a-n>
  unmap <a-p>

  unmap <leader>dc
  unmap <leader>dR

  call vimspector#Reset()
endfunction

function! s:MapDebugCustom() abort

  " keymap: [plugin][vimspector][debug][move] go to window code
  " nnoremap <localleader>dc :call GotoWindow(g:vimspector_session_windows.code)<CR>
  " keymap: [plugin][vimspector][debug][move] go to window variable
  " nnoremap <localleader>dv :call GotoWindow(g:vimspector_session_windows.variables)<CR>
  " keymap: [plugin][vimspector][debug][move] go to window watches
  " nnoremap <localleader>dw :call GotoWindow(g:vimspector_session_windows.watches)<CR>
  " keymap: [plugin][vimspector][debug][move] go to window stack_trace
  " nnoremap <localleader>ds :call GotoWindow(g:vimspector_session_windows.stack_trace)<CR>
  " keymap: [plugin][vimspector][debug][move] go to window output
  " nnoremap <localleader>do :call GotoWindow(g:vimspector_session_windows.output)<CR>

  " keymap: [plugin][vimspector][debug] add to Watch
  " nnoremap <localleader>d? :call AddToWatch()<CR>

  " keymap: [plugin][vimspector][debug][move] step Out
  nmap <a-o>     <Plug>VimspectorStepOut

  " keymap: [plugin][vimspector][debug][move] step Into (in depth)
  nmap <a-p>     <Plug>VimspectorStepInto

  " keymap: [plugin][vimspector][debug][move] step Over
  nmap <a-n>     <Plug>VimspectorStepOver

  " keymap: [plugin][vimspector][debug] continue
  nmap <leader>dc        :call vimspector#Continue()<CR>

  " keymap: [plugin][vimspector][debug] restart debug
  nmap <leader>dR        <Plug>VimspectorRestart

  call vimspector#Launch()
endfunction

function! s:CustomMapping() abort
  nmap <silent><leader>?      :<C-u>call <Sid>VimspectorHelp()<CR>
endfunction

function! s:VimspectorHelp()
  echo "\n"
  echo ' <leader>?            Hello world'
  echo "\n"
endfunction

" taken from https://github.com/puremourning/vimspector/blob/master/README.md#human-mode
augroup MyVimspectorUICustomistaion
  autocmd!
  autocmd User VimspectorUICreated call s:CustomMapping()
  autocmd User VimspectorUICreated nmap <silent><buffer> <leader>?

  " autocmd User VimspectorTerminalOpened call s:SetUpTerminal()
augroup END
