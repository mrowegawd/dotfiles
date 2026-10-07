local add = require("vim-pack").add

add {
  {
    src = "NStefan002/screenkey.nvim",
    lazy = true,
  },
}

vim.api.nvim_create_user_command("Screenkey", function()
  require("vim-pack").load_now "screenkey.nvim"

  vim.api.nvim_cmd({
    cmd = "Screenkey",
    args = {},
  }, {})
end, {})
