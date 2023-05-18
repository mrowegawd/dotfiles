#!/usr/bin/fish

alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias l="ls -CF --color=auto"
alias ll="exa -lhaa"
alias grep="grep --color=auto"
# alias rg="rg --hidden"
alias g="git"

alias r_m="tmux -2"
alias r_mat="r_m a -t"
alias s_ducks='sudo du -cks * | sort -rn | head -11'
# alias vv=neovide
alias mpv_c="mpv --geometry=-50-50 --autofit=40% "

alias :q!=exitq
alias :Q!=exitq
alias :c=exit
alias :C=exit
alias :c!=exit
alias :C!=exit

alias c="bat "
# alias logs="sudo find /var/log -type f -exec file {} \; | grep 'text' | cut -d' ' -f1 | sed -e's/:$//g' | grep -v '[0-9]$' | xargs tail -f"

alias ag="ag --hidden --skip-vcs-ignores --ignore=\"*Library*\" --ignore=\"*.gem*\" --ignore=\"*.build*\" --ignore=\"*.git*\""

alias ls="/bin/ls -nphq --time-style=iso --color=auto\
  --group-directories-first --show-control-chars"

function mdg --description "create folder and cd"
    mkdir -p $argv[1] && cd $argv[1] || return
end

# function cd
#     # Try a normal cd
#     set -l checkCD (builtin cd $argv)

#     if test -z "$checkCD"
#         exa -lhaa
#     end
# end

function cc --description "go back to the last cd"
    set -l last_dir (ls -Frt | grep '/$' | tail -n1 | awk 'NF>1{print $NF}')
    if test -z "$last_dir" # check jika $last_dir not contains any string, return it
        return 1
    end

    if test -d $last_dir
        cd "$last_dir" || return
    end
end

if [ $USER = root ]
    alias v="vim"
    alias sv="sudo vim"
    alias ttext='vim /tmp/dump_text.txt'
    alias tbash='vim /tmp/dump_bash.sh'
else
    if command -v nvim >/dev/null
        alias v="nvim"
        # alias vv=neovide
        alias sv="sudo nvim"
        alias ttext='nvim /tmp/dump_text.txt'
        alias tbash='nvim /tmp/dump_bash.sh'
    else
        alias v="vim"
        alias sv="sudo vim"
        alias ttext='vim /tmp/dump_text.txt'
        alias tbash='vim /tmp/dump_bash.sh'
    end
end

function e
    if command -v emacs >/dev/null
        emacs --insecure
    else
        echo "[war] there is no emacs installed"
    end
end

###############################################################################
## CHECK
###############################################################################
function c_size_cd --description "check current size folder/files"
    du -b --max-depth 1 | sort -nr | perl -pe 's{([0-9]+)}{sprintf "%.1f%s", $1>=2**30? ($1/2**30, "G"): $1>=2**20? ($1/2**20, "M"): $1>=2**10? ($1/2**10, "K"): ($1, "")}e'
end

function c_size_tfile --description "check size of file"
    if test -z $argv[1]
        echo "[warn] run like this, ex: c_size_cd <file>"
        return 1
    end

    if test -d $argv[1]
        echo "[warn] you need specific a file not a folder"
        return 1
    end

    sudo du -a $argv[1] 2>/dev/null | sort -n -r | head -n 20 | awk -F" " '{printf "%-15s %-10s\n",$1,$2}'
end

function c_sniff --description "sniff HTTP traffic (ngrep)"
    if command -v ngrep >/dev/null
        sudo ngrep -d en1 -t '^(GET|POST) ' 'tcp and port 80'
    else
        echo "[warn] install ngrep first!"
    end
end

function c_httpdump --description "sniff HTTP traffic (tcpdump)"
    if command -v tcpdump >/dev/null
        sudo tcpdump -i en1 -n -s 0 -w - | grep -a -o -E \"Host\\: .* | GET \\/.*\"
    else
        echo "[warn] install tcpdump first!"
    end
end

function c_size_owner_filefolder --description "check owner and perm files/folders"
    stat -L -c "%a %G %U" $argv[1]
end

function mylan
    if command -v ifconfig >/dev/null
        echo ---------------------------------------------------
        /sbin/ifconfig enp0s31f6 | awk /'inet/ {print $2}'
        /sbin/ifconfig enp0s31f6 | awk /'bcast/ {print $3}'
        /sbin/ifconfig enp0s31f6 | awk /'inet6 addr/ {print $1,$2,$3}'
        /sbin/ifconfig enp0s31f6 | awk /'HWaddr/ {print $4,$5}'
        echo ---------------------------------------------------
    else if command -v ip >/dev/null
        echo ---------------------------------------------------
        ip a show enp0s31f6 | awk /'inet/ {print $2}'
        ip a show enp0s31f6 | awk /'bcast/ {print $3}'
        ip a show enp0s31f6 | awk /'inet6 addr/ {print $1,$2,$3}'
        ip a show enp0s31f6 | awk /'HWaddr/ {print $4,$5}'
        echo ---------------------------------------------------
    end
end

function c_info_on_system --description "check size all disk size on system"
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

    # set -l NC '\033[0m' # No Color
    # set -l RED '\033[0;31m' # Red

    # echo -e "\\n$REDKernel Information:$NC "
    echo ""
    echo "╓───── i n f o r m a t i o n"
    echo "╙────────────────────────────────────── ─ ─ "
    uname -a

    # echo -e "\\n$REDUsers logged on:$NC "
    echo ""
    echo "╓───── u s e r . l o g g e d . o n"
    echo "╙────────────────────────────────────── ─ ─ "
    w -h

    echo ""
    echo "╓───── d a t e"
    echo "╙────────────────────────────────────── ─ ─ "
    date

    echo ""
    echo "╓───── s t a t e"
    echo "╙────────────────────────────────────── ─ ─ "
    uptime
    # echo -e "\\n$REDMemory stats :$NC "

    echo ""
    echo "╓───── s t a t s"
    echo "╙────────────────────────────────────── ─ ─ "
    free
    # echo -e "\\n$REDLAN Information :$NC"
    echo ""
    echo "╓───── m y l a n"
    echo "╙────────────────────────────────────── ─ ─ "
    mylan
end

function c_os --description "check os"
    # if test -e /etc/os-release
    #     # freedesktop.org and systemd
    #     . /etc/os-release
    #     set OS $NAME
    #     set VER $VERSION_ID
    if type lsb_release >/dev/null 2>&1
        # linuxbase.org
        set OS (lsb_release -si)
        set VER (lsb_release -sr)
    else if test -e /etc/lsb-release
        # For some versions of Debian/Ubuntu without lsb_release command
        . /etc/lsb-release
        set OS $DISTRIB_ID
        set VER $DISTRIB_RELEASE
    else if test -e /etc/debian_version
        # Older Debian/Ubuntu/etc.
        set OS Debian
        set VER (cat /etc/debian_version)
        # elif [ -f /etc/SuSe-release ]; then
        #     # Older SuSE/etc.
        #     ...
        # elif [ -f /etc/redhat-release ]; then
        # Older Red Hat, CentOS, etc.
    else
        # Fall back to uname, e.g. "Linux <version>", also works for BSD, etc.
        set OS (uname -s)
        set VER (uname -r)
    end
    echo "OS        : $OS"
    echo "version   : $VER"

end

# check users and their passwd
function c_user --description "check users on 'passwd'"
    getent passwd | awk -F ':' '
      BEGIN {
        print "======================================================================================"
          printf "%-20s %-10s %-10s %-30s %-10s\n", "USER", "UID", "GUID", "HOME", "SHELL"
          print "======================================================================================"
      }
    {printf "%-20s %-10d %-10d %-30s %-10s\n", $1, $3, $4, $6,  $NF}
    ' | less
end

function c_size_memuse --description "check memory usage of a process"
    ps -eo size,pid,user,command --sort -size |
        awk '{ hr=$1/1024 ; printf("%13.2f Mb ",hr) } { for ( x=4 ; x<=NF ; x++ ) { printf("%s ",$x) } print "" }' | fzf | cut -d "" -f2 | cut -d - -f1
end

function c_port_listen_tcpupd --description "list all listening ports tcp/udp conn"
    if command -v netstat >/dev/null
        sudo netstat -a | less
    else
        echo "[warn] install netstat first"
    end
end

function c_port_statistic --description "check show statistic by protocol"
    if command -v netstat >/dev/null
        sudo netstat -s | less
    else
        echo "[warn] install netstat first"
    end
end

###############################################################################
## RUN SCRIPT r_<name-of-snipscript>
###############################################################################
function r_logs --description "see current for all logs"
    sudo find /var/log -type f -exec file {} \; | grep text | cut -d' ' -f1 | sed -e's/:$//g' | grep -v '[0-9]$' | xargs tail -f
end

function r_ytmp3 --description "convert youtube link to mp3"
    tsp yt-dlp --extract-audio --audio-format mp3 $argv[1]
end

function r_ytdl --description "download youtube video"
    tsp yt-dlp --output "$(date +%s)-%(uploader)s%(title)s.%(ext)s" $argv[1]
end

function r_calc --description "run calculator with python"
    python -ic "from __future__ import division; from math import *; from random import *"
end

# abbr -a r_hapus_files find  -type f -name "*" -exec shred -v -n 25 -u -z {} \;

function r_sshkeygen --description "creating SSH keygen"
    read -P "some comments for new sshgen? " commentme
    read -P "prefix ~/.ssh/_your_prefix? " prefixfile

    ssh-keygen -t rsa -b 4096 -C "$commentme" \
        -f "$HOME/.ssh/$prefixfile$(date +%F)"
end

function r_passkeygen --description "creating password SHA-512 keygen"
    if command -v whois >/dev/null
        printf "##### GENERATE PASSWORD ###########\\n\\n"
        set -l PATHTEMP (mktemp -d)

        read -l -P "your password? " mypass
        # read -l -P "getvar? your password? " getvar

        mkpasswd -m sha-512 $mypass >$PATHTEMP/mypass_SHA512_(date +%F)
        echo $mypass >$PATHTEMP/mypass_(date +%F)
        printf "%s $PATHTEMP\\n" "store pass path:"
    else
        echo "[warn] package whois not found! let me install it.."
        sudo apt install whois -y
        sleep 1
        clear
        echo ""
        echo "run 'r-passkeygen' again"
    end
end

abbr -a r_r lfrun

function r_apt
    if test -z $argv[2]
        echo "[warn] you need spesific name of package. ex: 'r_apt show vim'"
        return 1
    else if test -z $argv[1]
        echo "[warn] define option, ex: show, policy, search"
        return 1
    end

    switch $argv[1]
        case show
            sudo apt-cache show $argv[2]
        case search
            sudo apt-cache search $argv[2]
        case policy
            sudo apt-cache policy $argv[2]
        case '*'
            echo "not found"
    end

end

function r_pfr --description 'Select a process to record performance data in given file name'
    set proc (ps -ef | fzf | awk '{print $2}')
    top -H -p $proc
end

function r_pst --description 'Show process tree of a process'
    set proc (ps -ef | fzf | awk '{print $2}' | head -1)
    pstree -H $proc $proc
end

function r_extract --description "run extract data zip/tar/gz"
    if test -z $argv[1]
        echo "[warn] run with ex: r_extract 'file.gz'"
        return 1
    end

    switch $argv[1]
        case *.tar.bz2
            tar xvjf $argv[1]
        case *.tar.gz
            tar xvzf $argv[1]
        case *.tar.xz
            tar xf $argv[1]
        case *.bz2
            bunzip2 $argv[1]
        case *.rar
            unrar e -r $argv[1]
        case *.gz
            gunzip $argv[1]
        case *.tar
            tar xvf $argv[1]
        case *.tbz2
            tar xvjf $argv[1]
        case *.tgz
            tar xvzf $argv[1]
        case *.zip
            unzip $argv[1]
        case *.Z
            uncompress $argv[1]
        case *.7z
            7z x $argv[1]
        case '*'
            echo "don't know how to extract '$argv[1]'..."
    end
end

function r_ps_curUser --description "get pid ps from current user"
    set -l PROC_ID_ORIGIN (ps -alf | grcat fps.grc | fzf-tmux -p 80% --ansi)
    set -l PROC_ID_GREP (echo $PROC_ID_ORIGIN | grep "UID[[:blank:]]*PID")
    if test -z $PROC_ID_GREP
        set -l PROC_ID (echo "$PROC_ID_ORIGIN" | grep -o '^[^[:blank:]]*[[:blank:]]*[^[:blank:]]*[[:blank:]]*[^[:blank:]]*[[:blank:]]*[^[:blank:]]*' | grep -o '[[:digit:]]*$')
        echo $PROC_ID
    end
end

function r_ps_allSystem --description "get pid ps for all systems"
    set -l PROC_ID_ORIGIN (ps -elf | grcat fps.grc | fzf-tmux -p 80% --ansi)
    set -l PROC_ID_GREP (echo $PROC_ID_ORIGIN | grep "UID[[:blank:]]*PID")
    if test -z $PROC_ID_GREP
        set -l PROC_ID (echo "$PROC_ID_ORIGIN" | grep -o '^[^[:blank:]]*[[:blank:]]*[^[:blank:]]*[[:blank:]]*[^[:blank:]]*[[:blank:]]*[^[:blank:]]*' | grep -o '[[:digit:]]*$')
        echo $PROC_ID
    end
end

###############################################################################
## WATCH
###############################################################################
function w_vlc
    if test -z $args[1]
        echo "[help] example w_vlc 1000 300 link_youtube"
        return 1
    end

    if test (count $argv) -eq 1
        # tsp vlc -ontop -no-border -force-window --autofit=$argv[1]x$argv[2] --geometry=-15-60 $argv[3]
        tsp mpv -ontop -no-border -force-window --autofit=$argv[1]x$argv[2] --geometry=-15-60 $argv[3]
    else
        # tsp vlc --ontop --no-border --force-window --autofit=700x300 --geometry=-15-60 $argv[1]
        tsp mpv -ontop -no-border -force-window --autofit=400x300 --geometry=-15-60 $argv[1]
    end
end

###############################################################################
## FZF ENCHANTED
###############################################################################
function fz_kill --description "fzf, kill selected pid"
    set fzpid (ps -ef | sed 1d  | grcat fps.grc | fzf --height=40% --ansi | awk '{print $2}')

    if test -z $fzpid
        return 1
    end

    echo $fzpid

    echo $fzpid | xargs kill
    # echo $fzpid | xargs kill -${1:-9}
end

###############################################################################
## DOCKER
###############################################################################
# IMAGES
abbr -a doc_im_ls docker images
abbr -a doc_im_his_id docker history # id
function doc_im_build_tag --description "docker im, build image with tag"
    if test -z $argv[1]
        echo "[Warn] - You need tag, ex: 'doc_im_build_tag name_img:latest'"
        return 1
    end
    docker build -t $argv[1] .
end

function doc_im_rall --description "docker im, remove all images"
    function read_confirm
        while true
            read -p 'set_color green; echo -n "Are you sure? [y/N]: "; set_color normal' -l confirm
            switch $confirm
                case Y y
                    return 0
                case '' N n
                    return 1
            end
        end
    end

    if read_confirm
        docker rmi -f (docker images -q)
    end
end

function doc_im_rnone --description "docker im, remove all 'none' images "
    set docker_im_are_none (docker images | grep '^<none>' | awk '{print $3}')
    if test -z $docker_im_are_none
        echo "There is no `none` images in our local, you are good.."
        return 1
    end
    docker rmi -f $docker_im_are_none
end

function doc_im_rdang --description "docker im, remove dangling images"
    set docker_im_are_dang (docker images -f 'dangling=true' -q)
    if test -z $docker_im_are_dang
        echo "There is no `dangling` images in our local, you are good.."
        return 1
    end

    docker rmi -f $docker_im_are_dang
end

abbr -a doc_im_rid docker rmi -f

# CONTAINERS
abbr -a doc_con_ls docker ps -a
abbr -a doc_con_run_it docker run -it
abbr -a doc_con_run_rmit docker run -it --rm
abbr -a doc_con_inspect_id docker container inspect
abbr -a doc_con_showex docker container ls -a --filter status=exited --filter status=created
abbr -a doc_con_log_id docker container logs
abbr -a doc_con_start_id docker start
abbr -a doc_con_stop_id docker stop
abbr -a doc_con_restart_id docker restart
function doc_con_rall --description "docker con, remove all containers"
    docker rm -f (docker ps -aq)
end
abbr -a doc_con_rid docker rm
function doc_con_rallex --description "docker con, remove all 'exit' containers"
    docker ps -a | grep Exit | cut -d ' ' -f 1 | xargs docker rm
end
function doc_con_enter_id --description "docker con, entering a container with ID"
    if test -z $args[1]
        echo "[warn] you need adding id, ex: doc_con_enter_id 'id'"
        return 1
    end
    docker exec -it $args[1] /bin/bash
end

## VOLUME
abbr -a doc_vol docker volume ls
function doc_vol_rall --description "docker vol, remove all volumes"
    docker volume rm (docker volume ls -qf dangling=true)
end
abbr -a doc_vol_rid docker volume rm
function doc_vol_rdang --description "docker vol, remove all dangling volumes"
    docker volume rm (docker volume ls -f dangling=true -q)
end
abbr -a doc_vol_inspect_id docker volume inspect

# NETWORK
abbr -a doc_net_ls docker network ls
function doc_net_rall --description "docker net, remove all networks"
    docker network rm (docker network ls -q)
end

#COMPOSE
abbr -a doc_comp_ps docker-compose ps
abbr -a doc_comp_upd docker-compose up -d
abbr -a doc_comp_down docker-compose down
abbr -a doc_comp_stop docker-compose stop
abbr -a doc_comp_run docker-compose run
abbr -a doc_comp_run_rm docker-compose run --rm

###############################################################################
## NPM AND YARN (TYPESCRIPT/JAVASCRIPT)
###############################################################################
abbr -a yarn_i_saveDev yarn add -D
abbr -a yarn_i_saveGlobal yarn global add
abbr -a yarn_run yarn run

abbr -a npm_i_saveGlobal npm install -g
abbr -a npm_c_outdated npm outdated -g

###############################################################################
## PIP ENV (PYTHON)
###############################################################################
abbr -a pip_i pip install
abbr -a pip_search pip search
abbr -a pip_show pip show
function pip_ls --description "pip list | less"
    pip list | less
end
abbr -a pip_i_requirments pip install -r

###############################################################################
## TRANSMISSION-REMOTE (TORRENT)
###############################################################################
abbr -a tsm_ls transmission-remote -l
abbr -a tsm_altspeedenable transmission-remote --alt-speed
abbr -a tsm_noaltspeedenable transmission-remote --no-alt-speed
abbr -a tsm_add transmission-remote -a
abbr -a tsm_pause transmission-remote -t "$1" --stop
abbr -a tsm_start transmission-remote -t "$1" --start
abbr -a tsm_purge transmission-remote -t "$1" --remove-and-delete
abbr -a tsm_i transmission-remote -t "$1" -i
function tsm_remove --description "Remove torrent with fzf"
    touch /tmp/test
    set chosen (transmission-remote -l | tail -n +2 > /tmp/test ; sed -i '$ d' /tmp/test; cat /tmp/test | fzf-tmux -p 80% | xargs | cut -d" " -f1)
    echo $chosen
    if test -z "$chosen"
        return 1
    end
    transmission-remote -t $chosen -r
    rm /tmp/test
end
