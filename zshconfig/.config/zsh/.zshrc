# vim: ft=zsh sw=2 ts=2 et
# --------------------------------
#░▀▀█░█▀▀░█░█░█▀▄░█▀▀░░░░█▀▄░█▀▀ +
#░▄▀░░▀▀█░█▀█░█▀▄░█░░░░░░█▀▄░█░░ +
#░▀▀▀░▀▀▀░▀░▀░▀░▀░▀▀▀░▀░░▀░▀░▀▀▀ +
# --------------------------------

# For debug:
# zmodload zsh/zprof

[[ $- != *i* ]] && return

# Enable Powerlevel10k instant prompt. Should stay close to the top of $HOME/.config/zsh/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

source "$HOME/.config/bashrc/aliases.bashrc"         # alias for all [bash/zsh]

# Noteme: source `asdf` sesuai dari README harus berada diatas sebelum line `compinit`
source "$HOME/.asdf/asdf.sh"

[[ -f "$HOME/.config/miscxrdb/fzf/fzf.config" ]] && source "$HOME/.config/miscxrdb/fzf/fzf.config"

[[ -f $ZSH_PLUGINS/autoenv/autoenv.plugin.zsh ]] \
  && source $ZSH_PLUGINS/autoenv/autoenv.plugin.zsh

[[ -f $ZSH_PLUGINS/fzf-tab/fzf-tab.zsh ]] \
  && source $ZSH_PLUGINS/fzf-tab/fzf-tab.zsh

[[ -f $ZSH_PLUGINS/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]] \
  && source $ZSH_PLUGINS/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

zle -N autosuggest-accept
[[ -f $ZSH_PLUGINS/zsh-autosuggestions/zsh-autosuggestions.zsh ]] \
  && source $ZSH_PLUGINS/zsh-autosuggestions/zsh-autosuggestions.zsh

# ┏╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┓
# ╏ OPTIONS                                                  ╏
# ┗╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┛

# Keep a ton of history.
HISTSIZE=100000
SAVEHIST=$HISTSIZE
HISTDUP=erase
HISTFILE=$ZSH_CACHE_DIR/.zsh_history

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

fpath=($ZDOTDIR/funcs $fpath)
fpath=(${ASDF_DIR}/completions $fpath)

# ┏╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┓
# ╏ COMPLETION                                               ╏
# ┗╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┛

# Check this link to find out how to make completion in zsh
# https://thevaluable.dev/zsh-completion-guide-examples/
zmodload zsh/complist
autoload -Uz $ZDOTDIR/funcs/*(.:t)
autoload -U compinit ; compinit
_comp_options+=(globdots) # Include hidden files, when do 'cd ..<tab>'

# ─< config completion >────────────────────────────────────────────────
# persistent reshahing i.e puts new executables in the $path
# if no command is set typing in a line will cd by default
zstyle ':completion:*' menu select
zstyle ':completion:*' rehash true
zstyle ':completion:*:options' description no
zstyle ':completion:*:options' auto-description '%d'
zstyle ':completion:*:corrections' format ' %F{green}-- %d (errors: %e) --%f'
# zstyle ':completion:*:descriptions' format ' %F{yellow}-- %d --%f'
zstyle ':completion:*:messages' format ' %F{purple} -- %d --%f'
zstyle ':completion:*:warnings' format ' %F{red}-- no matches found --%f'
zstyle ':completion:*:default' list-prompt '%S%M matches%s'
# zstyle ':completion:*' format ' %F{yellow}-- %d --%f'
zstyle ':completion:*' group-name ''
zstyle ':completion:*:matches' group yes
zstyle ':completion:*' verbose yes
zstyle ':completion:*' expand suffix
zstyle ':completion:*' file-sort modification
zstyle ':completion:*' list-suffixes true
zstyle ':completion:*' completer _extensions _complete _approximate
# Use cache for completion
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$XDG_CACHE_HOME/zsh/.zcompcache"
# Colors for files and directories
# zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
# disable sort when completing options of any command
# zstyle ':completion:complete:*:options' sort false

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

# ─< kill >─────────────────────────────────────────────────────────────
zstyle ':completion:*:*:*:*:processes' command 'ps -u $LOGNAME -o pid,user,command -w'
# zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;36=0=01'
# zstyle ':completion:*:*:kill:*' menu select
# zstyle ':completion:*:*:kill:*' force-list always
# zstyle ':completion:*:*:kill:*' insert-ids single
# zstyle ':completion:*:*:*:*:processes' command "ps -u $USER -o pid,user,comm -w -w"

# ─< completion of sudo command >───────────────────────────────────────
# zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin /usr/sbin /usr/bin /sbin /bin

# https://github.com/zsh-users/zsh/blob/master/Functions/Chpwd/cdr
# zstyle ':completion:*:*:cdr:*:*' menu selection

# $WINDOWID is an environment variable set by kitty representing the window ID
# of the OS window (NOTE this is not the same as the $KITTY_WINDOW_ID)
# @see: https://github.com/kovidgoyal/kitty/pull/2877
# zstyle ':chpwd:*' recent-dirs-file $ZSH_CACHE_DIR/.chpwd-recent-dirs-${WINDOWID##*/} +
# zstyle ':completion:*' recent-dirs-insert always
# zstyle ':chpwd:*' recent-dirs-default yes

# ── FZF-TAB ───────────────────────────────────────────────────────────

# FZF_DEFAULT_OPTS="-e \
#    --color 16,fg:10,bg:9,hl:1,hl+:1,bg+:7,fg+:-1:underline \
#    --color prompt:4,pointer:13,marker:13,spinner:3,info:3"
# zstyle ':fzf-tab:*' fzf-flags $(echo $FZF_DEFAULT_OPTS)
# zstyle ':fzf-tab:*' fzf-flags '--height='
zstyle ':fzf-tab:*' continuous-trigger '/'
zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup
# zstyle ":fzf-tab:*" fzf-flags '--height=' \
# --no-separator --border "none" \
# --preview-window 'right:50%:nohidden:cycle'

# zstyle ':fzf-tab:*' fzf-min-height 30
zstyle ':fzf-tab:*' popup-min-size 70 8
# zstyle ':fzf-tab:complete:*' fzf-preview 'bat $realpath'
# zstyle ':fzf-tab:*' popup-pad 80 80 # Not actually needed to elicit the bug, but it makes it easier to see
zstyle ':fzf-tab:complete:*' fzf-bindings \
	'ctrl-v:execute-silent({_FTB_INIT_}code "$realpath")' \
    'ctrl-e:execute-silent({_FTB_INIT_}kwrite "$realpath")'

# ─< preview cd >───────────────────────────────────────────────────────
# preview directory's content with eza when completing cd
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -a --tree --level=2 --icons --color=always $realpath'
zstyle ':fzf-tab:complete:cd:*' fzf-bindings 'ctrl-l:preview({_FTB_INIT_} eza -a --tree --level=2 --icons --color=always $realpath)'

# To disable `fzf-tab` when completing cd
# taken from: https://github.com/Aloxaf/fzf-tab/pull/293)
# use:
# zstyle ':fzf-tab:complete:cd:*' disabled-on any

# ─< show systemd unit status >─────────────────────────────────────────
zstyle ':fzf-tab:complete:systemctl-*:*' fzf-preview 'SYSTEMD_COLORS=1 systemctl status $word'

# zstyle ':fzf-tab:complete:doc_im_ls:*' disabled-on any
# zstyle ':completion:*:doc_im_ls:*' command "show_alias"
# zstyle ':fzf-tab:complete:doc_im_ls:*' fzf-preview 'echo "mantap"'

# zstyle ':completion:*:*:*:doc_im_ls:*' fzf-preview "show_alias"
# zstyle ':fzf-tab:complete:doc_im_ls:argument-rest' command 'show_alias'
# zstyle ':fzf-tab:complete:(kill|ps):argument-rest' fzf-preview \
#   [[ $group == "[process ID]" ]] && ps --pid=$word -o cmd --no-headers -w -w'

# ─< preview for kill/ps >──────────────────────────────────────────────
zstyle ':fzf-tab:complete:kill:argument-rest' extra-opts \
  --preview=$extract';ps --pid=$in[(w)2] uww' --preview-window='down:15%:wrap'
# https://github.com/Aloxaf/fzf-tab/wiki/Preview#killps-preview-of-full-commandline-arguments
# zstyle ':completion:*:*:(kill|ps):*' complete-options false
zstyle ':fzf-tab:complete:(kill|ps):*' fzf-preview $'[[ $group == "[process ID]" ]] && ps -f -p $word'  # only show items in group 'process ID'
# zstyle ':fzf-tab:complete:(kill|ps):*' fzf-flags --no-sort --height=60% --color=16,hl:green --preview-window=down:18%:wrap


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

bindkey '^y'                  autosuggest-accept                  # enter autosugest (c-y)
bindkey '^?'                  backward-delete-char
bindkey '^b'                  backward-word                       # backward (c-b)
bindkey '^f'                  forward-word                        # forward char (c-f)
bindkey '^a'                  beginning-of-line
bindkey '^e'                  end-of-line

# Shortcut bind to edit line text
autoload -U edit-command-line
zle -N edit-command-line

bindkey -M viins '^[q'        edit-command-line                   # alt-q
bindkey -M viins 'hh'         vi-cmd-mode                         # 'jk' for Escape

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

# NOTE: we use powerlevel10k, so commented
# Change cursor shape for different vi modes.
# function zle-keymap-select {
#   if [[ ${KEYMAP} == vicmd ]] ||
#      [[ $1 = 'block' ]]; then
#     echo -ne '\e[1 q'
#   elif [[ ${KEYMAP} == main ]] ||
#        [[ ${KEYMAP} == viins ]] ||
#        [[ ${KEYMAP} = '' ]] ||
#        [[ $1 = 'beam' ]]; then
#     echo -ne '\e[5 q'
#   fi
# }
# zle -N zle-keymap-select

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

last_working_dir

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

# ASDF for go
if [ -d $(asdf where golang) ]; then
  export GOPATH=$(asdf where golang)/packages
  export GOROOT=$(asdf where golang)/go
  export PATH="${PATH}:$(go env GOPATH)/bin"
fi

eval "$(zoxide init zsh)"
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# To customize prompt, run `p10k configure`
# Or edit $HOME/.config/zsh/.p10k.zsh.
source $HOME/powerlevel10k/powerlevel10k.zsh-theme

# unset ZSHENV_LOADED

# For debug:
# zprof

# To customize prompt, run `p10k configure` or edit ~/.config/zsh/.p10k.zsh.
[[ ! -f ~/.config/zsh/.p10k.zsh ]] || source ~/.config/zsh/.p10k.zsh
