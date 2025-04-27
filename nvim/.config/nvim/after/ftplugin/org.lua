local keymap = vim.keymap

local fzf_lua = RUtils.cmd.reqcall "fzf-lua"

keymap.set("n", "<Leader>ri", "<CMD>ImgInsert<CR>", { buffer = true, desc = "Markdown: insert image" })
-- vim.cmd [[:%s/^#\+/\=repeat('*', len(submatch(0)))/]]

keymap.set("n", "<Leader>rf", function()
  local opts = {
    winopts = {
      title = RUtils.fzflua.format_title("Buffers", "󰈙"),
      width = 0.60,
      height = 0.25,
      col = 0.50,
      row = 0.50,
      backdrop = 60,
    },
  }

  opts.actions = vim.tbl_extend("keep", {
    ["default"] = function(selected, _)
      local sel = selected[1]
      if sel == "Sniprun" then
        vim.cmd [[SnipRun]]
      end
    end,
  }, {})

  fzf_lua.fzf_exec({ "Sniprun", "ImgInsert" }, opts)
end, { buffer = true, desc = "Tasks: runner" })
