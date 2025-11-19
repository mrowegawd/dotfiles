
# Custom completion for 'cd' that uses fzf-tab and grep
_comp_dirs() {
  # Periksa apakah input mengandung " .. "
  local next_word="$words[2]"
  if [[ "$next_word" != "" ]]; then
    _cd
    return 0
  fi

  local directory
  directory=$(fd --color=never --type d --hidden --follow --exclude .git  2>/dev/null | fzf --preview-window 'right:50%:nohidden' --preview 'eza -a --tree --level=2 --icons --color=always {}')

  if [[ -n "$directory" ]]; then
    compadd -Q -- "$directory"
  fi

  # compadd -Q -- ${(f)"$(rg --files --column --line-number --no-heading --hidden --follow --smart-case 2>/dev/null)"}
}

# Use _comp_dirs for cd
compdef _comp_dirs cd
