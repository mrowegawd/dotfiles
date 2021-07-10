scriptencoding UTF-8    " Default encoding for current script.

if !PluginLoaded('nerdtree')
  finish
endif
let s:VIM_Fuzzy_Finder = 'fzf'

function! s:nerdtree_mappings() abort
  nnoremap <silent> <buffer> ~ :<C-u>NERDTreeVCS<CR>
  nnoremap <silent> <buffer> <leader>f :call Nerdtree_Fuzzy_Finder()<CR>
  nnoremap <silent> <buffer> <leader>g :call Nerdtree_Grep()<CR>
  nnoremap <silent> <buffer> <leader>? :call Help_nerdtree()<CR>
endfunction

map <F1> :NERDTreeToggle<CR>
nmap <leader><F1> :NERDTreeFind<CR>zz

function! Nerdtree_Fuzzy_Finder()
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
function! Nerdtree_Grep()
  if g:VIM_Fuzzy_Finder ==# 'leaderf'
    execute 'Leaderf rg'
  elseif g:VIM_Fuzzy_Finder ==# 'fzf'
    execute 'Ag'
  elseif g:VIM_Fuzzy_Finder ==# 'denite'
    execute 'Denite grep'
  elseif g:VIM_Fuzzy_Finder ==# 'remix'
    execute 'Ag'
  endif
endfunction

if exists('g:loaded_webdevicons')
  call webdevicons#refresh()
endif

augroup NERDTreeAu
  autocmd!
  autocmd FileType nerdtree setlocal signcolumn=no
  autocmd FileType nerdtree call s:nerdtree_mappings()
augroup END

" Automatically delete buffer
" if files deleted in nerdtree
let NERDTreeAutoDeleteBuffer                = 1
" let g:NERDTreeMapActivateNode               = '<tab>'
" let g:NERDTreeShowHidden                    = 1
" let g:NERDTreeChDirMode                     = 2
" let g:NERDTreeMouseMode                     = 2
" let g:NERDTreeStatusline                    = 'NERDTree'
" let g:NERDTreeCascadeSingleChildDir         = 0
" let g:NERDTreeShowBookmarks                 = 0
let g:NERDTreeDirArrowExpandable            = ' '
let g:NERDTreeDirArrowCollapsible           = ' '
" let g:NERDTreeGlyphReadOnly                 = ''
" let g:NERDTreeWinSize                       = 35
" let g:NERDTreeGitStatusUseNerdFonts         = 1
" let g:NERDTreeUpdateOnCursorHold            = 0
" let g:DevIconsEnableFoldersOpenClose        = 1
" let g:viz_nr2char_auto                      = 1
let g:NERDTreeMinimalUI                     = 1
" let g:NERDTreeGitStatusConcealBrackets      = 1 " default: 0
" let g:webdevicons_conceal_nerdtree_brackets = 0
let g:NERDTreeIgnore                        = [
      \ '\.idea',
      \ '\.iml',
      \ '\.pyc',
      \ '\~$',
      \ '\.swo$',
      \ '\.git$',
      \ '\.hg',
      \ '\.svn',
      \ '\.bzr',
      \ '\.DS_Store',
      \ '^node_modules',
      \ 'tmp',
      \ 'gin-bin'
      \]
