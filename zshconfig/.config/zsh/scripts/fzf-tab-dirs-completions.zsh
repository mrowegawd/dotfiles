_comp_dirs() {
  local prefix
  prefix="${words[CURRENT]}"

  # If the user already typed a path (contains /),
  # use the default file completion
  # if [[ "$prefix" == */* ]]; then
  # fi

  if [[ "$prefix" != "" ]]; then
    _cd
    return
  fi

  local directory
  directory=$(
    fd -i --type d --hidden --follow --exclude .git 2>/dev/null |
      fzf \
        --query="$prefix" \
        --preview-window 'right:50%:nohidden' \
        --preview 'eza -a --tree --level=2 --icons --color=always {}'
  )

  if [[ -n "$directory" ]]; then
    compadd -Q -- "$directory"
  fi
}

# Register completion
compdef _comp_dirs cd
