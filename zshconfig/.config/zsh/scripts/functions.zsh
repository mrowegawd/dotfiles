# vim: ft=zsh sw=2 ts=2 et

build-nvim() {
  neovim_dir="$PROJECTS_DIR/contrib/neovim"
  [ ! -d $neovim_dir ] && git clone git@github.com:neovim/neovim.git $neovim_dir
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
V
  # TODO: install cargo seperti eza, lazygit, etc
  cargo_install="eza"

  # TODO: install go get
  cargo_install="lf lazygit"

  # TODO: build yang khusus apt dan juga cargo
  sudo apt install "$apt_install"
}

build-react() {
  echo "usage\n 'build-react [project-name]'\n\n"
  echo "Clone the react-starter..."
  git clone git@github.com:mrowegawd/react-starter.git $@
}

build-go() {
  echo "Clone the go development..."
  echo "not implemented yet..."
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
bindkey '^j' run-mark

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
