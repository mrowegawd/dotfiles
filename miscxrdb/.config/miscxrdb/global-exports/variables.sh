# vim: foldmethod=marker foldlevel=0

# GENERAL: ---------------------------------------------------------------- {{{
#
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.config/miscxrdb/bin:$PATH"

if command -v nvim &>/dev/null; then
	export VISUAL="nvim"
	export EDITOR="$VISUAL"
else
	export VISUAL="vim"
	export EDITOR="$VISUAL"
fi

if grep -qEi "(Microsoft|WSL)" /proc/version &>/dev/null; then
	export BROWSER="/mnt/c/Program\ Files/Mozilla\ Firefox/firefox.exe"
else
	export BROWSER="firefox"
fi
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
export SDKMAN_DIR="$HOME/.sdkman"
[ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ] && source "$SDKMAN_DIR/bin/sdkman-init.sh"

export ANDROID_SDK=$HOME/Android/Sdk
export PATH=$ANDROID_SDK/emulator:$ANDROID_SDK/tools:$PATH

# Avoid error Intellij
export _JAVA_AWT_WM_NONREPARENTING=1
#
# }}}
# Ansible: ---------------------------------------------------------------- {{{
# config ansible agar bisa menampilkan color ketika menjalankan `molecule cli`
export PY_COLORS='1'
export ANSIBLE_FORCE_COLOR='1'
#
# }}}
# NNN: -------------------------------------------------------------------- {{{
#
export NNN_OPENER=$HOME/.config/miscxrdb/nnn/nnn-opener.sh
export NNN_PLUG='g:fzmark;q:fzsearch;o:fzopen;p:preview-tui;d:fzcd;t:termcd;O:opencurdir;B:oplazygit;D:oplazydocker'

export NNN_FIFO='/tmp/nnn.fifo'
export NNN_OPTS="H"

BLK="0B" CHR="0B" DIR="04" EXE="06" REG="00" HARDLINK="06" SYMLINK="06" MISSING="00" ORPHAN="09" FIFO="06" SOCK="0B" OTHER="06"
export NNN_FCOLORS="$BLK$CHR$DIR$EXE$REG$HARDLINK$SYMLINK$MISSING$ORPHAN$FIFO$SOCK$OTHER"
#
# }}}

# vim: ft=sh sw=2 ts=2 et foldmethod=marker foldlevel=0
