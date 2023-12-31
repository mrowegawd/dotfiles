# vim: ft=zsh sw=2 ts=2 et

build-nvim() {
  neovim_dir="$PROJECTS_DIR/contrib/neovim"
  [ ! -d $neovim_dir ] && git clone https://github.com/neovim/neovim.git $neovim_dir
  pushd $neovim_dir
  git checkout master
  # git pull upstream master
  git pull --rebase --prune
  git fetch --tags -f
  git checkout nightly
  [ -d "$neovim_dir/build/" ] && rm -r ./build/  # clear the CMake cache
  make CMAKE_BUILD_TYPE=Release CMAKE_EXTRA_FLAGS="-DCMAKE_INSTALL_PREFIX=$HOME/neovim"
  make install
  popd
}

build-install(){
  # TODO: install apt seperti urlview
  apt_install="urlview"

  # TODO: install cargo seperti eza, lazygit, etc
  cargo_install="eza"

  # TODO: install go get
  cargo_install="lf lazygit"

  # TODO: build yang khusus apt dan juga cargo
  sudo apt install "$apt_install"

  # TODO: install gpg-tui
  # install depencies apt-get install libgpgme-dev libx11-dev libxcb-shape0-dev libxcb-xfixes0-dev libxkbcommon-dev
  # carog install gpg-tui

  # TODO: install dive (https://github.com/wagoodman/dive)
  # go get github.com/wagoodman/dive

  # TODO: install gifski https://github.com/sindresorhus/Gifski
  # cargo install gifski
  
  # TODO: install lazydocker https://github.com/jesseduffield/lazydocker#
  # go install github.com/jesseduffield/lazydocker@latest 
}

build-react() {
  Green=$(tput setaf 2)        # Green
  Color_Off=$(tput sgr0)       # Text Reset

  if [[ $1 == "" ]]; then
    echo "You can use custom name project:\n 'build-react <name-project>'"
    echo -e "\n\nCreate default name for your react: '${Green}react-starter${Color_Off}'\n\n"
  else
    echo -e "\nName of your project name: '${Green}$1${Color_Off}'\n\n"
  fi
  git clone https://github.com/mrowegawd/react-starter.git $@
}

build-go() {
  Green=$(tput setaf 2)        # Green
  Color_Off=$(tput sgr0)       # Text Reset

  if [[ $1 == "" ]]; then
    echo "Define your project name:\n Ex: 'build-go <name-project>'"
  else
    mkdir -p $1
    cd $1
    go mod init $1
  fi


}

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
bindkey '^v' run-mark

function fg-bg(){
  if [[ $#BUFFER -eq 0 ]]; then
    fg
  else
    zle push-input
  fi
}

zle -N fg-bg
bindkey '^z' fg-bg

find-in-file() {
  local _file="$(rg --color=always --line-number --no-heading --smart-case "${@:-^[^\n]}" \
    | fzf --ansi -d ':' --preview 'bat --style=numbers --color=always $(cut -d: -f1 <<< {1}) --highlight-line {2}  --line-range={2}:+20' \
    --preview-window='50%' --height='50%' --with-nth 1,3.. --exact)"

  _file="${_file%%:*}"
  if [[ -n $_file ]]; then
    exec nvim "$_file"
  fi

  zle accept-line
}

zle -N find-in-file
bindkey '^g' find-in-file

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

show_alias() {
  setopt localoptions noglobsubst noposixbuiltins pipefail no_aliases 2>/dev/null

  local select
  local myargs=(${(z)$(_t_expand_alias_f $LBUFFER)})

  # check jika first command diawali dengan string `doc_ ..`
  local doc_con="doc_con_"
  local doc_im="doc_im_"
 
  if [[ $myargs[-1] == "-p" ]]; then
    select=$(myflag="," _fps)
  elif [[ $myargs[-1] == "git" ]]; then
    local alias_sel=$(git config --list | grep 'alias\.' | sed 's/alias\.\([^=]*\)=\(.*\)/\1\t\t => \2/' | fzf-tmux -p 80% | cut -d" " -f1 | xargs)
    if [[ ! -n $alias_sel ]]; then
      return
    fi

    LBUFFER="git $alias_sel "
    zle reset-prompt

  # TODO: buatkan untuk juga untuk container, images, volume
  elif [[ $myargs[-1] == *"$doc_con"* ]]; then
    #
    # Taken from: https://github.com/pierpo/fzf-docker/blob/913bc66e79d863b324065c1e840860fc79f900cb/fzf-docker.plugin.zsh
    #
    FZF_DOCKER_PS_START_FORMAT="table {{.ID}}\t{{.Names}}\t{{.Status}}\t{{.Image}}"
    FZF_DOCKER_PS_FORMAT="table {{.ID}}\t{{.Names}}\t{{.Image}}\t{{.Ports}}"
    select=$(docker ps -a --format "${FZF_DOCKER_PS_START_FORMAT}" | fzf --multi --header-lines=1 | awk '{print $1}' )

  elif [[ $myargs[-1] == *"$doc_im"* ]]; then
    #
    # Taken from: https://github.com/pierpo/fzf-docker/blob/913bc66e79d863b324065c1e840860fc79f900cb/fzf-docker.plugin.zsh
    #
    select=$(docker images --format "table {{.Repository}}:{{.Tag}}\t{{.Size}}\t{{.ID}}\t{{.CreatedSince}}" | fzf --multi --header-lines=1 | awk '{print $1}' )

  elif [[ $myargs[-1] == "" ]]; then
    local alias_selected=$(
    awk '/\(\)/&& last {print $1,"\t",last} {last=""} /^#/{last=$0}' ~/.config/bashrc/aliases.bashrc |
      column -t -s $'\t' | sed 's/#//' | sed 's/()//' | grcat alias.grc |
      fzf-tmux -xC -w '60%' -h '50%' --exit-0 --ansi
    )

    if [[ ! -n $alias_selected ]]; then
      return
    else
      select=$(echo "$alias_selected" | cut -d" " -f1 | cut -d"(" -f1)
    fi
  fi

  [[ -n $select ]] && LBUFFER="${LBUFFER}$select "
  zle reset-prompt
}

zle -N show_alias
bindkey '^o' show_alias


# show_alias_git() {
#   setopt localoptions noglobsubst noposixbuiltins pipefail no_aliases 2>/dev/null
#
#   local alias_sel=$(git config --list | grep 'alias\.' | sed 's/alias\.\([^=]*\)=\(.*\)/\1\t\t => \2/' | fzf-tmux -p 80% | cut -d" " -f1 | xargs)
#
#   if [[ ! -n $alias_sel ]]; then
#     return
#   fi
#
#   LBUFFER="${LBUFFER}git $alias_sel "
#   zle reset-prompt
# }
#
# zle -N show_alias_git
# bindkey '^q' show_alias_git
