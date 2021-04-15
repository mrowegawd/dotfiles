###############################################################################
# NOTE: Enter bindkey run :$bindkey -v
# and run `bindkey` again, you will get all list commands zsh
# vim: ft=zsh sw=2 ts=2 et
###############################################################################

bindkey -v                            # set bindkey to `vim`
# export KEYTIMEOUT=1

bindkey -M viins 'hh' vi-cmd-mode     # Changing <Esc> to mine bindkey

# bindkey '^[[Z' reverse-menu-complete
# bindkey '\ev' slash-backward-kill-word

# NOTE: kalau fzf aktif, bindkey ini akan teroverwrite
bindkey '^r'    history-incremental-pattern-search-backward
bindkey '^s'    history-incremental-pattern-search-forward

# bindkey "^[+" up-one-dir
# bindkey "^[=" back-one-dir

bindkey " "     magic-space
bindkey '^p'    clear-screen

# Edit line in vim with ctrl-e:
autoload edit-command-line
zle -N edit-command-line
bindkey '^e' edit-command-line

bindkey -M menuselect 'h'     vi-backward-char
bindkey -M menuselect 'k'     vi-up-line-or-history
bindkey -M menuselect 'l'     vi-forward-char
bindkey -M menuselect 'j'     vi-down-line-or-history
bindkey -M menuselect '^o'    accept-and-infer-next-history
bindkey -M menuselect 'o'     accept-and-infer-next-history
bindkey -M menuselect "+"     accept-and-menu-complete
bindkey -M menuselect "^[[2~" accept-and-menu-complete
bindkey -M menuselect '\e^M'  accept-and-menu-complete
