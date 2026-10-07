local keymap = vim.keymap
vim.opt_local.textwidth = 60
vim.opt_local.list = false

local fzf_lua = RUtils.cmd.reqcall "fzf-lua"

keymap.set("n", "<Leader>ri", "<CMD>ImgInsert<CR>", { buffer = true, desc = "Markdown: insert image" })

keymap.set("n", "<Leader>rn", function()
  local opts = {
    winopts = {
      fullscreen = false,
      border = RUtils.config.icons.border.rectangle,
      title = RUtils.fzflua.format_title("Buffers", "󰈙"),
      width = 0.60,
      height = 0.25,
      col = 0.50,
      row = 0.50,
    },
  }

  opts.actions = vim.tbl_extend("keep", {
    ["default"] = function(selected, _)
      local sel = selected[1]
      if sel then
        vim.cmd(sel)
      end
    end,
  }, {})

  fzf_lua.fzf_exec({ "SnipRun", "ImgInsert" }, opts)
end, { buffer = true, desc = "Tasks: runner" })
