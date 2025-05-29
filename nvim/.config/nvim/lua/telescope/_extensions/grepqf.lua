local action_set = require "telescope.actions.set"
local cmd = vim.cmd

local grepqf = function(opts)
  local bufnr = vim.api.nvim_get_current_buf()
  if vim.bo[bufnr].filetype == "qf" then
    cmd [[wincmd w]]
  end

  local path = {}
  local _qf = vim.fn.getqflist()
  -- The table 'path' still contains duplicate elements
  for i = 1, #_qf do
    table.insert(path, vim.fn.bufname(_qf[i].bufnr))
  end

  if #path == 0 then
    vim.schedule(function()
      vim.notify "No item on qf"
    end)
    return
  end

  opts = {
    vimgrep_arguments = RUtils.config.vimgrep_arguments,
    path_display = { "smart" },
    -- theme = "ivy",
    search_dirs = RUtils.cmd.rm_duplicates_tbl(path), -- much better, unique path
    prompt_title = "Live Grep Qf",

    attach_mappings = function(_)
      action_set.select:enhance {
        post = function()
          vim.cmd ":normal! zx"
        end,
      }
      return true
    end,
  } or {}

  require("telescope.builtin").live_grep(opts)
end

return require("telescope").register_extension {
  exports = { grepqf = grepqf },
}
