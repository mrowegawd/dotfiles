
# # Custom completion for 'nvim/v/vim' that uses fzf-tab and grep
_comp_files() {
  # Periksa apakah input mengandung anystring
  local next_word="$words[2]"
  if [[ "$next_word" != "" ]]; then
    _cd
    return 0
  fi

  local files
  files=$(rg --files --column --line-number --no-heading --hidden --follow --smart-case 2>/dev/null | fzf --preview-window 'right:50%:nohidden' --preview 'bat --style=numbers --color=always --line-range :500 {}')
  # files=$(rg --files --column --line-number --no-heading --hidden --follow --smart-case)

  # Jika ada file yang dipilih, return file tersebut
  if [[ -n "$files" ]]; then
    compadd -Q -- "$files"
  fi

  # compadd -Q -- ${(f)"$(rg --files --column --line-number --no-heading --hidden --follow --smart-case 2>/dev/null)"}
  # compadd -Q -- ${(f)"$(rg --files --column --line-number --no-heading --hidden --follow --smart-case)"}
}

# Use _comp_nvim_files for all editor
compdef _comp_files nvim
compdef _comp_files v
compdef _comp_files vim
