export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"

export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
export ZSH_CACHE_DIR="$XDG_CACHE_HOME/zsh"

export ZSH_PLUGINS="$XDG_CONFIG_HOME/zsh/plugins"

mkdir -p $ZSH_CACHE_DIR $ZSH_PLUGINS

export SYNC_DIR=${HOME}/Dropbox
export DOTFILES="${HOME}/moxconf/development/dotfiles"
export PROJECTS_DIR=${HOME}/moxconf
export PERSONAL_PROJECTS_DIR=${PROJECTS_DIR}/project-testing

export MANPATH="/usr/local/man:$MANPATH"
if which nvim >/dev/null; then
  export MANPAGER='nvim +Man!'
fi

source "${DOTFILES}/miscxrdb/.config/miscxrdb/global-exports/variables.sh"

# if [ -e "$HOME/.nix-profile/etc/profile.d/nix.sh" ]; then . $HOME/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer
