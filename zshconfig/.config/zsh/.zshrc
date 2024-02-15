# vim: ft=zsh sw=2 ts=2 et
# --------------------------------
#░▀▀█░█▀▀░█░█░█▀▄░█▀▀░░░░█▀▄░█▀▀ +
#░▄▀░░▀▀█░█▀█░█▀▄░█░░░░░░█▀▄░█░░ +
#░▀▀▀░▀▀▀░▀░▀░▀░▀░▀▀▀░▀░░▀░▀░▀▀▀ +
# --------------------------------

# For debug:
# zmodload zsh/zprof

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.config/zsh/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# ┏╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┓
# ╏ OPTIONS                                                  ╏
# ┗╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┛
setopt INTERACTIVE_COMMENTS
setopt LONG_LIST_JOBS
setopt NOTIFY
setopt APPEND_HISTORY
setopt AUTOPARAMSLASH            # tab completing directory appends a slash
setopt AUTO_CD
setopt AUTO_PUSHD                # Push the current directory visited on the stack.
setopt COMPLETE_ALIASES
setopt CORRECT                  # command auto-correction
setopt EXTENDED_HISTORY          # Write the history file in the ':start:elapsed;command' format.
setopt HIST_BEEP
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS
setopt HIST_VERIFY
setopt INC_APPEND_HISTORY        # Write to the history file immediately, not when the shell exits
setopt PROMPT_CR
setopt PROMPT_SP
setopt PUSHD_IGNORE_DUPS         # Do not store duplicates in the stack.
setopt PUSHD_SILENT              # Do not print the directory stack after pushd or popd.
setopt RM_STAR_WAIT
setopt SHARE_HISTORY             # Share your history across all your terminal windows
setopt HIST_SAVE_NO_DUPS
unsetopt HIST_SAVE_NO_DUPS       # Write a duplicate event to the history file

# Keep a ton of history.
HISTSIZE=100000
SAVEHIST=100000
HISTFILE=$ZSH_CACHE_DIR/.zsh_history

# Noteme: source `asdf` sesuai dari README harus berada diatas sebelum line `compinit`
source "$HOME/.asdf/asdf.sh"

fpath=($ZDOTDIR/funcs $fpath)
fpath=(${ASDF_DIR}/completions $fpath)

# ┏╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┓
# ╏ COMPLETION                                               ╏
# ┗╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┛

# Speed up zsh compinit by only checking cache once a day.
# This piece of code is taken from
# https://gist.github.com/ctechols/ca1035271ad13484128
# if [[ -n ${ZDOTDIR:-${HOME}}/.zcompdump(#qN.mh+24) ]]; then
#     compinit;
# else
#     compinit -C;
# fi;
# autoload -U compinit && (compinit &; compinit -C)

# Check this link to find out how to make completion in zsh
# https://thevaluable.dev/zsh-completion-guide-examples/
zmodload zsh/complist

autoload -Uz $ZDOTDIR/funcs/*(.:t)
autoload -Uz compinit ; compinit
_comp_options+=(globdots) # Include hidden files, when do 'cd ..<tab>'

# Colorize completions using default `ls` colors.
# zstyle ':completion:*' list-colors ''
# zstyle ':completion:*' list-colors "${LS_COLORS}"

# Akan memunculkan mode search ketika type `git <TAB>`
# zstyle ':completion:*:*:*:default' menu yes select search

# persistent reshahing i.e puts new executables in the $path
# if no command is set typing in a line will cd by default
zstyle ':completion:*' menu select
zstyle ':completion:*' rehash true
zstyle ':completion:*:matches' group yes
zstyle ':completion:*:options' description yes
zstyle ':completion:*:options' auto-description '%d'
zstyle ':completion:*:corrections' format ' %F{green}-- %d (errors: %e) --%f'
zstyle ':completion:*:descriptions' format ' %F{yellow}-- %d --%f'
zstyle ':completion:*:messages' format ' %F{purple} -- %d --%f'
zstyle ':completion:*:warnings' format ' %F{red}-- no matches found --%f'
zstyle ':completion:*:default' list-prompt '%S%M matches%s'
zstyle ':completion:*' format ' %F{yellow}-- %d --%f'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' verbose yes
zstyle ':completion:*' expand suffix
zstyle ':completion:*' file-sort modification
zstyle ':completion:*' list-suffixes true
# Make completion:
# (stolen from Wincent)
# - Try exact (case-sensitive) match first.
# - Then fall back to case-insensitive.
# - Accept abbreviations after . or _ or - (ie. f.b -> foo.bar).
# - Substring complete (ie. bar -> foobar).
zstyle ':completion:*' matcher-list '' \
  '+m:{[:lower:]}={[:upper:]}' \
  '+m:{[:upper:]}={[:lower:]}' \
  '+m:{_-}={-_}' \
  'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

# completion of ps command
# zstyle ':completion:*:processes' command 'ps x -o pid,s,args'

# Kill
zstyle ':completion:*:*:*:*:processes' command 'ps -u $LOGNAME -o pid,user,command -w'
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;36=0=01'
zstyle ':completion:*:*:kill:*' menu select
zstyle ':completion:*:*:kill:*' force-list always
zstyle ':completion:*:*:kill:*' insert-ids single

# completion of sudo command
# zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin /usr/sbin /usr/bin /sbin /bin

# Fuzzy match mistyped completions.
zstyle ':completion:*' completer _oldlist _complete _match _approximate
zstyle ':completion:*:match:*' original only
zstyle ':completion:*:approximate:*' max-errors 1 numeric

# https://github.com/zsh-users/zsh/blob/master/Functions/Chpwd/cdr
zstyle ':completion:*:*:cdr:*:*' menu selection

# $WINDOWID is an environment variable set by kitty representing the window ID
# of the OS window (NOTE this is not the same as the $KITTY_WINDOW_ID)
# @see: https://github.com/kovidgoyal/kitty/pull/2877
zstyle ':chpwd:*' recent-dirs-file $ZSH_CACHE_DIR/.chpwd-recent-dirs-${WINDOWID##*/} +
zstyle ':completion:*' recent-dirs-insert always
zstyle ':chpwd:*' recent-dirs-default yes

zstyle ':completion::complete:*' use-cache true
zstyle ':completion:*' cache-path "$ZSH_CACHE_DIR/zcompcache"


# Completion for kitty
if [[ "$TERM" == "xterm-kitty" ]]; then
  kitty + complete setup zsh | source /dev/stdin
fi

# ┏╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┓
# ╏ LESS                                                     ╏
# ┗╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┛
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

# ┏╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┓
# ╏ KEYBINDINGS                                              ╏
# ┗╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┛

# @see: https://thevaluable.dev/zsh-install-configure-mouseless/
bindkey -v # enables vi mode, using -e = emacs

bindkey '^?'                  backward-delete-char
bindkey '^h'                  backward-char            # backward (c-b)
bindkey '^l'                  forward-char             # forward char (c-f)
bindkey '^b'                  backward-word            # backward (c-b)
bindkey '^f'                  forward-word             # forward char (c-f)
bindkey '^a'                  beginning-of-line
bindkey '^e'                  end-of-line

# Shortcut bind to edit line text
autoload -U edit-command-line
zle -N edit-command-line

bindkey -M viins '^[q'        edit-command-line         # alt-q
bindkey -M viins 'jk'         vi-cmd-mode               # 'jk' for Escape
bindkey -M viins 'kj'         vi-cmd-mode               # 'kj' for <ESC>

bindkey '^R'                  history-incremental-search-backward
bindkey '^P'                  up-history
bindkey '^N'                  down-history

# Enable keyboard navigation of completions in menu
# (not just tab/shift-tab but cursor keys as well):
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history

# shift-tab to reverse completion
bindkey '^[[Z' reverse-menu-complete
bindkey -M menuselect '^[[Z' reverse-menu-complete

# Change cursor shape for different vi modes.
function zle-keymap-select {
  if [[ ${KEYMAP} == vicmd ]] ||
     [[ $1 = 'block' ]]; then
    echo -ne '\e[1 q'
  elif [[ ${KEYMAP} == main ]] ||
       [[ ${KEYMAP} == viins ]] ||
       [[ ${KEYMAP} = '' ]] ||
       [[ $1 = 'beam' ]]; then
    echo -ne '\e[5 q'
  fi
}
zle -N zle-keymap-select

# ╒══════════════════════════════════════════════════════════╕
# │ SOURCE MISC (PLUGINS, ASDF, ETC)                         │
# ╘══════════════════════════════════════════════════════════╛

# +----------------------------------------------------------+
# | LOCAL SCRIPTS                                            |
# +----------------------------------------------------------+
# source all zsh and sh files
for script in $ZDOTDIR/scripts/*; do
  source $script
done


###########################################
# AUTO SSH-ADD (for git master)
###########################################
# if [ ! -f /tmp/auto-ssh  ]; then
#   SSH_GITHUB="$HOME/.ssh/GITHUB2JAN2022.pub"
#
#   if [ -f "$SSH_GITHUB" ]; then
#     sshenv=$HOME/.ssh/agent.env
#
#     agent_load_env () { test -f "$sshenv" && . "$sshenv" >| /dev/null; }
#
#     agent_start () {
#       (umask 077; ssh-agent >| "$sshenv")
#       . "$sshenv" >| /dev/null ;
#     }
#
#     agent_run_state=$(ssh-add -l >| /dev/null 2>&1; echo $?)
#
#     if [ ! -z "$SSH_AUTH_SOCK" ] || [ $agent_run_state = 2 ]; then
#       agent_load_env
#       agent_start
#       ssh-add
#       ssh-add "$SSH_GITHUB"
#     elif ["$SSH_AUTH_SOCK"] && [$agent_run_state = 1]; then
#       ssh-add "$SSH_GITHUB"
#     fi
#
#     unset sshenv
#   fi
#
#   touch /tmp/auto-ssh
# fi

source "$HOME/.config/bashrc/aliases.bashrc"         # alias for all [bash/zsh]

[[ -f $ZSH_PLUGINS/autoenv/autoenv.plugin.zsh ]] \
  && source $ZSH_PLUGINS/autoenv/autoenv.plugin.zsh

[[ -f $ZSH_PLUGINS/fzf-tab/fzf-tab.plugin.zsh ]] \
  && source $ZSH_PLUGINS/fzf-tab/fzf-tab.plugin.zsh

[[ -f $ZSH_PLUGINS/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]] \
  && source $ZSH_PLUGINS/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

[[ -f $ZSH_PLUGINS/zsh-autosuggestions/zsh-autosuggestions.zsh ]] \
  && source $ZSH_PLUGINS/zsh-autosuggestions/zsh-autosuggestions.zsh

# ASDF for go
if [ -d $(asdf where golang) ]; then
  export GOPATH=$(asdf where golang)/packages
  export GOROOT=$(asdf where golang)/go
  export PATH="${PATH}:$(go env GOPATH)/bin"
fi

# FZF
if [ -f "$HOME/.fzf.zsh" ]; then
  ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=241'
  ZSH_AUTOSUGGEST_USE_ASYNC=1

  [ -f "$HOME/.config/miscxrdb/fzf/fzf.config" ] && source "$HOME/.config/miscxrdb/fzf/fzf.config"
  [ -f "$HOME/.fzf.zsh" ] && source ~/.fzf.zsh
fi

# GRCAT
# if [ -f "/etc/grc.zsh" ]; then
#   export GRCHPATH="/etc/grc.zsh"
#   [ -s "$GRCHPATH" ] && . "$GRCHPATH"
#   source /etc/grc.zsh
# fi
source ~/powerlevel10k/powerlevel10k.zsh-theme

last_working_dir

# To customize prompt, run `p10k configure` or edit ~/.config/zsh/.p10k.zsh.
[[ ! -f ~/.config/zsh/.p10k.zsh ]] || source ~/.config/zsh/.p10k.zsh

# For debug:
# zprof
