#!/usr/bin/env sh

FPATH="$1"

# set to 1 to enable GUI apps and/or BIN execution
GUI="${GUI:-0}"

not_in_tmux() {
	[ -z "$TMUX" ]
}

is_mac() {
	uname | grep -q "Darwin"
}

# sets the variable abs_target, this should be faster than calling printf
abspath() {
	case "$1" in
	/*) abs_target="$1" ;;
	*) abs_target="$PWD/$1" ;;
	esac
}

# storing the result to a tmp file is faster than calling listimages twice
listimages() {
	find -L "///${1%/*}" -maxdepth 1 -type f -print0 |
		grep -izZE '\.(jpe?g|png|gif|webp|tiff|bmp|ico|svg)$' |
		sort -z | tee "$tmp"
}

load_dir() {
	abspath "$2"
	tmp="${TMPDIR:-/tmp}/nuke_$$"
	trap 'rm -f $tmp' EXIT
	count="$(listimages "$abs_target" | grep -a -m 1 -ZznF "$abs_target" | cut -d: -f1)"

	if [ -n "$count" ]; then
		if [ "$GUI" -ne 0 ]; then
			xargs -0 nohup "$1" -n "$count" -- <"$tmp"
		else
			xargs -0 "$1" -n "$count" -- <"$tmp"
		fi
	else
		shift
		"$1" -- "$@" # fallback
	fi
}

handle_audio() {
	if type mocp >/dev/null 2>&1 && type mocq >/dev/null 2>&1; then
		mocq "${FPATH}" "opener" >/dev/null 2>&1
	elif type mpv >/dev/null 2>&1; then
		mpv "${FPATH}" >/dev/null 2>&1 &
	elif type media_client >/dev/null 2>&1; then
		media_client play "${FPATH}" >/dev/null 2>&1 &
	elif type mediainfo >/dev/null 2>&1; then
		mediainfo "${FPATH}" | eval "$PAGER"
	elif type exiftool >/dev/null 2>&1; then
		exiftool "${FPATH}" | eval "$PAGER"
	else
		return
	fi
	exit 0
}
handle_video() {
	# if [ "$GUI" -ne 0 ]; then
	if is_mac; then
		nohup open "${FPATH}" >/dev/null 2>&1 &
	elif type smplayer >/dev/null 2>&1; then
		nohup smplayer "${FPATH}" >/dev/null 2>&1 &
	elif type mpv >/dev/null 2>&1; then
		# nohup mpv "${FPATH}" >/dev/null 2>&1 &
		nohup mpv --autofit=1000x900 --geometry=-15-60 "${FPATH}" >/dev/null 2>&1 &
	else
		return
	fi
	# elif type ffmpegthumbnailer >/dev/null 2>&1; then
	# 	# Thumbnail
	# 	[ -d "${IMAGE_CACHE_PATH}" ] || mkdir "${IMAGE_CACHE_PATH}"
	# 	ffmpegthumbnailer -i "${FPATH}" -o "${IMAGE_CACHE_PATH}/${FNAME}.jpg" -s 0
	# 	viu -n "${IMAGE_CACHE_PATH}/${FNAME}.jpg" | eval "$PAGER"
	# elif type mediainfo >/dev/null 2>&1; then
	# 	mediainfo "${FPATH}" | eval "$PAGER"
	# elif type exiftool >/dev/null 2>&1; then
	# 	exiftool "${FPATH}" | eval "$PAGER"
	# else
	# 	return
	# fi
	exit 0
}

handle_pdf() {
	if is_mac; then
		nohup open "${FPATH}" >/dev/null 2>&1 &
	elif type zathura >/dev/null 2>&1; then
		nohup zathura "${FPATH}" >/dev/null 2>&1 &
	else
		return
	fi
	# elif type pdftotext >/dev/null 2>&1; then
	# 	## Preview as text conversion
	# 	pdftotext -l 10 -nopgbrk -q -- "${FPATH}" - | eval "$PAGER"
	# elif type mutool >/dev/null 2>&1; then
	# 	mutool draw -F txt -i -- "${FPATH}" 1-10 | eval "$PAGER"
	# elif type exiftool >/dev/null 2>&1; then
	# 	exiftool "${FPATH}" | eval "$PAGER"
	# else
	# 	return
	# fi
	exit 0
}

ftype=$(xdg-mime query filetype "$2/$1")

case "$ftype" in
## PDF
application/pdf)
	handle_pdf
	exit 1
	;;

## Audio
audio/*)
	handle_audio
	exit 1
	;;

## Video
video/*)
	handle_video
	exit 1
	;;

## gif
image/gif)
	mpv --force-window=immediate --autofit=800x800 --loop-file "${FPATH}"
	;;

## Image
image/*)
	# if [ "$GUI" -ne 0 ]; then
	if is_mac; then
		nohup open "${FPATH}" >/dev/null 2>&1 &
		exit 0
	elif type imv >/dev/null 2>&1; then
		load_dir imv "${FPATH}" >/dev/null 2>&1 &
		exit 0
	elif type imvr >/dev/null 2>&1; then
		load_dir imvr "${FPATH}" >/dev/null 2>&1 &
		exit 0
	elif type sxiv >/dev/null 2>&1; then
		load_dir sxiv "${FPATH}" >/dev/null 2>&1 &
		exit 0
	elif type nsxiv >/dev/null 2>&1; then
		load_dir nsxiv "${FPATH}" >/dev/null 2>&1 &
		exit 0
	fi
	# elif type viu >/dev/null 2>&1; then
	# 	viu -n "${FPATH}" | eval "$PAGER"
	# 	exit 0
	# elif type img2txt >/dev/null 2>&1; then
	# 	img2txt --gamma=0.6 -- "${FPATH}" | eval "$PAGER"
	# 	exit 0
	# elif type exiftool >/dev/null 2>&1; then
	# 	exiftool "${FPATH}" | eval "$PAGER"
	# 	exit 0
	# fi
	;;
*)
	if not_in_tmux; then
		pane_id=$(wezterm cli get-pane-direction right)
		if [ -z "${pane_id}" ]; then
			pane_id=$(wezterm cli split-pane --right --percent 85)
		fi

		program=$(wezterm cli list | awk -v pane_id="$pane_id" '$3==pane_id { print $6 }')

		if [ "$program" = "nvim" ]; then
			# echo ":e ${FPATH}\r" | wezterm cli send-text --pane-id "$pane_id" --no-paste
			echo ":e ${FPATH}\r" | wezterm cli send-text --pane-id "$pane_id" --no-paste
		else
			echo "nvim ${FPATH}\r" | wezterm cli send-text --pane-id "$pane_id" --no-paste
		fi

		wezterm cli activate-pane-direction --pane-id "$pane_id" right

	else

		tmux select-pane -R
		current_pane=$(tmux display-message -p '#{pane_id}')
		# output current_pane selalu 1
		if [ -z "${current_pane}" ]; then # --> jadi conditional ini tidak masuk
			# dunstify "mantap"
			tmux split-window -h -p 83
			current_pane=$(tmux display-message -p '#{pane_id}')
		fi

		program=$(tmux display -p '#{pane_current_command}')
		if [ "$program" = "nvim" ]; then
			tmux send-keys -t "$current_pane" ":e ${FPATH}" Enter
		else
			tmux send-keys -t "$current_pane" "nvim ${FPATH}" Enter
		fi
	fi

	;;
esac
