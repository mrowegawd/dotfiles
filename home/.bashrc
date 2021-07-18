# ------------------------------------
#░█▀▄░█▀█░█▀▀░█░█░█▀▄░█▀▀░░░░█▀▄░█▀▀ +
#░█▀▄░█▀█░▀▀█░█▀█░█▀▄░█░░░░░░█▀▄░█░░ +
#░▀▀░░▀░▀░▀▀▀░▀░▀░▀░▀░▀▀▀░▀░░▀░▀░▀▀▀ +
# ------------------------------------

# echo "----------------------------"
# echo "prefix: s_ cfg_ w_ r_ c_ t_ fz_ ii[codin] oo[git]"
# echo "prefix-prog: go_ py_ npm_"
# echo "docker: doc_im_(image), doc_con_(container) doc_vol_(volume) doc_net_(network) doc_comp_(compose)"
# echo "----------------------------"

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# case $(uname -s) in
# [Ll]inux)
#   TERM="xterm-256color"
#   ;;
# Darwin)
#   export CLICOLOR=1
#   export LSCOLORS=GxFxCxDxBxegedabagaced
#   ;;
# SunOS) ;;

# esac

export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

export DOTFILES="${HOME}/.dotfiles"
source "${DOTFILES}/variables.sh"

# EXPORT: ----------------------------------------------------------------- {{{
#
export HISTFILE="$HOME/.cache/.bash_history"

export LESSCHARSET=UTF-8
export PAGER=less
export LESS='-R -f -X --tabs=4 --ignore-case --SILENT -P --LESS-- ?f%f:(stdin). ?lb%lb?L/%L.. [?eEOF:?pb%pb\%..]'
# Less Colors for Man Pages
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[1;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'
#
# }}}
# ASDF: ------------------------------------------------------------------- {{{
#
[ -s $HOME/.asdf/asdf.sh ] && . $HOME/.asdf/asdf.sh
[ -s $HOME/.asdf/completions/asdf.bash ] && . $HOME/.asdf/completions/asdf.bash
#
# }}}
# AUTOENV: ---------------------------------------------------------------- {{{
#
# AUTOENV: https://github.com/inishchith/autoenv
export AUTOENVME="$HOME/.autoenv"
[ -s "$AUTOENVME/activate.sh" ] && \. "$AUTOENVME/activate.sh"
#
# }}}
# FZF: -------------------------------------------------------------------- {{{
#
[ -f ~/.fzf.bash ] && . ~/.fzf.bash

[ -f ~/.config/miscxrdb/fzf/fzf.config ] && source ~/.config/miscxrdb/fzf/fzf.config

[ -f ~/.config/zsh/plugins/fzf-marks/fzf-marks.plugin.bash ] &&
  source ~/.config/zsh/plugins/fzf-marks/fzf-marks.plugin.bash

# export FZF_MARKS_FILE="$HOME/.cache/fzf-marks"
export FZF_MARKS_FILE="$HOME/moxconf/data.programming.forprivate/fzf-marks"
export FZF_MARKS_COMMAND="fzf"
export FZF_MARKS_COLOR_RHS="249"
#
# }}}

source $HOME/.config/bashrc/aliases.bashrc
source $HOME/.config/bashrc/bash_prompt.bashrc
