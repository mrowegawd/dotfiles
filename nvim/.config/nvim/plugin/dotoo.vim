function! CreateCapture(window, ...)
	" if this file has a name
	if expand('%:p') !=# ''
		let g:temp_org_file=printf('file:%s:%d', expand('%:p') , line('.'))
		exec a:window . ' ' . g:org_refile
		exec '$read ' . globpath(&rtp, 'extra/org/template.org')
	elseif a:0 == 1 && a:1 == 'qutebrowser'
		exec a:window . ' ' . g:org_refile
		exec '$read ' . globpath(&rtp, 'extra/org/templateQUTE.org')
	else
		exec a:window . ' ' . g:org_refile
		exec '$read ' . globpath(&rtp, 'extra/org/templatenofile.org')
	endif
" 	call feedkeys("i\<Plug>(minisnip)", 'i')
endfunction

let g:dotoo#agenda#files = ['~/Dropbox/vimwiki/org/*.org']
let g:org_refile='~/Dropbox/vimwiki/org/refile.org'

let g:dotoo#parser#todo_keywords = [
			\ 'TODO',
			\ 'NEXT',
			\ 'SOMEDAY',
			\ 'WAITING',
			\ 'HOLD',
			\ '|',
			\ 'CANCELLED',
			\ 'DONE',
			\]

let g:org_state_keywords = [ 'TODO', 'NEXT', 'SOMEDAY', 'DONE', 'CANCELLED' ]

let g:dotoo_headline_highlight_colors = [
			\ 'Title',
			\ 'Identifier',
			\ 'Statement',
			\ 'PreProc',
			\ 'Type',
			\ 'Special',
			\ 'Constant']

let g:dotoo#agenda#warning_days = '30d'
hi dotoo_shade_stars ctermfg=NONE guifg='#000000'
hi link orgHeading2 Normal
let g:org_time='%H:%M'
let g:org_date='%Y-%m-%d %a'
let g:org_date_format=g:org_date.' '.g:org_time
map <silent>gO :e ~/Dropbox/vimwiki/org/todo.org<CR>
map <silent>gC :call CreateCapture('split')<CR>
command! -nargs=0 NGrep grep! ".*" ~/Dropbox/vimwiki/org/*.org
