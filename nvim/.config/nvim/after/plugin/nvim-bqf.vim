if !PluginLoaded('nvim-bqf')
  finish
endif

" MAPPINGS GUIDE

" | Function    | Action                                             | Def Key   |
" | ----------- | -------------------------------------------------- | --------- |
" | open        | open the item under the cursor                     | `<CR>`    |
" | openc       | like `open`, and close quickfix window             | `o`       |
" | tab         | open the item under the curosr in a new tab        | `t`       |
" | tabb        | like `tab`, but stay at quickfix window            | `T`       |
" | split       | open the item under the cursor in vertical split   | `<C-x>`   |
" | vsplit      | open the item under the cursor in horizontal split | `<C-v>`   |
" | prevfile    | go to previous file under the cursor               | `<C-p>`   |
" | nextfile    | go to next file under the cursor                   | `<C-n>`   |
" | prevhist    | go to previous quickfix list                       | `<`       |
" | nexthist    | go to next quickfix list                           | `>`       |
" | stoggleup   | toggle sign and move cursor up                     | `<S-Tab>` |
" | stoggledown | toggle sign and move cursor down                   | `<Tab>`   |
" | stogglevm   | toggle multiple signs in visual mode               | `<Tab>`   |
" | sclear      | clear the signs in current quickfix list           | `z<Tab>`  |
" | pscrollup   | scroll up half-page in preview window              | `<C-b>`   |
" | pscrolldown | scroll down half-page in preview window            | `<C-f>`   |
" | pscrollorig | scroll back to original postion in preview window  | `zo`      |
" | ptogglemode | toggle preview window between normal and max size  | `zp`      |
" | ptoggleitem | toggle preview for an item of quickfix list        | `p`       |
" | ptoggleauto | toggle auto preview when cursor moved              | `P`       |
" | filter      | create new list for signed items                   | `zn`      |
" | filterr     | create new list for non-signed items               | `zN`      |
" | fzffilter   | enter fzf mode                                     | `zf`      |

function! Help_forquicklist()
  echo "\n"
  echo "open the item under the cursor                     <CR>"
  echo "like `open`, and close quickfix window             o"
  echo "open the item under the curosr in a new tab        t"
  echo "like `tab`, but stay at quickfix window            T"
  echo "open the item under the cursor in vertical split   <C-x>"
  echo "open the item under the cursor in horizontal split <C-v>"
  echo "go to previous file under the cursor               <C-p>"
  echo "go to next file under the cursor                   <C-n>"
  echo "go to previous quickfix list                       <"
  echo "go to next quickfix list                           >"
  echo "toggle sign and move cursor up                     <S-Tab>"
  echo "toggle sign and move cursor down                   <Tab>"
  echo "toggle multiple signs in visual mode               <Tab>"
  echo "clear the signs in current quickfix list           z<Tab>"
  echo "scroll up half-page in preview window              <C-b>"
  echo "scroll down half-page in preview window            <C-f>"
  echo "scroll back to original postion in preview window  zo"
  echo "toggle preview window between normal and max size  zp"
  echo "toggle preview for an item of quickfix list        p"
  echo "toggle auto preview when cursor moved              P"
  echo "create new list for signed items                   zn"
  echo "create new list for non-signed items               zN"
  echo "enter fzf mode                                     zf"
  echo "\n"
endf

function! s:Myquick() abort

  " keymap: [plugin][nvim-bqf][quickfix] call help
  nnoremap <silent> <buffer> <leader>? :<C-U>call Help_forquicklist()<CR>

endfunction

if has('autocmd')
  augroup Myquickquick
    au!
    au FileType qf call s:Myquick()
  augroup END
endif
