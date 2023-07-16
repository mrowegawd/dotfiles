local keymap = vim.keymap

local set_toggle = 1

local function run_toggleterm()
  vim.cmd "silent noautocmd update"

  if set_toggle == 1 then
    vim.cmd.MarkdownPreviewToggle()
    set_toggle = 0
  else
    vim.cmd.MarkdownPreviewToggle()
    vim.notify "Closing MarkdownPreviewToggle"
    set_toggle = 1
  end
end

keymap.set("n", "<Leader>rf", run_toggleterm, { buffer = true })
keymap.set("n", "<F5>", run_toggleterm, { buffer = true })
