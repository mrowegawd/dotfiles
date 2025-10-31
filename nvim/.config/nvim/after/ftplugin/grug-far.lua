local keymap, api, opts = vim.keymap, vim.api, vim.opt_local

opts.wrap = false

keymap.set("n", "o", function()
  local get_inst = function()
    return require("grug-far").get_instance(0)
  end

  if vim.v.count then
    get_inst():goto_match(vim.v.count)
  end
  get_inst():goto_location()
end, { buffer = api.nvim_get_current_buf(), silent = true })

keymap.set("n", "<c-v>", function()
  local get_inst = function()
    return require("grug-far").get_instance(0)
  end

  if vim.v.count then
    get_inst():goto_match(vim.v.count)
  end
  get_inst():goto_location()
end, { buffer = api.nvim_get_current_buf(), silent = true })
