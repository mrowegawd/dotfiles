-- local keymap = vim.keymap
-- local buffer_dir = vim.fn.expand "%:p:h"

vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.list = false

vim.b.make = "luajit"

require("r.utils").write_and_source(0)

-- local run_toggleterm = function()
--   vim.cmd "silent noautocmd update"
--   vim.cmd(string.format('TermExec cmd="%s %s"', "nvim -ll", vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":p")))
-- end
--
-- local run_tmux_pane = function()
--   if vim.env.TMUX == nil then
--     return
--   end
--   local cwd = buffer_dir
--   local fname = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":t")
--   local sh_cmd = '"nvim -ll ' .. fname .. [[; read -p ''"]]
--   vim.cmd("silent! !tmux new-window -c " .. cwd .. " -n " .. fname .. " " .. sh_cmd)
-- end

-- keymap.set({ "n", "i" }, "<F5>", run_tmux_pane, { buffer = true, desc = "Task: run tmux pane" })
--
-- keymap.set("n", "rF", run_toggleterm, { buffer = true, desc = "Task: run toggleterm" })
