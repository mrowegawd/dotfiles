# vim: ft=zsh sw=2 ts=2 et

build-nvim() {
  neovim_dir="$PROJECTS_DIR/contrib/neovim"
  [ ! -d $neovim_dir ] && git clone https://github.com/neovim/neovim.git $neovim_dir
  pushd $neovim_dir
  git checkout master
  git reset --hard origin/$(git rev-parse --abbrev-ref HEAD) && git clean -fdx
  # git pull upstream master
  git fetch --tags -f
  git pull --rebase --prune
  git checkout nightly
  # git checkout stable
  [ -d "$neovim_dir/build/" ] && rm -r ./build/ # clear the CMake cache
  rm -rf $HOME/neovim/*
  make CMAKE_BUILD_TYPE=Release CMAKE_EXTRA_FLAGS="-DCMAKE_INSTALL_PREFIX=$HOME/neovim"
  make install
  popd
}
build-install() {
  # ──────────────────────────────────────────────────────────────────────
  # APT
  # ──────────────────────────────────────────────────────────────────────
  if ! command -v xinput >/dev/null; then
    echo "Installing: xinput - Fixing mouse lagging..?"
    sudo apt install xinput
  fi

  if ! command -v pass >/dev/null; then
    echo "Installing: pass - The standard unix password manager"
    sudo apt install pass ydotool ydotoold -y
  fi

  if ! command -v urlview >/dev/null; then
    echo "Installing: urlview"
    sudo apt install urlview
  fi

  if ! command -v betterlockscreen >/dev/null; then
    echo "Installing: i3lock - screen lock"
    sudo apt install autoconf gcc make pkg-config libpam0g-dev \
      libcairo2-dev libfontconfig1-dev libxcb-composite0-dev \
      libev-dev libx11-xcb-dev libxcb-xkb-dev libxcb-xinerama0-dev \
      libxcb-randr0-dev libxcb-image0-dev libxcb-util0-dev libxcb-xrm-dev \
      libxkbcommon-dev libxkbcommon-x11-dev libjpeg-dev
    git clone https://github.com/Raymo111/i3lock-color.git && cd i3lock-color && ./install-i3lock-color.sh
    wget https://raw.githubusercontent.com/betterlockscreen/betterlockscreen/main/install.sh -O - -q | sudo bash -s system
  fi

  if ! command -v fd >/dev/null; then
    echo "Installing: fd - Blazingly fast for search folder name"
    sudo apt install fd-find
    sudo ln -s /usr/bin/fdfind $HOME/.local/bin/fd
  fi

  if ! command -v proxychains >/dev/null; then
    echo "Installing: proxychains - Wrapper for tor"
    sudo apt install proxychains4
  fi

  # if ! command -v btop >/dev/null; then
  #   echo "Installing: btop - A monitor of resources"
  #   wget https://github.com/aristocratos/btop/releases/download/v1.4.2/btop-x86_64-linux-musl.tbz
  # fi

  if ! command -v ueberzugpp >/dev/null; then
    echo "Installing: ueberzugpp - Drop in replacement for ueberzug written in C++"
    echo 'deb http://download.opensuse.org/repositories/home:/justkidding/Debian_12/ /' | sudo tee /etc/apt/sources.list.d/home:justkidding.list
    curl -fsSL https://download.opensuse.org/repositories/home:justkidding/Debian_12/Release.key | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/home_justkidding.gpg > /dev/null
    sudo apt update
    sudo apt install ueberzugpp
  fi

  if ! command -v toilet >/dev/null; then
    echo "Installing: play - Funny color command"
    sudo apt install toilet
  fi

  # TODO: install pomodoro, from youtube https://www.youtube.com/watch?v=GfQjJBtO-8Y
  # https://github.com/caarlos0/timer
  # cara install `timer`:
  # echo 'deb [trusted=yes] https://repo.caarlos0.dev/apt/ /' | sudo tee /etc/apt/sources.list.d/caarlos0.list
  # sudo apt update
  # sudo apt install timer

  if ! command -v play >/dev/null; then
    echo "Installing: play - Play sound from the terminal"
    sudo apt install sox
    sudo apt install libsox-fmt-all
  fi

  if ! command -v hub >/dev/null; then
    echo "Installing: hub - An extensions to cmdline git"
    sudo apt install hub
  fi

  # ──────────────────────────────────────────────────────────────────────
  # RUST, cargo
  # ──────────────────────────────────────────────────────────────────────
  if ! command -v bat >/dev/null; then
    echo "Installing: bat - we cat before bat"
    cargo install bat
    asdf reshim rust
  fi

  if ! command -v viu >/dev/null; then
    echo "Installing: viu - Terminal image viewer with native support for iTerm and Kitty (fzflua dependencies)"
    cargo install viu
    asdf reshim rust
  fi

  if ! command -v gifski >/dev/null; then
    # Install: gifski
    # gihtub: https://github.com/sindresorhus/Gifski
    # install binary langsung dari link https://gif.ski/
    echo "Installing: gifski - Gif encoder"
    cargo install gifski
    asdf reshim rust
  fi


  if ! command -v dua >/dev/null; then
    echo "Installing: dua-cli - Similiar with tool 'du' to check disk usage"
    cargo install dua-cli
    asdf reshim rust
  fi

  if ! command -v procs >/dev/null; then
    echo "Installing: procs - Better than use 'ps' command"
    cargo install procs
    asdf reshim rust
  fi


  if ! command -v eza >/dev/null; then
    echo "Installing: eza - ls colors"
    cargo install eza
    asdf reshim rust
  fi

  if ! command -v zoxide >/dev/null; then
    echo "Installing: zoxide - A smarter cd commands"
    cargo install zoxide --locked
    asdf reshim rust
  fi

  if ! command -v delta >/dev/null; then
    echo "Installing: delta - Color for git hunk/chommits"
    cargo install git-delta
    asdf reshim rust
  fi

  if ! command -v rg >/dev/null; then
    echo "Installing: rg - Grep drugs"
    cargo install ripgrep
    asdf reshim rust
  fi

  # https://github.com/race604/clock-tui
  if ! command -v tclock >/dev/null; then
    echo "Installing: tclock - Clock tui"
    cargo install clock-tui
    asdf reshim rust
  fi

  if ! command -v tree-sitter >/dev/null; then
    echo "Installing: tree-sitter-cli - Treesitter passer cli for nvim"
    cargo install tree-sitter-cli
    asdf reshim rust
  fi

  if ! command -v yazi >/dev/null; then
    echo "Installing: yazi - File manager tui"
    cargo install --locked --git https://github.com/sxyazi/yazi.git yazi-fm yazi-cli
    asdf reshim rust
    # yazi git integration
    # ya pack -a yazi-rs/plugins:git
  fi

  if ! command -v rust-analyzer >/dev/null; then
    echo "Installing: rust-analyzer - Manual install for LSP analyzer rust"
    rustup component add rust-analyzer
    asdf reshim rust
  fi

  # ──────────────────────────────────────────────────────────────────────
  # GO install
  # ──────────────────────────────────────────────────────────────────────
  if ! command -v dive >/dev/null; then
    echo "Installing: dive - Explore docker layer"
    go install github.com/wagoodman/dive@latest
    asdf reshim golang
  fi

  if ! command -v sesh >/dev/null; then
    echo "Installing: sesh - Handle tmux session"
    go install github.com/joshmedeski/sesh@latest
    asdf reshim golang
  fi

  if ! command -v lazydocker >/dev/null; then
    echo "Installing: lazydocker - Docker TUI"
    go install github.com/jesseduffield/lazydocker@latest
    asdf reshim golang
  fi

  if ! command -v gowall >/dev/null; then
    echo "Installing: gowall - Convert wallpaper theme (just like pywall)"
    go install github.com/Achno/gowall@latest
    asdf reshim golang
  fi

  if ! command -v lazygit >/dev/null; then
    echo "Installing: lazygit - Git TUI"
    # go install github.com/jesseduffield/lazygit@latest
    # asdf reshim golang
    LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | \grep -Po '"tag_name": *"v\K[^"]*')
    curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
    tar xf lazygit.tar.gz lazygit
    sudo install lazygit -D -t /usr/local/bin/
    rm -rf lazygit.tar.gz lazygit
  fi

  # ──────────────────────────────────────────────────────────────────────
  # Pip, pipx
  # ──────────────────────────────────────────────────────────────────────
  if ! command -v pipx >/dev/null; then
    echo "Installing: pipx"
    pip install pipx
    asdf reshim python
  fi

  if ! command -v calcure >/dev/null; then
    echo "Installing: calcure - Calendar TUI"
    pipx install calcure
    asdf reshim python
  fi

  if ! command -v img2art >/dev/null; then
    # https://github.com/Asthestarsfalll/img2art
    echo "Installing: img2art - Convert image/gif/video to ascii art (use for snacks.nvim dashboard)"
    pipx install img2art
    asdf reshim python
  fi

  if ! command -v yt-dlp >/dev/null; then
    echo "Installing: yt-dlp - A tool for download youtube video"
    pipx install yt-dlp
    asdf reshim python
  fi

  # ──────────────────────────────────────────────────────────────────────
  # NPM
  # ──────────────────────────────────────────────────────────────────────
  if ! command -v mmdc >/dev/null; then
    echo "Installing: mmdc - A tool for the mermaid library nvim"
    npm install -g @mermaid-js/mermaid-cli
    asdf reshim nodejs
  fi

  if ! command -v cronstrue >/dev/null; then
    echo "Installing: cronstrue - parses a cron expression and outputs a human readable"
    npm install -g cronstrue
    asdf reshim nodejs
  fi

  if ! command -v yarn >/dev/null; then
    echo "Installing: yarn - another package managers for JavaScript"
    npm install -g yarn
    asdf reshim nodejs
  fi
}

Green=$(tput setaf 2)  # Green
Color_Off=$(tput sgr0) # Text Reset

build-python() {
  if [[ $1 == "" ]]; then
    echo "Must define project name:\nEx: 'build-python <name-project>'"
  else
    poetry new "$1"
    cd "$1"
  fi
}

build-react() {
  if [[ $1 == "" ]]; then
    echo "Must define project name:\n Ex: 'build-react <name-project>'"
  else
    git clone https://github.com/mrowegawd/react-starter.git $@
  fi
}

build-go() {
  if [[ $1 == "" ]]; then
    echo "Must define project name:\n Ex: 'build-go <name-project>'"
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

  if [[ ! -f $cwd ]]; then
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

function fg-bg() {
  if [[ $#BUFFER -eq 0 ]]; then
    fg
  else
    zle push-input
  fi
}
zle -N fg-bg
bindkey '^z' fg-bg

function tmc() {
  LBUFFER+="tm "
  zle accept-line
}
zle -N tmc
bindkey '^[y' tmc

function exitme() {
  LBUFFER+="exit "
  zle accept-line
}
zle -N exitme
bindkey '^[x' exitme

find-in-file() {
  local _file="$(rg --color=always --line-number --hidden --no-heading --smart-case "${@:-^[^\n]}" \
    | fzf --ansi -d ':' --preview 'bat --style=numbers --color=always $(cut -d: -f1 <<< {1}) --highlight-line {2}  --line-range={2}:+20' \
    --preview-window='50%' --prompt='Grep> ' --height='50%' --with-nth 1,3.. --exact)"

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

  elif echo "${myargs[-1]}" | grep -q "^doc_con_[a-zA-Z0-9_]\+\S" ; then
    #
    # Taken from: https://github.com/pierpo/fzf-docker/blob/913bc66e79d863b324065c1e840860fc79f900cb/fzf-docker.plugin.zsh
    #
    FZF_DOCKER_PS_START_FORMAT="table {{.ID}}\t{{.Names}}\t{{.Status}}\t{{.Image}}"
    FZF_DOCKER_PS_FORMAT="table {{.ID}}\t{{.Names}}\t{{.Image}}\t{{.Ports}}"
    local select=$(docker ps -a --format "${FZF_DOCKER_PS_START_FORMAT}" \
      | fzf --multi --height=40% --header-lines=1 | awk '{print $1}' )
    if [[ -n $select ]]; then
      LBUFFER="${LBUFFER}$select "
      zle reset-prompt
      return
    else
      LBUFFER="${LBUFFER}"
      zle reset-prompt
      return
    fi

  elif echo "${myargs[-1]}" | grep -q "^doc_im_[a-zA-Z0-9_]\+\S" ; then
    #
    # Taken from: https://github.com/pierpo/fzf-docker/blob/913bc66e79d863b324065c1e840860fc79f900cb/fzf-docker.plugin.zsh
    #
    local select=$(docker images --format "table {{.Repository}}:{{.Tag}}\t{{.Size}}\t{{.ID}}\t{{.CreatedSince}}" \
      | fzf --multi --height=40% --header-lines=1 | awk '{print $3}' )

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
      column -t -s $'\t' | sed 's/#//' | sed 's/()//' | fzf-tmux -xC -w '60%' -h '50%' --exit-0 --ansi
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
