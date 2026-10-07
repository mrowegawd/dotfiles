local add_remote_or_local_on_event = require("vim-pack").add_remote_or_local_on_event

add_remote_or_local_on_event("BufReadPost", {
  {
    src = "nvim_plugins/PDFview",
    setup = false,
    opts = function()
      return {
        path = os.getenv "HOME" .. "/Downloads/torrent",
        picker = "fzf-lua",
        open = {
          cb = function()
            vim.api.nvim_input ":CodeCompanion /translator_role <CR>"
          end,
        },
        keymaps = {
          go_to_page = "<Localleader>qf",
          show_page_in_zathura = "<Localleader>qd",
          next_page = "<a-n>",
          prev_page = "<a-p>",
        },
      }
    end,
  },
})
