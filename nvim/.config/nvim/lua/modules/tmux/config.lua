local config = {}

function config.tmux_navigator()
end

function config.obvious_resize()
  vim.g.obvious_resize_default = 7
  vim.g.obvious_resize_run_tmux = 1
end

return config
