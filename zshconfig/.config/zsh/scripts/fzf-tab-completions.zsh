_comp_files() {
  local prefix
  prefix="${words[CURRENT]}"

  if [[ "$prefix" != "" ]]; then
    _files
    return
  fi

  local files
  files=$(
    rg -i --files --hidden --follow --smart-case 2>/dev/null |
      fzf \
        --query="$prefix" \
        --preview-window 'right:50%:nohidden' \
        --preview 'bat --style=numbers --color=always --line-range :500 {}'
  )

  if [[ -n "$files" ]]; then
    compadd -Q -- "$files"
  fi
}

# Register completion for editors
compdef _comp_files nvim v vim
