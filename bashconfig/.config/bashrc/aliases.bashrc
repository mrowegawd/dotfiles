# ----------------------------------------
#░█▀█░█░░░▀█▀░█▀█░█▀▀░█▀▀░█▀▀░░░░█▀▄░█▀▀ +
#░█▀█░█░░░░█░░█▀█░▀▀█░█▀▀░▀▀█░░░░█▀▄░█░░ +
#░▀░▀░▀▀▀░▀▀▀░▀░▀░▀▀▀░▀▀▀░▀▀▀░▀░░▀░▀░▀▀▀ +
# ----------------------------------------

# cd to .. ... .... .....
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias l="ls -CF --color=auto"
alias grep="grep --color=auto"
alias rg="rg --hidden"

alias c="bat "

alias ls="/bin/ls -nphq --time-style=iso --color=auto\
  --group-directories-first --show-control-chars"


# if command -v exa > /dev/null; then
alias ll="exa -lhaa"
# else
#     alias ll="ls -lah -nphq --time-style=iso --color=auto\
#         --group-directories-first --show-control-chars"
# fi

alias :q!=exitq
alias :Q!=exitq
alias :c=exit
alias :C=exit
alias :c!=exit
alias :C!=exit

cdls() { cd "$@" && ll ; }

if [ "${USER}" = "root" ]; then
  alias v="vim"
  alias sv="sudo vim"
  alias ttext='vim /tmp/dump_text.txt'
  alias tbash='vim /tmp/dump_bash.sh'
else
  if command -v nvim > /dev/null; then
    alias v="nvim"
    alias svi="sudo nvim"
    alias ttext='nvim /tmp/dump_text.txt'
    alias tbash='nvim /tmp/dump_bash.sh'
  else
    alias v="vim"
    alias sv="sudo vim"
    alias ttext='vim /tmp/dump_text.txt'
    alias tbash='vim /tmp/dump_bash.sh'
  fi
fi


if command -v emacs > /dev/null; then
  alias e="emacs --insecure"
fi

# check: check chkmyinstall
c_myinstall() {
  bash ~/moxconf/exbin/for-local-bin/chkmyinstall
}

# check: boot message
c_bootmsg() {
  echo -n Boot Messages | pv -qL 10 && sudo journalctl -b | ccze -A
}

# check: check systemd boot-up performance statistic
c_blame() {
  systemd-analyze blame
}

# check: check units what they loaded
c_units() {
  echo -n '\e[1;32mListing Units:\e[0m ' | pv -qL 10 && systemctl list-units
}


# check: usage bencweb <url>
c_bencweb() {
  curl -s -w 'Testing Website Response Time for:%{url_effective}\n\nLookup Time:\t\t%{time_namelookup}\nConnect Time:\t\t%{time_connect}\nPre-transfer Time:\t%{time_pretransfer}\nStart-transfer Time:\t%{time_starttransfer}\n\nTotal Time:\t\t%{time_total}\n' -o /dev/null "$1"
}

# check: users getent passwd
c_user() {
  getent passwd | awk -F ':' '\
    BEGIN {
      print "======================================================================================"
      printf "%-20s %-10s %-10s %-30s %-10s\n", "USER", "UID", "GUID", "HOME", "SHELL"
      print "======================================================================================"
    }
  {printf "%-20s %-10d %-10d %-30s %-10s\n", $1, $3, $4, $6,  $NF}
  '
}

# check: octal permission current dir. ex: 633 /path
c_lsmod() {
  ls -lah | awk -F ' ' '{print $NF}' | xargs stat -c "%a %n"
}

# check: we are chrooted?
c_chroot() {
  if [ "$(stat -c %d:%i /)" != "$(stat -c %d:%i /proc/1/root/.)" ]; then
    echo "We are chrooted!";
  else
    echo "Business as usual";
  fi
}

# check: current host related info
c_ii() {
  NC='\033[0m'              # No Color

  RED='\033[0;31m'          # Red
  echo -e "\n${RED}Kernel Information:$NC " ; uname -a
  echo -e "\n${RED}Users logged on:$NC " ; w -h
  echo -e "\n${RED}Current date :$NC " ; date
  echo -e "\n${RED}Machine stats :$NC " ; uptime
  echo -e "\n${RED}Memory stats :$NC " ; free
  echo -e "\n${RED}Disk Usage :$NC " ; df -Th
  echo -e "\n${RED}LAN Information :$NC" ; c_lan
}

# check: netinfo - check LAN network information for your system (part of ii)
c_lan() {
  if command -v ifconfig > /dev/null ; then
    echo "---------------------------------------------------"
    /sbin/ifconfig enp0s31f6 | awk /'inet/ {print $2}'
    /sbin/ifconfig enp0s31f6 | awk /'bcast/ {print $3}'
    /sbin/ifconfig enp0s31f6 | awk /'inet6 addr/ {print $1,$2,$3}'
    /sbin/ifconfig enp0s31f6 | awk /'HWaddr/ {print $4,$5}'
    echo "---------------------------------------------------"
  elif command -v ip > /dev/null ; then
    echo "---------------------------------------------------"
    ip a show enp0s31f6 | awk /'inet/ {print $2}'
    ip a show enp0s31f6 | awk /'bcast/ {print $3}'
    ip a show enp0s31f6 | awk /'inet6 addr/ {print $1,$2,$3}'
    ip a show enp0s31f6 | awk /'HWaddr/ {print $4,$5}'
    echo "---------------------------------------------------"
  fi
}

# check: check size file $1
c_sizefile() {
  if [ ! -z "$1" ]; then
    sudo du -a "$1" 2>/dev/null | sort -n -r | head -n 20 | awk -F" " '{printf "%-15s %-10s\n",$1,$2}'
  else
    echo "warn - you need set path!!"
  fi

}

# check: check os
c_os() {
  if [ -f /etc/os-release ]; then
    # freedesktop.org and systemd
    . /etc/os-release
    OS=$NAME
    VER=$VERSION_ID
  elif type lsb_release >/dev/null 2>&1; then
    # linuxbase.org
    OS=$(lsb_release -si)
    VER=$(lsb_release -sr)
  elif [ -f /etc/lsb-release ]; then
    # For some versions of Debian/Ubuntu without lsb_release command
    . /etc/lsb-release
    OS=$DISTRIB_ID
    VER=$DISTRIB_RELEASE
  elif [ -f /etc/debian_version ]; then
    # Older Debian/Ubuntu/etc.
    OS=Debian
    VER=$(cat /etc/debian_version)
    # elif [ -f /etc/SuSe-release ]; then
    #     # Older SuSE/etc.
    #     ...
    # elif [ -f /etc/redhat-release ]; then
    # Older Red Hat, CentOS, etc.
  else
    # Fall back to uname, e.g. "Linux <version>", also works for BSD, etc.
    OS=$(uname -s)
    VER=$(uname -r)
  fi
  echo "OS        : $OS"
  echo "version   : $VER"

}

# download: youtube $1
d_ytdl() {
  tsp youtube-dl --output "$(date +%s)-%(uploader)s%(title)s.%(ext)s" "$1";
}

# download: youtube mp3 $1
d_ytmp3() {
  tsp youtube-dl --extract-audio --audio-format mp3 "$1"
}

# runtask: hapus file all $1
r_hapus() {
  find "$1" -type f -name "*" -exec shred -v -n 25 -u -z {} \;
}

# runtask: open ranger
r_r() {
  ranger
}

# runtask: open tmux
alias r_m="tmux -2"

# runtask: tmux at
alias r_mat="r_m a -t"

# runtask: run calculator with python
r_calc() {
  python -ic "from __future__ import division; from math import *; from random import *"
}

# runtask: extract file $1
r_extract() {
  if [ -f "$1" ] ; then
    case "$1" in
      *.tar.bz2)   tar xvjf $1    ;;
      *.tar.gz)    tar xvzf $1    ;;
      *.tar.xz)    tar xf $1      ;;
      *.bz2)       bunzip2 $1     ;;
      *.rar)       unrar e -r $1  ;;
      *.gz)        gunzip $1      ;;
      *.tar)       tar xvf $1     ;;
      *.tbz2)      tar xvjf $1    ;;
      *.tgz)       tar xvzf $1    ;;
      *.zip)       unzip $1       ;;
      *.Z)         uncompress $1  ;;
      *.7z)        7z x $1        ;;
      *)           echo "don't know how to extract '$1'..." ;;
    esac
  else
    echo "'$1' is not a valid file!"
  fi
}

# runtask: run newsboat
r_news() {
  if [ "$TERM" =~ "tmux".* ] || [ "$TERM" =~ "screen" ]; then
    tmux new-window && tmux rename-window 'newsboat' \
      && tmux send-keys 'newsboat && tmux kill-pane' enter
        else
          newsboat
  fi
}

# runtask: run pomo $1
r_pom() {
  # to kill file sock use -S flag
  if [ -S ~/.pomo/pomo.sock ]; then
    rm -rf ~/.pomo/pomo.sock
  fi
  if [ "$1" == "" ] || [ "$2" == "" ] || [ "$3" == "" ]; then
    # pomo start --tag myprokect --duration 5s --pomodoros 2 "write some commment"
    echo "Error: [!] args kurang juragan.."
    echo ""
    echo "Example: r_pomo \"myproject web 1\" 2s 3 \"membersihkan bug di js\""
    return
  elif [ "$TERM" =~ "tmux".* ] || [ "$TERM" =~ "screen" ]; then
    if tmux list-window | grep mypomo > /dev/null; then
      tmuxWindowName=$(tmux list-windows | grep mypomo | cut -d: -f1)
      tmux kill-window -t "$tmuxWindowName"
    fi
    tmux new-window && tmux rename-window 'mypomo' \
      && tmux send-keys "pomo start --tag \"$1\" --duration \"$2\" --pomodoros \"$3\" \"$4\" && tmux kill-pane" enter
        else
          pomo start --tag "$1" --duration "$2" --pomodoros "$3" "$4"
  fi
}

# runtask: multitail
r_logsys() {
  if [ "$TERM" =~ "tmux".* ] || [ "$TERM" =~ "screen" ]; then
    if tmux list-window | grep logging > /dev/null; then
      tmuxWindowName=$(tmux list-windows | grep logging | cut -d: -f1)
      tmux kill-window -t "$tmuxWindowName"
    fi
    tmux new-window && tmux rename-window "logging" \
      && tmux send-keys "sudo multitail -s 2 /var/log/syslog /var/log/auth.log /var/log/kern.log && tmux kill-pane" enter
        else
          sudo multitail -s 2 /var/log/syslog /var/log/auth.log /var/log/kern.log
  fi
}


# Use FZF to switch Tmux sessions:
# bind-key s run "tmux new-window 'bash -ci fs'"
fs() {
  local -r fmt='#{session_id}:|#S|(#{session_attached} attached)'
    { tmux display-message -p -F "$fmt" && tmux list-sessions -F "$fmt"; } \
      | awk '!seen[$1]++' \
      | column -t -s'|' \
      | fzf -q '$' --reverse --prompt 'switch session: ' -1 \
      | cut -d':' -f1 \
      | xargs tmux switch-client -t
    }

# runtask: run for-local-bin/proj script
r_proj() {
  ~/moxconf/exbin/for-local-bin/proj
}

# runtask: run generate password key
r_passkeygen() {
  if command -v whois > /dev/null; then
    printf "##### GENERATE PASSWORD ###########\n\n"
    PATHTEMP=$(mktemp -d)
    if [ ! -n "$TMUX" ]; then
      read -p "your password? " getvar
    else
      read "getvar?your password? "
    fi
    mkpasswd -m sha-512 "$getvar" > "$PATHTEMP/mypass_SHA512_$(date +%F)"
    echo "$getvar" > "$PATHTEMP/mypass_$(date +%F)"
    printf "%s $PATHTEMP\n" "store pass path:"
  else
    clear
    echo "package whois not found! let me install it.."
    sudo apt install whois -y
    sleep 1
    clear
    echo "run 'r-passkeygen'"
  fi
}

# runtask: run generate ssh key
r_sshkeygen() {
  echo "##### GENERATE SSH ###########"
  echo ""
  if [ ! -n "$TMUX" ]; then
    read -p "some comments for new sshgen? " commentme
    read -p "prefix ~/.ssh/_your_prefix? " prefixfile
  else
    read "commentme?some comments for new sshgen? "
    read "prefixfile?prefix ~/.ssh/_your_prefix? "
  fi

  ssh-keygen -t rsa -b 4096 -C "$commentme" \
    -f "$HOME/.ssh/$prefixfile$(date +%F)"
  }

# runtask: remove comment string file.conf/else
r_uncommentfile() {
  sudo cat "$1" | sed '/^#.*$/d;/^;.*$/d';
}

# runtask: find string vimwiki file with $1
r_vimwk() {
  WIKIPATH="$HOME/moxconf/vimwiki"
  [[ ! -d "$WIKIPATH" ]] && echo "no found $WIKIPATH" && exit 1
  [[ ! "$#" -gt 0 ]] && echo "[!] sorry, can't find. you need a keyword bro !!" && exit 1
  cd "$WIKIPATH"
  address=$(rg --files-with-matches --no-messages "$1" |
    fzf --preview "highlight -O ansi -l {} 2> /dev/null | rg --colors 'match:bg:yellow' --ignore-case --pretty --context 10 '$1' || rg --ignore-case --pretty --context 10 '$1' {}")

  [[ -z "$address" ]] && echo "no found" && exit 1
  nvim "$WIKIPATH/$address"
}

# ps ls
t_ps-ls() {
PROC_ID_ORIGIN=$(ps -alf | fzf )
if [[ $(echo "$PROC_ID_ORIGIN" | grep "UID[[:blank:]]*PID")x == ""x ]]; then
  PROC_ID=$(echo "$PROC_ID_ORIGIN" | grep -o '^[^[:blank:]]*[[:blank:]]*[^[:blank:]]*[[:blank:]]*[^[:blank:]]*[[:blank:]]*[^[:blank:]]*' | grep -o '[[:digit:]]*$')
  echo "$PROC_ID_ORIGIN"
fi
}

# ps ls all
t_ps-ls-all() {
PROC_ID_ORIGIN=$(ps -elf | fzf )
if [[ $(echo "$PROC_ID_ORIGIN" | grep "UID[[:blank:]]*PID")x == ""x ]]; then
  PROC_ID=$(echo "$PROC_ID_ORIGIN" | grep -o '^[^[:blank:]]*[[:blank:]]*[^[:blank:]]*[[:blank:]]*[^[:blank:]]*[[:blank:]]*[^[:blank:]]*' | grep -o '[[:digit:]]*$')
  echo "$PROC_ID_ORIGIN"
fi
}

# ps info
t_ps-info() {
PROC_ID_ORIGIN=$(ps -alf | fzf )
if [[ $(echo "$PROC_ID_ORIGIN" | grep "UID[[:blank:]]*PID")x == ""x ]]; then
  PROC_ID=$(echo "$PROC_ID_ORIGIN" | grep -o '^[^[:blank:]]*[[:blank:]]*[^[:blank:]]*[[:blank:]]*[^[:blank:]]*[[:blank:]]*[^[:blank:]]*' | grep -o '[[:digit:]]*$')
  top -p "$PROC_ID"
fi
}

# ps info all
t_ps-info-all() {
PROC_ID_ORIGIN=$(ps -elf | fzf )
if [[ $(echo "$PROC_ID_ORIGIN" | grep "UID[[:blank:]]*PID")x == ""x ]]; then
  PROC_ID=$(echo "$PROC_ID_ORIGIN" | grep -o '^[^[:blank:]]*[[:blank:]]*[^[:blank:]]*[[:blank:]]*[^[:blank:]]*[[:blank:]]*[^[:blank:]]*' | grep -o '[[:digit:]]*$')
  top -p "$PROC_ID"
fi
}

# ps tree
t_ps-tree() {
PROC_ID_ORIGIN=$(ps -alf | fzf )
if [[ $(echo "$PROC_ID_ORIGIN" | grep "UID[[:blank:]]*PID")x == ""x ]]; then
  PROC_ID=$(echo "$PROC_ID_ORIGIN" | grep -o '^[^[:blank:]]*[[:blank:]]*[^[:blank:]]*[[:blank:]]*[^[:blank:]]*[[:blank:]]*[^[:blank:]]*' | grep -o '[[:digit:]]*$')
  pstree -p "$PROC_ID"
fi
}

# ps tree all
t_ps-tree-all() {
PROC_ID_ORIGIN=$(ps -elf | fzf )
if [[ $(echo "$PROC_ID_ORIGIN" | grep "UID[[:blank:]]*PID")x == ""x ]]; then
  PROC_ID=$(echo "$PROC_ID_ORIGIN" | grep -o '^[^[:blank:]]*[[:blank:]]*[^[:blank:]]*[[:blank:]]*[^[:blank:]]*[[:blank:]]*[^[:blank:]]*' | grep -o '[[:digit:]]*$')
  pstree -p "$PROC_ID"
fi
}

# ps kill
t_ps-kill() {
PROC_ID_ORIGIN=$(ps -alf | fzf )
if [[ $(echo "$PROC_ID_ORIGIN" | grep "UID[[:blank:]]*PID")x == ""x ]]; then
  PROC_ID=$(echo "$PROC_ID_ORIGIN" | grep -o '^[^[:blank:]]*[[:blank:]]*[^[:blank:]]*[[:blank:]]*[^[:blank:]]*[[:blank:]]*[^[:blank:]]*' | grep -o '[[:digit:]]*$')
  kill -9 "$PROC_ID"
fi
}

# ps kill
t_ps-kill-all() {
PROC_ID_ORIGIN=$(ps -elf | fzf )
if [[ $(echo "$PROC_ID_ORIGIN" | grep "UID[[:blank:]]*PID")x == ""x ]]; then
  PROC_ID=$(echo "$PROC_ID_ORIGIN" | grep -o '^[^[:blank:]]*[[:blank:]]*[^[:blank:]]*[[:blank:]]*[^[:blank:]]*[[:blank:]]*[^[:blank:]]*' | grep -o '[[:digit:]]*$')
  kill -9 "$PROC_ID"
fi
}

# show size current dir
alias s_ducks='sudo du -cks * | sort -rn | head -11'

s_memuse(){
  ps -eo size,pid,user,command --sort -size | \
      awk '{ hr=$1/1024 ; printf("%13.2f Mb ",hr) } { for ( x=4 ; x<=NF ; x++ ) { printf("%s ",$x) } print "" }' |\
      cut -d "" -f2 | cut -d "-" -f1  | less
}

# show  listening port
alias s_netlist="sudo netstat -nltn"

# show netstat with name and pid
alias s_netlistpn="sudo netstat -nltpna"
alias s_netlistssh="sudo netstat -tpn"
alias s_netlistsshed="sudo netstat -ntpa | grep 'ESTABLISHED'"

# show IPTABLES
alias s_ipv="sudo iptables -L -n -v --line-numbers"
alias s_ipvnat="sudo iptables -L -n -v --line-numbers -t nat"

# check: interface inet
s_ethoip() {
  ifconfig -a | awk '/^[a-z]/ { iface=$1; mac=$NF; next }
  /inet addr:/ { print iface, mac }'
}

# show system
alias s_disks='echo "╓───── m o u n t . p o i n t s"; echo "╙────────────────────────────────────── ─ ─ "; lsblk -a; echo ""; echo "╓───── d i s k . u s a g e"; echo "╙────────────────────────────────────── ─ ─ "; df -h; echo ""; echo "╓───── U.U.I.D.s"; echo "╙────────────────────────────────────── ─ ─ "; lsblk -f;'

# show errors jurnalrc
alias s_jurnalerr="echo -n '\e[1;32mJournal Errors:\e[0m ' | pv -qL 10 && journalctl -b -p err | ccze -A"

# watch: mpv with args $1 or $1 $2 $3 ($1 $2 geometry)
w_mpvlol() {


  if [ "$#" -gt 1 ]; then
    tsp mpv -ontop -no-border -force-window \
      --autofit="$1"x"$2" --geometry=-15-60 "$3"
        else
          tsp mpv --ontop --no-border --force-window \
            --autofit=700x300 --geometry=-15-60 "$1"

          echo ""
          echo "Example: w_mpvlol 1000 300 link_youtube"
          echo "\t or w_mpvlol link_youtube"
          echo ""
  fi
}

# misc: create folder if not exist and run 'cd' to it
mdg() {
  mkdir -p "$@" && cd "$@"
}

# misc: create folder if not exist
md() {
  mkdir -p "$@"
}

# misc: create minimal tmux split pane
iide() {
  # check if tmux ses exists
  printf "..launch ide: "
  if [ ! -z $TMUX ]; then
    tmux split-window -v -p 34
    tmux split-window -h -p 66
    tmux split-window -h -p 34
    tmux rename-window 'ide'
    echo "Done"
  else
    echo "Tmux session off !!"
  fi
}

# snippet code command
# https://articles.engineers.my/golang-profiling-and-handling-http-disconnection/
# snippet cpu usege for go-build

# go: go mod init $1
go_modinit() {
  if [ ! -z "$1" ]; then
    go mod init "$1"
  else
    echo "warn - [go init mod] need args, ex: go_modinit projectname | github.com/projectname "
  fi
}

# go: go run $1
go_run() {
  if [ ! -z "$1" ]; then
    go run "$1"
  else
    echo "warn - [go run] need args, ex: go_run main.go"
  fi
}

# go: go build
go_build() {
  ps -A -o %cpu -o args | grep -i go-build
}

# go: go install
go_install() {
  go install
}

# go: go get $1
go_get() {
  if [ ! -z "$1" ]; then
    go get "$1"
  else
    echo "warn - [go get ] need args, ex: go_get url_github"
  fi
}

# go: go test
go_test() {
  go test
}

# go: go test -cover
go_cover() {
  go test -cover
}

# go: go test -coverprofile $1
go_coverfile() {
  if [ ! -z "$1" ]; then
    go test -coverprofile="$1"
  else
    echo "warn - [go test coverprofile] need args, ex: go_coverfile cover.out"
  fi
}

# go: go test -bench
go_bench() {
  go test -bench .
}

# go: go test -bench $1
go_benchcpu() {
  if [ ! -z "$1" ]; then
    go test -bench . -benchmem -cpuprofile "$1"
  else
    echo "warn - [go test benchmark profiling cpu] need args, ex: go_benchcpu prof.cpu"
  fi
}

# go: go test -benchmem $1
go_benchmem() {
  if [ ! -z "$1" ]; then
    go test -bench . -bechmem -memprofile "$1"
  else
    echo "warn - [go test benchmark profiling mem] need args, ex: go_benchmem prof.mem"
  fi
}

alias py_pipl="pip list --format=columns"
alias py_pips="pip show"
alias py_pudb="python -m pudb"

alias py_sourcesme="source ./.venv/bin/activate"

alias npm_gout="npm -g outdated"
alias npm_gupdated="npm -g update"
alias npm_list="npm list -g --depth 0"
alias npm_inst="npm install --save-dev"

# Info -> https://github.com/junegunn/fzf/wiki/examples#opening-files

# fzf: open files
fz_o() {
  local files
  IFS=$f'\n' files=($(fzf-tmux --query="$1" --multi --select-1 --exit-0))
  [[ -n "$files" ]] && ${EDITOR:-nvim} "${files[@]}"
}

# fzf: go to directory
fz_d() {
  local dir
  dir=$(find ${1:-.} -path '*/\.*' -prune \
    -o -type d -print 2> /dev/null | fzf +m) &&
    cd "$dir"
  }

# fzf: open with vim everywhere
fz_ov() {
  local files
  files=(${(f)"$(locate -Ai -0 "$@" | grep -z -vE '~$' | fzf --read0 -0 -1 -m)"})

  if [[ -n $files ]]
  then
    nvim -- $files
    print -l $files[1]
  fi
}

# fzf: call repeat history
fz_his() {
  eval $( ([ -n "$ZSH_NAME" ] && fc -l 1 || history) | fzf +s --tac | sed 's/ *[0-9]* *//')
}

# fzf: kill pid
fz_kill() {
  local pid
  pid=$(ps -ef | sed 1d | fzf -m | awk '{print $2}')

  if [ "x$pid" != "x" ]
  then
    echo $pid | xargs kill -${1:-9}
  fi
}


fz_sm() {
  local -r fmt='#{session_id}:|#S|(#{session_attached} attached)'
    { tmux display-message -p -F "$fmt" && tmux list-sessions -F "$fmt"; } \
      | awk '!seen[$1]++' \
      | column -t -s'|' \
      | fzf -q '$' --reverse --prompt 'switch session: ' -1 \
      | cut -d':' -f1 \
      | xargs tmux switch-client -t
    }

  fz_mx() {
    SELECTED_PROJECTS=$(tmuxinator list -n |
      tail -n +2 |
      fzf --prompt="Project: " -m -1 -q "$1")

    if [ -n "$SELECTED_PROJECTS" ]; then
      # Set the IFS to \n to iterate over \n delimited projects
      IFS=$'\n'

      # Start each project without attaching
      for PROJECT in $SELECTED_PROJECTS; do
        tmuxinator start "$PROJECT" --no-attach # force disable attaching
      done

      # If inside tmux then select session to switch, otherwise just attach
      if [ -n "$TMUX" ]; then
        SESSION=$(tmux list-sessions -F "#S" | fzf --prompt="Session: ")
        if [ -n "$SESSION" ]; then
          tmux switch-client -t "$SESSION"
        fi
      else
        tmux attach-session
      fi
    fi
  }

# More guide, check
# https://gist.github.com/bradtraversy/89fad226dc058a41b596d586022a9bd3

# image: docker images
doc_im_ls() {
  docker images
}

# image: check histroy docker image wiht id $1
doc_im_his_id() {
  if [ ! -z "$1" ]; then
    docker history "$1"
  else
    echo "warn - [docker history image] need image_id"
  fi
}

# image: build images with id $1
doc_im_build_tagname() {
  if [ ! -z "$1" ]; then
    docker build -t "$1" .
  else
    echo "warn - [docker build] you need tag, seperti name_img:latest"
  fi
}

# image: remove all images
doc_im_rall() {
  # remove all images
  docker rmi -f "$(docker images -q)"
}

# image: remove docker image only contain 'none' images
doc_im_rnone() {
  docker rmi -f "$(docker images | grep '^<none>' | awk '{print $3}')"
}

# image: remove all dangling images
doc_im_rdang() {
  docker rmi -f "$(docker images -f 'dangling=true' -q)"
}

# image: remove docker image with id $1
doc_im_rid() {
  if [ ! -z "$1" ]; then
    docker rmi -f "$1"
  else
    echo "warn - [docker image] need image_id"
  fi
}

# container: show all list container
doc_con_ls() {
  docker ps -a
}

# container: docker run -it
doc_con_run_it() {
  if [ ! -z "$1" ]; then
    docker run -it "$1"
  else
    echo "warn - [docker image] need image_id"
  fi
}

# container: docker run -it --rm
doc_con_run_rmit() {
  if [ ! -z "$1" ]; then
    docker run -it --rm "$1"
  else
    echo "warn - [docker image] need image_id"
  fi
}

# container: inspect container with id $1
doc_con_inspect_id() {
  if [ ! -z "$1" ]; then
    docker container inspect "$1"
  else
    echo "warn - [docker inspect] need container_id"
  fi
}

# container: show list container with contain 'exited'
doc_con_showex() {
  docker container ls -a --filter status=exited --filter status=created
}

# container: check log container with id $1
doc_con_log_id() {
  if [ ! -z "$1" ]; then
    docker container logs "$1"
  else
    echo "[warn] doc_con_log: need container id"
  fi
}

# container: start container with id $1
doc_con_start_id() {
  if [ ! -z "$1" ]; then
    docker start "$1"
  else
    echo "[warn] doc_con_start_id: need container id"
  fi
}

# container: stop container with id $1
doc_con_stop_id() {
  if [ ! -z "$1" ]; then
    docker stop "$1"
  else
    echo "[warn] doc_con_stop_id: need container id"
  fi
}

# container: restart container with id $1
doc_con_restart_id() {
  if [ ! -z "$1" ]; then
    docker restart "$1"
  else
    echo "[warn] doc_con_restart_id: need container id"
  fi
}

# container: remove all container
doc_con_rall() {
  docker rm -f "$(docker ps -aq)"
}

# container: remove all container with id $1
doc_con_rid() {
  if [ ! -z "$1" ];then
    docker rm "$1"
  else
    echo "[warn] doc_con_rid: need container id"
  fi
}

# container: remove container with contain 'exit'
doc_con_rallex() {
  docker ps -a | grep Exit | cut -d ' ' -f 1 | xargs docker rm
}

# container: enter to container
doc_con_enter_id() {
  docker exec -it "$1" /bin/bash
}

# dvolume: check list of docker volume
doc_vol() {
  docker volume ls
}

# dvolume: remove all docker volume
doc_vol_rall() {
  docker volume rm "$(docker volume ls -qf dangling=true)"
}

# dvolume: remove docker volume with id $1
doc_vol_rid() {
  if [ ! -z "$1" ]; then
    docker volume rm "$1"
  else
    echo "[warn] doc_vol_rid: need volume id"
  fi
}

# dvolume: remove dangling volumes
doc_vol_rdang() {
  docker volume rm "$(docker volume ls -f dangling=true -q)"
}

# dvolume: inspect docker volume with id $1
doc_vol_inspect_id() {
  docker volume inspect "$1"
}

# dnetwork: show list docker network
doc_net_ls() {
  docker network ls
}

# dnetwork: remove all docker network
doc_net_rall() {
  docker network rm "$(docker network ls -q)"
}

# dcompose: list of docker compose
doc_comp_ps() {
  docker-compose ps
}

# dcompose: docker compose up -d
doc_comp_upd() {
  docker-compose up -d
}

# dcompose: docker compose down
doc_comp_down() {
  docker-compose down
}

# dcompose: docker compose stop
doc_comp_stop() {
  docker-compose stop
}

# dcompose: docker compose run or start
doc_comp_run() {
  docker-compose run
}

# dcompose: docker compose run or start --rm
doc_comp_run_rm() {
  docker-compose run --rm
}

r_run(){
  if cat package.json >/dev/null 2>&1; then
    scripts=$(cat package.json | jq .scripts | sed '1d;$d' | fzf --height 40%)

    if [[ -n $scripts ]]; then
      script_name=$(echo $scripts | awk -F ': ' '{gsub(/"/, "", $1); print $1}')

      yarn run "$script_name"
    else
      echo "Exit: You haven't selected any script"
    fi
  else
    echo "Error: There's no package.json"
  fi
}
