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

alias logs="sudo find /var/log -type f -exec file {} \; | grep 'text' | cut -d' ' -f1 | sed -e's/:$//g' | grep -v '[0-9]$' | xargs tail -f"

alias l="eza -l -snew"
alias ll="eza --long --all --git --color=always --group-directories-first --icons"
alias lt="eza --icons --all --color=always -T"

# if command -v eza >/dev/null; then
# 	alias ll="eza --long --all --git --color=always --group-directories-first --icons"
# 	alias lt="eza --icons --all --color=always -T"
# else
# 	alias ll='ls -lFh' # size,show type,human readable
# 	alias lt="tree ."
# fi

alias :C=exit
alias :c=exit
alias :Q=exit
alias :q=exit

if [ "${USER}" = "root" ]; then
	alias v="vim"
	alias sv="sudo vim"
	alias ttext='vim /tmp/dump_text.txt'
	# alias tbash='vim /tmp/dump_bash.sh'
else
	if command -v nvim >/dev/null; then
		alias v="nvim"
		alias vv="vv"
		alias vvg="vv --multigrid"
		alias svi="sudo nvim"
		alias ttext='nvim /tmp/dump_text.txt'
		# alias tbash='nvim /tmp/dump_bash.sh'
	else
		alias v="vim"
		alias vv="vim"
		alias vvg="vim"
		alias svi="sudo vim"
		alias ttext='vim /tmp/dump_text.txt'
		# alias tbash='vim /tmp/dump_bash.sh'
	fi
fi

if command -v emacs >/dev/null; then
	alias e="emacs --insecure"
fi

# ╭──────────────────────────────────────────────────────────╮
# │                          CHECK                           │
# ╰──────────────────────────────────────────────────────────╯
# prefix: _c
#
# check: size current dir
c_ducks() {
	sudo du -cks "$(ls -A)" | sort -rn | head -20
}

c_size_cd() { du -b --max-depth 1 | sort -nr | perl -pe 's{([0-9]+)}{sprintf "%.1f%s", $1>=2**30? ($1/2**30, "G"): $1>=2**20? ($1/2**20, "M"): $1>=2**10? ($1/2**10, "K"): ($1, "")}e'; }

# check: size of the target path/file <$YOUR_PATH>
c_size_tfile() {
	if [ -n "$1" ]; then
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

# check: owner and permission file/folder
c_size_owner_filefolder() {
	stat -L -c "%a %G %U" "$1"
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

function __send_msg() {
	printf "\n=====================================\n"
	printf "command:\t%s\n" "$1"
	printf "=====================================\n\n"
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

# check: usage benchmark web <URL>
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

# check: listing all the listening ports of tcp and udp connections
c_port_listen_tcpupd() {
	sudo netstat -a | more

}

# check: show statistic by protocol
c_port_statistic() {
	sudo netstat -s
}

# check: show network interface packet transactions
c_port_stransactions() {
	sudo netstat -i
	sudo netstat -g
}

# check: listening port (verbose: name and pid)
c_port_listen_pid() {
	NETSTATALL_FILE="/tmp/netstat_allpid"
	if command -v netstat >/dev/null; then
		sudo netstat -nltpna | sudo tee $NETSTATALL_FILE >>/dev/null

		if [ -f $NETSTATALL_FILE ]; then
			# sed '/^[[:space:]]*$/d' $NETSTATALL_FILE

			SELECT=$(tail -n +3 <$NETSTATALL_FILE | fzf-tmux -p 80%)
			echo ""
			SELECTED_PORT=$(echo "$SELECT" | awk -F ' ' '{print $4}')
			echo "====================="
			echo "ADDRESS:PORT = $SELECTED_PORT"
			echo "====================="
			SELECTED_PROG=$(echo "$SELECT" | awk -F ' ' '{print $7}' | cut -d"/" -f2)
			sudo apt policy "$SELECTED_PROG"
			echo "====================="
			echo "location \`which\`: $(which "$SELECTED_PROG")"
			echo "====================="
			sudo rm $NETSTATALL_FILE
		fi

	else
		echo "install netstat first"
	fi

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

# check: summary about the scripts
c_summary() {
	printf "
\t\e[1;32mc_\e[0m       -> checking
\t\e[1;32md_\e[0m       -> download
\t\e[1;32mr_\e[0m       -> run task
\t\e[1;32mps_\e[0m      -> ps tree
\t\e[1;32mw_\e[0m       -> watch
\t\e[1;32mfz_\e[0m      -> fzf
\t\e[1;32myarn_\e[0m    -> yarn
\t\e[1;32mnpm_\e[0m     -> npm
\t\e[1;32mpip_\e[0m     -> pip (python)
\t\e[1;32mpipenv_\e[0m  -> pipenv (python)
\t\e[1;32mdoc_\e[0m     -> docker\n\n"
}

# ╭──────────────────────────────────────────────────────────╮
# │                        RUN SCRIPT                        │
# ╰──────────────────────────────────────────────────────────╯

# run: fzf ps aux
r_fzf_ps() {
	ps aux --sort=-%mem | grcat ps.grc | fzf --ansi
}

# run: youtube download <$URL_YOUTUBE>
r_ytdl() {
	tsp yt-dlp --output "$(date +%s)-%(uploader)s%(title)s.%(ext)s" "$1"
}

# run: convert youtube to mp3 <$URL_YOUTUBE>
r_ytmp3() {
	tsp youtube-dl --extract-audio --audio-format mp3 "$1"
}

# run: hapus file all <$1>
r_hapus() {
	find "$1" -type f -name "*" -exec shred -v -n 25 -u -z {} \;
}

# run: open lf
r_r() {
	if command -v lfrun >/dev/null; then
		lfrun
	else
		echo "lfrun not installed!"
	fi
}

# run: checking for <$1> <$2> apt package; show, policy, search
r_apt() {
	[[ -z "$1" ]] && printf '\tr_apt show <package> | ex: show, policy, search'
	[[ -z "$2" ]] && printf '\tr_apt show <package> | ex: show, policy, search'

	if [[ "$1" == "show" ]]; then
		sudo apt-cache show "$2"
	fi

	if [[ "$1" == "search" ]]; then
		sudo apt-cache search "$2"
	fi

	if [[ "$1" == "policy" ]]; then
		echo "=============================================="
		echo "       VERSION OF PACKAGE IN REPOSITORY       "
		echo "=============================================="
		echo ""
		sudo apt-cache policy "$2"
	fi
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

		if [ -n "$test_proxychains" ]; then
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
r_create_passSHA_512() {
	if command -v whois >/dev/null; then
		printf "##### GENERATE PASSWORD ###########\\n\\n"
		PATHTEMP=$(mktemp -d)
		if [ -z "$TMUX" ]; then
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
r_create_sshkeygen() {
	if [ -n "$TMUX" ]; then
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
	if [ -n "$TMUX" ]; then
		tmux split-window -v -p 34
		tmux split-window -h -p 66
		tmux split-window -h -p 34
		tmux rename-window 'ide'
		echo "Done"
	else
		echo "Tmux session off !!"
	fi
}

# run: kill pid
r_kill() {
	local pid
	pid=$(ps -ef | sed 1d | fzf-tmux -p 80% | awk '{print $2}')

	if [ "x$pid" != "x" ]; then
		echo "$pid" | xargs kill -"${1:-9}"
	fi
}

# run: watch vlc run with args <$GEOMETRY_X> <$GEOMETRY_Y> <$URL_OR_FILE_VID>
r_vlc() {

	if [ "$#" -gt 1 ]; then
		tsp vlc -ontop -no-border -force-window \
			--autofit="$1"x"$2" --geometry=-15-60 "$3"
	else
		tsp vlc --ontop --no-border --force-window \
			--autofit=700x300 --geometry=-15-60 "$1"

		echo ""
		echo "Example: w_vlc 1000 300 link_youtube"
		printf "\\t or w_vlc link_youtube\\n"
	fi
}

# run: watch mpv run with args <$GEOMETRY_X> <$GEOMETRY_Y> <$URL_OR_FILE_VID>
r_mpv() {

	if [ "$#" -gt 1 ]; then
		tsp mpv -ontop -no-border -force-window \
			--autofit="$1"x"$2" --geometry=-15-60 "$3"
	else
		tsp mpv --ontop --no-border --force-window \
			--autofit=700x300 --geometry=-15-60 "$1"

		echo ""
		echo "Example: w_mpv 1000 300 link_youtube"
		printf "\\t or w_mpv link_youtube\\n"
	fi
}

# ps: tree ls system try
ps_ls() {
	PROC_ID_ORIGIN=$(ps -alf | fzf-tmux -p 80%)
	if [[ $(echo "$PROC_ID_ORIGIN" | grep "UID[[:blank:]]*PID")x == ""x ]]; then
		PROC_ID=$(echo "$PROC_ID_ORIGIN" | grep -o '^[^[:blank:]]*[[:blank:]]*[^[:blank:]]*[[:blank:]]*[^[:blank:]]*[[:blank:]]*[^[:blank:]]*' | grep -o '[[:digit:]]*$')
		echo "$PROC_ID_ORIGIN"
	fi
}

# ps: ls system try
ps_ls_all() {
	PROC_ID_ORIGIN=$(ps -elf | fzf-tmux -p 80%)
	if [[ $(echo "$PROC_ID_ORIGIN" | grep "UID[[:blank:]]*PID")x == ""x ]]; then
		PROC_ID=$(echo "$PROC_ID_ORIGIN" | grep -o '^[^[:blank:]]*[[:blank:]]*[^[:blank:]]*[[:blank:]]*[^[:blank:]]*[[:blank:]]*[^[:blank:]]*' | grep -o '[[:digit:]]*$')
		echo "$PROC_ID_ORIGIN"
	fi
}

# ps: check: with top command info selected
ps_i() {
	PROC_ID_ORIGIN=$(ps -alf | fzf-tmux -p 80%)
	if [[ $(echo "$PROC_ID_ORIGIN" | grep "UID[[:blank:]]*PID")x == ""x ]]; then
		PROC_ID=$(echo "$PROC_ID_ORIGIN" | grep -o '^[^[:blank:]]*[[:blank:]]*[^[:blank:]]*[[:blank:]]*[^[:blank:]]*[[:blank:]]*[^[:blank:]]*' | grep -o '[[:digit:]]*$')
		top -p "$PROC_ID"
	fi
}

# ps: check: with top all command
ps_info_all() {
	PROC_ID_ORIGIN=$(ps -elf | fzf-tmux -p 80%)
	if [[ $(echo "$PROC_ID_ORIGIN" | grep "UID[[:blank:]]*PID")x == ""x ]]; then
		PROC_ID=$(echo "$PROC_ID_ORIGIN" | grep -o '^[^[:blank:]]*[[:blank:]]*[^[:blank:]]*[[:blank:]]*[^[:blank:]]*[[:blank:]]*[^[:blank:]]*' | grep -o '[[:digit:]]*$')
		top -p "$PROC_ID"
	fi
}

# ps: tree
ps_tree() {
	PROC_ID_ORIGIN=$(ps -alf | fzf-tmux -p 80%)
	if [[ $(echo "$PROC_ID_ORIGIN" | grep "UID[[:blank:]]*PID")x == ""x ]]; then
		PROC_ID=$(echo "$PROC_ID_ORIGIN" | grep -o '^[^[:blank:]]*[[:blank:]]*[^[:blank:]]*[[:blank:]]*[^[:blank:]]*[[:blank:]]*[^[:blank:]]*' | grep -o '[[:digit:]]*$')
		pstree -p "$PROC_ID"
	fi
}

# ps: tree all
ps_tree_all() {
	PROC_ID_ORIGIN=$(ps -elf | fzf-tmux -p 80%)
	if [[ $(echo "$PROC_ID_ORIGIN" | grep "UID[[:blank:]]*PID")x == ""x ]]; then
		PROC_ID=$(echo "$PROC_ID_ORIGIN" | grep -o '^[^[:blank:]]*[[:blank:]]*[^[:blank:]]*[[:blank:]]*[^[:blank:]]*[[:blank:]]*[^[:blank:]]*' | grep -o '[[:digit:]]*$')
		pstree -p "$PROC_ID"
	fi
}

# ps: kill
ps_kill() {
	PROC_ID_ORIGIN=$(ps -alf | grcat fps.grc | fzf-tmux -p 80%)
	if [[ $(echo "$PROC_ID_ORIGIN" | grep "UID[[:blank:]]*PID")x == ""x ]]; then
		PROC_ID=$(echo "$PROC_ID_ORIGIN" | grep -o '^[^[:blank:]]*[[:blank:]]*[^[:blank:]]*[[:blank:]]*[^[:blank:]]*[[:blank:]]*[^[:blank:]]*' | grep -o '[[:digit:]]*$')
		kill -9 "$PROC_ID"
	fi
}

# ps: kill
ps_kill_all() {
	PROC_ID_ORIGIN=$(ps -elf | fzf-tmux -p 80%)
	if [[ $(echo "$PROC_ID_ORIGIN" | grep "UID[[:blank:]]*PID")x == ""x ]]; then
		PROC_ID=$(echo "$PROC_ID_ORIGIN" | grep -o '^[^[:blank:]]*[[:blank:]]*[^[:blank:]]*[[:blank:]]*[^[:blank:]]*[[:blank:]]*[^[:blank:]]*' | grep -o '[[:digit:]]*$')
		kill -9 "$PROC_ID"
	fi
}

# alias py_pipl="pip list --format=columns"
# alias py_pips="pip show"
# alias py_pudb="python -m pudb"

# alias py_sourcesme="source ./.venv/bin/activate"

# alias npm_gout="npm -g outdated"
# alias npm_gupdated="npm -g update"
# alias npm_list="npm list -g --depth 0"
# alias npm_inst="npm install --save-dev"

# Info -> https://github.com/junegunn/fzf/wiki/examples#opening-files

# Check guide docker help commands:
# https://gist.github.com/bradtraversy/89fad226dc058a41b596d586022a9bd3

# ╭──────────────────────────────────────────────────────────╮
# │                          DOCKER                          │
# ╰──────────────────────────────────────────────────────────╯

# ╞══════════════════════════════════════════════════════════╡
#   Docker image
# ╞══════════════════════════════════════════════════════════╡

# docker: show list of docker images
doc_im_ls() {
	docker images
}

# docker: image: check histroy of docker image <$DOCKER_IMAGE_ID>
doc_im_his_id() {
	if [ -n "$1" ]; then
		docker history "$1"
	else
		echo "warn - [docker history image] need image_id"
	fi
}

# docker: image: build images with <$YOUR_NEW_DOCKER_TAG>
doc_im_build_tag() {
	if [ -n "$1" ]; then
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
	if [ -n "$1" ]; then
		__send_msg "docker rmi -f <id>"
		docker rmi -f "$1"
	else
		echo "warn - [docker image] need image_id"
	fi
}

# ╞══════════════════════════════════════════════════════════╡
#   Docker Container
# ╞══════════════════════════════════════════════════════════╡

# docker: container: show list or containers
doc_con_ls() {
	__send_msg "docker ps -a"
	docker ps -a
}

# docker: container: run container <$DOCKER_TARGET_IMAGE_ID> (run -it)
doc_con_run_it() {
	__send_msg "docker run -it <id>"

	if [ -n "$1" ]; then
		docker run -it "$@"
	else
		echo "warn - [docker image] need image_id"
	fi
}

# docker: container: run container but destroy <$DOCKER_TARGET_IMAGE_ID> (run --rm)
doc_con_run_rmit() {
	__send_msg "docker run -it --rm  <id>"

	if [ -n "$1" ]; then
		docker run -it --rm "$1"
	else
		echo "warn - [docker image] need image_id"
	fi
}

# docker: container: check inspect container <$DOCKER_CONTAINER_ID>
doc_con_inspect_id() {
	if [ -n "$1" ]; then
		__send_msg "docker container inspect <id>"
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
	if [ -n "$1" ]; then
		docker container logs "$1"
	else
		echo "[warn] doc_con_log: need container id"
	fi
}

# docker: container: start container <$DOCKER_CONTAINER_ID>
doc_con_start_id() {

	__send_msg "docker start <id>"

	if [ -n "$1" ]; then
		docker start "$1"
	else
		echo "[warn] doc_con_start_id: need container id"
	fi
}

# docker: container: stop container <$DOCKER_CONTAINER_ID>
doc_con_stop_id() {

	__send_msg "docker stop <id>"

	if [ -n "$1" ]; then
		docker stop "$1"
	else
		echo "[warn] doc_con_stop_id: need container id"
	fi
}

# docker: container: restart container <$DOCKER_CONTAINER_ID>
doc_con_restart_id() {

	__send_msg "docker restart <id>"

	if [ -n "$1" ]; then
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
	if [ -n "$1" ]; then
		docker rm "$1"
	else
		echo "[warn] doc_con_rid: need container id"
	fi
}

# docker: container: remove container with contains the string  'exit'
doc_con_rallex() {
	__send_msg "docker ps -a | grep Exit | cut -d ' ' -f 1 | xargs docker rm"
	docker ps -a | grep Exit | cut -d ' ' -f 1 | xargs docker rm
}

# docker: container: enter/login the container <$DOCKER_CONTAINER_ID>
doc_con_enter_id() {
	__send_msg "docker exec -it <id> /bin/bash"
	docker exec -it "$1" /bin/bash
}

# ╞══════════════════════════════════════════════════════════╡
#   Docker Volume
# ╞══════════════════════════════════════════════════════════╡

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
	if [ -n "$1" ]; then
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

# ╞══════════════════════════════════════════════════════════╡
#   Docker Network
# ╞══════════════════════════════════════════════════════════╡

# docker: network: show list of docker network
doc_net_ls() {
	docker network ls
}

# docker: network: remove all docker network
doc_net_rall() {
	docker network rm "$(docker network ls -q)"
}

# ╞══════════════════════════════════════════════════════════╡
#   Docker Compose
# ╞══════════════════════════════════════════════════════════╡

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

# yarn: install package local directory <$PACKAGE>
yarn_i_saveDev() {

	if [ -n "$1" ]; then
		yarn add -D "$1"
	else
		printf "\nwrong!\n\tex: yarn_i_savedev lodash\n\n"
	fi

}

# ╭──────────────────────────────────────────────────────────╮
# │                   COMMAND PROGRAMMING                    │
# ╰──────────────────────────────────────────────────────────╯

# ╞══════════════════════════════════════════════════════════╡
#   Npm and Yarn
# ╞══════════════════════════════════════════════════════════╡

# yarn: install package for global directory <$PACKAGE>
pr_yarn_i_saveGlobal() {

	if [ -n "$1" ]; then
		yarn global add "$1"
	else
		printf "\nwrong!\n\tex: yarn_i_global lodash\n\n"
	fi

}

# yarn: run with <$SCRIPT_NAME>
pr_yarn_run() {

	if [ -n "$1" ]; then
		yarn run "$1"
	else
		printf "\nwrong!\n\tex: yarn_t_run linter\n\n"
	fi

}

# npm: install package for global directory <$PACKAGE>
pr_npm_i_saveGlobal() {

	if [ -n "$1" ]; then
		npm install -g "$1"
	else
		printf "\nwrong!\n\tex: npm_i_global lodash\n\n"
	fi

}

# npm: check: outdated global packages
pr_npm_c_goutdated() {
	npm outdated -g
}

# ╞══════════════════════════════════════════════════════════╡
#   Pip
# ╞══════════════════════════════════════════════════════════╡

# pip: install package <$PACKAGE>++
pr_pip_i() {
	if [ -n "$1" ]; then
		pip install "$1"
	else
		printf "\nwrong!\n\tex: pip_i request\n\n"
	fi
}

# pip: search package <$PACKAGE>++
pr_pip_search() {
	if [ -n "$1" ]; then
		pip search "$1"
	else
		printf "\nwrong!\n\tex: pip_search request\n\n"
	fi
}

# pip: check: show package <$PACKAGE>++
pr_pip_show() {
	if [ -n "$1" ]; then
		pip show "$1"
	else
		printf "\nwrong!\n\tex: pip_search request\n\n"
	fi
}

# pip: check: list packages <$PACKAGE>++
pr_pip_c_ls() {
	pip list | less
}

# pip: install from requirments <$REQUIRMENTS.TXT>
pr_pip_i_requirments() {

	if [ -n "$1" ]; then
		pip install -r "$1"
	else
		printf "\nwrong!\n\tex: pip_i_requirments requirments.txt\n\n"
	fi
}

# pip: export packages installed to <$REQUIRMENTS.TXT>
pr_pip_frez_requirments() {

	if [ -n "$1" ]; then
		pip freeze >"$1"
	else
		printf "\nwrong!\n\tex: pip_frez_requirments requirments.txt\n\n"
	fi

}

# ╞══════════════════════════════════════════════════════════╡
#   Poetry
# ╞══════════════════════════════════════════════════════════╡

# pipenv: install package <$PACKAGES>++
pr_pipenv_i() {

	if [ -n "$1" ]; then
		pipenv install "$1"
	else
		printf "\nwrong!\n\tex: pipenv_i requests\n\n"
	fi

}

# pipenv: install package as dev <$PACKAGES>++
pr_pipenv_i_savedev() {

	if [ -n "$1" ]; then
		pipenv install --dev "$1"
	else
		printf "\nwrong!\n\tex: pipenv_i_savedev requests\n\n"
	fi

}

# pipenv: just do 'pipenv install' will install from pipfile
pr_pipenv_i_pipfile() {
	pipenv install
}

# pipenv: uninstall package <$PACKAGES>++
pr_pipenv_unins() {

	if [ -n "$1" ]; then
		pipenv uninstall "$1"
	else
		printf "\nwrong!\n\tex: pipenv_unins requestst\n\n"
	fi

}

# pipenv: install from requirments <$REQUIRMENTS.TXT>
pr_pipenv_i_requirments() {

	if [ -n "$1" ]; then
		pipenv install -r "$1"
	else
		printf "\nwrong!\n\tex: pipenv_i_requirments requirments.txt\n\n"
	fi
}

# pipenv: check: security vulnerabilities
pr_pipenv_c_vuln() {
	pipenv check
}

# pipenv: exit from virtualenvs
pr_pipenv_exit() {
	exit
}

# pipenv: enter virtualenvs base on pipenv path
# pipenv_r_source_active() {
# 	source "$(pipenv --venv)/bin/activate"
# 	# pipenv shell
# }

# pipenv: create virtualenvs with pipenv
pr_pipenv_shell() {
	pipenv shell
	# pipenv shell
}

# pipenv: remove or delete current virtualenvs
pr_pipenv_del() {
	pipenv --rm
}

# tsm: torrent transmission-remote -l
tsm_ls() {
	transmission-remote -l
}

# tsm: torrent transmission-remote alt speed enable
tsm_altspeedenable() {
	transmission-remote --alt-speed
}

# tsm: torrent transmission-remote alt speed disable
tsm_noaltspeedenable() {
	transmission-remote --no-alt-speed
}

# tsm: torrent transmission-remote add torrent links <$1>
tsm_add() {
	transmission-remote -a "$1"
}

# tsm: torrent transmission-remote pause with ID <$1>
tsm_pause() {
	transmission-remote -t "$1" --stop
}

# tsm: transmission-remote start with ID <$1>
tsm_start() {
	transmission-remote -t "$1" --start
}

# tsm: run transmission-daemon
tsm_running() {
	transmission-daemon
}

# tsm: transmission-remote will remove torrent and data also
tsm_purge() {
	transmission-remote -t "$1" --remove-and-delete
}

# tsm: transmission-remote remove, remove torrent but not the data
tsm_remove() {
	chosen=$(
		transmission-remote -l | tail -n +2 >/tmp/test
		sed -i '$ d' /tmp/test
		cat /tmp/test | fzf-tmux -p 80% | xargs | cut -d" " -f1
	)
	if [ -n "$chosen" ]; then
		transmission-remote -t "$chosen" -r
	fi

	rm /tmp/test
}

# tsm: transmission-remote info with ID <$1>
tsm_i() {
	transmission-remote -t "$1" -i
}

# vim: set ft=sh:
