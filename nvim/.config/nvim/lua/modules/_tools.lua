local api = vim.api
local fn = vim.fn

local M = {}

M.xresources = function(color)
  local col = fn.systemlist(
    "grep -i "
      .. color
      .. " < ~/.cache/paintee | head -1 | awk -F= '{print $2}' | sed 's/\"//g'"
  )
  if col ~= nil then
    return col[1]
  end
  return nil
end

M.mygit = function()
  local gitnm = fn.systemlist("git rev-parse --abbrev-ref HEAD 2>/dev/null | tr -d '\n'")
  return gitnm[1]
end

M.vimbg = function(name)
  local idnum = api.nvim_call_function("hlID", { name })
  local col = api.nvim_call_function("synIDattr", { idnum, "bg" })
  return col
end

M.vimfg = function(name)
  local idnum = api.nvim_call_function("hlID", { name })
  local col = api.nvim_call_function("synIDattr", { idnum, "fg" })
  return col
end

local modepomo_pause = 0
M.pomorun = function(keymap)

  local is_in_tmux = api.nvim_call_function("exists", { "$TMUX" })
  local check_pomo_tmuxwindow = fn.systemlist("tmux list-window | grep mypomo")

  if is_in_tmux > 0 then
    if keymap == "toggle" then

      if check_pomo_tmuxwindow[1] == nil then

        local ans_duration = fn.input("how much duration you need ([h]our/[m]inute ex 60m/1h)? ")
          or "25m"
        local ans_interval = fn.input("how much interval you need 3/2 or more? ")
          or "5"

        fn.systemlist("rm -rf $HOME/.pomo/pomo.sock")

        local pomo_cmd = "tmux new-windo && tmux rename-window 'mypomo'"
        pomo_cmd = pomo_cmd .. " && " .. "notify-send \"Pomo started..\""
        pomo_cmd = pomo_cmd
          .. " && "
          .. "tmux send-keys 'pomo start --tag \"ok\""

        pomo_cmd = pomo_cmd
          .. " --duration \""
          .. string.format("%s", ans_duration)
          .. "\" --pomodoros \""
          .. string.format("%s", ans_interval)
          .. "\" \"asfasdhf\"' enter"

        pomo_cmd = pomo_cmd .. " && " .. "tmux last-window"

        fn.systemlist(pomo_cmd)
      else
        fn.systemlist("tmux send-keys -t mypomo q")
        fn.systemlist("tmux kill-window -t mypomo && notify-send \"Pomo exited..\"")
      end

      api.nvim_command("normal :esc<CR>")
      return
    end

    if keymap == "pausetoggle" and modepomo_pause == 0 then
      fn.systemlist("tmux send-keys -t mypomo p && notify-send \"Pomo resume..\"")
      modepomo_pause = 1
      return
    elseif keymap == "pausetoggle" and modepomo_pause == 1 then
      fn.systemlist("tmux send-keys -t mypomo p && notify-send \"Pomo pause..\"")
      modepomo_pause = 0
      return
    end

  end

  print("Pomodoro will not run if you run outside tmux!!")
end

M.map = function(mode, key, result, opts)
  api.nvim_set_keymap(mode, key, result, {
    noremap = true,
    silent = opts.silent or false,
    expr = opts.expr or false,
    script = opts.script or false,
  })
end

return M
