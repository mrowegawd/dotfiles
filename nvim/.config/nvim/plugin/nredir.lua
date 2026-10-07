local add = require("vim-pack").add

add {
  {
    src = "sbulav/nredir.nvim",
    lazy = true,

    -- Usage:
    -- " Run a Vim Ex command:
    -- :Nredir buffers

    -- " Run a shell command:
    -- :Nredir !ls -la

    -- " Color output not supported:
    -- :Nredir !tofu plan -no-color

    -- " Run a complex shell pipeline:
    -- :Nredir !sleep 5 && echo "done"
  },
}

vim.api.nvim_create_user_command("Nredir", function()
  require("vim-pack").load_now "nredir.nvim"
end, {})
