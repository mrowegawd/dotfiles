# vim: ft=zsh sw=2 ts=2 et


# option ini digunakan untuk ekspansi fitur agar bisa menampilkan sesuatu secara periodik,
# seperti menampilkan waktu di prompt
# tanpa option ini, display waktu tidak berubah (statik), berubah ketika login
# baru di zsh
setopt prompt_subst


autoload -U colors && colors

# vcs_info git
autoload -Uz vcs_info

zstyle ':vcs_info:*' stagedstr '%F{green}•'
zstyle ':vcs_info:*' unstagedstr '%F{yellow}•'
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' enable git svn

: ${PR_JOBS_PREFIX:=" "}
: ${PR_JOBS_SUFFIX:=""}
: ${PR_JOBS_SYMBOL:=""}
: ${PR_DOTS:="•"}

virtualenv_info() {
  [ $VIRTUAL_ENV ] && echo '('`basename $VIRTUAL_ENV`')'
}

git_info() {

  # Exit if not inside a Git repository
  ! git rev-parse --is-inside-work-tree > /dev/null 2>&1 && return

  # Git branch/tag, or name-rev if on detached head
  local GIT_LOCATION=${$(git symbolic-ref -q HEAD || git name-rev --name-only --no-undefined --always HEAD)#(refs/heads/|tags/)}

  local AHEAD="%{$fg[red]%}⇡NUM%{$reset_color%}"
  local BEHIND="%{$fg[cyan]%}⇣NUM%{$reset_color%}"
  local MERGING="%{$fg[magenta]%}⚡︎%{$reset_color%}"
  local UNTRACKED="%{$fg[red]%}?%{$reset_color%}"
  local MODIFIED="%{$fg[yellow]%}!%{$reset_color%}"
  local STAGED="%{$fg[green]%}●%{$reset_color%}"

  local -a DIVERGENCES
  local -a FLAGS

  local NUM_AHEAD="$(git log --oneline @{u}.. 2> /dev/null \
    | wc -l | tr -d ' ')"
  if [ "$NUM_AHEAD" -gt 0 ]; then
    DIVERGENCES+=( "${AHEAD//NUM/$NUM_AHEAD}" )
  fi

  local NUM_BEHIND="$(git log --oneline ..@{u} 2> /dev/null \
    | wc -l | tr -d ' ')"
  if [ "$NUM_BEHIND" -gt 0 ]; then
    DIVERGENCES+=( "${BEHIND//NUM/$NUM_BEHIND}" )
  fi

  local GIT_DIR="$(git rev-parse --git-dir 2> /dev/null)"
  if [ -n $GIT_DIR ] && test -r $GIT_DIR/MERGE_HEAD; then
    FLAGS+=( "$MERGING" )
  fi

  if [[ -n $(git ls-files --other --exclude-standard 2> /dev/null) ]]; then
    FLAGS+=( "$UNTRACKED" )
  fi

  if ! git diff --quiet 2> /dev/null; then
    FLAGS+=( "$MODIFIED" )
  fi

  if ! git diff --cached --quiet 2> /dev/null; then
    FLAGS+=( "$STAGED" )
  fi

  local -a GIT_INFO
  GIT_INFO+=( "\033[38;5;15m" )
  GIT_INFO+=( "\033[38;5;15m$GIT_LOCATION%{$reset_color%}" )
  [ -n "$GIT_STATUS" ] && GIT_INFO+=( "$GIT_STATUS" )
  [[ ${#DIVERGENCES[@]} -ne 0 ]] && GIT_INFO+=( "${(j::)DIVERGENCES}" )
  [[ ${#FLAGS[@]} -ne 0 ]] && GIT_INFO+=( "[${(j::)FLAGS}]" )
  echo "$PR_JOBS_PREFIX%F{6}$PR_DOTS$PR_JOBS_PREFIX${(j: :)GIT_INFO}"

}

exit_code="%(?..<%F{202}%?%f>)"

set_jobs(){
  if [[ -n "$(jobs)" ]] ; then
    echo "$PR_JOBS_PREFIX%F{6}$PR_DOTS$PR_JOBS_PREFIX%F{3}$PR_JOBS_SYMBOL$PR_JOBS_PREFIX%(1j.%j.)%{$reset_color%}"
  else
    echo "$PR_JOBS_SUFFIX"
  fi
}


# preexec () {
#   timer=$(date +%s%3N)
# }

# precmd () {
#   if [ $timer ]; then
#     local now=$(date +%s%3N)
#     local d_ms=$(($now-$timer))
#     local d_s=$((d_ms / 1000))
#     local ms=$((d_ms % 1000))
#     local s=$((d_s % 60))
#     local m=$(((d_s / 60) % 60))
#     local h=$((d_s / 3600))
#     if ((h > 0)); then elapsed=${h}h${m}m
#     elif ((m > 0)); then elapsed=${m}m${s}s
#     elif ((s >= 10)); then elapsed=${s}.$((ms / 100))s
#     elif ((s > 0)); then elapsed=${s}.$((ms / 10))s
#     else elapsed=${ms}ms
#     fi

#     elapsedstring="%F{yellow}${elapsed}%f:"

#     export RPROMPT='$elapsedstring%F%{$reset_color%}%F{8}%l:%n@%m%f'
#     unset timer
#   fi
# }

# function zle-line-init zle-keymap-select {
#   RPS1="${${KEYMAP/vicmd/-- NORMAL --}/(main|viins)/-- INSERT --}"
#   RPS2=$RPS1
#   zle reset-prompt
# }
#
# zle -N zle-line-init
# zle -N zle-keymap-select

# show directory:
# https://wiki.gentoo.org/wiki/Zsh/Guide#Prompts
# %2~     :show only 2 dirs
# %~

zsh_update_vim_mode() {
  if [[ $KEYMAP == 'vicmd' ]]; then
    echo "[VIM]"
  else
    echo ""
  fi
}
# Set up a precmd hook to update the Vim mode indicator before each prompt display
# autoload -Uz add-zsh-hook
# add-zsh-hook precmd zsh_update_vim_mode

PROMPT='%F{6}┌──╼ [%F{6}%2~%{$reset_color%}$(git_info)$(set_jobs)%F{6}❯%{$reset_color%} %F{6}$(virtualenv_info)%{$reset_color%} $exit_code
%F{6}└╼%f%F{reset_color}$PR_JOBS_PREFIX'

# terminfo_down_sc=$terminfo[cud1]$terminfo[cuu1]$terminfo[sc]$terminfo[cud1]

# function insert-mode () { echo "-- INSERT --" }
# function normal-mode () { echo "-- NORMAL --" }

# precmd () {
#     # yes, I actually like to have a new line, then some stuff and then
#     # the input line
#     print -rP "
# [%D{%a, %d %b %Y, %H:%M:%S}] %n %{$fg[blue]%}%m%{$reset_color%}"

#     # this is required for initial prompt and a problem I had with Ctrl+C or
#     # Enter when in normal mode (a new line would come up in insert mode,
#     # but normal mode would be indicated)
#     PS1="%{$terminfo_down_sc$(insert-mode)$terminfo[rc]%}%~ $ "
# }
# function set-prompt () {
#     case ${KEYMAP} in
#       (vicmd)      VI_MODE="$(normal-mode)" ;;
#       (main|viins) VI_MODE="$(insert-mode)" ;;
#       (*)          VI_MODE="$(insert-mode)" ;;
#     esac
#     PS1="%{$terminfo_down_sc$VI_MODE$terminfo[rc]%}%~ $ "
# }

# function zle-line-init zle-keymap-select {
#     set-prompt
#     zle reset-prompt
# }
# preexec () { print -rn -- $terminfo[el]; }

# zle -N zle-line-init
# zle -N zle-keymap-select
