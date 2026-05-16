# vim: ft=zsh sw=2 ts=2 et
# --------------------------------
#░▀▀█░█▀▀░█░█░█▀▄░█▀▀░░░░█▀▄░█▀▀ +
#░▄▀░░▀▀█░█▀█░█▀▄░█░░░░░░█▀▄░█░░ +
#░▀▀▀░▀▀▀░▀░▀░▀░▀░▀▀▀░▀░░▀░▀░▀▀▀ +
# --------------------------------

[[ $- != *i* ]] && return

stty -ixon
zmodload zsh/datetime

typeset -A __DOTS
__DOTS[ITALIC_ON]=$'\e[3m'
__DOTS[ITALIC_OFF]=$'\e[23m'

exists() { (( $+commands[$1] )); }

# ┏╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┓
# ╏ OPTIONS                                                  ╏
# ┗╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┛

HISTSIZE=100000
SAVEHIST=$HISTSIZE
HISTDUP=erase
HISTFILE=$ZSH_CACHE_DIR/.zsh_history

setopt INTERACTIVE_COMMENTS LONG_LIST_JOBS NOTIFY APPEND_HISTORY AUTO_CD
setopt COMPLETE_ALIASES AUTOPARAMSLASH AUTO_PUSHD CORRECT EXTENDED_HISTORY
setopt HIST_BEEP HIST_EXPIRE_DUPS_FIRST HIST_FIND_NO_DUPS HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_DUPS HIST_IGNORE_SPACE HIST_REDUCE_BLANKS HIST_VERIFY
setopt PROMPT_CR PROMPT_SP RM_STAR_WAIT INC_APPEND_HISTORY
setopt PUSHD_IGNORE_DUPS PUSHD_SILENT SHARE_HISTORY
unsetopt HIST_SAVE_NO_DUPS

fpath=($ZDOTDIR/funcs ${ASDF_DATA_DIR:-$HOME/.asdf}/completions $fpath)
export PATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH"

autoload -Uz $ZDOTDIR/funcs/*(.:t)
autoload -U colors && colors

colorline="#202020"
colorsuggest="fg=#3f3f3f"

# ┏╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┓
# ╏ COMPLETION                                               ╏
# ┗╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┛

autoload -Uz compinit

# Fix bottleneck: compinit hanya rebuild dump kalau sudah > 24 jam
# Tanpa ini, compinit scan semua fpath setiap shell start (~100-300ms)
() {
  local zcd="${ZDOTDIR:-$HOME}/.zcompdump"
  local zcdc="$zcd.zwc"
  if [[ -f "$zcd"(#qN.mh+24) || ! -f "$zcd" ]]; then
    compinit -d "$zcd"
    { zcompile "$zcd" } &!  # compile di background
  else
    compinit -C -d "$zcd"   # -C: skip security check, pakai cache
  fi
}

_comp_options+=(globdots)

zmodload zsh/complist
zstyle ':completion:*' menu select
zstyle ':completion:*' rehash true
zstyle ':completion:*:options' description no
zstyle ':completion:*:options' auto-description '%d'
zstyle ':completion:*:corrections' format ' %F{green}-- %d (errors: %e) --%f'
zstyle ':completion:*:messages' format ' %F{purple} -- %d --%f'
zstyle ':completion:*:warnings' format ' %F{red}-- no matches found --%f'
zstyle ':completion:*:default' list-prompt '%S%M matches%s'
zstyle ':completion:*' group-name ''
zstyle ':completion:*:matches' group yes
zstyle ':completion:*' verbose yes
zstyle ':completion:*' expand suffix
zstyle ':completion:*' file-sort modification
zstyle ':completion:*' list-suffixes true
zstyle ':completion:*' completer _extensions _complete _approximate
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$XDG_CACHE_HOME/zsh/.zcompcache"
zstyle ':completion:*' matcher-list '' \
  '+m:{[:lower:]}={[:upper:]}' \
  '+m:{[:upper:]}={[:lower:]}' \
  '+m:{_-}={-_}' \
  'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

zstyle ':completion:*:*:*:*:processes' command 'ps -u $LOGNAME -o pid,user,command -w'

if [[ "$TERM" == "xterm-kitty" ]]; then
  kitty + complete setup zsh | source /dev/stdin
fi

# ┏╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┓
# ╏ SOURCE PLUGINS                                           ╏
# ┗╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┛

source_if_exists() { [[ -f $1 ]] && source $1 }

source_if_exists "$ZSH_PLUGINS/zsh-autosuggestions/zsh-autosuggestions.zsh"
source_if_exists "$ZSH_PLUGINS/autoenv/autoenv.plugin.zsh"

# ── FZF-TAB ───────────────────────────────────────────────────────────
if [[ -f $ZSH_PLUGINS/fzf-tab/fzf-tab.zsh ]]; then
  source $ZSH_PLUGINS/fzf-tab/fzf-tab.zsh

  if [[ -n "$TMUX" ]]; then
    zstyle ':fzf-tab:*' fzf-flags --preview-window "right:nohidden:50%" --no-border
  else
    zstyle ':fzf-tab:*' fzf-flags --preview-window "right:nohidden:50%" --border
  fi

  zstyle ':completion:*' menu no
  zstyle ':fzf-tab:*' use-fzf-default-opts yes
  zstyle ':fzf-tab:*' continuous-trigger 'ctrl-y'

  if [[ $TMUX ]]; then
    zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup
    zstyle ':fzf-tab:*' popup-min-size 80 20
    zstyle ':fzf-tab:*' popup-pad 0 0
    zstyle ':fzf-tab:*' popup-fit-preview yes
  fi

  zstyle ':fzf-tab:complete:systemctl-*:*' fzf-preview 'SYSTEMD_COLORS=1 systemctl status $word'

  zstyle ':fzf-tab:complete:icat:*' fzf-command fzf
  zstyle ':fzf-tab:complete:sxiv:*' fzf-command fzf
  icat() { kitten icat $@ }
  zstyle ':fzf-tab:complete:icat:*' fzf-preview 'kitten icat --clear --transfer-mode=memory --stdin=no --place=50x50@0x0 $realpath'
  zstyle ':fzf-tab:complete:sxiv:*' fzf-preview 'kitten icat --clear --transfer-mode=memory --stdin=no --place=50x50@0x0 $realpath'

  zstyle ':fzf-tab:complete:zathura:*' fzf-preview 'pdftotext $realpath - | head -n 20'
  zstyle ':fzf-tab:complete:tdf:*' fzf-preview 'pdftotext $realpath - | head -n 20'
  zstyle ':fzf-tab:complete:fancy-cat:*' fzf-preview 'pdftotext $realpath - | head -n 20'
  zstyle ':fzf-tab:complete:git:*' fzf-flags --preview-window "right:50%:hidden:cycle"

  zstyle ':completion:*:*:*:*:processes' command "ps -u $USER -o pid,user,comm -w -w"
  zstyle ':fzf-tab:complete:(kill|ps):argument-rest' fzf-preview \
    '[[ $group == "[process ID]" ]] && ps --pid=$word -o cmd --no-headers -w -w'
  zstyle ':fzf-tab:complete:(kill|ps):argument-rest' fzf-flags --preview-window=down:3:wrap

  if command -v eza >/dev/null; then
    fzf_dir_preview='eza -a --tree --level=2 --icons --color=always $realpath'
    zstyle ':fzf-tab:complete:eza:*' fzf-preview "$fzf_dir_preview"
  else
    fzf_dir_preview='ls -1 --color=always $realpath'
  fi
  zstyle ':fzf-tab:complete:cd:*' fzf-preview "$fzf_dir_preview"
  zstyle ':fzf-tab:complete:ls:*' fzf-preview "$fzf_dir_preview"
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
export MANPAGER="/bin/sh -c \"col -b | nvim -c 'set ft=man ts=8 nomod nolist nonu noma' -\""

# ┏╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┓
# ╏ VI-MODE                                                  ╏
# ┗╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┛

vim_insert_mode=""
vim_normal_mode="%F{${colorline}}╰─%f%F{green} %f"
vim_mode=$vim_insert_mode

function zle-line-finish { vim_mode=$vim_insert_mode }
zle -N zle-line-finish

function TRAPINT() {
  vim_mode=$vim_insert_mode
  return $(( 128 + $1 ))
}

cursor_mode() {
  cursor_block='\e[1 q'
  cursor_beam='\e[1 q'

  function zle-keymap-select {
    vim_mode="${${KEYMAP/vicmd/${vim_normal_mode}}/(main|viins)/${vim_insert_mode}}"
    zle && zle reset-prompt

    if [[ ${KEYMAP} == vicmd ]] || [[ $1 = 'block' ]]; then
      echo -ne $cursor_block
    elif [[ ${KEYMAP} == main ]] || [[ ${KEYMAP} == viins ]] ||
         [[ ${KEYMAP} = '' ]] || [[ $1 = 'beam' ]]; then
      echo -ne $cursor_beam
    fi
  }

  zle-line-init() { echo -ne $cursor_beam }

  zle -N zle-keymap-select
  zle -N zle-line-init
}

cursor_mode

# ┏╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┓
# ╏ VCS                                                      ╏
# ┗╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┛

autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' use-cache true
zstyle ':vcs_info:*' max-exports 2
zstyle ':vcs_info:*' check-for-changes false
zstyle ':vcs_info:*' stagedstr "%F{green} ●%f"
zstyle ':vcs_info:*' unstagedstr "%F{red} ●%f"
zstyle ':vcs_info:*' use-simple true
zstyle ':vcs_info:git+set-message:*' hooks git-stash git-compare git-remotebranch
zstyle ':vcs_info:git*:*' actionformats '(%B%F{red}%b|%a%c%u%%b%f) '
zstyle ':vcs_info:git:*' formats "%F{249}(%f%F{blue}%{$__DOTS[ITALIC_ON]%}%b%{$__DOTS[ITALIC_OFF]%}%f%F{249})%f%c%u%m"

__in_git() { git rev-parse --is-inside-work-tree &>/dev/null }

function +vi-git-untracked() {
  emulate -L zsh
  if __in_git && git status --porcelain=v1 -uno | grep -q '^??'; then
    hook_com[unstaged]+="%F{blue}  %f"
  fi
}

function +vi-git-stash() {
  emulate -L zsh
  if __in_git && git rev-list --walk-reflogs --count refs/stash &>/dev/null; then
    hook_com[unstaged]+=" %F{yellow}%f "
  fi
}

function +vi-git-compare() {
  emulate -L zsh
  local ahead behind branch upstream
  branch=${hook_com[branch]}
  upstream=$(git rev-parse --abbrev-ref ${branch}@{upstream} 2>/dev/null) || return 0
  local -a counts
  counts=(${(s: :)$(git rev-list --left-right --count HEAD...${branch}@{upstream} 2>/dev/null)})
  ahead=${counts[1]} behind=${counts[2]}
  (( ahead )) && hook_com[misc]+="%F{red}⇡${ahead}%f "
  (( behind )) && hook_com[misc]+="%F{cyan}⇣${behind}%f "
}

function +vi-git-remotebranch() {
  local remote
  remote=${$(git rev-parse --symbolic-full-name ${hook_com[branch]}@{upstream} 2>/dev/null)/refs\/remotes\/}
}

# ┏╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┓
# ╏ PROMPT                                                   ╏
# ┗╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┛

setopt PROMPT_SUBST

function __prompt_eval() {
  local virtualenv_prompt=""
  if [[ -n "$VIRTUAL_ENV" ]]; then
    virtualenv_prompt="%F{green}($(basename "$VIRTUAL_ENV"))%f"
  fi

  local dots_prompt_icon="%F{$colorline}╰─%f "
  local dots_prompt_failure_icon="%F{$colorline}╰─%f%F{red}✘%f "
  local top="%F{$colorline}┌───[ %B%F{magenta}%1~%f%b${_git_status_prompt:-}%F{$colorline}]%f %(1j.%F{cyan}job:%j✦%f .) %F{cyan}${virtualenv_prompt}"
  local character="%(?.${dots_prompt_icon}.${dots_prompt_failure_icon})"
  local bottom=$([[ -n "$vim_mode" ]] && echo "$vim_mode" || echo "$character")
  echo $top$'\n'$bottom
}

export PROMPT='$(__prompt_eval)'
export SPROMPT="correct %F{red}'%R'%f to %F{red}'%r'%f [%By%b/%Bn%b/%Be%b/%Ba%b]? "

# ┏╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┓
# ╏ EXECUTION TIME                                           ╏
# ┗╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┛

__human_time_to_var() {
  local total=$1 var=$2
  local d=$(( total / 86400 )) h=$(( total / 3600 % 24 )) m=$(( total / 60 % 60 )) s=$(( total % 60 ))
  local human=""
  (( d )) && human+="${d}d "
  (( h )) && human+="${h}h "
  (( m )) && human+="${m}m "
  human+="${s}s"
  typeset -g "${var}"="${human}"
}

__check_cmd_exec_time() {
  integer elapsed=$(( EPOCHSECONDS - ${cmd_timestamp:-$EPOCHSECONDS} ))
  typeset -g cmd_exec_time=
  (( elapsed > 1 )) && __human_time_to_var $elapsed cmd_exec_time
}

__timings_preexec() { typeset -g cmd_timestamp=$EPOCHSECONDS }
__timings_precmd()  { __check_cmd_exec_time; unset cmd_timestamp }

# ┏╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┓
# ╏ HOOKS                                                    ╏
# ┗╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┛

autoload -Uz add-zsh-hook

__async_vcs_start() {
  if [[ -n "$__prompt_async_fd" ]] && { true <&$__prompt_async_fd } 2>/dev/null; then
    exec {__prompt_async_fd}<&-
    zle -F $__prompt_async_fd
  fi
  exec {__prompt_async_fd}< <(__async_vcs_info "$PWD")
  zle -F $__prompt_async_fd __async_vcs_info_done
}

__async_vcs_info() {
  builtin cd -q "$1" || return
  vcs_info
  print -r -- "${vcs_info_msg_0_}"
}

__async_vcs_info_done() {
  _git_status_prompt="$(<&$1)"
  [[ -z $_git_status_prompt ]] && _git_status_prompt=" "
  zle -F "$1"
  exec {1}<&-
  zle && zle reset-prompt
}

function TRAPWINCH() { zle && zle reset-prompt }

add-zsh-hook precmd __timings_precmd
add-zsh-hook precmd __async_vcs_start
add-zsh-hook preexec __timings_preexec

__on_chpwd() { _git_status_prompt="" }
add-zsh-hook chpwd __on_chpwd

# ┏╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┓
# ╏ LOCAL SCRIPTS                                            ╏
# ┗╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┛

for script in $ZDOTDIR/scripts/*; do source $script; done
source_if_exists "$HOME/.config/bashrc/aliases.bashrc"

# ┏╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┓
# ╏ KEYBINDINGS                                              ╏
# ┗╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┛

bindkey -v

bindkey '^y' autosuggest-accept
bindkey '^?' backward-delete-char
bindkey '^b' backward-word
bindkey '^f' forward-word
bindkey '^a' beginning-of-line
bindkey '^e' end-of-line
bindkey '^l' forward-char
bindkey '^h' backward-char

bindkey -M viins '^w' backward-kill-word
bindkey -r "^s"

autoload -U edit-command-line
zle -N edit-command-line
bindkey -M viins '^[q' edit-command-line
bindkey -M viins 'hh' vi-cmd-mode

bindkey '^r' history-incremental-search-backward
bindkey '^p' up-history
bindkey '^n' down-history

bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history

bindkey '^[[Z' reverse-menu-complete
bindkey -M menuselect '^[[Z' reverse-menu-complete
bindkey -M menuselect '\e[Z' reverse-menu-complete

# ┏╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┓
# ╏ PLUGINS (LATE)                                           ╏
# ┗╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌┛

export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE=$colorsuggest
export ZSH_AUTOSUGGEST_USE_ASYNC=1

source_if_exists "$HOME/.fzf.zsh"
source_if_exists "$HOME/.config/miscxrdb/fzf/fzf.config"

if command -v asdf >/dev/null 2>&1 && asdf where golang >/dev/null 2>&1; then
  local golang_dir="$(asdf where golang)"
  export GOPATH="${golang_dir}/packages"
  export GOROOT="${golang_dir}/go"
  export PATH="${PATH}:$(go env GOPATH)/bin:$(go env GOBIN)"
fi

if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init zsh)"
fi

# Fix bottleneck: cache hasil uv completion ke file, jangan generate tiap start
# Generate ulang hanya kalau uv binary berubah (cek via mtime)
if [[ -f ~/.local/bin/uv ]]; then
  local _uv_comp_cache="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/uv-completion.zsh"
  if [[ ! -f "$_uv_comp_cache" || ~/.local/bin/uv -nt "$_uv_comp_cache" ]]; then
    mkdir -p "${_uv_comp_cache:h}"
    ~/.local/bin/uv generate-shell-completion zsh >| "$_uv_comp_cache"
  fi
  source_if_exists "$_uv_comp_cache"
fi

export PATH="${PATH}:$HOME/.config/emacs/bin"

# ⚠️ MUST be sourced last
source_if_exists "$ZSH_PLUGINS/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
