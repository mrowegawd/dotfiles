# vim: ft=zsh sw=2 ts=2 et

build-nvim() {
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

fzf_ctrlO() {
  local selected num
  setopt localoptions noglobsubst noposixbuiltins pipefail no_aliases 2>/dev/null

  #  +----------------------------------------------------------+
  #  |                       APT AND DKPG                       |
  #  +----------------------------------------------------------+

  show_apt_search(){
    apt-cache search '' | sort | cut --delimiter ' ' --fields 1 | fzf-tmux -xC -w '80%' -h '50%' --prompt="apt> " --multi --preview 'apt-cache show {1}' \
    | xargs -r sudo \$aptget install -y
  }

  show_alias() {
    SELECT=$(awk '/\(\)/&& last {print $1,"\t",last} {last=""} /^#/{last=$0}' ~/.config/bashrc/aliases.bashrc |
    column -t -s $'\t' | sed 's/#//' | sed 's/()//' | grcat alias.grc | fzf-tmux -xC -w '60%' -h '50%' ${commands[grcat]:+--ansi} | cut -d" " -f1 | cut -d"(" -f1)

    # note: https://doronbehar.com/articles/ZSH-FZF-completion/
    # how to Programmatically Change the Line in Zle?
    LBUFFER="${LBUFFER}$SELECT "
    local ret=$?

    zle reset-prompt
    # return $selected
  }

  #  +----------------------------------------------------------+
  #  |                           OPEN                           |
  #  +----------------------------------------------------------+

  open_calc(){
    tmux display-popup -E python -ic "from __future__ import division; from math import *; from random import *"
  }
  # CREDIT: taken from https://github.com/kevinhwang91/dotfiles/blob/main/zsh/lplug/fzf/fzf-completion-widget
  open_ps_lsof(){
    SELECT_PS=$(ps -eo user,pid,ppid,pgid,stat,command | awk '
    BEGIN { "ps -p $$ -o pgid= | tr -d \"[:blank:]\"" | getline pgid } {
    if ($4 != pgid || $2 == pgid) print }' |
      grcat fps.grc | fzf-tmux -xC -w '80%' -h '60%' --header-lines=1 -m \
      ${commands[grcat]:+--ansi} --height=60% \
      --min-height=15 --tac --reverse \
      --preview 'htop {1}' \
      --preview-window down:30%:nohidden,border-top |
      awk -v sep=${myflag:- } '{ printf "%s%c", $2, sep }' |
      sed -E "s/${myflag:- }$//")

    LBUFFER="${LBUFFER}$SELECT_PS "
    local ret=$?

    zle reset-prompt
    # return $selected
  }
  open_systemctl_ui(){
    # TODO: create fzfcommand nya harus full
    tmux display-popup -w '80%' -h '50%' -E sysz
  }

  #  +----------------------------------------------------------+
  #  |                           TMUX                           |
  #  +----------------------------------------------------------+

  tmux_select_tree(){
    tmux display-popup -w '100%' -h '100%' -E tmux choose-tree
  }
  tmux_select_win(){
    SELECT_WINS=$(tmux list-windows -F "#I: #W" | fzf-tmux -p --prompt="TMUX select win> " | cut -d ":" -f 1)
    echo $SELECT_WINS | xargs tmux select-window -t
  }
  tmux_select_sess(){
	  SELECT_SES=$(tmux list-sessions -F "#{session_name}" 2>/dev/null | fzf-tmux -xC -w '50%' -h '40%' --exit-0 --prompt="TMUX select session> ")
	  tmux switch-client -t "$SELECT_SES"
  }
  tmux_create_sess(){
    # DROPBOX_PATH="$HOME/Dropbox/data.programming.forprivate"
    # MARKED_PWD="$DROPBOX_PATH/marked-pwd"

    # if [[ -z "$TMUX" ]]; then
    #   select=$(fzf <"$MARKED_PWD")
    # else
    #   select=$(fzf-tmux -xC -w '80%' -h '40%' --prompt="TMUX: create session> " <"$MARKED_PWD")
    # fi

    not_in_tmux() {
      [ -z "$TMUX" ]
    }

    path_name="$(basename "$PWD" | tr . -)"
    session_name=${1-$path_name}

    session_exists() {
      tmux has-session -t "=$session_name"
    }

    create_detached_session() {
      (TMUX='' tmux new-session -Ad -s "$session_name")
    }

    if not_in_tmux; then
      tmux new-session -As "$session_name"
    else
      if ! session_exists; then
        create_detached_session
      else
        tmux switch-client -t "$session_name"
      fi
    fi

    # [[ -z $select ]] && exit
    # [[ ! -d $select ]] && dunstify "Path: $select" "Not found!" && exit

    # session_name=$(basename "$select")

    # ss_name=$(echo "$session_name" | sed -e "s/\./\_/g")

    # session_exists() {
    #   tmux has-session -t "=$ss_name"
    # }

    # if not_in_tmux; then
    #   tmux new-session -As "$ss_name" -c "$select"
    # else
    #   if ! session_exists; then
    #     tmux new-session -d -s "$ss_name" -c "$select"
    #   else
    #     tmux switch-client -t "$ss_name"
    #   fi
    # fi
  }

  #  +----------------------------------------------------------+
  #  |                         MENULIST                         |
  #  +----------------------------------------------------------+

  MENULIST="alias_bashrc\nshow_apt_search\ntmux_select_tree\ntmux_create_sess\ntmux_select_sess\ntmux_select_wins\nopen_calc\nopen_ps_lsof\nopen_systemctl_ui"

  selected=$(echo -e "$MENULIST" | fzf-tmux -xC -w '60%' -h '50%' --prompt="Ctrl-o: ")
	# [[ -z $selected ]] && exit    <-- dont use this

  case $selected in
    "alias_bashrc") show_alias ;;
    "show_apt_search") show_apt_search ;;
    "tmux_create_sess") tmux_create_sess;;
    "tmux_select_sess") tmux_select_sess ;;
    "tmux_select_wins") tmux_select_win ;;
    "tmux_select_tree") tmux_select_tree ;;
    "open_calc") open_calc ;;
    "open_ps_lsof") open_ps_lsof ;;
    "open_systemctl_ui") open_systemctl_ui ;;
    *) dunstify "not selected" ;;
  esac
}

zle -N fzf_ctrlO
bindkey '^o' fzf_ctrlO

run-mark() {
  local cwd="$HOME/Dropbox/data.programming.forprivate/marked-pwd"

  if [[ ! -f $cwd  ]]; then
    echo -ne "[warn] path not found: $cwd\n"
  else
    select=$(cat $cwd | fzf --preview 'eza --long --all --git --color=always --group-directories-first --icons {1}' \
      --preview-window right:50%:nohidden \
    --prompt "Jump to> ")
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

function fg-bg(){
  if [[ $#BUFFER -eq 0 ]]; then
    fg
  else
    zle push-input
  fi
}

zle -N fg-bg
bindkey '^z' fg-bg

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
