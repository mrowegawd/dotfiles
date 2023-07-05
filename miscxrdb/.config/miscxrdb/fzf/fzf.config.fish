function _gen_fzf_default_opts

          # --files: List files that would be searched but do not search
          # --no-ignore: Do not respect .gitignore, etc...
          # --hidden: Search hidden files and folders
          export FZF_DEFAULT_COMMAND='rg --files --no-ignore-vcs --hidden --smart-case'

          # export FZF_DEFAULT_COMMAND='rg --no-heading --hidden --follow --no-ignore-vcs --smart-case '

          export FZF_DEFAULT_OPTS='
          --bind ctrl-a:toggle-all,ctrl-l:clear-query,ctrl-d:preview-down,ctrl-u:preview-up,ctrl-n:down,ctrl-p:up,ctrl-g:top,F4:toggle-preview
          --color=bg:#15151c,fg:,hl:#ff3636 --height=40%
          --color=bg+:#1f3748,fg+:#dcd7ba,hl+:#ff3636,gutter:#15151c,pointer:#76946a
          --preview "echo {}" --preview-window down:4:hidden:wrap --border --reverse
          --cycle --prompt="> "'

end
_gen_fzf_default_opts
