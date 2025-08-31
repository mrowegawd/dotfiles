local keymap, api, opt = vim.keymap, vim.api, vim.opt_local

opt.foldexpr = ""
opt.foldmethod = "syntax"

-- opt.number = false
-- opt.relativenumber = false
opt.signcolumn = "no"

keymap.set("n", "<Tab>", function()
  vim.schedule(function()
    local _, err = pcall(function()
      vim.fn.execute "normal! za"
    end)

    if err and (string.match(err, "E510") or string.match(err, "E490")) then
      local msg = string.format "No fold found"
      ---@diagnostic disable-next-line: undefined-field
      RUtils.warn(msg, { title = "Folds" })
    end
  end)
end, { buffer = api.nvim_get_current_buf() })
