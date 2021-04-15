set encoding=utf-8
scriptencoding utf-8

let g:myblackdark = '#000000'
let g:myblue      = '#81a2be'
let g:mycyan      = '#8abeb7'
let g:mygreen     = '#a9dc76'
let g:mygrey      = '#dcdcdc'
let g:mymagenta   = '#b294bb'
let g:myred       = '#cc6666'
let g:mywhite     = '#c5c8c6'
let g:myyellow    = '#7accd7'

function s:set_custom_highlight()
  execute 'hi DiffAdd guibg='. g:myguibg_non . ' guifg='. g:mygreen
  execute 'hi DiffChange guibg='. g:myguibg_non . ' guifg='. g:myblue
  execute 'hi DiffDelete guibg='. g:myguibg_non
  execute 'hi! ColorColumn ctermbg=NONE guibg='. g:myguibg_non
  execute 'hi! Normal guibg='. g:myguibg_active
  execute 'hi! LineNr ctermbg=NONE guibg='. g:myguibg_non
  execute 'hi! Folded ctermbg=NONE guibg='. g:myguibg_non

  " color NormalFloat, check `statusline.vim`
  execute 'hi! GWhite ctermbg=NONE guibg='. g:myblackdark ' guifg='. g:mywhite

  hi Todo gui=bold
  " execute 'hi! NormalFloat ctermbg=NONE guibg='.g:myred

  execute 'hi! clear VertSplit'
  execute 'hi! link  VertSplit LineNr'

  execute 'hi! SignColumn ctermbg=NONE guibg='. g:myguibg_non

  execute 'hi! CursorLine ctermbg=NONE guibg='. g:myguibg_non

  execute 'hi! link SignifySignAdd DiffAdd'
  execute 'hi! link SignifySignChange DiffChange'
  execute 'hi! SignifySignDelete guibg='. g:myguibg_non

  highlight! link ALEErrorSign DiffDelete
  execute 'hi ALEWarningSign guibg='. g:myguibg_non

endfunction

augroup Custom_highlights
  autocmd!
  autocmd VimEnter * call <SID>set_custom_highlight()
  autocmd ColorScheme * call <SID>set_custom_highlight()
augroup END

" execute 'colorscheme '. g:mytheme
" set background=dark
highlight! Comment cterm=italic gui=italic
