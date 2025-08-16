local python_errorformat = ""
  -- luacheck:ignore 631
  -- See https://github.com/python-mode/python-mode/blob/149ccf7c5be0753f5e9872c023ab2eeec3442105/autoload/pymode/run.vim#L4
  .. [[%E\ \ File\ \"%f\"\\\,\ line\ %l\\\,%m%\\C,]]
  .. [[%E\ \ File\ \"%f\"\\\,\ line\ %l%\\C,]]
  .. [[%C%p^,]]
  .. [[%-C\ \ %.%#,]]
  .. [[%-C\ \ \ \ %.%#,]]
  .. [[%Z%\\@=%m,]]
  .. [[%+GTraceback%.%#,]]
  .. [[%+GDuring\ handling%.%#,]]
  .. [[%+GThe\ above\ exception%.%#,]]
  .. [[%-G[Process exited%.%#,]]
  .. [[%f:%l:\ %.%#%tarning:%m,]]

local function _parse_qf(task_metadata, cwd, active_window_id)
  local pdb = false

  local current_qf = vim.fn.getqflist()
  local new_qf = {}
  for _, v in ipairs(current_qf) do
    if v.valid > 0 or v.text ~= "" then
      table.insert(new_qf, v)
      if string.match(v.text, "bdb.BdbQuit") then
        pdb = true
      end
    end
  end

  if task_metadata and task_metadata.name == "run_precommit" then
    -- Fix file paths
    for _, v in ipairs(new_qf) do
      local fn = vim.fs.normalize(vim.api.nvim_buf_get_name(v.bufnr))
      for _, i in ipairs(task_metadata.project_files) do
        if string.match(i, fn) then
          vim.cmd.badd(i)
          v.bufnr = vim.fn.bufnr(i)
          break
        end
      end
    end
    vim.cmd.lcd { args = { cwd } }
  end

  if next(new_qf) ~= nil then
    vim.fn.setqflist({}, " ", { items = new_qf, title = task_metadata.run_cmd })
    if not pdb then
      vim.cmd.copen()
    end
    vim.api.nvim_set_current_win(active_window_id)
  end
end

local function tmux2qf(cmd_opt)
  local tmux_win_nr = cmd_opt.args
  local result = vim.system({ "tmux", "capture-pane", "-p", "-t", tmux_win_nr }, { text = true }):wait()
  vim.fn.setqflist({}, " ", {
    lines = vim.split(result.stdout or "", "\n", { plain = true }),
    efm = python_errorformat,
  })
  _parse_qf({ run_cmd = "Tmux Window: " .. tmux_win_nr }, vim.uv.cwd(), vim.api.nvim_get_current_win())
end

local function run_ipython(mode)
  vim.cmd.update { mods = { silent = true, noautocmd = true } }
  local fname = vim.api.nvim_buf_get_name(0)

  local ttt = require "toggleterm.terminal"
  local term_info = ttt.get(1)
  local is_open = term_info ~= nil and term_info:is_open() or false
  if not is_open then
    local ipython = ttt.Terminal:new {
      cmd = "ipython",
      hidden = false,
    }
    ipython:toggle()
    vim.cmd.wincmd { args = { "p" } }
    vim.cmd.stopinsert()
  else
    if term_info ~= nil and term_info.cmd ~= "ipython" then
      -- Switch to an ipython console if we are not already in one
      vim.cmd 'TermExec cmd="ipython"'
      term_info.cmd = "ipython"
    end
  end

  if mode == "open" then
    return
  elseif mode == "module" then
    vim.cmd(string.format('TermExec cmd="\\%%run %s"', fname))
  elseif mode == "line" then
    vim.cmd.ToggleTermSendCurrentLine()
  elseif mode == "selection" then
    vim.cmd "normal " -- leave visual mode to set <,> marks
    vim.cmd.ToggleTermSendVisualLines()
  elseif mode == "reset" then
    vim.cmd 'TermExec cmd="\\%reset -f"'
  elseif mode == "carriage" then
    local current_win_id = vim.api.nvim_get_current_win()
    vim.fn.win_gotoid(vim.fn.bufwinid "ipython")
    vim.api.nvim_input "<CR>"
    vim.defer_fn(function()
      vim.api.nvim_set_current_win(current_win_id)
    end, 100)
  end
end

vim.keymap.set("n", "<Leader>rl", function()
  run_ipython "line"
end, { buffer = true })

vim.api.nvim_create_user_command("Tmux2Qf", tmux2qf, { nargs = 1 })
vim.keymap.set("n", "<Leader>lt", ":Tmux2Qf ", { silent = false })
