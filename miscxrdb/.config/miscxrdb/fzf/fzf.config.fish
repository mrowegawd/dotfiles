function _gen_fzf_default_opts

          # --files: List files that would be searched but do not search
          # --no-ignore: Do not respect .gitignore, etc...
          # --hidden: Search hidden files and folders
          export FZF_DEFAULT_COMMAND='rg --files --no-ignore-vcs --hidden --smart-case'

          # export FZF_DEFAULT_COMMAND='rg --no-heading --hidden --follow --no-ignore-vcs --smart-case '

          export FZF_DEFAULT_OPTS='
          --bind ctrl-a:toggle-all,ctrl-l:clear-query,ctrl-d:preview-down,ctrl-u:preview-up,ctrl-n:down,ctrl-p:up,ctrl-g:top,F4:toggle-preview
          --color=bg:#191c29,fg:#868dab,hl:#ff6161 --height=40%
          --color=bg+:#3b4363,fg+:#c0caf5,hl+:#ff6161,gutter:#191c29,pointer:#9ece6a
          --preview "echo {}" --preview-window down:4:hidden:wrap --border --reverse
          --cycle --prompt="> "'

end
_gen_fzf_default_opts
