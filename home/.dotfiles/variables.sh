# GENERAL: ---------------------------------------------------------------- {{{
#
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

export PATH="$HOME/.local/bin:$PATH"

if command -v nvim &>/dev/null; then
	export VISUAL="nvim"
	export EDITOR="$VISUAL"
else
	export VISUAL="vim"
	export EDITOR="$VISUAL"
fi

if grep -qEi "(Microsoft|WSL)" /proc/version &>/dev/null; then
	export BROWSER="/mnt/c/Program\ Files/Mozilla\ Firefox/firefox.exe"
	export TERMINAL="termite"
else
	if [ -f ~/.local/bin/kitty ]; then
		export TERMINAL="kitty"
	elif [ -f /usr/local/bin/wezterm ]; then
		export TERMINAL="wezterm"
	elif [ -n "$(command -v alacritty)" ]; then
		export TERMINAL="alacritty"
	fi
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

# vim: ft=sh sw=2 ts=2 et foldmethod=marker
