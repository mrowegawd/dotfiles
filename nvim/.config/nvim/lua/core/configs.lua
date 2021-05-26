local fn = vim.fn
local api = vim.api

local M = {}

SETFolding = 0

M.fold_toggle = function()
  if SETFolding == 1 then
    api.nvim_command("exec 'normal! zM'")
    SETFolding = 0
  else
    api.nvim_command("exec 'normal! zR'")
    SETFolding = 1
  end
end

-- Toggle quicfix and location list
M.copenloc_toggle = function(prefix)
  for _, i in ipairs(vim.fn.getwininfo()) do

    if prefix == "c" then
      if i.quickfix == 0 then
        api.nvim_command("exec 'copen'")
      else
        api.nvim_command("exec 'cclose'")
      end
    end

    if prefix == "l" then
      if i.loclist == 0 then
        api.nvim_command("exec 'lopen'")
      else
        api.nvim_command("exec 'lclose'")
      end
    end
  end
end

M.handleURL = function()
  --  TODO: buatkan nanti untuk grab word under selected cursor from visualline
  --   local lines = fn.getpos("'<")
  --   print(vim.inspect(lines))
  --   print(vim.inspect(lines[2]), lines[3])
  --
--   local first_line, last_line = fn.getpos("'<")[2], fn.getpos("'>")[2]
--   local lines = fn.getline(first_line, last_line)

--   print(vim.inspect(lines))


  local uri = fn.matchstr(fn.getline("."), [[[a-z]*:\/\/[^ >,;")]*]])
  local expand_word = fn.expand("<cword>")

  if uri ~= "" then
    print("open URL: " .. uri)
    api.nvim_command(string.format([[silent!exec '!%s "%s"']], "firefox", uri))
    return
  end

  if expand_word ~= "" then
    print("search keyword: " .. expand_word)
    api.nvim_command(string.format([[silent!exec '!%s "https://www.google.com/search?&q=%s"']], "firefox", expand_word ))
    return
  end

  api.nvim_command([[normal! \<esc>]])

end

return M
