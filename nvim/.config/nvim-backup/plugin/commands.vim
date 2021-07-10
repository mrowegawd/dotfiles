command! -nargs=0 CreateVimDirectories call Create_vim_directories()

" Remove all buffers, but not the current
command! -nargs=? -complete=buffer -bang BufOnly :call BufOnly('<args>', '<bang>')

" Remove all opened buffers
command! -bang Wipeout          :call Wipeout(<bang>0)

command! -range=% -nargs=1 NL
  \ <line1>,<line2>!nl -w <args> -s '. ' | perl -pe 's/^.{<args>}..$//'
