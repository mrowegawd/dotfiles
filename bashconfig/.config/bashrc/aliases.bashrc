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

# misc: create and cd/go to folder <$NEW_NAMEFOLDER>
mdg() {
  mkdir -p "$@" && cd "$@" || return
}

# misc: create folder if not exist
md() {
  mkdir -p "$@"
}

alias r_m="tmux -2"
alias r_mat="r_m a -t"

# show size current dir
alias s_ducks='sudo du -cks * | sort -rn | head -11'

cl() {
  last_dir="$(ls -Frt | grep '/$' | tail -n1)"
  if [ -d "$last_dir" ]; then
    cd "$last_dir" || return
  fi
}

alias c="bat "
alias logs="sudo find /var/log -type f -exec file {} \; | grep 'text' | cut -d' ' -f1 | sed -e's/:$//g' | grep -v '[0-9]$' | xargs tail -f"

alias ls="/bin/ls -nphq --time-style=iso --color=auto\
  --group-directories-first --show-control-chars"

# if command -v exa > /dev/null; then
alias ll="exa -lhaa"
# else
#     alias ll="ls -lah -nphq --time-style=iso --color=auto\
#         --group-directories-first --show-control-chars"
# fi
#
alias mpv_c="mpv --no-osc --profile=low-latency --untimed --geometry=-50-50 --autofit=40% --no-resume-playback "

alias :q!=exitq
alias :Q!=exitq
alias :c=exit
alias :C=exit
alias :c!=exit
alias :C!=exit

cdls() { cd "$@" && ll; }

if [ "${USER}" = "root" ]; then
  alias v="vim"
  alias sv="sudo vim"
  alias ttext='vim /tmp/dump_text.txt'
  alias tbash='vim /tmp/dump_bash.sh'
else
  if command -v nvim >/dev/null; then
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

if command -v emacs >/dev/null; then
  alias e="emacs --insecure"
fi

# check: get size of current directorys

c_size_cd() { du -b --max-depth 1 | sort -nr | perl -pe 's{([0-9]+)}{sprintf "%.1f%s", $1>=2**30? ($1/2**30, "G"): $1>=2**20? ($1/2**20, "M"): $1>=2**10? ($1/2**10, "K"): ($1, "")}e'; }

# check: size of the target path/file <$YOUR_PATH>
c_size_tfile() {
  if [ ! -z "$1" ]; then
    sudo du -a "$1" 2>/dev/null | sort -n -r | head -n 20 | awk -F" " '{printf "%-15s %-10s\n",$1,$2}'
  else
    echo "warn - you need set path!!"
  fi
}

# check: sniff HTTP traffic (ngrep)
c_sniff() {

  sudo ngrep -d 'en1' -t '^(GET|POST) ' 'tcp and port 80'
}

# check: sniff HTTP traffic 2 (tcpdump)
c_httpdump() {

  sudo tcpdump -i en1 -n -s 0 -w - | grep -a -o -E \"Host\\: .* | GET \\/.*\"
}

# check: size of disks system
c_size_disks() {
  echo "╓───── m o u n t . p o i n t s"
  echo "╙────────────────────────────────────── ─ ─ "
  lsblk -a
  echo ""
  echo "╓───── d i s k . u s a g e"
  echo "╙────────────────────────────────────── ─ ─ "
  df -h
  echo ""
  echo "╓───── U.U.I.D.s"
  echo "╙────────────────────────────────────── ─ ─ "
  lsblk -f
}

# check: size memory usage
c_size_memuse() {
  ps -eo size,pid,user,command --sort -size |
    awk '{ hr=$1/1024 ; printf("%13.2f Mb ",hr) } { for ( x=4 ; x<=NF ; x++ ) { printf("%s ",$x) } print "" }' |
    cut -d "" -f2 | cut -d "-" -f1 | less
}

# check: boot message
c_bootmsg() {
  echo -n Boot Messages | pv -qL 10 && sudo journalctl -b | ccze -A
}

# check: systemd boot-up performance statistic
c_blame() {
  systemd-analyze blame
}

# check: units what they loaded
c_units() {
  echo -n '\e[1;32mListing Units:\e[0m ' | pv -qL 10 && systemctl list-units
}

# check: usage bencweb <URL>
c_bencweb() {
  curl -s -w 'Testing Website Response Time for:%{url_effective}\n\nLookup Time:\t\t%{time_namelookup}\nConnect Time:\t\t%{time_connect}\nPre-transfer Time:\t%{time_pretransfer}\nStart-transfer Time:\t%{time_starttransfer}\n\nTotal Time:\t\t%{time_total}\n' -o /dev/null "$1"
}

# check: users and their passwd
c_user() {
  getent passwd | awk -F ':' '
    BEGIN {
      print "======================================================================================"
      printf "%-20s %-10s %-10s %-30s %-10s\n", "USER", "UID", "GUID", "HOME", "SHELL"
      print "======================================================================================"
    }
  {printf "%-20s %-10d %-10d %-30s %-10s\n", $1, $3, $4, $6,  $NF}
  '
}

# check: permission mode of current dir (ex: 755, 644, etc)
c_lsmod() {
  ls -lah | awk -F ' ' '{print $NF}' | xargs stat -c "%a %n"
}

# check: we are chrooted?
c_chroot() {
  if [ "$(stat -c %d:%i /)" != "$(stat -c %d:%i /proc/1/root/.)" ]; then
    echo "We are chrooted!"
  else
    echo "Business as usual"
  fi
}

# check: current host related info
c_ii() {
  NC='\033[0m' # No Color

  RED='\033[0;31m' # Red
  echo -e "\\n${RED}Kernel Information:$NC "
  uname -a
  echo -e "\\n${RED}Users logged on:$NC "
  w -h
  echo -e "\\n${RED}Current date :$NC "
  date
  echo -e "\\n${RED}Machine stats :$NC "
  uptime
  echo -e "\\n${RED}Memory stats :$NC "
  free
  echo -e "\\n${RED}Disk Usage :$NC "
  df -Th
  echo -e "\\n${RED}LAN Information :$NC"
  mylan
}

mylan() {
  if command -v ifconfig >/dev/null; then
    echo "---------------------------------------------------"
    /sbin/ifconfig enp0s31f6 | awk /'inet/ {print $2}'
    /sbin/ifconfig enp0s31f6 | awk /'bcast/ {print $3}'
    /sbin/ifconfig enp0s31f6 | awk /'inet6 addr/ {print $1,$2,$3}'
    /sbin/ifconfig enp0s31f6 | awk /'HWaddr/ {print $4,$5}'
    echo "---------------------------------------------------"
  elif command -v ip >/dev/null; then
    echo "---------------------------------------------------"
    ip a show enp0s31f6 | awk /'inet/ {print $2}'
    ip a show enp0s31f6 | awk /'bcast/ {print $3}'
    ip a show enp0s31f6 | awk /'inet6 addr/ {print $1,$2,$3}'
    ip a show enp0s31f6 | awk /'HWaddr/ {print $4,$5}'
    echo "---------------------------------------------------"
  fi
}

# check: version of OS
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

# check: listening port
c_port_listen() {
  sudo netstat -nltn
}

# check: listing all the listening ports of tcp and udp connections
c_port_listen_tcpupd() {
  sudo netstat -a | more

}
# check: listening port by program
c_port_listen_byprogram() {
  sudo netstat -ap | grep -i http

}

# check: show statistic by protocol
c_port_statistic() {
  sudo netstat -s
}

# check: showing network interface packet transactions
c_port_stransactions() {
  sudo netstat -i
  sudo netstat -g
}


# check: show listening port (verbose: name and pid)
c_port_listenpid() {
  sudo netstat -nltpna
}

# check: show established port (verbose: name and pid)
c_port_establishidA() {
  sudo netstat -ntpa | grep 'ESTABLISHED'
}


# check: show status ip firewall (by iptables)
c_ipv() {
  sudo iptables -L -n -v --line-numbers
}

# check: show status iptable -dnat (by iptables)
c_ipvnat() {
  sudo iptables -L -n -v --line-numbers -t nat
}

# check: error journalctl
c_jurnalerr() {

  echo -n '\e[1;32mJournal Errors:\e[0m ' | pv -qL 10 && journalctl -b -p err | ccze -A
}

# download: youtube <$URL_YOUTUBE>
d_ytdl() {
  tsp youtube-dl --output "$(date +%s)-%(uploader)s%(title)s.%(ext)s" "$1"
}

# download: convert vidoutube to mp3 <$URL_YOUTUBE>
d_ytmp3() {
  tsp youtube-dl --extract-audio --audio-format mp3 "$1"
}

# run: hapus file all <$1>
r_hapus() {
  find "$1" -type f -name "*" -exec shred -v -n 25 -u -z {} \;
}

# run: open ranger
r_r() {
  ranger
}

# run: run calculator by python
r_calc() {
  python -ic "from __future__ import division; from math import *; from random import *"
}

# run: extract file <$YOUR_TAR_RAR_ZIP_7z_TAR_GZ_FILE>
r_extract() {
  if [ -f "$1" ]; then
    case "$1" in
    *.tar.bz2) tar xvjf "$1" ;;
    *.tar.gz) tar xvzf "$1" ;;
    *.tar.xz) tar xf "$1" ;;
    *.bz2) bunzip2 "$1" ;;
    *.rar) unrar e -r "$1" ;;
    *.gz) gunzip "$1" ;;
    *.tar) tar xvf "$1" ;;
    *.tbz2) tar xvjf "$1" ;;
    *.tgz) tar xvzf "$1" ;;
    *.zip) unzip "$1" ;;
    *.Z) uncompress "$1" ;;
    *.7z) 7z x "$1" ;;
    *) echo "don't know how to extract '$1'..." ;;
    esac
  else
    echo "'$1' is not a valid file!"
  fi
}

# run: run newsboat
r_news() {
  if [[ "$TERM" =~ "tmux".* ]] || [[ "$TERM" =~ "screen" ]]; then

    test_proxychains=$(docker ps -a | grep -i up)

    if [ ! -z "$test_proxychains" ]; then
      tmux new-window && tmux rename-window 'newsboat' &&
        tmux send-keys 'proxychains newsboat && tmux kill-pane' enter
    else
      tmux new-window && tmux rename-window 'newsboat' &&
        tmux send-keys 'newsboat && tmux kill-pane' enter
    fi
  else

    newsboat
  fi
}

# run: multitail
r_logsys() {
  if [[ "$TERM" =~ "tmux".* ]] || [[ "$TERM" =~ "screen" ]]; then
    if tmux list-window | grep logging >/dev/null; then
      tmuxWindowName=$(tmux list-windows | grep logging | cut -d: -f1)
      tmux kill-window -t "$tmuxWindowName"
    fi
    tmux new-window && tmux rename-window "logging" &&
      tmux send-keys "sudo multitail -s 2 /var/log/syslog /var/log/auth.log /var/log/kern.log && tmux kill-pane" enter
  else
    sudo multitail -s 2 /var/log/syslog /var/log/auth.log /var/log/kern.log
  fi
}

# run: generate pass key
r_passkeygen() {
  if command -v whois >/dev/null; then
    printf "##### GENERATE PASSWORD ###########\\n\\n"
    PATHTEMP=$(mktemp -d)
    if [ ! -n "$TMUX" ]; then
      read -r -p "your password? " getvar
      hlse
      read -r "getvar?your password? "
    fi
    mkpasswd -m sha-512 "$getvar" >"$PATHTEMP/mypass_SHA512_$(date +%F)"
    echo "$getvar" >"$PATHTEMP/mypass_$(date +%F)"
    printf "%s $PATHTEMP\\n" "store pass path:"
  else
    clear
    echo "package whois not found! let me install it.."
    sudo apt install whois -y
    sleep 1
    clear
    echo "run 'r-passkeygen' again"
  fi
}

# run: generate ssh key
r_sshkeygen() {
  echo "##### GENERATE SSH ###########"
  echo ""
  if [ ! -n "$TMUX" ]; then
    read -r -p "some comments for new sshgen? " commentme
    read -r -p "prefix ~/.ssh/_your_prefix? " prefixfile
  else
    read -r "commentme?some comments for new sshgen? "
    read -r "prefixfile?prefix ~/.ssh/_your_prefix? "
  fi

  ssh-keygen -t rsa -b 4096 -C "$commentme" \
    -f "$HOME/.ssh/$prefixfile$(date +%F)"
}

# run: remove comment of the file <$YOUR_FILE>
r_uncommentfile() {
  sudo cat "$1" | sed '/^#.*$/d;/^;.*$/d'
}

# run: create minimal tmux pane split
r_iide() {
  # check if tmux ses exists
  printf "..launch ide: "
  if [ ! -z "$TMUX" ]; then
    tmux split-window -v -p 34
    tmux split-window -h -p 66
    tmux split-window -h -p 34
    tmux rename-window 'ide'
    echo "Done"
  else
    echo "Tmux session off !!"
  fi
}

# ps: tree ls system try
ps_ls() {
  PROC_ID_ORIGIN=$(ps -alf | fzf)
  if [[ $(echo "$PROC_ID_ORIGIN" | grep "UID[[:blank:]]*PID")x == ""x ]]; then
    PROC_ID=$(echo "$PROC_ID_ORIGIN" | grep -o '^[^[:blank:]]*[[:blank:]]*[^[:blank:]]*[[:blank:]]*[^[:blank:]]*[[:blank:]]*[^[:blank:]]*' | grep -o '[[:digit:]]*$')
    echo "$PROC_ID_ORIGIN"
  fi
}

# ps: ls system try
ps_ls_all() {
  PROC_ID_ORIGIN=$(ps -elf | fzf)
  if [[ $(echo "$PROC_ID_ORIGIN" | grep "UID[[:blank:]]*PID")x == ""x ]]; then
    PROC_ID=$(echo "$PROC_ID_ORIGIN" | grep -o '^[^[:blank:]]*[[:blank:]]*[^[:blank:]]*[[:blank:]]*[^[:blank:]]*[[:blank:]]*[^[:blank:]]*' | grep -o '[[:digit:]]*$')
    echo "$PROC_ID_ORIGIN"
  fi
}

# ps: check with top command info selected
ps_i() {
  PROC_ID_ORIGIN=$(ps -alf | fzf)
  if [[ $(echo "$PROC_ID_ORIGIN" | grep "UID[[:blank:]]*PID")x == ""x ]]; then
    PROC_ID=$(echo "$PROC_ID_ORIGIN" | grep -o '^[^[:blank:]]*[[:blank:]]*[^[:blank:]]*[[:blank:]]*[^[:blank:]]*[[:blank:]]*[^[:blank:]]*' | grep -o '[[:digit:]]*$')
    top -p "$PROC_ID"
  fi
}

# ps: check with top all command
ps_info_all() {
  PROC_ID_ORIGIN=$(ps -elf | fzf)
  if [[ $(echo "$PROC_ID_ORIGIN" | grep "UID[[:blank:]]*PID")x == ""x ]]; then
    PROC_ID=$(echo "$PROC_ID_ORIGIN" | grep -o '^[^[:blank:]]*[[:blank:]]*[^[:blank:]]*[[:blank:]]*[^[:blank:]]*[[:blank:]]*[^[:blank:]]*' | grep -o '[[:digit:]]*$')
    top -p "$PROC_ID"
  fi
}

# ps: tree
ps_tree() {
  PROC_ID_ORIGIN=$(ps -alf | fzf)
  if [[ $(echo "$PROC_ID_ORIGIN" | grep "UID[[:blank:]]*PID")x == ""x ]]; then
    PROC_ID=$(echo "$PROC_ID_ORIGIN" | grep -o '^[^[:blank:]]*[[:blank:]]*[^[:blank:]]*[[:blank:]]*[^[:blank:]]*[[:blank:]]*[^[:blank:]]*' | grep -o '[[:digit:]]*$')
    pstree -p "$PROC_ID"
  fi
}

# ps: tree all
ps_tree_all() {
  PROC_ID_ORIGIN=$(ps -elf | fzf)
  if [[ $(echo "$PROC_ID_ORIGIN" | grep "UID[[:blank:]]*PID")x == ""x ]]; then
    PROC_ID=$(echo "$PROC_ID_ORIGIN" | grep -o '^[^[:blank:]]*[[:blank:]]*[^[:blank:]]*[[:blank:]]*[^[:blank:]]*[[:blank:]]*[^[:blank:]]*' | grep -o '[[:digit:]]*$')
    pstree -p "$PROC_ID"
  fi
}

# ps: kill
ps_kill() {
  PROC_ID_ORIGIN=$(ps -alf | fzf)
  if [[ $(echo "$PROC_ID_ORIGIN" | grep "UID[[:blank:]]*PID")x == ""x ]]; then
    PROC_ID=$(echo "$PROC_ID_ORIGIN" | grep -o '^[^[:blank:]]*[[:blank:]]*[^[:blank:]]*[[:blank:]]*[^[:blank:]]*[[:blank:]]*[^[:blank:]]*' | grep -o '[[:digit:]]*$')
    kill -9 "$PROC_ID"
  fi
}

# ps: kill
ps_kill_all() {
  PROC_ID_ORIGIN=$(ps -elf | fzf)
  if [[ $(echo "$PROC_ID_ORIGIN" | grep "UID[[:blank:]]*PID")x == ""x ]]; then
    PROC_ID=$(echo "$PROC_ID_ORIGIN" | grep -o '^[^[:blank:]]*[[:blank:]]*[^[:blank:]]*[[:blank:]]*[^[:blank:]]*[[:blank:]]*[^[:blank:]]*' | grep -o '[[:digit:]]*$')
    kill -9 "$PROC_ID"
  fi
}

# watch: mpv run with args <$GEOMETRY_X> <$GEOMETRY_Y> <$URL_OR_FILE_VID>
w_mpv() {

  if [ "$#" -gt 1 ]; then
    tsp mpv -ontop -no-border -force-window \
      --autofit="$1"x"$2" --geometry=-15-60 "$3"
  else
    tsp mpv --ontop --no-border --force-window \
      --autofit=700x300 --geometry=-15-60 "$1"

    echo ""
    echo "Example: w_mpvlol 1000 300 link_youtube"
    printf "\\t or w_mpvlol link_youtube\\n"
  fi
}

# watch: vlc run with args <$GEOMETRY_X> <$GEOMETRY_Y> <$URL_OR_FILE_VID>
w_vlc() {

  if [ "$#" -gt 1 ]; then
    tsp vlc -ontop -no-border -force-window \
      --autofit="$1"x"$2" --geometry=-15-60 "$3"
  else
    tsp vlc --ontop --no-border --force-window \
      --autofit=700x300 --geometry=-15-60 "$1"

    echo ""
    echo "Example: w_mpvlol 1000 300 link_youtube"
    printf "\\t or w_mpvlol link_youtube\\n"
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

# fzf: kill pid
fz_kill() {
  local pid
  pid=$(ps -ef | sed 1d | fzf -m | awk '{print $2}')

  if [ "x$pid" != "x" ]; then
    echo $pid | xargs kill -${1:-9}
  fi
}

# fzf: tmux session
fz_tmux_lses() {
  local -r fmt='#{session_id}:|#S|(#{session_attached} attached)'
  { tmux display-message -p -F "$fmt" && tmux list-sessions -F "$fmt"; } |
    awk '!seen[$1]++' |
    column -t -s'|' |
    fzf -q '$' --reverse --prompt 'switch session: ' -1 |
    cut -d':' -f1 |
    xargs tmux switch-client -t
}

# fzf: create tmux session
fz_tmux_cses() {
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

# docker: show list of docker images
doc_im_ls() {
  docker images
}

# docker: image: check histroy of docker image <$DOCKER_IMAGE_ID>
doc_im_his_id() {
  if [ ! -z "$1" ]; then
    docker history "$1"
  else
    echo "warn - [docker history image] need image_id"
  fi
}

# docker: image: build images with <$YOUR_NEW_DOCKER_TAG>
doc_im_buildtag() {
  if [ ! -z "$1" ]; then
    docker build -t "$1" .
  else
    echo "warn - [docker build] you need tag, seperti name_img:latest"
  fi
}

# docker: image: remove all images
doc_im_rall() {
  docker rmi -f "$(docker images -q)"
}

# docker: image: remove images only contains the string 'none'
doc_im_rnone() {
  docker rmi -f "$(docker images | grep '^<none>' | awk '{print $3}')"
}

# docker: image: remove all dangling images
doc_im_rdang() {
  docker rmi -f "$(docker images -f 'dangling=true' -q)"
}

# docker: image: remove docker image <$ID_DOCKER_IMAGE>
doc_im_rid() {
  if [ ! -z "$1" ]; then
    docker rmi -f "$1"
  else
    echo "warn - [docker image] need image_id"
  fi
}

# docker: container: show list or containers
doc_con_ls() {
  docker ps -a
}

# docker: container: run container <$DOCKER_TARGET_IMAGE_ID> (run -it)
doc_con_run_it() {
  if [ ! -z "$1" ]; then
    docker run -it "$1"
  else
    echo "warn - [docker image] need image_id"
  fi
}

# docker: container: run container but destroy <$DOCKER_TARGET_IMAGE_ID> (run --rm)
doc_con_run_rmit() {
  if [ ! -z "$1" ]; then
    docker run -it --rm "$1"
  else
    echo "warn - [docker image] need image_id"
  fi
}

# docker: container: check inspect container <$DOCKER_CONTAINER_ID>
doc_con_inspect_id() {
  if [ ! -z "$1" ]; then
    docker container inspect "$1"
  else
    echo "warn - [docker inspect] need container_id"
  fi
}

# docker: container: show list of containers with contains the string 'exited'
doc_con_showex() {
  docker container ls -a --filter status=exited --filter status=created
}

# docker: container: check log container <$DOCKER_CONTAINER_ID>
doc_con_log_id() {
  if [ ! -z "$1" ]; then
    docker container logs "$1"
  else
    echo "[warn] doc_con_log: need container id"
  fi
}

# docker: container: start container <$DOCKER_CONTAINER_ID>
doc_con_start_id() {
  if [ ! -z "$1" ]; then
    docker start "$1"
  else
    echo "[warn] doc_con_start_id: need container id"
  fi
}

# docker: container: stop container <$DOCKER_CONTAINER_ID>
doc_con_stop_id() {
  if [ ! -z "$1" ]; then
    docker stop "$1"
  else
    echo "[warn] doc_con_stop_id: need container id"
  fi
}

# docker: container: restart container <$DOCKER_CONTAINER_ID>
doc_con_restart_id() {
  if [ ! -z "$1" ]; then
    docker restart "$1"
  else
    echo "[warn] doc_con_restart_id: need container id"
  fi
}

# docker: container: remove all containers
doc_con_rall() {
  docker rm -f "$(docker ps -aq)"
}

# docker: container: remove container by id <$DOCKER_CONTAINER_ID>
doc_con_rid() {
  if [ ! -z "$1" ]; then
    docker rm "$1"
  else
    echo "[warn] doc_con_rid: need container id"
  fi
}

# docker: container: remove container with contains the string  'exit'
doc_con_rallex() {
  docker ps -a | grep Exit | cut -d ' ' -f 1 | xargs docker rm
}

# docker: container: enter/login the container <$DOCKER_CONTAINER_ID>
doc_con_enter_id() {
  docker exec -it "$1" /bin/bash
}

# docker: volume: show list of docker volumes
doc_vol() {
  docker volume ls
}

# docker: volume: remove all docker volumes
doc_vol_rall() {
  docker volume rm "$(docker volume ls -qf dangling=true)"
}

# docker: volume: remove docker volume by <$DOCKER_VOLUME_ID>
doc_vol_rid() {
  if [ ! -z "$1" ]; then
    docker volume rm "$1"
  else
    echo "[warn] doc_vol_rid: need volume id"
  fi
}

# docker: volume: remove all dangling volumes
doc_vol_rdang() {
  docker volume rm "$(docker volume ls -f dangling=true -q)"
}

# docker: volume: inspect volume by id <$DOCKER_VOLUME_ID>
doc_vol_inspect_id() {
  docker volume inspect "$1"
}

# docker: network: show list of docker network
doc_net_ls() {
  docker network ls
}

# docker: network: remove all docker network
doc_net_rall() {
  docker network rm "$(docker network ls -q)"
}

# docker: compose: show list of docker compose
doc_comp_ps() {
  docker-compose ps
}

# docker: compose: docker compose up -d
doc_comp_upd() {
  docker-compose up -d
}

# docker: compose: stop service docker compose
doc_comp_down() {
  docker-compose down
}

# docker: compose: stop service and remove the container
doc_comp_stop() {
  docker-compose stop
}

# docker: compose: run
doc_comp_run() {
  docker-compose run
}

# docker: compose: run with flag --rm
doc_comp_run_rm() {
  docker-compose run --rm
}

# # snippet code command
# # https://articles.engineers.my/golang-profiling-and-handling-http-disconnection/
# # snippet cpu usege for go-build

# # go: go mod init $1
# go_modinit() {
#   if [ ! -z "$1" ]; then
#     go mod init "$1"
#   else
#     echo "warn - [go init mod] need args, ex: go_modinit projectname | github.com/projectname "
#   fi
# }

# # go: go run $1
# go_run() {
#   if [ ! -z "$1" ]; then
#     go run "$1"
#   else
#     echo "warn - [go run] need args, ex: go_run main.go"
#   fi
# }

# # go: go build
# go_build() {
#   ps -A -o %cpu -o args | grep -i go-build
# }

# # go: go install
# go_install() {
#   go install
# }

# # go: go get $1
# go_get() {
#   if [ ! -z "$1" ]; then
#     go get "$1"
#   else
#     echo "warn - [go get ] need args, ex: go_get url_github"
#   fi
# }

# # go: go test
# go_test() {
#   go test
# }

# # go: go test -cover
# gocover() {
#   go test -cover
# }

# # go: go test -coverprofile $1
# gocoverfile() {
#   if [ ! -z "$1" ]; then
#     go test -coverprofile="$1"
#   else
#     echo "warn - [go test coverprofile] need args, ex: go_coverfile cover.out"
#   fi
# }

# # go: go test -bench
# gobench() {
#   go test -bench .
# }
