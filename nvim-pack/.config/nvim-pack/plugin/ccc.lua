local add = require("vim-pack").add

local UtilKey = require "utils.map"

add {
  {
    src = "uga-rosa/ccc.nvim",
    lazy = true,
    opts = {
      highlighter = {
        auto_enable = false,
        lsp = false,
      },
    },
  },
}

local load_ccc = function()
  require("vim-pack").load_now "ccc.nvim"
end

UtilKey.nnoremap("<Leader>oP", function()
  load_ccc()
  vim.cmd.CccPick()
end, { desc = "Open: pick color [ccc.nvim]" })

local ccc_cmds = { "CccHighlighterToggle", "CccHighlighterEnable", "CccHighlighterDisable" }
for _, ccc_cmd in pairs(ccc_cmds) do
  vim.api.nvim_create_user_command(ccc_cmd, function()
    load_ccc()

    vim.api.nvim_cmd({
      cmd = ccc_cmd,
    }, {})
  end, {})
end
