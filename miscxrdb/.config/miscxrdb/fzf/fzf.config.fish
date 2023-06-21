function _gen_fzf_default_opts

          # --files: List files that would be searched but do not search
          # --no-ignore: Do not respect .gitignore, etc...
          # --hidden: Search hidden files and folders
          export FZF_DEFAULT_COMMAND='rg --files --no-ignore-vcs --hidden --smart-case'

          # export FZF_DEFAULT_COMMAND='rg --no-heading --hidden --follow --no-ignore-vcs --smart-case '

          export FZF_DEFAULT_OPTS='
          --bind ctrl-a:toggle-all,ctrl-l:clear-query,ctrl-d:preview-down,ctrl-u:preview-up,ctrl-n:down,ctrl-p:up,ctrl-g:top,F4:toggle-preview
          --color=bg:#1c1e24,fg:,hl:#ff7c7b --height=40%
          --color=bg+:#275574,fg+:#bbc2cf,hl+:#ff7c7b,gutter:#1c1e24,pointer:#98be65
          --preview "echo {}" --preview-window down:4:hidden:wrap --border --reverse
          --cycle --prompt="> "'

end
_gen_fzf_default_opts
