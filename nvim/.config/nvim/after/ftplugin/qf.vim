" Disable some unneccessary settings in quickfix windows
setlocal colorcolumn=
setlocal signcolumn=

setlocal nonumber
setlocal norelativenumber

nnoremap <buffer> <silent> <c-d>  :CekduluqfRemove<CR>
nnoremap <buffer> <silent> dd     :CekduluqfRemove<CR>
