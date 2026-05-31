local opt_local = vim.opt_local

opt_local.number = false
opt_local.relativenumber = false
opt_local.signcolumn = "no"
opt_local.buflisted = false
opt_local.conceallevel = 2
opt_local.list = false

vim.cmd.wincmd "L"

local function get_text(wrapper)
  -- local escaped = vim.pesc(wrapper)
  local escaped = "\\" .. wrapper
  return vim.fn.matchstr(vim.fn.expand "<cWORD>", ([[\v%s\zs.{-}\ze%s]]):format(escaped, escaped))
end

RUtils.map.nnoremap("gs", function()
  local text = get_text "|"
  if text ~= "" then
    vim.cmd "normal! m'"
    local result = vim.fn.search([[\V\<]] .. vim.fn.escape(text, [[\]]) .. [[\>]])
    if result == 0 then
      RUtils.warn("Tag |" .. text .. "| not found in this document!")
    end
  end
end, { desc = "Help: search |tag|", buffer = true }, true)
RUtils.map.nnoremap("gS", function()
  local text = get_text "*"
  if text ~= "" then
    vim.cmd "normal! m'"
    local result = vim.fn.search([[\V\<]] .. vim.fn.escape(text, [[\]]) .. [[\>]])
    if result == 0 then
      RUtils.warn("Word *" .. text .. "* not found in this document!")
    end
  end
end, { desc = "Help: search *word*", buffer = true }, true)

RUtils.map.nnoremap("<Leader>ld", "<C-]>", { desc = "Help: goto definition", buffer = true }, true)
RUtils.map.nnoremap("<BS>", "<C-t>", { desc = "Help: goback last definition", buffer = true }, true)

RUtils.map.nnoremap("go", function()
  ---@diagnostic disable-next-line: param-type-mismatch
  local success = pcall(vim.cmd, "normal! /'\\l\\{2,\\}'\r")
  if not success then
    -- RUtils.warn "Next Vim option not found!"
    return
  end
end, { buffer = true, silent = true }, true)

RUtils.map.nnoremap("gO", function()
  ---@diagnostic disable-next-line: param-type-mismatch
  local success = pcall(vim.cmd, "normal! ?'\\l\\{2,\\}'\r")
  if not success then
    -- RUtils.warn "Previous Vim option not found!"
    return
  end
end, { buffer = true, silent = true }, true)
