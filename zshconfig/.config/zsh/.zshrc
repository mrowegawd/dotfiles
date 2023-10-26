# vim: ft=zsh sw=2 ts=2 et
# --------------------------------
#░▀▀█░█▀▀░█░█░█▀▄░█▀▀░░░░█▀▄░█▀▀ +
#░▄▀░░▀▀█░█▀█░█▀▄░█░░░░░░█▀▄░█░░ +
#░▀▀▀░▀▀▀░▀░▀░▀░▀░▀▀▀░▀░░▀░▀░▀▀▀ +
# --------------------------------

[[ $- == *i* ]] && stty -ixon

#-------------------------------------------------------------------------------
# References:
#-------------------------------------------------------------------------------
# Color table - https://jonasjacek.github.io/colors/
# Wincent's dotfiles - https://github.com/wincent/wincent/blob/d6c52ed552/aspects/dotfiles/files/.zshrc
# https://github.com/vincentbernat/zshrc/blob/d66fd6b6ea5b3c899efb7f36141e3c8eb7ce348b/rc/vcs.zsh
# sourcing autoloaded functions:
# https://unix.stackexchange.com/questions/33255/how-to-define-and-load-your-own-shell-function-in-zsh
# Git prompt script: https://github.com/git/git/blob/master/contrib/completion/git-prompt.sh

zmodload zsh/datetime

# Create a hash table for globally stashing variables without polluting main
# scope with a bunch of identifiers.
typeset -A __DOTS

__DOTS[ITALIC_ON]=$'\e[3m'
__DOTS[ITALIC_OFF]=$'\e[23m'

# ZSH only and most performant way to check existence of an executable
# https://www.topbug.net/blog/2016/10/11/speed-test-check-the-existence-of-a-command-in-bash-and-zsh/
exists() { (( $+commands[$1] )); }

# Create a hash table for globally stashing variables without polluting main
# scope with a bunch of identifiers.
typeset -A __DOTS

__DOTS[ITALIC_ON]=$'\e[3m'
__DOTS[ITALIC_OFF]=$'\e[23m'

# ZSH only and most performant way to check existence of an executable
# https://www.topbug.net/blog/2016/10/11/speed-test-check-the-existence-of-a-command-in-bash-and-zsh/
exists() { (( $+commands[$1] )); }


fpath=($ZDOTDIR/funcs $fpath)
autoload -Uz $ZDOTDIR/funcs/*(.:t)

zsh_add_plugin    "zsh-users/zsh-autosuggestions"
zsh_add_plugin    "zsh-users/zsh-completions"
zsh_add_plugin    "zsh-users/zsh-syntax-highlighting"
# zsh_add_plugin    "djui/alias-tips"
# zsh_add_plugin    "MichaelAquilina/zsh-auto-notify" "auto-notify.plugin"
# zsh_add_plugin    "hlissner/zsh-autopair"

#  ┏╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┓
#  ╏ SOURCE PLUGIN                                            ╏
#  ┗╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┛
source "$HOME/.config/bashrc/aliases.bashrc"         # alias for all [bash/zsh]
source "$ZDOTDIR/11-prompt.zsh"

# CHECK: Source dari plugin seperti `asdf` or `git` or harus diload sebelum line
# -> 'autoload -Uz compinit; compinit'
# Jadi jika kamu ingin mendapatkan completion dari plugins (contoh `asdf`),
# taruh dibagian ini:
#  ┌
#  │ ASDF
#  └
source "$HOME/.asdf/asdf.sh"
fpath=(${ASDF_DIR}/completions $fpath)

#  ┏╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┓
#  ╏ COMPLETION                                               ╏
#  ┗╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┛
autoload -Uz compinit ;compinit
_comp_options+=(globdots) # Include hidden files, when do 'cd ..<tab>'

setopt ALWAYS_TO_END
setopt AUTO_MENU
setopt LIST_PACKED

# Completion for kitty
if [[ "$TERM" == "xterm-kitty" ]]; then
  kitty + complete setup zsh | source /dev/stdin
fi

# Colorize completions using default `ls` colors.
zstyle ':completion:*' list-colors ''

# Enable keyboard navigation of completions in menu
# (not just tab/shift-tab but cursor keys as well):
zstyle ':completion:*' menu select
zmodload zsh/complist

# use the vi navigation keys in menu completion
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history

# shift-tab to reverse completion
bindkey '^[[Z' reverse-menu-complete
bindkey -M menuselect '^[[Z' reverse-menu-complete

# persistent reshahing i.e puts new executables in the $path
# if no command is set typing in a line will cd by default
zstyle ':completion:*' rehash true

# Allow completion of ..<Tab> to ../ and beyond.
zstyle -e ':completion:*' special-dirs '[[ $PREFIX = (../)#(..) ]] && reply=(..)'

# Categorize completion suggestions with headings:
zstyle ':completion:*' group-name ''
# Style the group names
zstyle ':completion:*' format %F{yellow}%B%U%{$__DOTS[ITALIC_ON]%}%d%{$__DOTS[ITALIC_OFF]%}%b%u%f

# Added by running `compinstall`
zstyle ':completion:*' expand suffix
zstyle ':completion:*' file-sort modification
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' list-suffixes true
# End of lines added by compinstall

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

zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$ZSH_CACHE_DIR/zcompcache"

#  ┌
#  │ CDR
#  └
# https://github.com/zsh-users/zsh/blob/master/Functions/Chpwd/cdr

zstyle ':completion:*:*:cdr:*:*' menu selection
# $WINDOWID is an environment variable set by kitty representing the window ID
# of the OS window (NOTE this is not the same as the $KITTY_WINDOW_ID)
# @see: https://github.com/kovidgoyal/kitty/pull/2877
zstyle ':chpwd:*' recent-dirs-file $ZSH_CACHE_DIR/.chpwd-recent-dirs-${WINDOWID##*/} +
zstyle ':completion:*' recent-dirs-insert always
zstyle ':chpwd:*' recent-dirs-default yes

#  ┏╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┓
#  ╏ OPTIONS                                                  ╏
#  ┗╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┛
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
setopt HIST_SAVE_NO_DUPS
setopt HIST_VERIFY
setopt INC_APPEND_HISTORY        # Write to the history file immediately, not when the shell exits
setopt PROMPT_CR
setopt PROMPT_SP
setopt PUSHD_IGNORE_DUPS         # Do not store duplicates in the stack.
setopt PUSHD_SILENT              # Do not print the directory stack after pushd or popd.
setopt RM_STAR_WAIT
setopt SHARE_HISTORY             # Share your history across all your terminal windows

# Keep a ton of history.
HISTSIZE=100000
SAVEHIST=100000
HISTFILE=$ZSH_CACHE_DIR/.zsh_history

#  ┏╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┓
#  ╏ LESS                                                     ╏
#  ┗╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┛
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

#  ┏╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┓
#  ╏ KEYBINDINGS                                              ╏
#  ┗╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┛
bindkey '^y'        autosuggest-accept
bindkey "^[[89;5u"  autosuggest-accept
bindkey '^?'        backward-delete-char
bindkey '^h'        backward-char            # backward (c-b)
bindkey '^l'        forward-char             # forward char (c-f)
bindkey '^b'        backward-word            # backward (c-b)
bindkey '^f'        forward-word             # forward char (c-f)
# bindkey '^w'      backward-kill-word
# bindkey '^u'      backward-kill-line
bindkey '^a'        beginning-of-line
bindkey '^e'        end-of-line

# Shortcut bind to edit line text
autoload -U edit-command-line
zle -N edit-command-line
bindkey -M viins '^[e' edit-command-line    # alt-e
bindkey -M viins 'jk' vi-cmd-mode         # 'jk' to <esc>
# bindkey -M vicmd v edit-command-line

bindkey ‘^R’ history-incremental-search-backward
bindkey '^P' up-history
bindkey '^N' down-history

#  ╒══════════════════════════════════════════════════════════╕
#  │ SOURCE MISC (PLUGINS, ASDF, ETC)                         │
#  ╘══════════════════════════════════════════════════════════╛

#  +----------------------------------------------------------+
#  | LOCAL SCRIPTS                                            |
#  +----------------------------------------------------------+
# source all zsh and sh files
for script in $ZDOTDIR/scripts/*; do
  source $script
done

#  +----------------------------------------------------------+
#  | FZF                                                      |
#  +----------------------------------------------------------+
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=241'
ZSH_AUTOSUGGEST_USE_ASYNC=1

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
[ -f ~/.config/miscxrdb/fzf/fzf.config ] && source ~/.config/miscxrdb/fzf/fzf.config

last_working_dir

#  +----------------------------------------------------------+
#  | PLUGINS                                                  |
#  +----------------------------------------------------------+
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
# set -g VIRTUAL_ENV_DISABLE_PROMPT 1

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
