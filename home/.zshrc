# vim: ft=zsh sw=2 ts=2 et
# --------------------------------
#░▀▀█░█▀▀░█░█░█▀▄░█▀▀░░░░█▀▄░█▀▀ +
#░▄▀░░▀▀█░█▀█░█▀▄░█░░░░░░█▀▄░█░░ +
#░▀▀▀░▀▀▀░▀░▀░▀░▀░▀▀▀░▀░░▀░▀░▀▀▀ +
# --------------------------------

echo "----------------------------"
echo "prefix: s_ cfg_ w_ r_ c_ t_ fz_ ii[codin] oo[git]"
echo "prefix-prog: go_ py_ npm_"
echo "docker: doc_im_(image), doc_con_(container) doc_vol_(volume) doc_net_(network) doc_comp_(compose)"
echo "----------------------------"

# If you want to debug zsh shell, you can use `zprof`
#
# To debug, set PROFILE_CONFIG to `true`
# PROFILE_CONFIG=false
# [[ $PROFILE_CONFIG == true ]] && zmodload zsh/zprof

unsetopt correct

setopt interactive_comments
setopt long_list_jobs
setopt notify

# setopt hup

unsetopt mail_warning
unsetopt bg_nice
unsetopt hup
unsetopt check_jobs

###################
# directory
###################
setopt auto_cd
setopt auto_pushd
setopt pushd_ignore_dups
setopt pushd_silent
setopt pushd_to_home
setopt cdable_vars
setopt multios
setopt correct
setopt extended_glob
unsetopt clobber


###################
# history
###################
setopt append_history
setopt bang_hist
setopt extended_history
setopt share_history
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_ignore_all_dups
setopt hist_find_no_dups
setopt hist_ignore_space
setopt hist_save_no_dups
setopt hist_verify
setopt hist_beep
setopt inc_append_history
setopt extended_history


source "$HOME/.config/zsh/03-exports.zsh"            # base exports for zsh
source "$ZSH_CONFIG/05-completion.zsh"
source "$HOME/.config/bashrc/aliases.bashrc"         # alias for all [bash/zsh]
source "$ZSH_CONFIG/10-ohmyzsh.zsh"
source "$ZSH_CONFIG/11-prompt.zsh"
source "$ZSH_CONFIG/15-bindkey.zsh"
source "$ZSH_CONFIG/20-aliases.zsh"

typeset -ga sources
sources+="$ZSH_CONFIG/zshload/asdf.zsh"

foreach file (`echo $sources`)
  if [[ -a $file ]]; then
    source $file
  fi
end

# [[ ${PROFILE_CONFIG} == true ]] && zprof

SAVEHIST=5000
HISTSIZE=5000               #How many lines of history to keep in memory
if (( ! EUID )); then
  HISTFILE=$HOME/.cache/zsh/history_root

else
  HISTFILE=$HOME/.cache/zsh/history
fi


export LESSCHARSET=UTF-8
export PAGER=less
export LESS='-R -f -X --tabs=4 --ignore-case --SILENT -P --LESS-- ?f%f:(stdin). ?lb%lb?L/%L.. [?eEOF:?pb%pb\%..]'
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;38;5;74m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[38;5;246m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[04;38;5;146m'

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

export MANPAGER="/bin/sh -c \"col -b | \
    nvim -c 'set ft=man ts=8 nomod nolist nonu noma' -\""


# autoload -Uz compinit && compinit
###########################################
# FZF
###########################################
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
[ -f ~/.config/miscxrdb/fzf/fzf.config ] && source ~/.config/miscxrdb/fzf/fzf.config

[ -f $ZSH_PLUGINS/fzf-marks/fzf-marks.plugin.zsh ] \
  && source $ZSH_PLUGINS/fzf-marks/fzf-marks.plugin.zsh

FZF_MARKS_FILE="$HOME/Dropbox/data.programming.forprivate/fzf-marks"
FZF_MARKS_COMMAND="fzf"
FZF_MARKS_COLOR_RHS="249"

###########################################
# ZSH-SYNTAX-HIGHLIGHTING
###########################################

# [ -f $ZSH_PLUGINS/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ] \
#   && source $ZSH_PLUGINS/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh


###########################################
# AUTO SSH-ADD (for git master)
###########################################

if [ ! -f /tmp/auto-ssh  ]; then
  sshenv=~/.ssh/agent.env

  agent_load_env () { test -f "$sshenv" && . "$sshenv" >| /dev/null; }

  agent_start () {
    (umask 077; ssh-agent >| "$sshenv")
    . "$sshenv" >| /dev/null ;
  }

  agent_load_env

  # agent_run_state: 0=agent running w/ key; 1=agent w/o key; 2= agent not running

  agent_run_state=$(ssh-add -l >| /dev/null 2>&1; echo $?)

  if [ ! -z "$SSH_AUTH_SOCK" ] || [ $agent_run_state = 2 ]; then
    agent_start
    ssh-add
  elif ["$SSH_AUTH_SOCK"] && [$agent_run_state = 1]; then
    ssh-add
  fi

  unset sshenv

  # Get your start now my fucking dropbox!
  if grep -qEi "(Microsoft|WSL)" /proc/version &> /dev/null ; then
    if command -v dropbox.py &>/dev/null; then
      dropbox.py start
    fi
  fi

  touch /tmp/auto-ssh

fi

# export TERM=screen-256color-bce
