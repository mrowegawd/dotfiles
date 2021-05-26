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
PROFILE_CONFIG=false
[[ $PROFILE_CONFIG == true ]] && zmodload zsh/zprof

source "$HOME/.config/zsh/01-init.zsh"
source "$HOME/.config/zsh/03-exports.zsh"            # base exports for zsh
source "$ZSH_CONFIG/05-completion.zsh"

source "$HOME/.config/bashrc/aliases.bashrc"         # alias for all [bash/zsh]
source "$ZSH_CONFIG/10-ohmyzsh.zsh"
source "$ZSH_CONFIG/11-prompt.zsh"
source "$ZSH_CONFIG/15-bindkey.zsh"
source "$ZSH_CONFIG/20-aliases.zsh"

typeset -ga sources
sources+="$ZSH_CONFIG/zshload/fzf.zsh"
sources+="$ZSH_CONFIG/zshload/asdf.zsh"

foreach file (`echo $sources`)
  if [[ -a $file ]]; then
    source $file
  fi
end

[[ ${PROFILE_CONFIG} == true ]] && zprof

export MANPAGER="/bin/sh -c \"col -b | \
    nvim -c 'set ft=man ts=8 nomod nolist nonu noma' -\""

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

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
