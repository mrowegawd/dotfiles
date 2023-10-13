
source "$HOME/.asdf/asdf.sh"

# vim: ft=zsh sw=2 ts=2 et
fpath+=(~/.zsh/completion/)

# append completions to fpath
fpath=(${ASDF_DIR}/completions $fpath)

autoload -Uz compinit && compinit

setopt COMPLETE_IN_WORD    # Complete from both ends of a word.
setopt ALWAYS_TO_END       # Move cursor to the end of a completed word.
setopt PATH_DIRS           # Perform path search even on command names with slashes.
setopt AUTO_MENU           # Show completion menu on a succesive tab press.
setopt AUTO_LIST           # Automatically list choices on ambiguous completion.
setopt AUTO_PARAM_SLASH    # If completed parameter is a directory, add a trailing slash.
unsetopt MENU_COMPLETE     # Do not autoselect the first completion entry.
unsetopt FLOW_CONTROL      # Disable start/stop characters in shell editor.


# Completing Groping
zstyle ':completion:*' completer _oldlist _complete _ignored
zstyle ':completion:*:messages' format '%F{yellow}%d'
zstyle ':completion:*:warnings' format '%B%F{red}No matches for:''%F{white}%d%b'
zstyle ':completion:*:descriptions' format '%B%F{white}--- %d ---%f%b'
zstyle ':completion:*:corrections' format ' %F{green}%d (errors: %e) %f'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' keep-prefix
zstyle ':completion:*' recent-dirs-insert both
zstyle ':completion:*:options' description 'yes'
zstyle ':completion:*:options' auto-description '%d'

# Completing misc
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*' verbose yes
zstyle ':completion:*' completer _expand _complete _match _prefix _approximate _list
zstyle ':completion:*:*files' ignored-patterns '*?.o' '*?~' '*\#'
zstyle ':completion:*' use-cache true
zstyle ':completion:*:*:-subscript-:*' tag-order indexes parameters
zstyle ':completion:*:processes' command 'ps x -o pid,s,args'

# Directory
zstyle ':completion:*:cd:*' ignore-parents parent pwd
export LS_COLORS='di=34:ln=35:so=32:pi=33:ex=31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# default: --
zstyle ':completion:*' list-separator '-->'
zstyle ':completion:*:manuals' separate-sections true

bindkey -v # using vim bindkey
export KEYTIMEOUT=300

# Menu select
# Select completion candidates with ←↓↑→ (completion candidates are displayed in different colors)
# zstyle show completion menu if 1 or more items to select
zstyle ':completion:*:default' menu select=1
zmodload -i zsh/complist
# Menggunakan <Shift-hjkl> daripada <c-hjkl>, karena untuk navigate tmux
bindkey -M menuselect 'H' vi-backward-char
bindkey -M menuselect 'K' vi-up-line-or-history
bindkey -M menuselect 'L' vi-forward-char
bindkey -M menuselect 'J' vi-down-line-or-history
# Shift-tab to reverse completion
bindkey '^[[Z' reverse-menu-complete
bindkey -M menuselect '^[[Z' reverse-menu-complete


# Changing <Esc> to mine bindkey
bindkey -M viins 'hh' vi-cmd-mode

bindkey '^?' backward-delete-char
bindkey '^b' backward-char      # backward (c-b)
bindkey '^f' forward-char       # forward char (c-f)
bindkey '^w' backward-kill-word
bindkey '^a' beginning-of-line
bindkey '^e' end-of-line


# edit command-line using editor (like <alt-e> command)
autoload -U edit-command-line
zle -N edit-command-line
bindkey -M viins '^[e' edit-command-line

# bindkey -M vicmd '^U' backward-kill-line
bindkey '^U' backward-kill-line

# bindkey '^ ' autosuggest-accept
# bindkey '^I' autosuggest-accept

autoload -U history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^P" history-beginning-search-backward
bindkey "^N" history-beginning-search-forward
