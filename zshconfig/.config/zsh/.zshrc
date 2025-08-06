# vim: ft=zsh sw=2 ts=2 et
# --------------------------------
#░▀▀█░█▀▀░█░█░█▀▄░█▀▀░░░░█▀▄░█▀▀ +
#░▄▀░░▀▀█░█▀█░█▀▄░█░░░░░░█▀▄░█░░ +
#░▀▀▀░▀▀▀░▀░▀░▀░▀░▀▀▀░▀░░▀░▀░▀▀▀ +
# --------------------------------

# ╒══════════════════════════════════════════════════════════╕
#   References
# ╘══════════════════════════════════════════════════════════╛
# Color table - https://jonasjacek.github.io/colors/
# Akinsho - https://github.com/akinsho/dotfiles/blob/main/.config/zsh/.zshrc
# Wincent's dotfiles - https://github.com/wincent/wincent/blob/d6c52ed552/aspects/dotfiles/files/.zshrc

# For debug:
# zmodload zsh/zprof

[[ $- != *i* ]] && return

# Disable XON/XOFF flow control because it collides with C-s
[[ $- == *i* ]] && stty -ixon

zmodload zsh/datetime


# Create a hash table for globally stashing variables without polluting main
# scope with a bunch of identifiers.
typeset -A __DOTS

__DOTS[ITALIC_ON]=$'\e[3m'
__DOTS[ITALIC_OFF]=$'\e[23m'

_comp_options+=(globdots) # Include hidden files.

# ZSH only and most performant way to check existence of an executable
# https://www.topbug.net/blog/2016/10/11/speed-test-check-the-existence-of-a-command-in-bash-and-zsh/
exists() { (( $+commands[$1] )); }

# Enable Powerlevel10k instant prompt. Should stay close to the top of $HOME/.config/zsh/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
# if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
#   source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
# fi

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
setopt AUTO_CD
setopt COMPLETE_ALIASES
setopt AUTOPARAMSLASH         #  tab completing directory appends a slash
setopt AUTO_PUSHD             #  Push the current directory visited on the stack.
setopt CORRECT                #  command auto-correction
setopt EXTENDED_HISTORY       #  Write the history file in the ':start:elapsed;command' format.
setopt HIST_BEEP
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS
setopt HIST_VERIFY
setopt PROMPT_CR
setopt PROMPT_SP
setopt RM_STAR_WAIT           #  notify me, ketika use "rm -rf .."
setopt INC_APPEND_HISTORY     #  Write to the history file immediately, not when the shell exits
setopt PUSHD_IGNORE_DUPS      #  Do not store duplicates in the stack.
setopt PUSHD_SILENT           #  Do not print the directory stack after pushd or popd.
setopt SHARE_HISTORY          #  Share your history across all your terminal windows
unsetopt HIST_SAVE_NO_DUPS    #  Write a duplicate event to the history file

fpath=($ZDOTDIR/funcs $fpath)
fpath=(${ASDF_DIR}/completions $fpath)

export PATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH"
fpath=(${ASDF_DATA_DIR:-$HOME/.asdf}/completions $fpath)

# NOTE: autoloaded functions wrap the contents of these files in a function
# block with the same name as the file. This means that the function is NOT
# called when autoloaded. When the function is called it will be defined and
# contents of the file executed. This means that if the contents are wrapped
# in function blocks they will not be executed till the second time the function
# is called.
# see: https://unix.stackexchange.com/a/33898
#
# Load all autoload functions alternatively this could
# be done as fpath[1]/*(.:t) i.e autload the functions
# in the first item in the fpath.
autoload -Uz $ZDOTDIR/funcs/*(.:t)
autoload -U colors && colors # Enable colors in prompt

# ── DEFINE COLOR ──────────────────────────────────────────────────────
colorline="#383838"
colorsuggest="fg=#404040"

# ┏╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┓
# ╏ COMPLETION                                               ╏
# ┗╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┛
# Check this link to find out how to make completion in zsh
# https://thevaluable.dev/zsh-completion-guide-examples/
autoload -Uz compinit
compinit
_comp_options+=(globdots) # Include hidden files, when do 'cd ..<tab>'

# ─< config completion >────────────────────────────────────────────────
# persistent reshahing i.e puts new executables in the $path
# if no command is set typing in a line will cd by default
zstyle ':completion:*' menu select
zmodload zsh/complist

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

# Completion for kitty
if [[ "$TERM" == "xterm-kitty" ]]; then
  kitty + complete setup zsh | source /dev/stdin
fi

# ┏╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┓
# ╏ SOURCE PLUGINS                                           ╏
# ┗╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┛
[[ -f $ZSH_PLUGINS/zsh-autosuggestions/zsh-autosuggestions.zsh ]] \
  && source $ZSH_PLUGINS/zsh-autosuggestions/zsh-autosuggestions.zsh \

[[ -f $ZSH_PLUGINS/autoenv/autoenv.plugin.zsh ]] &&
  source $ZSH_PLUGINS/autoenv/autoenv.plugin.zsh

# ── FZF-TAB ───────────────────────────────────────────────────────────
if [[ -f $ZSH_PLUGINS/fzf-tab/fzf-tab.zsh ]]; then
  source $ZSH_PLUGINS/fzf-tab/fzf-tab.zsh

  # Guide for adding size popup window (outside tmux):
  # https://github.com/Aloxaf/fzf-tab/issues/429#issuecomment-2189228770
  if [[ -n "$TMUX" ]]; then
    zstyle ':fzf-tab:*' fzf-flags --preview-window "right:nohidden:50%" --no-border
  else
    zstyle ':fzf-tab:*' fzf-flags --preview-window "right:nohidden:50%" --border
  fi

  # Guide for adding size popup window (only works inside tmux):
  # https://github.com/Aloxaf/fzf-tab/wiki/Configuration#ftb-tmux-popup
  zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup
  zstyle ':fzf-tab:*' popup-min-size 80 20  # atur tinggi dan lebar
  zstyle ':fzf-tab:*' popup-pad 0 0         # atur padding vertical dan horizontal
  zstyle ':fzf-tab:*' popup-fit-preview yes
  zstyle ':fzf-tab:*' use-fzf-default-opts yes

  zstyle ':fzf-tab:complete:*' fzf-preview 'bat $realpath'

  # ─< KEYBINDING >───────────────────────────────────────────────────────
  # Guide for adding continuous-trigger
  # https://github.com/Aloxaf/fzf-tab/wiki/Configuration#continuous-trigger
  zstyle ':fzf-tab:*' continuous-trigger 'ctrl-y' # default "/"

  # ─< PREVIEW CD >───────────────────────────────────────────────────────
  # preview directory's content with eza when completing cd
  if command -v eza >/dev/null; then
    fzf_dir_preview='eza -a --tree --level=2 --icons --color=always $realpath'
    zstyle ':fzf-tab:complete:eza:*' fzf-preview "$fzf_dir_preview"
  else
    fzf_dir_preview='ls -1 --color=always $realpath'
  fi
  zstyle ':fzf-tab:complete:cd:*' fzf-preview "$fzf_dir_preview"
  zstyle ':fzf-tab:complete:ls:*' fzf-preview "$fzf_dir_preview"

  # Guide for disable `fzf-tab` when completing cd
  # https://github.com/Aloxaf/fzf-tab/pull/293
  # zstyle ':fzf-tab:complete:cd:*' disabled-on any

  # ─< SHOW SYSTEMD UNIT STATUS >─────────────────────────────────────────
  zstyle ':fzf-tab:complete:systemctl-*:*' fzf-preview 'SYSTEMD_COLORS=1 systemctl status $word'

  # ─< SHOW ALIAS CMDS >──────────────────────────────────────────────────
  # zstyle ':fzf-tab:complete:doc_*:*' disabled-on any
  # zstyle ':completion:*:doc_im_ls:*' command "show_alias"
  # zstyle ':fzf-tab:complete:doc_im_ls:*' fzf-preview 'echo "mantap"'
  # zstyle ':completion:*:*:*:doc_comp_ls:*' fzf-preview "show_alias"
  # zstyle ':fzf-tab:complete:doc_im_ls:argument-rest' command 'show_alias'

  # ─< PREVIEW FOR KILL/PS >──────────────────────────────────────────────
  # zstyle ':completion:*:*:*:*:processes' command "ps -u $USER -o pid,user,comm -w -w"
  # zstyle ':fzf-tab:complete:(kill|ps):argument-rest' fzf-preview \
  #   '[[ $group == "[process ID]" ]] && ps --pid=$word -o cmd --no-headers -w -w'
  # zstyle ':fzf-tab:complete:(kill|ps):argument-rest' fzf-flags --preview-window=down:3:wrap
  # zstyle ':completion:*:*:*:*:processes' command 'ps -ef --no-headers -w -w'
  zstyle ':completion:*:*:*:*:processes' command "ps -u $USER -o pid,user,comm -w -w"
  zstyle ':fzf-tab:complete:(kill|ps):argument-rest' fzf-preview \
    '[[ $group == "[process ID]" ]] && ps --pid=$word -o cmd --no-headers -w -w'
  zstyle ':fzf-tab:complete:(kill|ps):argument-rest' fzf-flags --preview-window=down:3:wrap
  # zstyle ':fzf-tab:complete:kill:argument-rest' extra-opts \
  #   --preview=$extract';ps --pid=$in[(w)2] uww' --preview-window='up:15%:wr

  # ─< PREVIEW FOR IMAGE WITH ICAT & SXIV >───────────────────────────────
  # I disable `ftb-tmux-popup` for spesific command `icat`, `sxiv` and use `fzf` instead.
  zstyle ':fzf-tab:complete:icat:*' fzf-command fzf
  zstyle ':fzf-tab:complete:sxiv:*' fzf-command fzf
  icat() {
      kitten icat $@
  }
  zstyle ':fzf-tab:complete:icat:*' fzf-preview 'kitten icat --clear --transfer-mode=memory --stdin=no --place=50x50@0x0 $realpath'
  zstyle ':fzf-tab:complete:sxiv:*' fzf-preview 'kitten icat --clear --transfer-mode=memory --stdin=no --place=50x50@0x0 $realpath'

  # ─< PREVIEW FOR PDF >──────────────────────────────────────────────────
  zstyle ':fzf-tab:complete:zathura:*' fzf-preview 'pdftotext $realpath - | head -n 20'
  zstyle ':fzf-tab:complete:tdf:*' fzf-preview 'pdftotext $realpath - | head -n 20'
  zstyle ':fzf-tab:complete:fancy-cat:*' fzf-preview 'pdftotext $realpath - | head -n 20'

  # ─< PREVIEW FOR GIT >──────────────────────────────────────────────────
  zstyle ':fzf-tab:complete:git:*' fzf-flags --preview-window "right:50%:hidden:cycle"
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
# ╏ VI-MODE                                                  ╏
# ┗╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┛
# @see: https://thevaluable.dev/zsh-install-configure-mouseless/
bindkey -v # enables vi mode, using -e = emacs
# export KEYTIMEOUT=1 # uncomment option ini karena kita memakai `hh` untuk 'enter' ke vim mode

# https://superuser.com/questions/151803/how-do-i-customize-zshs-vim-mode
# http://pawelgoscicki.com/archives/2012/09/vi-mode-indicator-in-zsh-prompt/
vim_insert_mode=""
vim_normal_mode="%F{${colorline}}╰─%f %F{green} %f "
vim_mode=$vim_insert_mode

function zle-line-finish {
  vim_mode=$vim_insert_mode
}
zle -N zle-line-finish

# When you C-c in CMD mode and you'd be prompted with CMD mode indicator,
# while in fact you would be in INS mode Fixed by catching SIGINT (C-c),
# set vim_mode to INS and then repropagate the SIGINT,
# so if anything else depends on it, we will not break it
function TRAPINT() {
  vim_mode=$vim_insert_mode
  return $(( 128 + $1 ))
}

cursor_mode() {
  # See https://ttssh2.osdn.jp/manual/4/en/usage/tips/vim.html for cursor shapes
  cursor_block='\e[2 q'
  cursor_beam='\e[2 q' # <-- I set this block cursor because dont want to use beam "|"
  # cursor_beam='\e[6 q'

  function zle-keymap-select {
    vim_mode="${${KEYMAP/vicmd/${vim_normal_mode}}/(main|viins)/${vim_insert_mode}}"
    zle && zle reset-prompt

    if [[ ${KEYMAP} == vicmd ]] ||
        [[ $1 = 'block' ]]; then
        echo -ne $cursor_block
    elif [[ ${KEYMAP} == main ]] ||
        [[ ${KEYMAP} == viins ]] ||
        [[ ${KEYMAP} = '' ]] ||
        [[ $1 = 'beam' ]]; then
        echo -ne $cursor_beam
    fi
  }

  zle-line-init() {
    echo -ne $cursor_beam
  }

  zle -N zle-keymap-select
  zle -N zle-line-init
}

cursor_mode

# ┏╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┓
# ╏ VERSION CONTROL (VCS)                                    ╏
# ┗╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┛
# vcs_info is a zsh native module for getting git info into your
# prompt. It's not as fast as using git directly in some cases
# but easy and well documented.
# Resources:
# 1. http://zsh.sourceforge.net/Doc/Release/User-Contributions.html
# 2. https://github.com/zsh-users/zsh/blob/master/Misc/vcs_info-examples
# 3. using vcs_infow with check-for-changes can be expensive if used in large repos
#    see the link below if looking for how to avoid running these check for changes on large repos
#    https://github.com/zsh-users/zsh/blob/545c42cdac25b73134a9577e3c0efa36d76b4091/Misc/vcs_info-examples#L72
# %c - git staged
# %u - git untracked
# %b - git branch
# %r - git repo
autoload -Uz vcs_info

# Using named colors means that the prompt automatically adapts to how these
# are set by the current terminal theme
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' stagedstr "%F{green} ●%f"
zstyle ':vcs_info:*' unstagedstr "%F{red} ●%f" # alternative: ✘
zstyle ':vcs_info:*' use-simple true
zstyle ':vcs_info:git+set-message:*' hooks git-untracked git-stash git-compare git-remotebranch
zstyle ':vcs_info:git*:*' actionformats '(%B%F{red}%b|%a%c%u%%b%f) '
zstyle ':vcs_info:git:*' formats "%F{249}(%f%F{blue}%{$__DOTS[ITALIC_ON]%}%b%{$__DOTS[ITALIC_OFF]%}%f%F{249})%f%c%u%m"

__in_git() {
    [[ $(git rev-parse --is-inside-work-tree 2> /dev/null) == "true" ]]
}

# on the output of the git command adds an indicator to the the vcs info
# use --directory and --no-empty-directory to speed up command
# https://stackoverflow.com/questions/11122410/fastest-way-to-get-git-status-in-bash
function +vi-git-untracked() {
  emulate -L zsh
  if __in_git; then
    if [[ -n $(git ls-files --directory --no-empty-directory --exclude-standard --others 2> /dev/null) ]]; then
      hook_com[unstaged]+="%F{blue}  %f" # alternatives ●
    fi
  fi
}

function +vi-git-stash() {
  local stash_icon=""
  emulate -L zsh
  if __in_git; then
    if [[ -n $(git rev-list --walk-reflogs --count refs/stash 2> /dev/null) ]]; then
      hook_com[unstaged]+=" %F{yellow}$stash_icon%f "
    fi
  fi
}
# git: Show +N/-N when your local branch is ahead-of or behind remote HEAD.
# Make sure you have added misc to your 'formats':  %m
# source: https://github.com/zsh-users/zsh/blob/545c42cdac25b73134a9577e3c0efa36d76b4091/Misc/vcs_info-examples#L180
function +vi-git-compare() {
  local ahead behind
  local -a gitstatus

  # Exit early in case the worktree is on a detached HEAD
  git rev-parse ${hook_com[branch]}@{upstream} >/dev/null 2>&1 || return 0

  local -a ahead_and_behind=(
      $(git rev-list --left-right --count HEAD...${hook_com[branch]}@{upstream} 2>/dev/null)
  )

  ahead=${ahead_and_behind[1]}
  behind=${ahead_and_behind[2]}

  local ahead_symbol="%{$fg[red]%}⇡%{$reset_color%}${ahead}"
  local behind_symbol="%{$fg[cyan]%}⇣%{$reset_color%}${behind}"
  (( $ahead )) && gitstatus+=( "${ahead_symbol}" )
  (( $behind )) && gitstatus+=( "${behind_symbol}" )
  # `(j:<char>:)` represents joining the items of a list with a character
  # similar to a string.join type operation this can also be written as
  # (j./.) the character representing each part is interchangeable, and the
  # middle character represents the string to use to join the items
  # https://zsh.sourceforge.io/Guide/zshguide05.html#l124
  hook_com[misc]+="${(j: :)gitstatus} "
}

## git: Show remote branch name for remote-tracking branches
function +vi-git-remotebranch() {
    local remote

    # Are we on a remote-tracking branch?
    remote=${$(git rev-parse --verify ${hook_com[branch]}@{upstream} \
        --symbolic-full-name 2>/dev/null)/refs\/remotes\/}

    # The first test will show a tracking branch whenever there is one. The
    # second test, however, will only show the remote branch's name if it
    # differs from the local one.
    # if [[ -n ${remote} ]] ; then
    if [[ -n ${remote} && ${remote#*/} != ${hook_com[branch]} ]] ; then
        hook_com[branch]="${hook_com[branch]}→[${remote}]"
    fi
}

# ┏╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┓
# ╏ PROMPT                                                   ╏
# ┗╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┛
setopt PROMPT_SUBST
# %F...%f - - foreground color
# toggle color based on success %F{%(?.green.red)}
# %F{a_color} - color specifier
# %B..%b - bold
# %* - reset highlight
# %j - background jobs
#
# directory(branch) ● ●
# ❯  █                                  10:51
#
# icon options =  ❯    ➜
# icon box_lines = ╭─ ├─ ╰─ ─╮ ─┤ ─╯
#
function __prompt_eval() {
  if [[ -n "$VIRTUAL_ENV" ]]; then
    virtualenv_prompt="%F{green}($(basename "$VIRTUAL_ENV"))%f"
  else
    virtualenv_prompt=""
  fi

  local dots_prompt_icon="%F{${colorline}}╰─%f %F{${colorline}} %f "
  local dots_prompt_failure_icon="%F{${colorline}}╰─%f %F{red}✘ %f "
  local placeholder="(%F{gray}%{$__DOTS[ITALIC_ON]%}…%{$__DOTS[ITALIC_OFF]%}%f) "
  local top="%F{${colorline}}┌───[ %B%F{magenta}%1~%f%b${_git_status_prompt:-$placeholder}%F{${colorline}}]%f %(1j.%F{cyan}job:%j✦%f .) %F{cyan}${virtualenv_prompt}"
  local character="%(?.${dots_prompt_icon}.${dots_prompt_failure_icon})"
  local bottom=$([[ -n "$vim_mode" ]] && echo "$vim_mode" || echo "$character")
  echo $top$'\n'$bottom
}
# NOTE: VERY IMPORTANT: the type of quotes used matters greatly. Single quotes MUST be used for these variables
export PROMPT='$(__prompt_eval)'
# Right prompt
# export RPROMPT='%F{yellow}%{$__DOTS[ITALIC_ON]%}${cmd_exec_time}%{$__DOTS[ITALIC_OFF]%}%f %F{240}%*%f'
# Correction prompt
export SPROMPT="correct %F{red}'%R'%f to %F{red}'%r'%f [%B%Uy%u%bes, %B%Un%u%bo, %B%Ue%u%bdit, %B%Ua%u%bbort]? "

# ┏╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┓
# ╏ EXECUTION TIME                                           ╏
# ┗╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┛
# Inspired by https://github.com/sindresorhus/pure/blob/81dd496eb380aa051494f93fd99322ec796ec4c2/pure.zsh#L47
#
# Turns seconds into human readable time.
# 165392 => 1d 21h 56m 32s
# https://github.com/sindresorhus/pretty-time-zsh
__human_time_to_var() {
  local human total_seconds=$1 var=$2
  local days=$(( total_seconds / 60 / 60 / 24 ))
  local hours=$(( total_seconds / 60 / 60 % 24 ))
  local minutes=$(( total_seconds / 60 % 60 ))
  local seconds=$(( total_seconds % 60 ))
  (( days > 0 )) && human+="${days}d "
  (( hours > 0 )) && human+="${hours}h "
  (( minutes > 0 )) && human+="${minutes}m "
  human+="${seconds}s"

  # Store human readable time in a variable as specified by the caller
  typeset -g "${var}"="${human}"
}

# Stores (into cmd_exec_time) the execution
# time of the last command if set threshold was exceeded.
__check_cmd_exec_time() {
  integer elapsed
  (( elapsed = EPOCHSECONDS - ${cmd_timestamp:-$EPOCHSECONDS} ))
  typeset -g cmd_exec_time=
  (( elapsed > 1 )) && {
    __human_time_to_var $elapsed "cmd_exec_time"
  }
}

__timings_preexec() {
  emulate -L zsh
  typeset -g cmd_timestamp=$EPOCHSECONDS
}

__timings_precmd() {
  __check_cmd_exec_time
  unset cmd_timestamp
}

# ┏╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┓
# ╏ HOOKS                                                    ╏
# ┗╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┛
autoload -Uz add-zsh-hook
# Async prompt in Zsh
# Rather than using zpty (a pseudo terminal) under the hood
# as is the case with zsh-async this method forks a process sends
# it the command to evaluate which is written to a file descriptor
#
# terminology:
# exec - replaces the current shell. This means no subshell is
# created and the current process is replaced with this new command.
# fd/FD - file descriptor
# &- closes a FD e.g. "exec 3<&-" closes FD 3
# file descriptor 0 is stdin (the standard input),
# 1 is stdout (the standard output),
# 2 is stderr (the standard error).
#
# https://www.zsh.org/mla/users/2018/msg00424.html
# https://github.com/sorin-ionescu/prezto/pull/1805/files#diff-6a24e7644c4c0969110e86872283ec82L79
# https://github.com/zsh-users/zsh-autosuggestions/pull/338/files
__async_vcs_start() {
  # Close the last file descriptor to invalidate old requests
  if [[ -n "$__prompt_async_fd" ]] && { true <&$__prompt_async_fd } 2>/dev/null; then
    exec {__prompt_async_fd}<&-
    zle -F $__prompt_async_fd
  fi
  # fork a process to fetch the vcs status and open a pipe to read from it
  exec {__prompt_async_fd}< <(
    __async_vcs_info $PWD
  )

  # When the fd is readable, call the response handler
  zle -F "$__prompt_async_fd" __async_vcs_info_done
}

__async_vcs_info() {
  cd -q "$1"
  vcs_info
  print ${vcs_info_msg_0_}
}

# Called when new data is ready to be read from the pipe
__async_vcs_info_done() {
  # Read everything from the fd
  _git_status_prompt="$(<&$1)"
  # check if vcs info is returned, if not set the prompt
  # to a non visible character to clear the placeholder
  # NOTE: -z returns true if a string value has a length of 0
  if [[ -z $_git_status_prompt ]]; then
    _git_status_prompt=" "
  fi
  # remove the handler and close the file descriptor
  zle -F "$1"
  exec {1}<&-
  zle && zle reset-prompt
}

# When the terminal is resized, the shell receives a SIGWINCH signal.
# So redraw the prompt in a trap.
# https://unix.stackexchange.com/questions/360600/reload-zsh-when-resizing-terminator-window
#
# Resource: [TRAP functions]
# http://zsh.sourceforge.net/Doc/Release/Functions.html#Trap-Functions
function TRAPWINCH () {
  zle && zle reset-prompt
}

add-zsh-hook precmd () {
  __timings_precmd
  __async_vcs_start # start async job to populate git info
}

autoload -Uz chpwd_recent_dirs cdr
add-zsh-hook chpwd

add-zsh-hook chpwd () {
  _git_status_prompt="" # clear current vcs_info
  # chpwd_last_working_dir
  # chpwd_recent_dirs
}

add-zsh-hook preexec () {
  __timings_preexec
}

# ┏╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┓
# ╏ LOCAL SCRIPTS                                            ╏
# ┗╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┛

# Load and source all zsh, sh files
for script in $ZDOTDIR/scripts/*; do
  source $script
done

source "$HOME/.config/bashrc/aliases.bashrc" # alias for all [bash/zsh]

# ┏╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┓
# ╏ KEYBINDINGS                                              ╏
# ┗╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┛
# https://unix.stackexchange.com/questions/285208/how-to-remove-a-zsh-keybinding-if-i-dont-know-what-it-does
# To check these commands run: `zle -al`
bindkey '^y' autosuggest-accept # enter autosugest (c-y)
bindkey '^?' backward-delete-char
bindkey '^b' backward-word # backward (c-b)
bindkey '^f' forward-word  # forward char (c-f)
bindkey '^a' beginning-of-line
bindkey '^e' end-of-line
bindkey '^l' forward-char
bindkey '^h' backward-char

# To disable bindkey: use "bindkey -r <name_key>"
bindkey -r "^s"

# Shortcut bind to edit line text
autoload -U edit-command-line
zle -N edit-command-line

# bindkey -M viins '^[q' edit-command-line # alt-q
bindkey -M viins '^q' edit-command-line   # c-q
bindkey -M viins 'hh' vi-cmd-mode         # 'jk' for Escape

bindkey '^R' history-incremental-search-backward
bindkey '^P' up-history
bindkey '^N' down-history

# Enable keyboard navigation of completions in menu
# (not just tab/shift-tab but cursor keys as well):
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history

# shift-tab to reverse completion
bindkey '^[[Z' reverse-menu-complete
bindkey -M menuselect '^[[Z' reverse-menu-complete

# AUTO SSH-ADD (for git master)
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

# ╒══════════════════════════════════════════════════════════╕
#   PLUGINS
# └──────────────────────────────────────────────────────────┘
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE=$colorsuggest
ZSH_AUTOSUGGEST_USE_ASYNC=1
bindkey '^y' autosuggest-accept

# last_working_dir

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
[[ -f "$HOME/.config/miscxrdb/fzf/fzf.config" ]] && source "$HOME/.config/miscxrdb/fzf/fzf.config"

# ASDF for golang
if [ -d $(asdf where golang) ]; then
  export GOPATH=$(asdf where golang)/packages
  export GOROOT=$(asdf where golang)/go
  export PATH="${PATH}:$(go env GOPATH)/bin"
  export PATH="${PATH}:$(go env GOBIN)"
fi

if exists zoxide; then
  eval "$(zoxide init zsh)"
fi

[ -f ~/.local/bin/uv ] && eval "$(uv generate-shell-completion zsh)"

# To customize prompt, run `p10k configure`
# Or edit $HOME/.config/zsh/.p10k.zsh.
# source $HOME/powerlevel10k/powerlevel10k.zsh-theme

# NOTE: syntax highlighting must load after all the zsh widgets are setup
[[ -f $ZSH_PLUGINS/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]] &&
  source $ZSH_PLUGINS/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# unset ZSHENV_LOADED

# For debug:
# zprof

# To customize prompt, run `p10k configure` or edit ~/.config/zsh/.p10k.zsh.
# [[ ! -f ~/.config/zsh/.p10k.zsh ]] || source ~/.config/zsh/.p10k.zsh
