local tmux = {}
local conf = require("modules.tmux.config")

tmux["christoomey/vim-tmux-navigator"] = {
    config = conf.tmux_navigator
}

tmux["talek/obvious-resize"] = {
    config = conf.obvious_resize
}

return tmux
