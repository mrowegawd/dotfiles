
nnoremap <buffer> <localleader>cf :call UpdatePhpDocIfExists()<CR>

function! UpdatePhpDocIfExists()
    normal! k
    if getline('.') =~? '/'
        normal! V%d
    else
        normal! j
    endif
    call PhpDocSingle()
    normal! k^%k$
    if getline('.') =~? ';'
        exe 'normal! $svoid'
    endif
endfunction
