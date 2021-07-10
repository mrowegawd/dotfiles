" ----------------------------------------------------------------------------
" after/filetype.vim
"  - http://vim.wikia.com/wiki/Filetype.vim#File_structure
"
" filetype.vim load order
" User Specific Primary Definitions:
"   $XDG_CONFIG_HOME/nvim/filetype.vim
" System Primary Definitions:
"   $VIM/vimfiles/filetype.vim
" NeoVim Default Ruleset:
"   $VIMRUNTIME/filetype.vim
" System Fallback Definitions:
"   $VIM/vimfiles/after/filetype.vim
" User Specific Fallback Definitions:
"   $XDG_CONFIG_HOME/nvim/after/filetype.vim
" ----------------------------------------------------------------------------

" if exists('did_load_filetypes_userafter')
"   finish
" endif
" let g:did_load_filetypes_userafter = 0

augroup filetypedetect
  " extension
  autocmd! BufNewFile,BufRead *.\(swig\|swigcxx\)                               setlocal filetype=swig " TODO(zchee): 'cxx' prefix only
  autocmd! BufNewFile,BufRead *.asm                                             setlocal filetype=nasm syntax=nasm
  autocmd! BufNewFile,BufRead *.dockerignore,.gitignore,.gitignore-global       setlocal filetype=gitignore
  autocmd! BufNewFile,BufRead *.gitconfig-local                                 setlocal filetype=gitconfig
  autocmd! BufNewFile,BufRead *.editorconfig,*fpm,www.conf                      setlocal filetype=dosini
  autocmd! BufNewFile,BufRead *.es6                                             setlocal filetype=javascript
  autocmd! BufNewFile,BufRead *.gcloudignore                                    setlocal filetype=gitignore
  autocmd! BufNewFile,BufRead *.go.y                                            setlocal filetype=goyacc
  autocmd! BufNewFile,BufRead *.hla                                             setlocal filetype=hla  syntax=header_standard_Vim_script_file_header
  autocmd! BufNewFile,BufRead *.i                                               setlocal filetype=swig
  autocmd! BufNewFile,BufRead *.inc                                             setlocal filetype=masm syntax=masm
  autocmd! BufNewFile,BufRead *.jsonschema                                      setlocal filetype=jsonschema
  autocmd! BufNewFile,BufRead *.mm                                              setlocal filetype=objcpp
  autocmd! BufNewFile,BufRead *.pbtxt                                           setlocal filetype=proto
  autocmd! BufNewFile,BufRead *.py[xd]                                          setlocal filetype=cython
  autocmd! BufNewFile,BufRead *.S                                               setlocal filetype=gas  syntax=gas
  autocmd! BufNewFile,BufRead *.sb                                              setlocal filetype=scheme
  autocmd! BufNewFile,BufRead *.slide                                           setlocal filetype=goslide
  autocmd! BufNewFile,BufRead *.tfstate                                         setlocal filetype=teraterm
  autocmd! BufNewFile,BufRead *.ts                                              setlocal filetype=typescript

  autocmd! BufNewFile,BufRead *.vfj,*.cjson,coc-settings.json,config.json,*vmoptions,*/Code/User/settings.json,*.jsonc       setlocal filetype=jsonc
  autocmd! BufNewFile,BufRead tsconfig.json                                     setlocal filetype=jsonc

  autocmd! BufNewFile,BufRead *.log,*_log                                       setlocal filetype=log

  autocmd! BufNewFile,BufRead *.vmoptions                                       setlocal filetype=conf
  autocmd! BufNewFile,BufRead *.conf                                            setlocal filetype=conf

  autocmd! BufNewFile,BufRead *.coveragerc                                      setlocal filetype=config
  autocmd! BufEnter,BufNewFile,BufRead tmux.conf                                setlocal filetype=tmux

  autocmd! BufNewFile,BufRead calcurse*                                         setlocal foldmethod=indent |
        \ setlocal filetype=markdown

  " directory
  autocmd! BufNewFile,BufRead **/c++/**/*                                       setlocal filetype=cpp  " cpp stdlib

  autocmd! BufNewFile,BufRead */roles/*.yml                                     setlocal foldmethod=indent  |
        \ setlocal foldlevel=0

  autocmd! BufNewFile,BufRead *.png,*.jpg,*.jpeg,*.gif                          silent! exec "!feh ".expand("%") | :bw

  " filename
  autocmd! BufNewFile,BufRead $XDG_CONFIG_HOME/go/env,*.bashrc                  setlocal filetype=sh
  autocmd! BufNewFile,BufRead .bash_profile,bash_profile                        setlocal filetype=sh
  autocmd! BufNewFile,BufRead .envrc                                            setlocal filetype=sh

  autocmd! BufNewFile,BufRead **/*hal/config                                    setlocal filetype=yaml
  autocmd! BufNewFile,BufRead *.yamllint                                        setlocal filetype=yaml
  autocmd! BufNewFile,BufRead **/*kube/config                                   setlocal filetype=yaml
  autocmd! BufNewFile,BufRead .yamllint                                         setlocal filetype=yaml
  autocmd! BufNewFile,BufRead glide.lock                                        setlocal filetype=yaml
  autocmd! BufNewFile,BufRead .clang-format                                     setlocal filetype=yaml

  autocmd! BufNewFile,BufRead **/google-cloud-sdk/properties                    setlocal filetype=cfg
  autocmd! BufNewFile,BufRead .gunkconfig                                       setlocal filetype=cfg
  autocmd! BufNewFile,BufRead $XDG_CONFIG_HOME/gcloud/configurations/*          setlocal filetype=cfg  " dosini

  autocmd! BufNewFile,BufRead *.gunk                                            setlocal filetype=gunk.go
  autocmd! BufNewFile,BufRead *[Dd]ockerfile\(\.|-\).*\(.vim\)\@!*              setlocal filetype=dockerfile

  autocmd! BufNewFile,BufRead .{babel,eslint,prettier,stylelint,jshint,csslint}rc setlocal filetype=json
  autocmd! BufNewFile,BufRead .markdownlintrc                                   setlocal filetype=json
  autocmd! BufNewFile,BufRead .firebaserc                                       setlocal filetype=json
  autocmd! BufNewFile,BufRead .tern-config                                      setlocal filetype=json
  autocmd! BufNewFile,BufRead manifest                                          setlocal filetype=json
  autocmd! BufNewFile,BufRead osquery.conf                                      setlocal filetype=json
  autocmd! BufNewFile,BufRead proto.lock                                        setlocal filetype=json

  autocmd! BufNewFile,BufRead .pythonrc                                         setlocal filetype=python
  autocmd! BufNewFile,BufRead [Dd]ockerfile                                     setlocal filetype=dockerfile
  autocmd! BufNewFile,BufRead boto,.boto                                        setlocal filetype=cfg
  autocmd! BufNewFile,BufRead gdbinit                                           setlocal filetype=gdb
  autocmd! BufNewFile,BufRead Gopkg.lock                                        setlocal filetype=toml
  autocmd! BufNewFile,BufRead poetry.lock                                       setlocal filetype=toml
augroup END

" autocmd! BufNewFile,BufRead s:srcpath.'/github.com/envoyproxy/envoy/**/*.h'   setlocal filetype=cpp
" autocmd! BufNewFile,BufRead **/startup-log.txt                                setlocal foldlevel=1
" autocmd! BufNewFile,BufRead *[Dd]oxyfile\(.vim\)\@!*                          setlocal filetype=doxyfile
" autocmd! BufNewFile,BufRead *[Dd]ockerfile\(\.|-\).*                          setlocal filetype=dockerfile
" autocmd! BufNewFile,BufRead *[Dd]oxyfile\(\.|-\).*\(.vim\)\@!*                setlocal filetype=doxyfile
" autocmd! BufNewFile,BufRead *[Dd]ockerfile setlocal filetype=dockerfile
" autocmd! BufNewFile,BufRead [Dd]ockerfile,.*\=[Dd]ockerfile\(\.|-\).*\(.vim\)\@!* setlocal filetype=dockerfile
" autocmd! BufNewFile,BufRead *[Dd]ockerfile\(.vim\|*.yaml\)\@!.*,[Dd]ockerfile,*.[Dd]ockerfile setlocal filetype=dockerfile
