
" settings specific to Go file types
setlocal tabstop=4 shiftwidth=4 softtabstop=4

" setl foldmethod=expr
" setl foldexpr=GoFolder()
" setl foldtext=GoText()
" setl foldlevel=0

" TODO: remove this, jika setting khusus file go sudah benar
setl nolist

" create a go doc comment based on the word under the cursor
function! s:create_go_doc_comment()
  norm "zyiw
  execute ':put! z'
  execute ':norm I// \<Esc>$'
endfunction

" keymap: [lang][go] Create doc
nnoremap <buffer> <localleader>cf :<C-u>call <SID>create_go_doc_comment()<CR>

function! s:matches(str, patterns) abort
  if type(a:patterns) == v:t_string
    return match(a:str, a:patterns) != -1
  elseif type(a:patterns) == v:t_list
    for pat in a:patterns
      if s:matches(a:str, pat)
        return v:true
      endif
    endfor
  endif

  return v:false
endfunction

let s:start_new_important_fold = [
          \ '^func',
          \ '^struct',
          \ ]

let s:is_comment =  '^//\ '

function! GoFolder(...) abort
  let lnum = get(a:, 1, v:lnum)
  let line = getline(lnum)

  let next_line = getline(lnum + 1)
  let prev_line = getline(lnum - 1)

  " TOD0: Copy some basics from vim go...

  if s:matches(line, s:is_comment)
    " Start a new fold when the previous line was empty
    if s:matches(prev_line, '^$')
      return '>1'
    endif

    " Stop the current fold when the next line is important
    if s:matches(next_line, s:start_new_important_fold)
      return '<1'
    endif

    " Otherwise you're chillin in the fold
    return '1'
  endif

  if s:matches(line, s:start_new_important_fold)
    return '>1'
  endif

  return '='
endfunction

function! GoText(...) abort
  let fold_start = get(a:, 1, v:foldstart)
  let fold_end = get(a:, 2, v:foldend)

  let start_line = getline(fold_start)

  if s:matches(start_line, s:is_comment)
    let lines = getline(fold_start, fold_end)

    " TODO: Limit how many characters we see.
    " Pick out only the stuff I want fro mcmoments
    return join(
          \ map(lines, { k, v -> substitute(v, '// ', '', '') }),
          \ ' ')
  endif

  " TODO: Still could make structs and funcs show up cooler...
  " etc.
  return foldtext()
endfunction

" if has('autocmd')
"   augroup GoCustomm
"     autocmd!
"     autocmd BufWritePre *.go :call CocAction('runCommand', 'editor.action.organizeImport')
"   augroup End
" endif

" highlight default link goErr WarningMsg |
"             \ match goErr /\<err\>/

" function! s:Tlor() abort
"   nmap      <buffer><F2>  <Plug>(go-run-split)

"   nmap      <buffer><F5>  :DlvDebug<cr>
"   " possible to call DlvTest --build-flags='--tags=integration' using tags for separating integration / unit tests
"   nmap      <buffer><F6>  :DlvTest<cr>

"   nnoremap  <buffer><F7>  :DlvToggleBreakpoint<cr>
"   nnoremap  <buffer><F8>  :DlvToggleTracepoint<cr>
"   nnoremap  <buffer><F9>  :DlvClearAll<cr>

"   nmap      <buffer><leader>rf   <Plug>(go-test)
"   nmap      <buffer><leader>rs   <Plug>(go-test-func)
"   nmap      <buffer><leader>tax   :GoAddTags xml<cr>
"   nmap      <buffer><leader>taj   :GoAddTags json<cr>
"   nmap      <buffer><leader>tab   :GoAddTags bson<cr>:GoAddTags bson,omitempty<cr>
"   nmap      <buffer><leader>tad   :GoAddTags dynamo<cr>

"   nmap      <buffer><leader>tr    :GoRemoveTags<cr>
"   nmap      <buffer><leader>trx   :GoRemoveTags xml<cr>
"   nmap      <buffer><leader>trj   :GoRemoveTags json<cr>
"   nmap      <buffer><leader>trb   :GoRemoveTags bson<cr>
"   nmap      <buffer><leader>trd   :GoRemoveTags dynamo<cr>
"   nmap      <buffer><leader>?     :call gitmox#helpmenu#vimgo()<cr>
" endfunction

" call s:Tlor()
