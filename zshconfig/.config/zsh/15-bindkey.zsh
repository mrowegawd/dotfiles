###############################################################################
# Enter bindkey run :$bindkey -v
# and run `bindkey` again, you will get all list commands zsh
# vim: ft=zsh sw=2 ts=2 et
###############################################################################

bindkey -v                            # set bindkey to `vim`
# export KEYTIMEOUT=1

autoload -Uz history-search-end edit-command-line
zle -N edit-command-line
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end

bindkey -M viins 'hh' vi-cmd-mode     # Changing <Esc> to mine bindkey

bindkey -M viins '^A' beginning-of-line
bindkey -M viins '^B' backward-char
bindkey -M viins '^D' delete-char-or-list
bindkey -M viins '^E' end-of-line
bindkey -M viins '^F' forward-char
bindkey -M viins '^K' kill-line
bindkey -M viins '^P' history-beginning-search-backward-end
bindkey -M viins '^N' history-beginning-search-forward-end
bindkey -M viins '^X^E' edit-command-line
bindkey -M viins '^[[Z' reverse-menu-complete

# bindkey '^[[Z' reverse-menu-complete
# bindkey '\ev' slash-backward-kill-word

# If fzf activated this mapping will overwrited
# bindkey '^r'    history-incremental-pattern-search-backward

# bindkey '^s'    history-incremental-pattern-search-forward

# bindkey "^[+" up-one-dir
# bindkey "^[=" back-one-dir

# bindkey " "     magic-space
# bindkey '^p'    clear-screen

bindkey -M menuselect 'h'     vi-backward-char
bindkey -M menuselect 'k'     vi-up-line-or-history
bindkey -M menuselect 'l'     vi-forward-char
bindkey -M menuselect 'j'     vi-down-line-or-history

bindkey '^Y' fzm

# bindkey -M menuselect '^o'    accept-and-infer-next-history
# bindkey -M menuselect 'o'     accept-and-infer-next-history
# bindkey -M menuselect "+"     accept-and-menu-complete
# bindkey -M menuselect "^[[2~" accept-and-menu-complete
# bindkey -M menuselect '\e^M'  accept-and-menu-complete

