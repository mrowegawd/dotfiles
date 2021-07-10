scriptencoding utf-8

if !PluginLoaded('nvim-tree.lua')
  finish
endif

function! s:NvimTree_mappings() abort

  " keymap: [plugin][nvimtree][inside] open fzf
  nnoremap <silent> <buffer> <leader>f :call NvimTree_Fuzzy_Finder()<CR>

  " keymap: [plugin][nvimtree][inside] call help
  nnoremap <silent> <buffer> <leader>? :<C-U>call Help_NvimTree()<CR>

endfunction


" keymap: [plugin][nvimtree][toggle] open
nnoremap <silent> <F1>          :NvimTreeToggle<CR>

" keymap: [plugin][nvimtree] find file with nvimtree
nnoremap <silent> <leader><F1>  :NvimTreeFindFile<CR>zz

" keymap: [plugin][nvimtree][inside] refresh
nnoremap <silent> R             :NvimTreeRefresh<CR>


function! Help_NvimTree()
  echo "\n"
  echo ' add                                a'
  echo ' rename                             r'
  echo ' refresh                            R'
  echo ' cut                                x'
  echo ' copy                               c'
  echo ' paste from clipboard               p'
  echo ' delete                             d'
  echo ' go to next git                     <S-DOWN>'
  echo ' go to prev git                     <S-UP>'
  echo ' find in FZF :files                 <leader>f'
  echo ' find in grep :Ag                   <leader>g'
  echo "\n"
  echo ' enter/edit file/dir                l'
  echo ' view split vertical                <C-v>'
  echo ' view split horizontal              <C-s>'
  echo "\n"
  echo ' will toggle visibility file/dir    I'
  echo "\n"
endf

let s:VIM_Fuzzy_Finder = 'fzf'

function! NvimTree_Fuzzy_Finder()
  if s:VIM_Fuzzy_Finder ==# 'leaderf'
    execute 'LeaderfFile'
  elseif s:VIM_Fuzzy_Finder ==# 'fzf'
    execute 'Files'
  elseif s:VIM_Fuzzy_Finder ==# 'denite'
    execute 'Denite file_rec'
  elseif s:VIM_Fuzzy_Finder ==# 'remix'
    execute 'LeaderfFile'
  endif
endfunction

function! NvimTree_Grep()
  if s:VIM_Fuzzy_Finder ==# 'leaderf'
    execute 'Leaderf rg'
  elseif s:VIM_Fuzzy_Finder ==# 'fzf'
    execute 'Ag'
  elseif s:VIM_Fuzzy_Finder ==# 'denite'
    execute 'Denite grep'
  elseif s:VIM_Fuzzy_Finder ==# 'remix'
    execute 'Ag'
  endif
endfunction

if has('autocmd')
  augroup MyNvimTree
    au!
    au FileType NvimTree call s:NvimTree_mappings()
  augroup END
endif
