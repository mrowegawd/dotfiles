" remove all other buffers
function! BufOnly(buffer, bang) abort
    if a:buffer ==# ''
        let buffer = bufnr('%')
    elseif (a:buffer + 0) > 0
        let buffer = bufnr(a:buffer + 0)
    else
        let buffer = bufnr(a:buffer)
    endif
    if buffer == -1
        echohl ErrorMsg
        echomsg 'No matching buffer for' a:buffer
        echohl None
        return
    endif
    let last_buffer = bufnr('$')
    let delete_count = 0
    let n = 1
    while n <= last_buffer
        if n != buffer && buflisted(n)
            if a:bang ==# '' && getbufvar(n, '&modified')
                echohl ErrorMsg
                echomsg 'No write since last change for buffer'
                            \ n '(add ! to override)'
                echohl None
            else
                silent exe 'bdel' . a:bang . ' ' . n
                if ! buflisted(n)
                    let delete_count = delete_count+1
                endif
            endif
        endif
        let n = n+1
    endwhile
    if delete_count == 1
        echomsg delete_count 'buffer deleted'
    elseif delete_count > 1
        echomsg delete_count 'buffers deleted'
    endif
endfunction

" delete all not visible buffers
function! Wipeout(bang) abort
    let visible = {}
    for t in range(1, tabpagenr('$'))
        for b in tabpagebuflist(t)
            let visible[b] = 1
        endfor
    endfor
    let l:tally = 0
    let l:cmd = 'bw'
    if a:bang
        let l:cmd .= '!'
    endif
    for b in range(1, bufnr('$'))
        if buflisted(b) && !has_key(visible, b)
            let l:tally += 1
            exe l:cmd . ' ' . b
        endif
    endfor
    echon 'Deleted ' . l:tally . ' buffers'
endfunction

" function! GoogleSearch() abort
"     let searchterm = getreg('g')
"     silent! exec "silent! !firefox \"http://google.com/search?q=" . searchterm . "\" &"
" endfunction

" function! s:HandleURL() abort
"     let g:uri = matchstr(getline('.'), '[a-z]*:\/\/[^ >,;]*')
"     if g:uri !=# ''
"         silent! exec '!firefox "'.g:uri.'"'
"     else
"         echo '[!] Sorry, No URI found in line.'
"     endif
" endfunction

function! PlantUmlfunc() abort
    if has('nvim')
        nmap <buffer> <F2>   :PlantumlOpen<cr>
        nmap <buffer> <F4>   :PlantumlStop<cr>
    endif
endfunction

" copy current file's path to clipboard
function! s:Copypath() abort
    let @+ = expand('%:p')
    echo '[+] pwd copied..'
endfunction

nnoremap <Plug>Copypath
            \ :<C-U>call <SID>Copypath()<CR>

" function! s:ZoomToggle() abort
"     if exists('t:zoomed') && t:zoomed
"         execute t:zoom_winrestcmd
"         let t:zoomed = 0
"     else
"         let t:zoom_winrestcmd = winrestcmd()
"         resize
"         vertical resize
"         let t:zoomed = 1
"     endif
" endfunction

" command! ZoomToggle call s:ZoomToggle()
