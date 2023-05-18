
# file `.exports.zsh` ONLY for default export zsh
# if you want to set another export, use path: ~/.dotfiles/variables.sh

export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export ZSH_CONFIG="$XDG_CONFIG_HOME/zsh"
export ZSH_CACHE="$XDG_CACHE_HOME/zsh"
export ZSH_PLUGINS="$XDG_CACHE_HOME/zsh/plugins"

mkdir -p $ZSH_CACHE $ZSH_PLUGINS
