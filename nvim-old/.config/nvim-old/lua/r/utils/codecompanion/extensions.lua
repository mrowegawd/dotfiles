local M = {}

local extensions = {
  -- History
  history = {
    enabled = true,
    opts = {
      auto_generate_title = false,
      auto_save = true,
      expiration_days = 30,
      keymap = { n = "<nope>", i = "<nope>" },
      picker_keymaps = {
        rename = { n = "<C-r>", i = "<C-r>" },
        delete = { n = "<C-x>", i = "<C-x>" },
        duplicate = { n = "<C-y>", i = "<C-y>" },
      },
      save_chat_keymap = { n = "<nop>", i = "<nop>" },
    },
  },
}

function M.build()
  return extensions
end

return M
