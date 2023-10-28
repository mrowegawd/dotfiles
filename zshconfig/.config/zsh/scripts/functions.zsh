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

build-install(){
  # TODO: install apt seperti urlview
  apt_install="urlview"

  # TODO: install cargo seperti eza, lazygit, etc
  cargo_install="eza"

  # TODO: buil yang khusus apt dan juga cargo
  sudo apt install "$apt_install"
}

build-react() {
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
