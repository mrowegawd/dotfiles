local keymap, api = vim.keymap, vim.api

-- Disable ctrl-i and ctrl-o
keymap.set("n", "<c-i>", "<Nop>", { buffer = api.nvim_get_current_buf() })
keymap.set("n", "<c-o>", "<Nop>", { buffer = api.nvim_get_current_buf() })

keymap.set("n", "<c-q>", function()
  local tbl_items = {}
  local prefix_title
  if vim.bo.filetype == "trouble" then
    local items = require("trouble").get_items()

    for _, x in pairs(items) do
      table.insert(tbl_items, {
        bufnr = x.buf,
        text = x.text,
        lnum = x.pos[1],
        col = x.pos[2],
        filename = x.filename,
      })

      if prefix_title == nil then
        prefix_title = x.source
      end
    end
  end

  if #tbl_items > 0 then
    vim.fn.setqflist({}, "r", { title = "Trouble-" .. prefix_title, items = tbl_items })

    local qf_win = RUtils.cmd.windows_is_opened { "trouble" }
    if qf_win.found then
      require("trouble").close()
    end

    local is_qf_opened = RUtils.cmd.windows_is_opened { "qf" }
    if not is_qf_opened.found then
      vim.cmd "copen"
    end
  end
end, { buffer = api.nvim_get_current_buf(), desc = "Trouble: send to quickfix" })
