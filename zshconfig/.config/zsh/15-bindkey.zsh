###############################################################################
# Enter bindkey run :$bindkey -v
# and run `bindkey` again, you will get all list commands zsh
# vim: ft=zsh sw=2 ts=2 et
###############################################################################

bindkey -v # set bindkey to `vim`
# export KEYTIMEOUT=1

autoload -Uz history-search-end edit-command-line
zle -N edit-command-line
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end

bindkey -M viins 'hh' vi-cmd-mode # Changing <Esc> to mine bindkey

bindkey -M viins '^A' beginning-of-line
bindkey -M viins '^E' end-of-line
bindkey -M viins '^F' forward-char
bindkey -M viins '^B' backward-char
bindkey -M viins '^D' delete-char-or-list

bindkey -M viins '^K' kill-line
bindkey -M viins '^P' history-beginning-search-backward-end
bindkey -M viins '^N' history-beginning-search-forward-end

# bindkey -M viins '^e' edit-command-line
bindkey -M viins '^[[Z' reverse-menu-complete

# bindkey -M viins '^[M' edit-command-line
bindkey -M viins '^e' edit-command-line

# bindkey '\ev' slash-backward-kill-word

# If fzf activated this mapping will overwrited
# bindkey '^r'    history-incremental-pattern-search-backward
# bindkey '^s'    history-incremental-pattern-search-forward

# bindkey "^[+" up-one-dir
# bindkey "^[=" back-one-dir

# bindkey " "     magic-space

showalias() {
  local selected num
  setopt localoptions noglobsubst noposixbuiltins pipefail no_aliases 2>/dev/null

  SELECT=$(awk '/\(\)/&& last {print $1,"\t",last} {last=""} /^#/{last=$0}' ~/.config/bashrc/aliases.bashrc |
    column -t -s $'\t' | sed 's/#//' | sed 's/()//' | grcat alias.grc | fzf-tmux -p 80% ${commands[grcat]:+--ansi} | cut -d" " -f1 | cut -d"(" -f1)

  # note: https://doronbehar.com/articles/ZSH-FZF-completion/
  # how to Programmatically Change the Line in Zle?
  LBUFFER="${LBUFFER}$SELECT "
  local ret=$?

  zle reset-prompt

  return $selected
}

zle -N showalias
# bindkey '\ej' showalias
bindkey '^o' showalias

bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history

bindkey '^g' fzm

# bindkey -M menuselect '^o'    accept-and-infer-next-history
# bindkey -M menuselect 'o'     accept-and-infer-next-history
# bindkey -M menuselect "+"     accept-and-menu-complete
# bindkey -M menuselect "^[[2~" accept-and-menu-complete
# bindkey -M menuselect '\e^M'  accept-and-menu-complete

# CREDIT: taken from https://github.com/kevinhwang91/dotfiles/blob/main/zsh/lplug/fzf/fzf-completion-widget
_fps() {
  ps -eo user,pid,ppid,pgid,stat,command | awk '
    BEGIN { "ps -p $$ -o pgid= | tr -d \"[:blank:]\"" | getline pgid } {
        if ($4 != pgid || $2 == pgid) print }' |
    grcat fps.grc | fzf --header-lines=1 -m \
    ${commands[grcat]:+--ansi} --height=60% \
    --min-height=15 --tac --reverse \
    --preview-window=down:2,border-top |
    awk -v sep=${myflag:- } '{ printf "%s%c", $2, sep }' |
    sed -E "s/${myflag:- }$//"
}

_t_expand_alias_f() {
    # echo $functions
    if (( $+functions[_t_expand_alias] )); then
        print ${functions[_t_expand_alias]#$'\t'}
        unset -f _t_expand_alias
    else
        print $@
    fi
}

fzf_lsof() {
  setopt localoptions noglobsubst noposixbuiltins pipefail no_aliases 2>/dev/null

  local matches
  local myargs=(${(z)$(_t_expand_alias_f $LBUFFER)})

  if [[ $myargs[-1] == "-p" ]]; then
    matches=$(myflag="," _fps)
  else
    matches=$(_fps)
  fi

  LBUFFER="${LBUFFER}$matches"
  zle reset-prompt

}

zle -N fzf_lsof

#mapping: open fzf lsof(to get PID) dengan flag -p
# bindkey '\eu' fzf_lsof
bindkey '^u' fzf_lsof

function fg-bg(){
  if [[ $#BUFFER -eq 0 ]]; then
    fg
  else
    zle push-input
  fi
}

zle -N fg-bg

#mapping: shortcut toggle fg command with vim
bindkey '^z' fg-bg


# # Pipenv completion
# _pipenv() {
#   eval $(env COMMANDLINE="${words[1,$CURRENT]}" _PIPENV_COMPLETE=complete-zsh  pipenv)
# }
# compdef _pipenv pipenv

# # Automatic pipenv shell activation/deactivation
# _togglePipenvShell() {
#   # deactivate shell if Pipfile doesn't exist and not in a subdir
#   if [[ ! -a "$PWD/Pipfile" ]]; then
#     if [[ "$PIPENV_ACTIVE" == 1 ]]; then
#       if [[ "$PWD" != "$pipfile_dir"* ]]; then
#         exit
#       fi
#     fi
#   fi

#   # activate the shell if Pipfile exists
#   if [[ "$PIPENV_ACTIVE" != 1 ]]; then
#     if [[ -a "$PWD/Pipfile" ]]; then
#       export pipfile_dir="$PWD"
#       pipenv shell
#     fi
#   fi
# }

# autoload -U add-zsh-hook
# add-zsh-hook chpwd _togglePipenvShell

# copy_output() {
#     BUFFER+=' | xclip -selection clipboard -r'
#     zle accept-line
# }

# zle -N copy_output
# bindkey '^y' copy_output

# copy_buffer() {
#     echo -n $BUFFER | xclip -selection clipboard
# }
# zle -N copy_buffer
# bindkey '^b' copy_buffer
