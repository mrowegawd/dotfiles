if !PluginLoaded('fuzzymenu.vim')
  finish
endif

" keymap: [plugin][fuzzymenu][toggle] open
nmap <localleader><localleader> <Plug>Fzm

" keymap: [plugin][fuzzymenu][toggle] open visual
nmap <localleader><localleader>l <Plug>FzmVisual

call fuzzymenu#Add('Agit', {'exec': 'Agit'})

call fuzzymenu#AddAll({
            \ 'ALE Turn Off': {'exec': 'ALEToggle'},
            \ 'ALE Fix Suggestion': {'exec': 'ALEFixSuggest'},
            \ 'Indent Guides Toggle': {'exec': 'IndentGuidesToggle'},
            \ 'Indent Lines Toggle': {'exec': 'IndentLinesToggle'},
            \ 'Mundo Open': {'exec': 'MundoToggle'},
            \ 'Signify Git Toggle': {'exec': 'SignifyToggle'},
            \ 'Signify Git Toggle Highlight': {'exec': 'SignifyToggleHighlight'},
            \ 'Signify Git Fold': {'exec': 'SignifyFold'},
            \ },
            \ {'after': 'call fuzzymenu#InsertMode()', 'tags': ['linter', 'toggle']})

call fuzzymenu#AddAll({
            \ 'Vim Base': {'exec': 'call Joke("vimbase")'},
            \ },
            \ {'after': 'call fuzzymenu#InsertMode()', 'tags': ['keybinding', 'vimbase']})

call fuzzymenu#AddAll({
            \ 'Plugin Ale': {'exec': 'call Joke("vimplugale")'},
            \ 'Plugin LSP': {'exec': 'call Joke("vimpluglsp")'},
            \ 'Plugin FZF': {'exec': 'call Joke("vimplugfzf")'},
            \ 'Plugin Vimwiki': {'exec': 'call Joke("vimplugvimwiki")'},
            \ 'Plugin Vim-tmux-runner': {'exec': 'call Joke("vimplugtmuxrunner")'},
            \ 'Plugin Surround': {'exec': 'call Joke("vimplugsurround")'},
            \ 'Plugin Pomo': {'exec': 'call Joke("vimplugpomo")'},
            \ 'Plugin Startify': {'exec': 'call Joke("vimplugstartiy")'},
            \ 'Plugin Git': {'exec': 'call Joke("vimpluggit")'},
            \ 'Plugin Debug': {'exec': 'call Joke("vimdebugdap")'},
            \ },
            \ {'after': 'call fuzzymenu#InsertMode()', 'tags': ['keybinding', 'plugins']})


call fuzzymenu#AddAll({
            \ 'Typescript': {'exec': 'call Joke("vimprogramtypescript")'},
            \ 'Markdown': {'exec': 'call Joke("vimprogrammarkdown")'},
            \ 'UML': {'exec': 'call Joke("vimprogramplantuml")'}
            \ },
            \ {'after': 'call fuzzymenu#InsertMode()', 'tags': ['keybinding', 'programming']})

call fuzzymenu#Add('Re-indent/format line', {'normal': 'gg=G<C-o><C-o>'})

" \ g:fuzzymenu_position: g:fuzzymenu_size,
function! Joke(command) abort
    let opts = {
                \ 'source': s:TextObjectsSource(a:command),
                \ 'options': '--ansi',
                \ }
    call fzf#run(fzf#wrap('fzm#TextObjects', opts, 0))
endfunction

let s:vimbase = {
            \ 'commandline : history prev'                                              : '<c-p>',
            \ 'commandline : history next'                                              : '<c-n>',
            \ 'commandline : forward word'                                              : '<c-w>',
            \ 'commandline : back word'                                                 : '<c-b>',
            \ 'commandline : [move] cursor go to first word'                            : '<c-u>',
            \ 'commandline : [move] cursor go to last word'                             : '<c-o>',
            \ 'commandline : [move] cursor go to left'                                  : '<c-h>',
            \ 'commandline : [move] cursor go to right'                                 : '<c-l>',
            \ 'commandline : printout/show current path'                                : '<c-t>',
            \ 'editing     : [visual] select word, inside word, under cursor'           : 'viw',
            \ 'editing     : delete line'                                               : 'dd',
            \ 'editing     : delete <inside> word, under cursor'                        : 'diw',
            \ 'editing     : delete word'                                               : 'dw',
            \ 'editing     : delete <inside> tag, under cursor'                         : 'dit',
            \ 'editing     : change <inside> word, under cursor'                        : 'ciw',
            \ 'editing     : change <inside> word inside brackets ('                    : 'ci(',
            \ 'editing     : next function'                                             : '] [',
            \ 'editing     : next empty line'                                           : '} {',
            \ 'editing     : (jumplist) go to last edited'                              : 'g;',
            \ 'editing     : (jumplist) go to next edited'                              : 'g,',
            \ 'editing     : (marks) go back mark'                                      : '<c-o>',
            \ 'editing     : (marks) go next mark'                                      : '<c-i>',
            \ 'editing     : [visual] move line up'                                     : '<a-k>',
            \ 'editing     : [visual] move line down'                                   : '<a-j>',
            \ 'editing     : disable nohl'                                              : '<Esc><Esc>',
            \ 'terminal    : open/exit terminal'                                        : '<leader>tt',
            \ 'terminal    : open terminal vsplit'                                      : '<leader>tV',
            \ 'word        : [visual] make text lowercase'                              : '<leader>u',
            \ 'word        : [visual] make text uppercase'                              : '<leader>U',
            \ 'word        : [insert] erase per word'                                   : '<c-w>',
            \ 'select      : [visual], rectangle block, block visual'                   : 'vv <c-v> V',
            \ 'select      : [visual], go block all lines'                              : 'ie',
            \ 'select      : [visual], inner lines'                                     : 'il',
            \ 'yank        : yank line from current cursor'                             : 'Y',
            \ 'yank        : yank one line'                                             : 'yy',
            \ 'yank        : copy path current file, then press "p"'                    : '<leader>%',
            \ 'substitute  : enter search and replace'                                  : 'sr',
            \ 'substitute  : current word under cursor'                                 : 'sR',
            \ 'substitute  : search word under cursor'                                  : 's/',
            \ '[search]    : find next, find prev'                                      : 'n N',
            \ 'toggle      : no/with list'                                              : 'tl',
            \ 'toggle      : [fold] foldall/Unfoldall, unfold/fold'                     : 'zf zo/zO',
            \ 'browser     : [both] search keyword on browser'                          : '<leader>OK',
            \ 'browser     : [both] http current on browser'                            : '<leader>O',
            \ 'window      : [split] vertical'                                          : '<c-w>v',
            \ 'window      : [split] horizontal'                                        : '<c-w>s',
            \ 'window      : [swap]'                                                    : '<C-w>r',
            \ 'window      : [move] / rotate along windows'                             : '<c-w>w',
            \ 'window      : [move] / rotate to left window'                            : '<c-w>L',
            \ 'window      : [move] / rotate to up window'                              : '<c-w>K ',
            \ 'window      : [move] / rotate to down window'                            : '<c-w>J',
            \ 'window      : [move] / rotate to right window'                           : '<c-w>H',
            \ 'window      : [rotate] window (next)'                                    : 'TAB',
            \ 'window      : [rotate] window (prev)'                                    : 'S-TAB',
            \ 'window      : [resize] left, up, down, right'                            : '<a-hjkl>',
            \ 'window      : [resize] balance window size'                              : '<c-w>=',
            \ 'window      : (toggle) maximaze/minimaze'                                : 'ZZ',
            \ 'window      : close window or quit'                                      : '<c-w>q',
            \ 'scroll      : center window'                                             : 'zz',
            \ 'scroll      : to left'                                                   : 'zl',
            \ 'scroll      : to right'                                                  : 'zh',
            \ 'scroll      : go up'                                                     : '<c-y>',
            \ 'scroll      : go down'                                                   : '<c-e>',
            \ 'scroll      : go fast up'                                                : '<c-b>',
            \ 'scroll      : go fast down'                                              : '<c-f>',
            \ 'scroll      : go to up zero line'                                        : '[',
            \ 'scroll      : go to down zero line'                                      : ']',
            \ 'scroll      : go to next function keyword'                               : ']]',
            \ 'scroll      : go to prev function keyword'                               : '[[',
            \ 'scroll      : go to next comment keyword'                                : ']"',
            \ 'scroll      : go to prev comment keyword'                                : '["',
            \ 'scroll      : [fold] go to down fol'                                     : 'zj',
            \ 'scroll      : [fold] go to up fol'                                       : 'zk',
            \ 'buffers     : only current buffer open but other buffers dont delete it' : '<c-w>o',
            \ 'tab         : create/open new tab'                                       : '<c-t>',
            \ 'tab         : closing current tab'                                       : '<c-t>c',
            \ 'tab         : move existing tab to a new tab'                            : '<c-t>b',
            \ 'tab         : prev tab'                                                  : 'gh',
            \ 'tab         : next tab'                                                  : 'gl'
            \}

let s:vimplugale = {
            \ 'ale : next'   : '<leader>an',
            \ 'ale : prev'   : '<leader>ap',
            \ 'ale : detail' : '<leader>aD',
            \ 'ale : info'   : '<leader>ai'
            \}

let s:vimplugpomo = {
            \ 'pomo : to run/start'              : '<leader>pr',
            \ 'pomo : pause'                     : '<leader>pp',
            \ 'pomo : toggle/start after finish' : '<leader>pt'
            \}

let s:vimpluglsp = {
            \ 'lsp : definition'                     : '<leader>ld',
            \ 'lsp : type definition'                : '<leader>lt',
            \ 'lsp : implementation'                 : '<leader>li',
            \ 'lsp : hover'                          : '<leader>lh',
            \ 'lsp : signature help'                 : '<leader>ls',
            \ 'lsp : references'                     : '<leader>lr',
            \ 'lsp : rename'                         : '<leader>lR',
            \ 'lsp : format code'                    : '<leader>lf',
            \ 'lsp : code action'                    : '<leader>la',
            \ 'lsp : document symbol'                : '<leader>lw',
            \ 'lsp : workspace symbol'               : '<leader>lW',
            \ 'lsp : peek definition'                : '<leader>lP',
            \ 'lsp : trigger completion'             : '<C-Space>',
            \ 'lsp : diagnostic show detail status'  : '<leader>lD',
            \ 'lsp : diagnostic next'                : '<leader>lj',
            \ 'lsp : diagnostic prev'                : '<leader>lk',
            \ 'coc : diagnostic next'                : '<leader>lj',
            \ 'coc : diagnostic prev'                : '<leader>lk',
            \ 'coc : diagnostic info'                : '<leader>lI',
            \ 'coc : CocList'                        : 'fcl',
            \ 'coc : CocCommand'                     : 'fcc',
            \ 'coc : misc help'                      : '<leader>l?',
            \ 'coc : misc toggle hover'              : '?',
            \ 'coc : misc trigger completion'        : '<c-Space>',
            \ 'coc : misc trigger help vim tags'     : 'K',
            \ 'coc : misc [insert] complete path'    : '<c-f><c-f>',
            \ 'coc : misc [insert] complete file-ag' : '<c-f><c-g>',
            \ 'coc : misc [insert] complete lines'   : '<c-f><c-l>',
            \ 'coc : misc [insert] complete word'    : '<c-f><c-w>'
            \}

let s:vimplugterminalfloat = {
            \ 'open: terminal' : '<leader>tt'
            \}

let s:vimplugfzf = {
            \ 'grep rg'        : '<leader>fg',
            \ 'grep rg [word]' : '<leader>fG',
            \ 'Files'          : '<leader>ff',
            \ 'Buffer'         : '<leader>fb',
            \ 'Bline'          : '<leader>fl',
            \ 'Maps'           : '<leader>fm',
            \ 'Helptags'       : '<leader>fh',
            \ 'Colors'         : '<leader>fC',
            \ 'History         : '             : '<leader>fH',
            \ 'History/'       : '<leader>f/',
            \ 'Marks'          : '<leader>f`',
            \ 'helpFZF'        : '<leader>f?',
            \ 'path[insert]'   : '<c-f><c-f>',
            \ 'line[insert]'   : '<c-f><c-l>',
            \ 'word[insert]'   : '<c-f><c-j>'
            \}

let s:vimplugvimwiki = {
            \ 'Vimwiki : open index'               : '<leader>vv',
            \ 'Vimwiki : open with new tab'        : '<leader>vt',
            \ 'Vimwiki : open select'              : '<leader>vs',
            \ 'Vimwiki : open diary index'         : '<leader>vi',
            \ 'Vimwiki : open and convert to html' : '<leader>vh',
            \ 'Vimwiki : open with browser'        : '<leader>vO',
            \ 'Vimwiki : delete current file'      : '<leader>vd',
            \ 'Vimwiki : rename current file'      : '<leader>vr'
            \}

let s:vimplugtmuxrunner = {
            \ 'Tmux-runner : open tmux (attach)'     : '<leader>vo',
            \ 'Tmux-runner : send command to runner' : '<F2>',
            \ 'Tmux-runner : kill attach tmux'       : '<F4>'
            \}

let s:vimplugsurround = {
            \ 'Surround : create surround "({[`'                              : '<leader>s..',
            \ 'Surround : create surround in one line "({[`'                  : 'yss..',
            \ 'Surround : create surround inside word "({[`'                  : 'ysiw..',
            \ 'Surround : create surround inside word, unicode include "({[`' : 'ysiW..',
            \ 'Surround : change surround "({[` inside word'                  : 'csW..',
            \ 'Surround : delete surround "({[`'                              : 'ds..'
            \}

let s:vimplugstartiy = {
            \ 'Startify : open toggle'  : '<leader>yy',
            \ 'Startify : save session' : '<leader>ss',
            \ 'Startify : load session' : '<leader>so'
            \}

let s:vimpluggit = {
            \ 'Agit     : open Agit'                                       : '<leader>ga',
            \ 'Agit     : open Agitfile'                                   : '<leader>gaf',
            \ 'Agit     : scroll down diff window'                         : '<C-j>',
            \ 'Agit     : scroll up diff window'                           : '<C-k>',
            \ 'Agit     : quit'                                            : 'q',
            \ 'Agit     : show help'                                       : '<leader>?',
            \ 'CocGIT   : next chunk'                                      : '<leader>gn',
            \ 'CocGIT   : prev chunk'                                      : '<leader>gp',
            \ 'CocGIT   : chunk info'                                      : '<leader>gi',
            \ 'CocGIT   : (toggle) gutter on/off'                          : '<leader>gt',
            \ 'CocGIT   : git undo'                                        : '<leader>gu',
            \ 'CocGIT   : chunkstage (to stage or add)'                    : '<leader>ga',
            \ 'CocGIT   : fold all does not change, only the event change' : '<leader>gz',
            \ 'CocGIT   : open giturl in browser'                          : '<leader>gO',
            \ 'Signify  : SignifyHunkDiff '                                : '<leader>gi',
            \ 'Signify  : SignifyDiff '                                    : '<leader>gd',
            \ 'Signify  : SignifyToggleHighlight'                          : '<leader>gt',
            \ 'Signify  : signify-next-hunk '                              : '<leader>gj',
            \ 'Signify  : signify-prev-hunk '                              : '<leader>gk',
            \ 'Fugitive : open GStatus'                                    : '<leader>gs',
            \ 'Fugitive : (inside fugitive) add stagging'                  : 'a',
            \ 'Fugitive : (inside fugitive) undo line/Undo everything'     : 'u|U',
            \ 'Fugitive : (inside fugitive) (toggle) inline diff'          : '=',
            \ 'Fugitive : (inside fugitive) (open) diff split vertical'    : 'dd',
            \ 'Fugitive : (inside fugitive) (open) diff split horizontal'  : 'dv',
            \ 'Fugitive : close diff'                                      : 'dq',
            \ 'Fugitive : show help'                                       : 'd?'
            \}

let s:vimdebugdap = {
            \ 'Debug[dap] : continue'               : '<F5>',
            \ 'Debug[dap] : reset'                  : '<F3>',
            \ 'Debug[dap] : stepOver'               : '<F10>',
            \ 'Debug[dap] : stepInto'               : '<F11>',
            \ 'Debug[dap] : stepOut'                : '<F12>',
            \ 'Debug[dap] : breakpoint'             : '<leader>b',
            \ 'Debug[dap] : breakpoint interactive' : '<leader>B',
            \ 'Debug[dap] : open dap'               : '<leader>dr',
            \ 'Debug[dap] : open last dap'          : '<leader>dl',
            \ 'Debug[dap] : help'                   : '<leader>?',
            \}

let s:vimprogramtypescript = {
            \ 'vimwiki : open index'               : '<leader>vv',
            \ 'vimwiki : open with new tab'        : '<leader>vt',
            \ 'vimwiki : open select'              : '<leader>vs',
            \ 'vimwiki : open diary index'         : '<leader>vi',
            \ 'vimwiki : delete current file'      : '<leader>vd',
            \ 'vimwiki : rename current file'      : '<leader>vr',
            \ 'vimwiki : open and convert to html' : '<leader>vh',
            \ 'vimwiki : open with browser'        : '<leader>vhh'
            \}

let s:vimprogrammarkdown = {
            \ 'Markdown : live preview'        : 'F2',
            \ 'Markdown : kill live preview'   : 'F4',
            \ 'Markdown : toggle conceallevel' : 'tc'
            \}

let s:vimprogramplantuml = {
            \ 'Plantuml : live preview'      : 'F2',
            \ 'Plantuml : kill live preview' : 'F4'
            \}


function! s:TextObjectsSource(command) abort
    let textObjects = []
    " Vim base
    if a:command ==# 'vimbase'
        let dd = s:vimbase
        " Plugin
    elseif a:command ==# 'vimplugale'
        let dd = s:vimplugale
    elseif a:command ==# 'vimplugpomo'
        let dd = s:vimplugpomo
    elseif a:command ==# 'vimpluglsp'
        let dd = s:vimpluglsp
    elseif a:command ==# 'vimplugterminalfloat'
        let dd = s:vimplugterminalfloat
    elseif a:command ==# 'vimplugfzf'
        let dd = s:vimplugfzf
    elseif a:command ==# 'vimplugvimwiki'
        let dd = s:vimplugvimwiki
    elseif a:command ==# 'vimplugtmuxrunner'
        let dd = s:vimplugtmuxrunner
    elseif a:command ==# 'vimplugsurround'
        let dd = s:vimplugsurround
    elseif a:command ==# 'vimplugstartiy'
        let dd = s:vimplugstartiy
    elseif a:command ==# 'vimpluggit'
        let dd = s:vimpluggit
        " Debug
    elseif a:command ==# 'vimdebugdap'
        let dd = s:vimdebugdap
        " Programming
    elseif a:command ==# 'vimprogramtypescript'
        let dd = s:vimprogramtypescript
    elseif a:command ==# 'vimprogrammarkdown'
        let dd = s:vimprogrammarkdown
    elseif a:command ==# 'vimprogramplantuml'
        let dd = s:vimprogramplantuml
    endif
    for i in items(dd)
        let key = i[0]
        let val = i[1]
        let textObject = printf("\e[1;35m%-60s\e[m\t\t%s", key, val)
        call add(textObjects, textObject)
    endfor
    return textObjects
endfunction
