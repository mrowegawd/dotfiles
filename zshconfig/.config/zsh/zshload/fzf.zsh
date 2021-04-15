# vim: ft=zsh sw=2 ts=2 et

########################
# DEFAULT FZF
########################
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
[ -f ~/.config/miscxrdb/fzf/fzf.config ] && source ~/.config/miscxrdb/fzf/fzf.config

########################
# FZF PLUGINS
########################
# syntax highlighting
[ -f $ZSH_PLUGINS/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ] \
  && source $ZSH_PLUGINS/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# mark for fzf
[ -f $ZSH_PLUGINS/fzf-marks/fzf-marks.plugin.zsh ] \
  && source $ZSH_PLUGINS/fzf-marks/fzf-marks.plugin.zsh

# unameOut="$(uname -s)"
# case "${unameOut}" in
#     Linux*)     machine=Linux;;
#     Darwin*)    machine=Mac;;
#     CYGWIN*)    machine=Cygwin;;
#     MINGW*)     machine=MinGw;;
#     *)          machine="UNKNOWN:${unameOut}"
# esac

# echo ${machine}

FZF_MARKS_FILE="$HOME/Dropbox/data.programming.forprivate/fzf-marks"
FZF_MARKS_COMMAND="fzf"
FZF_MARKS_COLOR_RHS="249"

bindkey '^Y' fzm
