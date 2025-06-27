# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# if running bash
if [ -n "$BASH_VERSION" ]; then
  # include .bashrc if it exists
  if [ -f "$HOME/.bashrc" ]; then
    #shellcheck source=/dev/null
    . "$HOME/.bashrc"
  fi
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ]; then
  PATH="$HOME/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ]; then
  PATH="$HOME/.local/bin:$PATH"
fi

# shellcheck source=/dev/null
if [ -e "$HOME/.nix-profile/etc/profile.d/nix.sh" ]; then . "$HOME/.nix-profile/etc/profile.d/nix.sh"; fi # added by Nix installer

export TERMINAL="kitty"
export NUBROWSER="zen-browser"

# Set PATH ditaruh disini karena alasan nya biar 'ensure` PATH terakses ketika
# membuka neovide
export PATH="$HOME/.poetry/bin:$PATH"
export PATH="$HOME/.asdf/shims:$PATH"
export PATH="$HOME/.asdf/bin:$PATH"
export PATH="$HOME/.fzf/bin:$PATH"

if grep -qi microsoft /proc/version; then
  sudo_autopasswd() {
    echo "<add password here>" | sudo -Svp ""
    # Default timeout for caching your sudo password: 15 minutes

    # If you're uncomfortable entering your password here,
    # you can comment out the line above. But keep in mind that functions
    # in a Bash script cannot be empty; comment lines are ignored.
    # A function should at least have a ':' (null command).
    # https://tldp.org/LDP/abs/html/functions.html#EMPTYFUNC
  }

  sudo_resetpasswd() {
    # Clears cached password for sudo
    sudo -k
  }

  #
  # '/run/user' directory is always empty when WSL2 is first
  # launched; a perfect time to setup daemons and D-Bus
  #

  export XDG_RUNTIME_DIR=/run/user/$(id -u)
  if [ ! -d "$XDG_RUNTIME_DIR" ]; then
    {
      sudo_autopasswd

      # Create user runtime directories
      sudo mkdir "$XDG_RUNTIME_DIR" && sudo chmod 700 "$XDG_RUNTIME_DIR" && sudo chown $(id -un):$(id -gn) "$XDG_RUNTIME_DIR"

      # System D-Bus
      sudo service dbus start

      # --------------------
      # Start additional services as they are needed.
      # We recommend adding commands that require 'sudo' here. For other
      # regular background processes, you should add them below where a
      # session 'dbus-daemon' is started.
      # --------------------

      sudo_resetpasswd
    }
  fi

  set_session_dbus() {
    local bus_file_path="$XDG_RUNTIME_DIR/bus"

    export DBUS_SESSION_BUS_ADDRESS=unix:path=$bus_file_path
    if [ ! -e "$bus_file_path" ]; then
      {
        /usr/bin/dbus-daemon --session --address=$DBUS_SESSION_BUS_ADDRESS --nofork --nopidfile --syslog-only &

        # --------------------
        # More background processes can be added here.
        # For 'sudo' requiring commands, you should add them above
        # where the 'dbus' service is started.
        # --------------------

      }
    fi
  }

  set_session_dbus
fi
