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
  rm -rf $HOME/neovim/*
  make CMAKE_BUILD_TYPE=Release CMAKE_EXTRA_FLAGS="-DCMAKE_INSTALL_PREFIX=$HOME/neovim"
  make install
  popd
}

build-install(){
  if ! command -v xinput >/dev/null; then
    echo "Installing: xinput - fixing mouse lagging..?"
  	sudo apt install xinput
  fi

  if ! command -v urlview >/dev/null; then
    echo "Installing: urlview"
  	sudo apt install urlview
  fi

  if ! command -v fd >/dev/null; then
    echo "Installing: fd - blazingly fast"
    sudo apt install fd-find
  fi

  if ! command -v proxychains >/dev/null; then
    echo "Installing: proxychains - wrapper for tor"
    sudo apt install proxychains4
  fi

  # TODO: install pomodoro, from youtube https://www.youtube.com/watch?v=GfQjJBtO-8Y
  # https://github.com/caarlos0/timer
  # cara install `timer`:
  # echo 'deb [trusted=yes] https://repo.caarlos0.dev/apt/ /' | sudo tee /etc/apt/sources.list.d/caarlos0.list
  # sudo apt update
  # sudo apt install timer

  if ! command -v play >/dev/null; then
    echo "Installing: play - play sound from the terminal"
    sudo apt install sox
    sudo apt install libsox-fmt-all
  fi

  if ! asdf which bat >/dev/null; then
    echo "Installing: bat - we cat before bat"
  	cargo install bat
    asdf reshim rust
  fi

  if ! asdf which gifski >/dev/null; then
  # Install: gifski
  # gihtub: https://github.com/sindresorhus/Gifski
  # install binary langsung dari link https://gif.ski/
    echo "Installing: gifski - Gif encoder"
  	cargo install gifski
    asdf reshim rust
  fi

  if ! asdf which tree-sitter >/dev/null; then
    echo "Installing: tree-sitter-cli - tree-sitter-cli for nvim"
  	cargo install tree-sitter-cli
    asdf reshim rust
  fi

  if ! asdf which dua >/dev/null; then
    echo "Installing: dua-cli - similiar with 'du', to check disk usage"
    cargo install dua-cli
    asdf reshim rust
  fi

  if ! asdf which procs >/dev/null; then
    echo "Installing: procs - better than 'ps' command"
    cargo install procs
    asdf reshim rust
  fi

  # WARN: terjadi error ketika di install,
  # idk source code nya mungkin ada yang error
  # if ! asdf which openapi-tui >/dev/null; then
  #   echo "Installing: openapi-tui - Terminal UI to list, browse and run APIs"
  #   cargo install openapi-tui
  #   asdf reshim rust
  # fi

  if ! asdf which eza >/dev/null; then
    echo "Installing: eza - ls colors"
  	cargo install eza
    asdf reshim rust
  fi

  if ! asdf which zoxide >/dev/null; then
    echo "Installing: zoxide - A smarter cd commands"
    cargo install zoxide --locked
    asdf reshim rust
  fi

  if ! asdf which delta >/dev/null; then
    echo "Installing: delta - color hunk"
  	cargo install git-delta
    asdf reshim rust
  fi

  if ! asdf which rg >/dev/null; then
    echo "Installing: rg - grep drugs"
    cargo install ripgrep
    asdf reshim rust
  fi

  # https://github.com/race604/clock-tui
  if ! asdf which tclock >/dev/null; then
    echo "Installing: tclock - clock tui"
    cargo install clock-tui
    asdf reshim rust
  fi

  # if ! asdf which joshuto >/dev/null; then
  #   echo "Installing: joshuto - file manager"
  #   cargo install --git https://github.com/kamiyaa/joshuto.git --force
  #   asdf reshim rust
  # fi

  if ! asdf which yazi >/dev/null; then
    echo "Installing: yazi - file manager"
    cargo install --locked --git https://github.com/sxyazi/yazi.git yazi-fm yazi-cli
    asdf reshim rust
  fi

  if ! asdf which rust-analyzer >/dev/null; then
    echo "Installing: rust-analyzer - manual install for LSP rust"
    rustup component add rust-analyzer
    asdf reshim rust
  fi

  if ! asdf which lf >/dev/null; then
    echo "Installing: lf - file manager"
    env CGO_ENABLED=0 go install -ldflags="-s -w" github.com/gokcehan/lf@latest
    asdf reshim golang
  fi

  if ! asdf which lazygit >/dev/null; then
    echo "Installing: lazygit - git GUI"
    go install github.com/jesseduffield/lazygit@latest
    asdf reshim golang
  fi

  # Explore docker layer
  if ! asdf which dive >/dev/null; then
    echo "Installing: dive - docker layer"
    go install github.com/wagoodman/dive@latest
    asdf reshim golang
  fi

  if ! asdf which lazydocker >/dev/null; then
    echo "Installing: lazydocker - docker GUI"
    go install github.com/jesseduffield/lazydocker@latest
    asdf reshim golang
  fi

  if ! command -v calcure >/dev/null; then
    echo "Installing: calcure - calendar TUI and task manager"
    pipx install calcure
    asdf reshim python
  fi

  if ! command -v yt-dlp >/dev/null; then
    echo "Installing: yt-dlp - download youtube video"
    pipx install yt-dlp
    asdf reshim python
  fi
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
  if grep -qi microsoft /proc/version; then # --> check for WSL
    cwd="/mnt/c/Users/moxli/Dropbox/data.programming.forprivate/marked-pwd"
  fi

  if [[ ! -f $cwd  ]]; then
    echo -ne "[warn] path not found: $cwd\n"
  else
    select=$(cat $cwd | fzf --preview 'eza --long --all --git --color=always --group-directories-first --icons {1}' \
      --preview-window right:50%:nohidden \
      --height=60% --prompt "Jump to> ")
    if [[ -n $select ]]; then
      if [[ ! -d $select ]]; then
        notify-send "invalid folder path:" "$select"
      else
        cd $select
      fi

    fi
  fi

  zle accept-line
}

zle -N run-mark
bindkey '^o' run-mark

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
    --preview-window='50%' --prompt='Grep text current cwd> ' --height='50%' --with-nth 1,3.. --exact)"

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
  

  local doc_con="doc_con_"
  local doc_im="doc_im_"

  if [[ $myargs[-1] == "-p" ]]; then
    select=$(myflag="," _fps)
    LBUFFER="${LBUFFER}$select "
    zle reset-prompt
    return

  elif [[ $myargs[-2] == "alias" ]]; then
    local alias_sel=$(git config --list | grep 'alias\.' | sed 's/alias\.\([^=]*\)=\(.*\)/\1\t\t => \2/' \
      | fzf-tmux -p 80% | cut -d" " -f1 | xargs)
    if [[ -n $alias_sel ]]; then
      LBUFFER="git $alias_sel "
      zle reset-prompt
      return
    else
      LBUFFER="${LBUFFER}"
      zle reset-prompt
      return
    fi

  # for nvim, vim
  elif [[ $myargs[-1] == "v" ]]; then
    local select="**"
    if [[ -n $select ]]; then
      LBUFFER="${LBUFFER}$select"
      zle reset-prompt
      return
    else
      LBUFFER="${LBUFFER}"
      zle reset-prompt
      return
    fi

  elif [[ $myargs[-1] == "nvim" ]]; then
    local select="**"
    if [[ -n $select ]]; then
      LBUFFER="${LBUFFER}$select"
      zle reset-prompt
      return
    else
      LBUFFER="${LBUFFER}"
      zle reset-prompt
      return
    fi

  elif [[ $myargs[-1] == "vim" ]]; then
    local select="**"
    if [[ -n $select ]]; then
      LBUFFER="${LBUFFER}$select"
      zle reset-prompt
      return
    else
      LBUFFER="${LBUFFER}"
      zle reset-prompt
      return
    fi

  elif [[ $myargs[-1] == *"$doc_con"* ]]; then
    #
    # Taken from: https://github.com/pierpo/fzf-docker/blob/913bc66e79d863b324065c1e840860fc79f900cb/fzf-docker.plugin.zsh
    #
    FZF_DOCKER_PS_START_FORMAT="table {{.ID}}\t{{.Names}}\t{{.Status}}\t{{.Image}}"
    FZF_DOCKER_PS_FORMAT="table {{.ID}}\t{{.Names}}\t{{.Image}}\t{{.Ports}}"
    local select=$(docker ps -a --format "${FZF_DOCKER_PS_START_FORMAT}" \
      | fzf --multi --header-lines=1 | awk '{print $1}' )
    if [[ -n $select ]]; then
      LBUFFER="${LBUFFER}$select "
      zle reset-prompt
      return
    else
      LBUFFER="${LBUFFER}"
      zle reset-prompt
      return
    fi

  elif [[ $myargs[-1] == *"$doc_im"* ]]; then
    #
    # Taken from: https://github.com/pierpo/fzf-docker/blob/913bc66e79d863b324065c1e840860fc79f900cb/fzf-docker.plugin.zsh
    #
    local select=$(docker images --format "table {{.Repository}}:{{.Tag}}\t{{.Size}}\t{{.ID}}\t{{.CreatedSince}}" \
      | fzf --multi --header-lines=1 | awk '{print $3}' )

    if [[ -n $select ]]; then
      LBUFFER="${LBUFFER}$select "
      zle reset-prompt
    else
      LBUFFER="${LBUFFER}"
      zle reset-prompt
      return
    fi

  elif [[ $myargs[-1] == "" ]]; then
    local alias_selected=$(
    awk '/\(\)/&& last {print $1,"\t",last} {last=""} /^#/{last=$0}' ~/.config/bashrc/aliases.bashrc |
      column -t -s $'\t' | sed 's/#//' | sed 's/()//' | grcat alias.grc |
      fzf-tmux -xC -w '60%' -h '50%' --exit-0 --ansi
    )

    if [[ -n $alias_selected ]]; then
      select=$(echo "$alias_selected" | cut -d" " -f1 | cut -d"(" -f1)
      if [[ -n $select ]]; then
        LBUFFER="${LBUFFER}$select "
        zle reset-prompt
      else
        LBUFFER="${LBUFFER}"
        zle reset-prompt
        return
      fi
    else
      LBUFFER="${LBUFFER}"
      zle reset-prompt
    fi
  else
    # https://github.com/Aloxaf/fzf-tab/issues/65
    fzf-tab-complete
  fi
}

zle -N show_alias
bindkey '\t' show_alias
