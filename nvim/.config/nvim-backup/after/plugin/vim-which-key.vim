scriptencoding utf-8

if !PluginLoaded('vim-which-key')
  finish
endif

call which_key#register('<Space>', 'g:which_key_leader_map')
call which_key#register(',', 'g:which_key_localleader_map')

nnoremap <silent> <localleader><space> :WhichKey '<Space>'<CR>
nnoremap <silent> <localleader><localleader> :<c-u>WhichKey ','<CR>

" remove link between diff added and vim which key
" highlight WhichKeySeperator guifg=green guibg=background
highlight default link WhichKey          Operator
highlight default link WhichKeySeperator DiffAdded
highlight default link WhichKeyGroup     Identifier
highlight default link WhichKeyDesc      Function

let g:which_key_use_floating_win       = 0
let g:which_key_disable_default_offset = 1
let g:which_key_sep                    = '→'
" let g:which_key_display_names          = {'<CR>': '↵', '<TAB>': '⇆'}

" Hide status line
augroup MyWich_Key
  " this one is which you're most likely to use?
  autocmd! FileType which_key
  autocmd  FileType which_key set laststatus=0 noshowmode noruler
        \| autocmd BufLeave <buffer> set laststatus=2 noshowmode ruler
augroup end

" =============================================================================
let g:which_key_leader_map =  {}

"let g:which_leader_key_map = {
"      \ 'name':   'main',
"      \ '0':      'which_key_ignore',
"      \ '1':      'which_key_ignore',
"      \ '2':      'which_key_ignore',
"      \ '3':      'which_key_ignore',
"      \ '4':      'which_key_ignore',
"      \ '5':      'which_key_ignore',
"      \ '6':      'which_key_ignore',
"      \ '7':      'which_key_ignore',
"      \ '8':      'which_key_ignore',
"      \ '9':      'which_key_ignore',
"      \}

let g:which_key_leader_map['%']     = ['%'      , 'Copy current path']
" let g:which_key_leader_map['Q']     = ['Q'      , 'Open Location-list']
" let g:which_key_leader_map['n']     = ['n'      , 'Next Buffer']
" let g:which_key_leader_map['p']     = ['p'      , 'Prev Buffer']
" let g:which_key_leader_map['j']     = ['j'      , 'Cnext']
" let g:which_key_leader_map['k']     = ['j'      , 'Cprev']
" let g:which_key_leader_map['l']     = ['l'      , 'Clast']
" let g:which_key_leader_map['h']     = ['h'      , 'Cfirst']
" let g:which_key_leader_map['s']     = ['s'      , 'Substitute']
" let g:which_key_leader_map['sW']    = ['sW'     , 'Substitute Current Word']
" let g:which_key_leader_map['o']     = ['o'      , 'Open browsers']
" let g:which_key_leader_map['Q']     = ['Q'      , 'Quickfix prev']
" let g:which_key_leader_map['l']     = ['q'      , 'Locationlist next']
" let g:which_key_leader_map.o        = {'name':  '+open' }
" let g:which_key_leader_map.o = {
"       \ 'name':  '+open_browsers'
"       \ }

" let g:which_key_leader_map.d = {
"       \ 'name': '+debug' ,
"       \ }

" LSP:
" let g:which_key_leader_map.l = {
"      \ 'name' : '+lsp'
"      \ }

" COC:
" let g:which_key_leader_map.l = {
"       \ 'name' : '+lsp' ,
"       \ '.' : [':CocConfig'                          , 'config'],
"       \ ';' : ['<Plug>(coc-refactor)'                , 'refactor'],
"       \ 'a' : ['<Plug>(coc-codeaction)'              , 'line action'],
"       \ 'A' : ['<Plug>(coc-codeaction-selected)'     , 'selected action'],
"       \ 'b' : [':CocNext'                            , 'next action'],
"       \ 'B' : [':CocPrev'                            , 'prev action'],
"       \ 'c' : [':CocList commands'                   , 'commands'],
"       \ 'd' : ['<Plug>(coc-definition)'              , 'definition'],
"       \ 'D' : ['<Plug>(coc-declaration)'             , 'declaration'],
"       \ 'e' : [':CocList extensions'                 , 'extensions'],
"       \ 'f' : ['<Plug>(coc-format-selected)'         , 'format selected'],
"       \ 'F' : ['<Plug>(coc-format)'                  , 'format'],
"       \ 'h' : ['<Plug>(coc-float-hide)'              , 'hide'],
"       \ 'i' : ['<Plug>(coc-implementation)'          , 'implementation'],
"       \ 'I' : [':CocList diagnostics'                , 'diagnostics'],
"       \ 'j' : ['<Plug>(coc-float-jump)'              , 'float jump'],
"       \ 'l' : ['<Plug>(coc-codelens-action)'         , 'code lens'],
"       \ 'n' : ['<Plug>(coc-diagnostic-next)'         , 'next diagnostic'],
"       \ 'N' : ['<Plug>(coc-diagnostic-next-error)'   , 'next error'],
"       \ 'o' : ['<Plug>(coc-openlink)'                , 'open link'],
"       \ 'O' : [':CocList outline'                    , 'outline'],
"       \ 'p' : ['<Plug>(coc-diagnostic-prev)'         , 'prev diagnostic'],
"       \ 'P' : ['<Plug>(coc-diagnostic-prev-error)'   , 'prev error'],
"       \ 'q' : ['<Plug>(coc-fix-current)'             , 'quickfix'],
"       \ 'r' : ['<Plug>(coc-rename)'                  , 'rename'],
"       \ 'R' : ['<Plug>(coc-references)'              , 'references'],
"       \ 's' : [':CocList -I symbols'                 , 'references'],
"       \ 'S' : [':CocList snippets'                   , 'snippets'],
"       \ 't' : ['<Plug>(coc-type-definition)'         , 'type definition'],
"       \ 'u' : [':CocListResume'                      , 'resume list'],
"       \ 'U' : [':CocUpdate'                          , 'update CoC'],
"       \ 'v' : [':Vista!!'                            , 'tag viewer'],
"       \ 'z' : [':CocDisable'                         , 'disable CoC'],
"       \ 'Z' : [':CocEnable'                          , 'enable CoC'],
"       \ }

" =============================================================================
let g:which_key_localleader_map = {}
" let g:which_key_localleader_map['f']  = {'name': '+fzf'}
" let g:which_key_localleader_map['s']  = {'name': '+sessions'}
" let g:which_key_localleader_map['t']  = {'name': '+runtest'}
" let g:which_key_localleader_map['w']  = {'name': '+wiki'}
" let g:which_key_localleader_map['y']  = {'name': '+startify'}
" let g:which_key_localleader_map['q']  = ['l'      , 'Balance size window']
" let g:which_key_localleader_map['a']  = {'name': '+actions'}

" let g:which_key_localleader_map.g = {
"       \ 'name'        : '+git',
"       \ 'q'           : 'Quit from diff',
"       \ 'P'           : 'Preview git messenger',
"       \ 'H'           : 'Show hunk git',
"       \ 'U'           : 'Undo hunk',
"       \ 's'           : 'Gitstatus',
"       \ 'S'           : 'Gdiff current file',
"       \ 'b'           : {
"       \     'name'      : '+blame',
"       \ },
"       \ 'c'           : {
"       \     'name'      : '+gclog',
"       \ }
"       \ }

" let g:which_key_localleader_map.F = {
"       \ 'name'        : '+customFZF',
"       \ 'F'           : 'Open FZF manual',
"       \ 'W'           : 'Open FZF word',
"       \ 'S'           : 'Open FZF history',
"       \ 'V'           : 'Toggle open',
"       \ }

" let g:which_key_localleader_map.G = {
"       \ 'name'        : '+customGREP',
"       \ 'G'           : 'Open GREP manual',
"       \ 'W'           : 'Open GREP word',
"       \ 'S'           : 'Open GREP history',
"       \ }

" let g:which_key_localleader_map.d = {
"       \ 'name'        : '+debug',
"       \ 'r'           : 'Run debug',
"       \ 'q'           : 'Quit debug',
"       \ 'b'           : 'Toggle breakpoint',
"       \ 'B'           : 'Clear all breakpoint',
"       \ 'c'           : 'Toggle breakpoint conditonal',
"       \ }
