# vim: ft=zsh sw=2 ts=2 et

function build-nvim() {
  neovim_dir="$PROJECTS_DIR/contrib/neovim"
  [ ! -d $neovim_dir ] && git clone git@github.com:neovim/neovim.git $neovim_dir
  pushd $neovim_dir
  git checkout master
  git pull upstream master
  [ -d "$neovim_dir/build/" ] && rm -r ./build/  # clear the CMake cache
  make CMAKE_BUILD_TYPE=Release CMAKE_EXTRA_FLAGS="-DCMAKE_INSTALL_PREFIX=$HOME/neovim"
  make install
  popd
}

showalias() {
  local selected num
  setopt localoptions noglobsubst noposixbuiltins pipefail no_aliases 2>/dev/null

  SELECT=$(awk '/\(\)/&& last {print $1,"\t",last} {last=""} /^#/{last=$0}' ~/.config/bashrc/aliases.bashrc |
  column -t -s $'\t' | sed 's/#//' | sed 's/()//' | grcat alias.grc | fzf-tmux -xC -w '60%' -h '50%' ${commands[grcat]:+--ansi} | cut -d" " -f1 | cut -d"(" -f1)

  # note: https://doronbehar.com/articles/ZSH-FZF-completion/
  # how to Programmatically Change the Line in Zle?
  LBUFFER="${LBUFFER}$SELECT "
  local ret=$?
zle reset-prompt

  return $selected
}

zle -N showalias
bindkey '^o' showalias

run-mark() {
  local cwd="$HOME/Dropbox/data.programming.forprivate/marked-pwd"

  if [[ ! -f $cwd  ]]; then
    echo -ne "[warn] path not found: $cwd\n"
  else
    select=$(cat $cwd | fzf)
    if [[ -n $select ]]; then
      if [[ ! -f $select ]]; then
        cd $select
      else
        echo -ne "[warn] this not folder??"
      fi

    fi
  fi

  zle accept-line
}

zle -N run-mark
bindkey '^g' run-mark

# CREDIT: taken from https://github.com/kevinhwang91/dotfiles/blob/main/zsh/lplug/fzf/fzf-completion-widget
_fps() {
  ps -eo user,pid,ppid,pgid,stat,command | awk '
    BEGIN { "ps -p $$ -o pgid= | tr -d \"[:blank:]\"" | getline pgid } {
  if ($4 != pgid || $2 == pgid) print }' |
  grcat fps.grc | fzf --header-lines=1 -m \
    ${commands[grcat]:+--ansi} --height=60% \
    --min-height=15 --tac --reverse \
    --preview-window=down:2,border-top |
  awk -v sep=${myflag:- } '{ printf "%s%c", $2, sep }' |
  sed -E "s/${myflag:- }$//"
}

_t_expand_alias_f() {
  # echo $functions
  if (( $+functions[_t_expand_alias] )); then
    print ${functions[_t_expand_alias]#$'\t'}
    unset -f _t_expand_alias
  else
    print $@
  fi
}

fzf_lsof() {
  setopt localoptions noglobsubst noposixbuiltins pipefail no_aliases 2>/dev/null

  local matches
  local myargs=(${(z)$(_t_expand_alias_f $LBUFFER)})

  if [[ $myargs[-1] == "-p" ]]; then
    matches=$(myflag="," _fps)
  else
    matches=$(_fps)
  fi

  LBUFFER="${LBUFFER}$matches"
  zle reset-prompt

}

#mapping: open fzf lsof(to get PID) dengan flag -p
# zle -N fzf_lsof
# bindkey '^u' fzf_lsof

function fg-bg(){
  if [[ $#BUFFER -eq 0 ]]; then
    fg
  else
    zle push-input
  fi
}

zle -N fg-bg
bindkey '^z' fg-bg

# function tmux-resize(){
#   tmux resize-pane -Z
# }

# zle -N tmux-resize
# bindkey '^[m' tmux-resize

cursor_mode() {
  # See https://ttssh2.osdn.jp/manual/4/en/usage/tips/vim.html for cursor shapes
  cursor_block='\e[2 q'
  cursor_beam='\e[6 q'

  function zle-keymap-select {
    if [[ ${KEYMAP} == vicmd ]] ||
    [[ $1 = 'block' ]]; then
      echo -ne $cursor_block
    elif [[ ${KEYMAP} == main ]] ||
    [[ ${KEYMAP} == viins ]] ||
    [[ ${KEYMAP} = '' ]] ||
    [[ $1 = 'beam' ]]; then
      echo -ne $cursor_beam
    fi
  }

  zle-line-init() {
    echo -ne $cursor_beam
  }

  zle -N zle-keymap-select
  zle -N zle-line-init
}

cursor_mode

# # Pipenv completion
# _pipenv() {
#   eval $(env COMMANDLINE="${words[1,$CURRENT]}" _PIPENV_COMPLETE=complete-zsh  pipenv)
# }
# compdef _pipenv pipenv

# # Automatic pipenv shell activation/deactivation
# _togglePipenvShell() {
#   # deactivate shell if Pipfile doesn't exist and not in a subdir
#   if [[ ! -a "$PWD/Pipfile" ]]; then
#     if [[ "$PIPENV_ACTIVE" == 1 ]]; then
#       if [[ "$PWD" != "$pipfile_dir"* ]]; then
#         exit
#       fi
#     fi
#   fi

#   # activate the shell if Pipfile exists
#   if [[ "$PIPENV_ACTIVE" != 1 ]]; then
#     if [[ -a "$PWD/Pipfile" ]]; then
#       export pipfile_dir="$PWD"
#       pipenv shell
#     fi
#   fi
# }

# copy_output() {
#     BUFFER+=' | xclip -selection clipboard -r'
#     zle accept-line
# }

# zle -N copy_output
# bindkey '^y' copy_output

# copy_buffer() {
#     echo -n $BUFFER | xclip -selection clipboard
# }
# zle -N copy_buffer
# bindkey '^b' copy_buffer

