# vim: ft=zsh sw=2 ts=2 et

# ┏╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┓
# ╏                                   HELPERS                                    ╏
# ┗╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┛

# Direct escape sequences (no fork `tput` at shell start).
typeset -g Green=$'\e[32m' Yellow=$'\e[33m' Red=$'\e[31m' Color_Off=$'\e[0m'

_have()    { command -v "$1" >/dev/null 2>&1 }
_log()     { print -r -- "${Green}==>${Color_Off} $*" }
_warn()    { print -u2 -r -- "${Yellow}[warn]${Color_Off} $*" }
_section() { print -r -- $'\n'"${Green}━━ $* ━━${Color_Off}" }

# End the widget with a fresh prompt, without executing the buffer contents.
# The currently typed buffer is saved first, then restored at the next prompt.
_zle_fresh_prompt() {
  [[ -n $BUFFER ]] && zle push-line
  zle accept-line
}

# ┏╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┓
# ╏                                    NEOVIM                                    ╏
# ┗╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┛

build-nvim() {
  [[ -n $PROJECTS_DIR ]] || { _warn "PROJECTS_DIR belum di-set"; return 1; }

  local dir="$PROJECTS_DIR/contrib/neovim"
  local prefix="$HOME/neovim"

  if [[ ! -d $dir/.git ]]; then
    git clone https://github.com/neovim/neovim.git "$dir" || return 1
  fi

  pushd -q "$dir" || return 1
  {
    _log "sync tag nightly"
    # `nightly` is a moving tag -> fetch --force.
    # `.deps` is preserved so dependencies aren't recompiled on every build.
    git fetch --tags --force --prune origin &&
      git checkout --force nightly &&
      git clean -fdx -e .deps &&
      make CMAKE_BUILD_TYPE=Release CMAKE_EXTRA_FLAGS="-DCMAKE_INSTALL_PREFIX=$prefix" ||
      return 1

    # The old install is only removed AFTER a successful build.
    rm -rf -- "$prefix"
    make install
  } always {
    popd -q
  }
}

# ┏╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┓
# ╏                                  INSTALLER                                   ╏
# ┗╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┛
#  Usage:  build-install            -> install only what's missing
#          build-install --update   -> upgrade everything
#
#  Note: `UPDATE` and `failed` are declared local in build-install and
#  used by the helpers below via zsh dynamic scoping.

# ├───────────────────────────────────┤ APT ├─────────────────────────────────┤
_install_apt() {
  _section "APT"

  # format: "binary=package [package...]"
  local -a table=(
    "curl=curl"
    "jq=jq"
    "xinput=xinput"                    # fix mouse lag
    "pass=pass"                        # password manager
    "urlview=urlview"
    "rg=ripgrep"
    "pamixer=pamixer"
    "sqlite3=sqlite3"
    "proxychains4=proxychains4"        # tor wrapper
    "btop=btop"                        # process monitor
    "toilet=toilet"                    # colored figlet
    "play=sox libsox-fmt-all"          # play sound from the terminal
    "hub=hub"                          # git cli extension
  )

  local -a missing=()
  local entry
  for entry in $table; do
    _have "${entry%%=*}" || missing+=( ${=entry#*=} )
  done

  # fd: on Debian/Ubuntu the binary is named `fdfind`
  _have fd || _have fdfind || missing+=( fd-find )

  if (( $#missing )); then
    _log "apt: $missing"
    sudo apt install -y $missing || failed+=( apt )
  fi

  if ! _have fd && _have fdfind; then
    mkdir -p "$HOME/.local/bin" &&
      ln -sf "$(command -v fdfind)" "$HOME/.local/bin/fd"
  fi
}

_install_gh() {
  _have gh && return 0
  _log "gh - GitHub CLI"

  local keyring=/usr/share/keyrings/githubcli-archive-keyring.gpg
  {
    curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg |
      sudo dd of=$keyring status=none &&
      sudo chmod go+r $keyring &&
      echo "deb [arch=$(dpkg --print-architecture) signed-by=$keyring] https://cli.github.com/packages stable main" |
      sudo tee /etc/apt/sources.list.d/github-cli.list >/dev/null &&
      sudo apt update &&
      sudo apt install -y gh
  } || failed+=( gh )
}

_install_newsboat() {
  _have newsboat && return 0

  local script="$HOME/.config/miscxrdb/exbin/install-newsboat"
  if [[ ! -f $script ]]; then
    _warn "newsboat: $script not found"
    return 1
  fi

  _log "newsboat - RSS reader"
  bash "$script" || failed+=( newsboat )
}

# ══════════════════════ GitHub releases (direct binaries) ════════════════════
_gh_latest_tag() { # <owner/repo>
  curl -fsSL "https://api.github.com/repos/$1/releases/latest" | jq -r .tag_name
}

_install_resterm() {
  _have resterm && (( ! UPDATE )) && return 0
  _log "resterm - HTTP/GraphQL/gRPC client for the terminal"

  local tmp tag
  tmp=$(mktemp -d) || return 1

  tag=$(_gh_latest_tag unkn0wn-root/resterm) &&
    curl -fL -o "$tmp/resterm" \
      "https://github.com/unkn0wn-root/resterm/releases/download/${tag}/resterm_$(uname -s)_$(uname -m)" &&
    sudo install -m 0755 "$tmp/resterm" /usr/local/bin/resterm ||
    failed+=( resterm )

  rm -rf -- "$tmp"
}

_install_lazygit() {
  _have lazygit && (( ! UPDATE )) && return 0
  _log "lazygit - Git TUI"

  local arch tmp tag
  case $(uname -m) in
    x86_64)        arch=x86_64 ;;
    aarch64|arm64) arch=arm64 ;;
    *) _warn "lazygit: unsupported architecture ($(uname -m))"; return 1 ;;
  esac

  tmp=$(mktemp -d) || return 1

  tag=$(_gh_latest_tag jesseduffield/lazygit) &&
    curl -fL "https://github.com/jesseduffield/lazygit/releases/download/${tag}/lazygit_${tag#v}_Linux_${arch}.tar.gz" |
    tar xz -C "$tmp" lazygit &&
    sudo install -D -t /usr/local/bin "$tmp/lazygit" ||
    failed+=( lazygit )

  rm -rf -- "$tmp"
}

# ├───────────────────────────────┤ RUST / CARGO ├───────────────────────────────┤
# _cargo_ensure <binary> <description> <cargo install arguments...>
_cargo_ensure() {
  local bin=$1 desc=$2
  shift 2
  _have "$bin" && (( ! UPDATE )) && return 0

  _log "$bin - $desc"
  cargo install "$@" || failed+=( "$bin" )
}

_install_rust_tools() {
  _section "RUST (cargo)"
  if ! _have cargo; then
    _warn "cargo not found, skipping the Rust section"
    return 0
  fi

  _cargo_ensure bat         "cat with syntax highlighting"                bat
  _cargo_ensure viu         "terminal image viewer (fzf-lua dependency)"  viu
  _cargo_ensure rmpc        "MPD client (alternative to ncmpcpp)"         --git https://github.com/mierak/rmpc --locked
  _cargo_ensure gifski      "GIF encoder"                                 gifski
  _cargo_ensure dua         "disk usage (similar to du)"                  dua-cli
  _cargo_ensure procs       "ps replacement"                              procs
  _cargo_ensure eza         "colorful ls replacement"                     eza
  _cargo_ensure zoxide      "smarter cd"                                  zoxide --locked
  _cargo_ensure delta       "color pager for git diff"                    git-delta
  _cargo_ensure tclock      "TUI clock"                                   clock-tui
  _cargo_ensure tree-sitter "tree-sitter CLI for nvim"                    tree-sitter-cli
  _cargo_ensure yazi        "TUI file manager"                            --force --locked yazi-build

  # rust-analyzer: the `rust-analyzer` shim always exists even when the component
  # isn't installed, so check via rustup.
  if _have rustup && ! rustup component list --installed 2>/dev/null | grep -q '^rust-analyzer'; then
    _log "rust-analyzer - LSP Rust"
    rustup component add rust-analyzer || failed+=( rust-analyzer )
  fi

  _have asdf && asdf reshim rust
}

# ├────────────────────────────────────┤ GO ├────────────────────────────────────┤
# _go_ensure <binary> <description> <package@version>
_go_ensure() {
  local bin=$1 desc=$2 pkg=$3
  _have "$bin" && (( ! UPDATE )) && return 0

  _log "$bin - $desc"
  go install "$pkg" || failed+=( "$bin" )
}

_install_go_tools() {
  _section "GO"
  if ! _have go; then
    _warn "go not found, skipping the Go section"
    return 0
  fi

  _go_ensure dive       "explore docker layers"            github.com/wagoodman/dive@latest
  _go_ensure sesh       "tmux session management"          github.com/joshmedeski/sesh/v2@latest
  _go_ensure tock       "time tracking CLI"                github.com/kriuchkov/tock/cmd/tock@latest
  _go_ensure lazydocker "Docker TUI"                       github.com/jesseduffield/lazydocker@latest
  _go_ensure gowall     "wallpaper theme conversion (pywall)" github.com/Achno/gowall@latest
}

# ├──────────────────────────────┤ PYTHON / PIPX ├────────────────────────────┤
# _pipx_ensure <binary> <description> <package>
_pipx_ensure() {
  local bin=$1 desc=$2 pkg=$3

  if _have "$bin"; then
    (( UPDATE )) || return 0
    _log "$bin - upgrade"
    pipx upgrade "$pkg" || failed+=( "$bin" )
  else
    _log "$bin - $desc"
    pipx install "$pkg" || failed+=( "$bin" )
  fi
}

_install_python_tools() {
  _section "PYTHON (pipx)"

  if ! _have pipx; then
    if ! _have pip; then
      _warn "pip not found, skipping the Python section"
      return 0
    fi
    _log "pipx"
    pip install pipx || { failed+=( pipx ); return 1; }
    _have asdf && asdf reshim python
    hash -r
  fi

  _pipx_ensure calcure "TUI calendar"                                          calcure
  _pipx_ensure img2art "image/gif/video -> ascii art (snacks.nvim dashboard)"  img2art
  _pipx_ensure yt-dlp  "YouTube video downloader"                              yt-dlp

  _have asdf && asdf reshim python
}

# ├───────────────────────────────────┤ NPM ├─────────────────────────────────┤
_install_npm_tools() {
  _section "NPM"
  if ! _have npm; then
    _warn "npm not found, skipping the NPM section"
    return 0
  fi

  # format: "binary=package"
  local -a table=(
    "mmdc=@mermaid-js/mermaid-cli"   # mermaid for nvim
    "cronstrue=cronstrue"            # cron expression -> text
    "yarn=yarn"
  )

  local -a pkgs=()
  local entry
  for entry in $table; do
    if (( UPDATE )) || ! _have "${entry%%=*}"; then
      pkgs+=( "${entry#*=}" )
    fi
  done

  if (( $#pkgs )); then
    _log "npm: $pkgs"
    npm install -g $pkgs || failed+=( npm )
    _have asdf && asdf reshim nodejs
  fi
}

# ╓──────────────────────────────────────────────────────────────────────────────╖
# ║                                 ENTRY POINT                                  ║
# ╙──────────────────────────────────────────────────────────────────────────────╜
build-install() {
  local UPDATE=0
  [[ $1 == (-u|--update) ]] && UPDATE=1
  local -a failed=()

  _install_apt
  _install_gh
  _install_newsboat
  _install_resterm
  _install_lazygit
  _install_rust_tools
  _install_go_tools
  _install_python_tools
  _install_npm_tools

  print
  if (( $#failed )); then
    _warn "Failed: ${(j:, :)failed}"
    return 1
  fi
  _log "Done"
}

# ┏╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┓
# ╏                               SCAFFOLD PROJECT                               ╏
# ┗╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┛

# _require_arg <nama-fungsi> <argumen>
_require_arg() {
  [[ -n $2 ]] && return 0
  print -u2 -r -- "${Red}You must provide a project name${Color_Off}"$'\n'"Example: '$1 <project-name>'"
  return 1
}

build-python() {
  _require_arg build-python "$1" || return 1
  uv init "$1" && cd -- "$1"
}

build-react() {
  _require_arg build-react "$1" || return 1
  git clone --depth=1 https://github.com/mrowegawd/react-starter.git "$@"
}

build-go() {
  _require_arg build-go "$1" || return 1
  mkdir -p -- "$1" && cd -- "$1" && go mod init "$1"
}

# ┏╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┓
# ╏                                 ZLE WIDGETS                                  ╏
# ┗╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┛

# ├────────────────────┤ <Alt-o>  jump to the marked folder ├────────────────────┤
run-mark() {
  local marks="$HOME/Dropbox/data.programming.forprivate/marked-pwd"
  if [[ -n $WSL_DISTRO_NAME || ${(L)$(</proc/version)} == *microsoft* ]]; then
    marks="/mnt/c/Users/moxli/Dropbox/data.programming.forprivate/marked-pwd"
  fi

  if [[ ! -f $marks ]]; then
    print -u2 -r -- "[warn] path not found: $marks"
    _zle_fresh_prompt
    return
  fi

  local choice
  choice=$(
    fzf --height=60% --prompt "Jump to> " \
      --preview 'eza --long --all --git --color=always --group-directories-first --icons {1}' \
      --preview-window right:50%:nohidden < "$marks"
  )

  if [[ -n $choice ]]; then
    if [[ -d $choice ]]; then
      cd -- "$choice"
    elif _have notify-send; then
      notify-send "invalid folder path:" "$choice"
    else
      _warn "invalid folder path: $choice"
    fi
  fi

  _zle_fresh_prompt
}
zle -N run-mark
bindkey '^[o' run-mark

# ├─────┤ <Ctrl-z>  empty buffer -> fg, non-empty buffer -> save it first ├───┤
fg-bg() {
  if [[ -n $BUFFER ]]; then
    zle push-input
  elif (( $#jobstates )); then
    BUFFER=fg
    zle accept-line
  else
    zle -M "no current job"
  fi
}
zle -N fg-bg
bindkey '^z' fg-bg

# ├──────────────────────────────┤ <Alt-x>  exit ├────────────────────────────┤
exitme() {
  BUFFER=exit
  zle accept-line
}
zle -N exitme
bindkey '^[x' exitme

# ├─┤ <Ctrl-g>  grep file contents (rg + fzf), then open in nvim at that line ├┤
find-in-file() {
  local sel
  sel=$(
    rg --color=always --line-number --hidden --no-heading --smart-case \
      --glob '!.git/' -- "${@:-.}" |
      fzf --ansi --exact --delimiter=: --with-nth=1,3.. \
        --prompt='Grep In File> ' --height=50% \
        --preview 'bat --style=numbers --color=always --highlight-line {2} {1}' \
        --preview-window='50%,+{2}+3/3,~3'
  )

  if [[ -n $sel ]]; then
    local file=${sel%%:*}
    local line=${${sel#*:}%%:*}
    nvim "+$line" -- "$file"
  fi

  _zle_fresh_prompt
}
zle -N find-in-file
bindkey '^g' find-in-file

# ┏╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┓
# ╏                                TAB DISPATCHER                                ╏
# ┗╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┛

# CREDIT: https://github.com/kevinhwang91/dotfiles/blob/main/zsh/lplug/fzf/fzf-completion-widget
# _fps [separator]  -> PID terpilih, dipisah separator (default: spasi)
_fps() {
  local sep=${1:- }
  local -a filter=(cat) fzf_opts=()
  if _have grcat; then
    filter=(grcat fps.grc)
    fzf_opts=(--ansi)
  fi

  local -a pids=( ${(f)"$(
    ps -eo user,pid,ppid,pgid,stat,command |
      awk '
        BEGIN { "ps -p $$ -o pgid=" | getline pgid; gsub(/[[:blank:]]/, "", pgid) }
        { if ($4 != pgid || $2 == pgid) print }
      ' |
      $filter |
      fzf --header-lines=1 -m --height=60% --min-height=15 --tac --reverse $fzf_opts |
      awk '{ print $2 }'
  )"} )

  local IFS=$sep
  print -rn -- "${pids[*]}"
}

# Git aliases -> alias names.
# (`-p 80%` = popup; make sure your `fzf` supports it / fzf-tmux wrapper)
_pick_git_alias() {
  git config --get-regexp '^alias\.' 2>/dev/null |
    awk '{ name = substr($1, 7); $1 = ""; printf "%-20s => %s\n", name, substr($0, 2) }' |
    fzf -p 80% |
    awk '{ print $1 }'
}

# Taken from: https://github.com/pierpo/fzf-docker/blob/913bc66e79d863b324065c1e840860fc79f900cb/fzf-docker.plugin.zsh
# _pick_docker container|image  -> ID (one per line)
_pick_docker() {
  case $1 in
    container)
      docker ps -a --format "table {{.ID}}\t{{.Names}}\t{{.Status}}\t{{.Image}}"
      ;;
    image)
      docker images --format "table {{.ID}}\t{{.Repository}}:{{.Tag}}\t{{.Size}}\t{{.CreatedSince}}"
      ;;
  esac | fzf --multi --height=40% --header-lines=1 | awk '{ print $1 }'
}

# Functions in aliases.bashrc (those starting with a comment line) -> function names.
_pick_alias_func() {
  local file="$HOME/.config/bashrc/aliases.bashrc"
  [[ -r $file ]] || return 1

  awk '
    /\(\)/ && last {
      name = $1; sub(/\(\).*/, "", name)
      desc = last; sub(/^#[[:space:]]*/, "", desc)
      printf "%-24s %s\n", name, desc
    }
    { last = "" }
    /^#/ { last = $0 }
  ' "$file" | fzf --exit-0 --ansi | awk '{ print $1 }'
}

# Capture the output of `_t_expand_alias` (if any) into $REPLY without
# a subshell, so that `unfunction` actually takes effect in the main shell.
_t_expand_alias_f() {
  if (( $+functions[_t_expand_alias] )); then
    REPLY=${functions[_t_expand_alias]#$'\t'}
    unfunction _t_expand_alias
  else
    REPLY=$1
  fi
}

# ├──────────────────────────────────┤ WIDGET ├──────────────────────────────────┤
show_alias() {
  setopt localoptions noglobsubst noposixbuiltins pipefail no_aliases 2>/dev/null

  _t_expand_alias_f "$LBUFFER"
  local -a words=( ${(z)REPLY} )
  local last=${words[-1]} prev=${words[-2]} picked ids

  if [[ $last == -p ]]; then
    # select a process PID
    picked=$(_fps ",")
    [[ -n $picked ]] && LBUFFER+="$picked "

  elif [[ $prev == alias ]]; then
    # `git alias <Tab>` -> pick a git alias
    picked=$(_pick_git_alias)
    [[ -n $picked ]] && LBUFFER="git $picked "

  elif [[ $last == doc_con_??* ]]; then
    # `doc_con_*` tokens -> replaced with the selected container ID
    picked=$(_pick_docker container)
    if [[ -n $picked ]]; then
      ids=${(j: :)${(f)picked}}
      LBUFFER="${LBUFFER%"$last"}$ids "
    fi

  elif [[ $last == doc_im_??* ]]; then
    # `doc_im_*` tokens -> replaced with the selected image ID
    picked=$(_pick_docker image)
    if [[ -n $picked ]]; then
      ids=${(j: :)${(f)picked}}
      LBUFFER="${LBUFFER%"$last"}$ids "
    fi

  elif [[ -z $last ]]; then
    # empty buffer -> pick a function from aliases.bashrc
    picked=$(_pick_alias_func)
    [[ -n $picked ]] && LBUFFER+="$picked "

  else
    # default: regular completion (fzf-tab)
    if (( $+functions[fzf-tab-complete] )); then
      fzf-tab-complete
    else
      zle expand-or-complete
    fi
    return
  fi

  zle reset-prompt
}
zle -N show_alias
bindkey '\t' show_alias # <Tab>
