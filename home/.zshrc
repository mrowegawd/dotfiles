# vim: ft=zsh sw=2 ts=2 et
# --------------------------------
#░▀▀█░█▀▀░█░█░█▀▄░█▀▀░░░░█▀▄░█▀▀ +
#░▄▀░░▀▀█░█▀█░█▀▄░█░░░░░░█▀▄░█░░ +
#░▀▀▀░▀▀▀░▀░▀░▀░▀░▀▀▀░▀░░▀░▀░▀▀▀ +
# --------------------------------

# echo "----------------------------"
# echo "prefix: s_ cfg_ w_ r_ c_ t_ fz_ ii[codin] oo[git]"
# echo "prefix-prog: go_ py_ npm_"
# printf "docker:\n"
# printf "\tdoc_im_(image)\tdoc_con_(container)\tdoc_vol_(volume)\n"
# printf "\tdoc_net_(network)\tdoc_comp_(compose)\n"
# # echo "docker: doc_im_(image), doc_con_(container) doc_vol_(volume) doc_net_(network) doc_comp_(compose)"
# echo "----------------------------"

# If you want to debug zsh shell, you can use `zprof`
#
# To debug, set PROFILE_CONFIG to `true`
# PROFILE_CONFIG=false
# [[ $PROFILE_CONFIG == true ]] && zmodload zsh/zprof
#
[[ $- == *i* ]] && stty -ixon

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

# Remove % line
# read: https://superuser.com/questions/645599/why-is-a-percent-sign-appearing-before-each-prompt-on-zsh-in-windows
setopt PROMPT_CR
setopt PROMPT_SP
export PROMPT_EOL_MARK=""


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

source "$HOME/.config/zsh/03-exports.zsh"            # base exports for zsh
source "$HOME/.config/bashrc/aliases.bashrc"         # alias for all [bash/zsh]
source "$ZSH_CONFIG/05-completion.zsh"               # terdapat default keybind juga
source "$ZSH_CONFIG/11-prompt.zsh"
source "$ZSH_CONFIG/15-bindkey.zsh"


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

export MANPAGER="/bin/sh -c \"col -b | \
    nvim -c 'set ft=man ts=8 nomod nolist nonu noma' -\""

###########################################
# FZF
###########################################
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
[ -f ~/.config/miscxrdb/fzf/fzf.config ] && source ~/.config/miscxrdb/fzf/fzf.config

###########################################
# ZSH-SYNTAX-HIGHLIGHTING
###########################################
[ -f $ZSH_PLUGINS/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ] \
  && source $ZSH_PLUGINS/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

[ -f $ZSH_PLUGINS/zsh-autosuggestions/zsh-autosuggestions.zsh ] \
  && source $ZSH_PLUGINS/zsh-autosuggestions/zsh-autosuggestions.zsh

###########################################
# AUTO SSH-ADD (for git master)
###########################################
if [ ! -f /tmp/auto-ssh  ]; then
  SSH_GITHUB="$HOME/.ssh/GITHUB2JAN2022.pub"

  if [ -f "$SSH_GITHUB" ]; then
    sshenv=$HOME/.ssh/agent.env

    agent_load_env () { test -f "$sshenv" && . "$sshenv" >| /dev/null; }

    agent_start () {
      (umask 077; ssh-agent >| "$sshenv")
      . "$sshenv" >| /dev/null ;
    }

    agent_run_state=$(ssh-add -l >| /dev/null 2>&1; echo $?)

    if [ ! -z "$SSH_AUTH_SOCK" ] || [ $agent_run_state = 2 ]; then
      agent_load_env
      agent_start
      ssh-add
      ssh-add "$SSH_GITHUB"
    elif ["$SSH_AUTH_SOCK"] && [$agent_run_state = 1]; then
      ssh-add "$SSH_GITHUB"
    fi

    unset sshenv
  fi

  touch /tmp/auto-ssh
fi

# AUTOENV: ---------------------------------------------------------------- {{{
#
# Link install: https://github.com/inishchith/autoenv
export AUTOENVME="$HOME/.autoenv"
[ -s "$AUTOENVME/activate.sh" ] && . "$AUTOENVME/activate.sh"
#
# }}}

[[ -s "/etc/grc.zsh" ]] && source /etc/grc.zsh

# Disable virtualenv prompt, it breaks starship
set -g VIRTUAL_ENV_DISABLE_PROMPT 1

# export TERM=screen-256color-bce

export PATH="$HOME/.poetry/bin:$PATH"

export XDG_RUNTIME_DIR="/run/user/$UID"
export DBUS_SESSION_BUS_ADDRESS="unix:path=${XDG_RUNTIME_DIR}/bus"

# [[ $TERM != "screen" ]] && exec tmux

# [ -z "$TMUX"  ] && { tmux attach || exec tmux new-session && exit;}

# lf-ueberzug() {
# 	cleanup() {
# 		lf-ueberzug-cleaner
# 		kill "$UEBERZUGPID"
# 		pkill -f "tail -f $LF_UEBERZUG_TEMPDIR/fifo"
# 		rm -rf "$LF_UEBERZUG_TEMPDIR"
# 	}
# 	trap cleanup INT HUP

# 	# Set up temporary directory.
# 	export LF_UEBERZUG_TEMPDIR="$(mktemp -d -t lf-ueberzug-XXXXXX)"

# 	# Launch ueberzug.
# 	mkfifo "$LF_UEBERZUG_TEMPDIR/fifo"
# 	tail -f "$LF_UEBERZUG_TEMPDIR/fifo" | ueberzug layer --silent &
# 	UEBERZUGPID=$!

# 	lf "$@"
# 	cleanup
# }
# alias lf=lf-ueberzug
lf () {
  LF_TEMPDIR="$(mktemp -d -t lf-tempdir-XXXXXX)"
  LF_TEMPDIR="$LF_TEMPDIR" lf-run -last-dir-path="$LF_TEMPDIR/lastdir" "$@"
  if [ "$(cat "$LF_TEMPDIR/cdtolastdir" 2>/dev/null)" = "1" ]; then
    cd "$(cat "$LF_TEMPDIR/lastdir")"
  fi
  rm -r "$LF_TEMPDIR"
  unset LF_TEMPDIR
}
