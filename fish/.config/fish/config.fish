# Non-interactive users (sshy, sync)
if not status --is-interactive
    exit # Skips the rest of this file, not exiting the shell
end

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

if command -v nvim &>/dev/null
    export VISUAL="nvim"
    export EDITOR="$VISUAL"
else
    export VISUAL="vim"
    export EDITOR="$VISUAL"
end

set -U fifc_fd_opts --hidden
set -Ux fifc_editor nvim

# if grep -qEi "(Microsoft|WSL)" /proc/version &>/dev/null
#     export BROWSER="/mnt/c/Program\ Files/Mozilla\ Firefox/firefox.exe"
# else
if test -e "$HOME/.local/bin/kitty"
    export TERMINAL="kitty"
else if test -e /usr/local/bin/wezterm
    export TERMINAL="wezterm"
else if command -v alacritty >/dev/null
    export TERMINAL="alacritty"
end

export BROWSER="firefox"

# export TERM="xterm-256color"
# [[ -n $TMUX ]] && export TERM="screen-256color"
# end

# -----------------------------------------------------------------------------
# We use starship sebagai prompt nya install nya run di BASH SHELL!!
# sh -c "$(curl -fsSL https://starship.rs/install.sh)"
#
# Configuration check this link: https://starship.rs/config/
# if command -v starship >/dev/null
#     starship init fish | source
# end
# -----------------------------------------------------------------------------

# FORGIT: ----------------------------------------------------------------- {{{
#
export FORGIT_FZF_DEFAULT_OPTS=" --exact --border --cycle --reverse --height '80%'"
export FORGIT_LOG_FZF_OPTS='--bind="ctrl-e:execute(echo {} |grep -Eo [a-f0-9]+ |head -1 |xargs git show |nvim -)" '
#
# }}}
# PIPENV: ----------------------------------------------------------------- {{{
#
export PIPENV_VERBOSITY=1
export VIRTUAL_ENV_DISABLE_PROMPT=0
#
# }}}
# ANDROIDSTUDIO: ---------------------------------------------------------- {{{
#
export PATH="$PATH:/opt/android-studio/bin"
#
# }}}
# FLUTTER: ---------------------------------------------------------------- {{{
#
export PATH="$PATH:$HOME/.pub-cache/bin"
export PATH="$PATH:/opt/flutter/bin"
#
# }}}
# SDKMAN: ----------------------------------------------------------------- {{{
#
# THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
# export SDKMAN_DIR="$HOME/.sdkman"
# [ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ] && source "$SDKMAN_DIR/bin/sdkman-init.sh"

# export ANDROID_SDK=$HOME/Android/Sdk
# export PATH=$ANDROID_SDK/emulator:$ANDROID_SDK/tools:$PATH

# Avoid error Intellij
export _JAVA_AWT_WM_NONREPARENTING=1
#
# }}}

set -U fish_greeting
fish_vi_key_bindings

# NOTE: dunno why this error?! command `cat` `systemctl` ga bisa karena nya
# if command -v grcat >/dev/null
#     [ -f "/etc/grc.fish" ] && source /etc/grc.fish
# else
#     echo "install grcat from https://github.com/garabik/grc"
# end

set -g fzf_fd_opts --hidden --no-ignore --exclude=.git --exclude=library

set -g FZF_DEFAULT_COMMAND "rg --column --line-number --no-heading --hidden --follow --color=always"

[ -f "$HOME/.config/miscxrdb/fzf/fzf.config.fish" ] && source "$HOME/.config/miscxrdb/fzf/fzf.config.fish"
[ -f "$HOME/.config/fish/alias.fish" ] && source "$HOME/.config/fish/alias.fish"
set FZF_MARKS_FILE "$HOME/Dropbox/data.programming.forprivate/fzf-marks"

# vim: foldmethod=marker foldlevel=2
