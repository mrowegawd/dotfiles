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
V
  # TODO: install cargo seperti eza, lazygit, etc
  cargo_install="eza"

  # TODO: install go get
  cargo_install="lf lazygit"

  # TODO: build yang khusus apt dan juga cargo
  sudo apt install "$apt_install"

  # TODO: install gpg-tui
  # install depencies apt-get install libgpgme-dev libx11-dev libxcb-shape0-dev libxcb-xfixes0-dev libxkbcommon-dev
  # carog install gpg-tui
  #

  # TODO: install dive (https://github.com/wagoodman/dive)
  # go get github.com/wagoodman/dive
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

show_alias() {
  setopt localoptions noglobsubst noposixbuiltins pipefail no_aliases 2>/dev/null

  local select
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

  LBUFFER="${LBUFFER}$select "
  zle reset-prompt
}

zle -N show_alias
bindkey '^o' show_alias


show_alias_git() {
  setopt localoptions noglobsubst noposixbuiltins pipefail no_aliases 2>/dev/null

  local alias_sel=$(git config --list | grep 'alias\.' | sed 's/alias\.\([^=]*\)=\(.*\)/\1\t\t => \2/' | fzf-tmux -p 80% | cut -d" " -f1 | xargs)

  if [[ ! -n $alias_sel ]]; then
    return
  fi

  LBUFFER="${LBUFFER}git $alias_sel "
  zle reset-prompt
}

zle -N show_alias_git
bindkey '^q' show_alias_git
