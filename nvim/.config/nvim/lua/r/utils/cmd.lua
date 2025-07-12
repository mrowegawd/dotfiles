---@class r.utils.cmd
local M = {}

function M.remove_alias(link)
  local split_index = string.find(link, "%s*|")
  if split_index ~= nil and type(split_index) == "number" then
    return string.sub(link, 0, split_index - 1)
  end
  return link
end

function M.quit_return()
  vim.cmd "wincmd p"
  local win_id = vim.api.nvim_get_current_win()
  vim.cmd "wincmd p"
  vim.cmd "bdelete"
  vim.fn.win_gotoid(win_id)
end

function M.get_total_wins()
  local tbl_winsplits = {}

  local exclude_ft = { "notify", "snacks_notif", "noice", "trouble", "qf", "smear-cursor" }
  local win_amount = vim.api.nvim_tabpage_list_wins(0)
  for _, winnr in ipairs(win_amount) do
    if not vim.tbl_contains({ "incline" }, vim.fn.getwinvar(winnr, "&syntax")) then
      local winbufnr = vim.fn.winbufnr(winnr)

      if winbufnr > 0 then
        local winft = vim.api.nvim_get_option_value("filetype", { buf = winbufnr })
        if not vim.tbl_contains(exclude_ft, winft) and #winft > 0 then
          table.insert(tbl_winsplits, winft)
        end
      end
    end
  end
  return tbl_winsplits
end

---@param wins table
function M.windows_is_opened(wins)
  wins = wins or {}

  vim.validate {
    wins = { wins, "table" },
  }

  local ft_wins = {
    "incline",
  }

  if #wins > 0 then
    for _, x in pairs(wins) do
      ft_wins[#ft_wins + 1] = x
    end
  end

  local outline_tbl = { found = false, winbufnr = 0, winnr = 0, winid = 0 }
  for _, winnr in ipairs(vim.fn.range(1, vim.fn.winnr "$")) do
    local winbufnr = vim.fn.winbufnr(winnr)
    if
      winbufnr > 0
      and (
        vim.tbl_contains(ft_wins, vim.api.nvim_get_option_value("filetype", { buf = winbufnr }))
        or vim.tbl_contains(ft_wins, vim.api.nvim_get_option_value("buftype", { buf = winbufnr }))
      )
    then
      local winid = vim.fn.win_findbuf(winbufnr)[1] -- example winid: 1004, 1005
      outline_tbl = { found = true, winbufnr = winbufnr, winnr = winnr, winid = winid }
    end
  end

  return outline_tbl
end

function M.get_option(name_opt)
  return vim.api.nvim_get_option_value(name_opt, { scope = "local" })
end

function M.foreach(callback, list)
  for k, v in pairs(list) do
    callback(v, k)
  end
end

function M.pcall(msg, func, ...)
  local L = vim.log.levels
  local args = { ... }
  if type(msg) == "function" then
    local arg = func
    args, func, msg = { arg, unpack(args) }, msg, nil
  end
  return xpcall(func, function(err)
    msg = debug.traceback(msg and string.format("%s:\n%s\n%s", msg, vim.inspect(args), err) or err)
    vim.schedule(function()
      vim.notify(msg, L.ERROR, { title = "ERROR" })
    end)
  end, unpack(args))
end

function M.fold(callback, list, accum)
  accum = accum or {}
  for k, v in pairs(list) do
    accum = callback(accum, v, k)
    assert(accum ~= nil, "The accumulator must be returned on each iteration")
  end
  return accum
end

function M.get_term_id()
  local term_idx = nil
  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    local name = vim.api.nvim_buf_get_name(bufnr)
    term_idx = vim.fn.fnamemodify(name, ":t")
    print(name)

    -- if name == term_name then
    -- term_idx = bufnr
    -- else
  end

  -- local t_idx = vim.fn.termopen(term_idx)
  return term_idx
  -- vim.fn.chansend(--[[  ]]t_idx, { "echo 'hello world'", "" })
end

function M.browse_this_error(is_selection)
  is_selection = is_selection or false

  vim.cmd "normal yy"
  local str_sel = vim.fn.getreg '"0'
  str_sel = str_sel:gsub("^(%[)(.+)(%])$", "%2")
  str_sel = M.remove_alias(str_sel)

  local open_search = {
    ["Search Error For General Purpose?"] = {
      google = "https://google.com/search?q=",
      github_issue = "https://github.com/search?q=",
      stackoverflow = "https://stackoverflow.com/search?q=",
    },
    ["Search Error with Google Footprint?"] = {
      google = {
        url = "https://google.com/search?q=",
        on_site = "site%3Astackoverflow.com",
        match = false,
      },
      google_matching = {
        url = "https://google.com/search?q=",
        on_site = "site%3Astackoverflow.com",
        match = true,
      },
      github_matching = {
        url = "https://google.com/search?q=",
        on_site = "site%3Agithub.com",
        match = true,
      },
    },
    ["Search Error For Nvim Footprint?"] = {
      google_stackoverflow = {
        url = "https://google.com/search?q=",
        on_site = "site%3Astackoverflow.com",
        match = false,
      },
      google_stackexchange = {
        url = "https://google.com/search?q=",
        on_site = "site%3Astackexchange.com",
        match = false,
      },
      google_matching = {
        url = "https://google.com/search?q=",
        on_site = "site%3Avi.stackexchange.com",
        match = true,
      },
    },
    ["Search Error For Emacs Footprint?"] = {
      google_matching = {
        url = "https://google.com/search?q=",
        on_site = "site%3Aemacs.stackexchange.com",
        match = true,
      },
    },
    -- ["Search Error For VSCODE Footprint?"] = {
    --   google_matching = {
    --     url = "https://google.com/search?q=",
    --     on_site = "site%3Aemacs.stackexchange.com",
    --     match = true,
    --   },
    -- },
    -- ["Search Error For Helix Footprint?"] = {
    --   google_matching = {
    --     url = "https://google.com/search?q=",
    --     on_site = "site%3Aemacs.stackexchange.com",
    --     match = true,
    --   },
    -- },

    ["Search For Reverse Engineering?"] = {
      google_matching = {
        url = "https://google.com/search?q=",
        on_site = "site%3Areverseengineering.stackexchange.com",
        match = true,
      },
    },
  }

  local call_exec_cmds = function(sel_str, str_error)
    vim.validate { sel_str = { sel_str, "string" }, str_error = { str_error, "string" } }
    local browser = os.getenv "NUBROWSER"

    local cmd_sel = open_search[sel_str]

    for _, x in pairs(cmd_sel) do
      local c
      if type(x) == "table" then
        local parts = vim.split(str_error, " ")
        local str = table.concat(parts, "+")
        if x.match then
          c = string.format("%s%s%s", x.url, '"' .. str .. '"' .. "+", x.on_site)
        else
          c = string.format("%s%s%s", x.url, str .. "+", x.on_site)
        end
      else
        c = string.format("%s%s", x, str_error)
      end

      local cmds = { browser, c }
      vim.fn.jobstart(cmds, { detach = true })
      ---@diagnostic disable-next-line: undefined-field
      RUtils.info(vim.inspect(cmds))
    end
  end

  local fzfopts = {
    prompt = "  ",
    cwd_prompt = false,
    cwd_header = false,
    no_header = true,
    no_header_i = true,
    winopts = {
      title = RUtils.fzflua.format_title("What do you want?", "󱥽"),
      border = "rounded",
      height = 0.15,
      width = 0.30,
      row = 1.05,
      relative = "cursor",
    },
    actions = {
      ["default"] = function(selected, _)
        call_exec_cmds(selected[1], str_sel)
      end,
    },
  }

  local selection_str = {}
  for idx, _ in pairs(open_search) do
    selection_str[#selection_str + 1] = idx
  end

  require("fzf-lua").fzf_exec(selection_str, fzfopts)
end

function M.falsy(item)
  if not item then
    return true
  end
  local item_type = type(item)
  if item_type == "boolean" then
    return not item
  end
  if item_type == "string" then
    return item == ""
  end
  if item_type == "number" then
    return item <= 0
  end
  if item_type == "table" then
    return vim.tbl_isempty(item)
  end
  return item ~= nil
end

function M.tryrange(lower, upper)
  local result = {}
  for i = lower, upper do
    table.insert(result, i)
  end
  return result
end

function M.tryjoin(tbl, delimiter)
  delimiter = delimiter or ""
  local result = ""
  local len = #tbl
  for i, item in ipairs(tbl) do
    if i == len then
      result = result .. item
    else
      result = result .. item .. delimiter
    end
  end
  return result
end

function M.rm_duplicates_tbl(arr)
  local newArray = {}
  local checkerTbl = {}
  for _, element in ipairs(arr) do
    -- [[if there is not yet a value at the index of element, then it will
    -- be nil, which will operate like false in an if statement
    -- ]]
    if not checkerTbl[element] then
      checkerTbl[element] = true
      table.insert(newArray, element)
    end
  end
  return newArray
end

function M.normalize_return(str)
  ---@diagnostic disable-next-line: redefined-local
  local str_slice = string.gsub(str, "\n", "")
  local res = vim.split(str_slice, "\n")
  if res[1] then
    return res[1]
  end

  return str_slice
end

function M.check_tbl_element(tbl, element)
  for _, x in pairs(tbl) do
    if x == element then
      return true
    end
  end
  return false
end

function M.remove_duplicates_tbl(old_tbl)
  local new_tbl = {}
  for _, x in pairs(old_tbl) do
    if not M.check_tbl_element(new_tbl, x) then
      table.insert(new_tbl, x)
    end
  end

  return new_tbl
end

local rstrip_whitespace = function(str)
  str = string.gsub(str, "%s+$", "")
  return str
end

function M.lstrip_whitespace(str, limit)
  if limit ~= nil then
    local num_found = 0
    while num_found < limit do
      str = string.gsub(str, "^%s", "")
      num_found = num_found + 1
    end
  else
    str = string.gsub(str, "^%s+", "")
  end
  return str
end

function M.strip_whitespace(str)
  return rstrip_whitespace(M.lstrip_whitespace(str))
end

function M.p_table(map)
  return setmetatable(map, {
    __index = function(tbl, key)
      if not key then
        return
      end
      for k, v in pairs(tbl) do
        if key:match(k) then
          return v
        end
      end
    end,
  })
end

function M.del_buffer_autocmd(augroup, bufnr)
  local cmds_found, cmds = pcall(vim.api.nvim_get_autocmds, { group = augroup, buffer = bufnr })
  if cmds_found then
    vim.tbl_map(function(cmd)
      vim.api.nvim_del_autocmd(cmd.id)
    end, cmds)
  end
end

function M.create_command(name, rhs, opts)
  opts = opts or {}
  vim.api.nvim_create_user_command(name, rhs, opts)
end

local autocmd_keys = {
  "event",
  "buffer",
  "pattern",
  "desc",
  "command",
  "group",
  "once",
  "nested",
}

local function validate_autocmd(name, command)
  local incorrect = M.fold(function(accum, _, key)
    if not vim.tbl_contains(autocmd_keys, key) then
      table.insert(accum, key)
    end
    return accum
  end, command, {})

  if #incorrect > 0 then
    vim.schedule(function()
      local msg = "Incorrect keys: " .. table.concat(incorrect, ", ")
      ---@diagnostic disable-next-line: param-type-mismatch
      vim.notify(msg, "error", { title = string.format("Autocmd: %s", name) })
    end)
  end
end

function M.augroup(name, ...)
  local commands = { ... }
  assert(name ~= "User", "The name of an augroup CANNOT be User")
  assert(#commands > 0, string.format("You must specify at least one autocommand for %s", name))
  local id = vim.api.nvim_create_augroup(name, { clear = true })
  for _, autocmd in ipairs(commands) do
    validate_autocmd(name, autocmd)
    local is_callback = type(autocmd.command) == "function"
    vim.api.nvim_create_autocmd(autocmd.event, {
      group = name,
      pattern = autocmd.pattern,
      desc = autocmd.desc,
      callback = is_callback and autocmd.command or nil,
      command = not is_callback and autocmd.command or nil,
      once = autocmd.once,
      nested = autocmd.nested,
      buffer = autocmd.buffer,
    })
  end
  return id
end

function M.get_visual_selection(opts)
  opts = opts or {}
  -- Adapted from fzf-lua:
  -- https://github.com/ibhagwan/fzf-lua/blob/6ee73fdf2a79bbd74ec56d980262e29993b46f2b/lua/fzf-lua/utils.lua#L434-L466
  -- this will exit visual mode
  -- use 'gv' to reselect the text
  local _, csrow, cscol, cerow, cecol
  local mode = vim.fn.mode()
  if opts.strict and not vim.endswith(string.lower(mode), "v") then
    return
  end

  if mode == "v" or mode == "V" or mode == "" then
    -- if we are in visual mode use the live position
    _, csrow, cscol, _ = unpack(vim.fn.getpos ".")
    _, cerow, cecol, _ = unpack(vim.fn.getpos "v")
    if mode == "V" then
      -- visual line doesn't provide columns
      cscol, cecol = 0, 999
    end
    -- exit visual mode
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", true)
  else
    -- otherwise, use the last known visual position
    _, csrow, cscol, _ = unpack(vim.fn.getpos "'<")
    _, cerow, cecol, _ = unpack(vim.fn.getpos "'>")
  end

  -- Swap vars if needed
  if cerow < csrow then
    csrow, cerow = cerow, csrow
    cscol, cecol = cecol, cscol
  elseif cerow == csrow and cecol < cscol then
    cscol, cecol = cecol, cscol
  end

  local lines = vim.fn.getline(csrow, cerow)
  assert(type(lines) == "table")
  if vim.tbl_isempty(lines) then
    return
  end

  -- When the whole line is selected via visual line mode ("V"), cscol / cecol will be equal to "v:maxcol"
  -- for some odd reason. So change that to what they should be here. See ':h getpos' for more info.
  local maxcol = vim.api.nvim_get_vvar "maxcol"
  if cscol == maxcol then
    cscol = string.len(lines[1])
  end
  if cecol == maxcol then
    cecol = string.len(lines[#lines])
  end

  ---@type string
  local selection
  local n = #lines
  if n <= 0 then
    selection = ""
  elseif n == 1 then
    selection = string.sub(lines[1], cscol, cecol)
  elseif n == 2 then
    selection = string.sub(lines[1], cscol) .. "\n" .. string.sub(lines[n], 1, cecol)
  else
    selection = string.sub(lines[1], cscol)
      .. "\n"
      .. table.concat(lines, "\n", 2, n - 1)
      .. "\n"
      .. string.sub(lines[n], 1, cecol)
  end

  return {
    lines = lines,
    selection = selection,
    csrow = csrow,
    cscol = cscol,
    cerow = cerow,
    cecol = cecol,
  }
end

function M.run_jobstart(command, on_stdout)
  vim.fn.jobstart(command, {
    on_stdout = on_stdout,
    on_stderr = on_stdout,
    stdout_buffered = false,
    stderr_buffered = false,
  })
end

function M.start()
  coroutine.wrap(function()
    print "test"
  end)()
end

--- Executes a command and returns the output
--- @param command string
--- @return string returns empty string upon error
M.execute_io_open = function(command)
  local handle = io.popen(command)

  if handle == nil then
    return ""
  end

  local output = handle:read "*a"
  handle:close()

  return output
end

------------------------------------------------------------------------------------------------------------------------
--  Lazy Requires
------------------------------------------------------------------------------------------------------------------------
--- source: https://github.com/tjdevries/lazy-require.nvim

--- Require on index.
---
--- Will only require the module after the first index of a module.
--- Only works for modules that export a table.
function M.reqidx(require_path)
  return setmetatable({}, {
    __index = function(_, key)
      return require(require_path)[key]
    end,
    __newindex = function(_, key, value)
      require(require_path)[key] = value
    end,
  })
end

--- Require when an exported method is called.
---
--- Creates a new function. Cannot be used to compare functions,
--- set new values, etc. Only useful for waiting to do the require until you actually
--- call the code.
---
--- ```lua
--- -- This is not loaded yet
--- local lazy_mod = lazy.require_on_exported_call('my_module')
--- local lazy_func = lazy_mod.exported_func
---
--- -- ... some time later
--- lazy_func(42)  -- <- Only loads the module now
---
--- ```
---@param require_path string
---@return table<string, fun(...): any>
function M.reqcall(require_path)
  return setmetatable({}, {
    __index = function(_, k)
      return function(...)
        if not RUtils.has(require_path) then
          ---@diagnostic disable-next-line: undefined-field
          RUtils.warn(string.format("module %s not found", require_path), { Title = "reqcall" })
          return
        end
        return require(require_path)[k](...)
      end
    end,
  })
end

--  ┏╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┓
--  ╏                           test                           ╏
--  ┗╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┛

local title, kind

local function is_tag_or_link_at(line, col, opts)
  opts = opts or {}
  local initial_col = col

  local char
  local is_tagline = opts.tag_notation == "yaml-bare" and line:sub(1, 4) == "tags"

  local seen_bracket = false
  local seen_parenthesis = false
  local seen_hashtag = false
  local cannot_be_tag = false

  -- Solves [[Link]]
  --     at ^
  -- In this case we try to move col forward to match the link.
  if "[" == line:sub(col, col) then
    col = math.max(col + 1, string.len(line))
  end

  while col >= 1 do
    char = line:sub(col, col)

    if seen_bracket then
      if char == "[" then
        return "link", col + 2
      end
    end

    if seen_parenthesis then
      -- Media link, currently identified by not link nor tag
      if char == "]" then
        return nil, nil
      end
    end

    if char == "[" then
      seen_bracket = true
    elseif char == "(" then
      seen_parenthesis = true
    end

    if is_tagline == true then
      if char == " " or char == "\t" or char == "," or char == ":" then
        if col ~= initial_col then
          return "tag", col + 1
        end
      end
    else
      if char == "#" then
        seen_hashtag = true
      end
      if char == "@" then
        seen_hashtag = true
      end
      -- Tags should have a space before #, if not we are likely in a link
      if char == " " and seen_hashtag and opts.tag_notation == "#tag" then
        if not cannot_be_tag then
          return "tag", col
        end
      end

      if char == ":" and opts.tag_notation == ":tag:" then
        if not cannot_be_tag then
          return "tag", col
        end
      end
    end

    if char == " " or char == "\t" then
      cannot_be_tag = true
    end
    col = col - 1
  end
  return nil, nil
end

local function check_for_link_or_tag()
  local line = vim.api.nvim_get_current_line()
  local col = vim.fn.col "."
  return is_tag_or_link_at(line, col, {}) -- TODO: ini adalah yang salah
end

function M.open_with_mvp_or_sxiv()
  local url = vim.fn.expand "<cWORD>"

  -- check jika terdapat `https` pada `url`
  local uri = vim.fn.matchstr(url, [[https\?:\/\/[A-Za-z0-9-_\.#\/=\?%]\+]])

  -- if not string.match(url, "[a-z]*://[^ >,;]*") and string.match(url, "[%w%p\\-]*/[%w%p\\-]*") then
  if uri ~= "" then
    url = uri
  else
    vim.cmd "normal yy"
    title = vim.fn.getreg '"0'
    title = title:gsub("^(%[)(.+)(%])$", "%2")
    title = RUtils.cmd.remove_alias(title)

    local parts = vim.split(title, "#")
    if #parts > 0 then
      url = parts[1]
    end
  end

  local sel_open_with = {
    mpv = {
      --   { "tsp", "mpv", "--ontop", "--no-border", "--force-window", "--autofit=1000x500", "--geometry=-20-60", url }
      cmd = { "tsp", "mpv", "--ontop", "--no-border", "--force-window", "--autofit=1000x500", "--geometry=-20-60" },
    },
    sxiv = {
      cmd = { "tsp", "svix", "--ontop" },
    },
  }

  local sel_fzf = function()
    local newtbl = {}
    for i, _ in pairs(sel_open_with) do
      newtbl[#newtbl + 1] = i
    end
    return newtbl
  end

  local opts = {
    winopts = {
      title = RUtils.fzflua.format_title("Select To Open With", RUtils.config.icons.documents.openfolder),
      relative = "cursor",
      width = 0.30,
      height = 0.25,
      row = 1,
      col = 2,
    },
    actions = {
      ["default"] = function(selected)
        local sel = selected[1]

        local cmds, notif_msg
        for i, x in pairs(sel_open_with) do
          if i == sel then
            x.cmd[#x.cmd + 1] = url
            cmds = x.cmd
            notif_msg = i .. ": " .. url
          end
        end

        vim.fn.jobstart(cmds, { detach = true })
        ---@diagnostic disable-next-line: undefined-field
        RUtils.info(notif_msg, { title = "Open With" })
      end,
    },
  }

  require("fzf-lua").fzf_exec(sel_fzf(), opts)
end

function M.follow_link(is_selection)
  is_selection = is_selection or false

  local saved_reg = vim.fn.getreg '"0'
  kind, _ = check_for_link_or_tag()

  if kind == "link" then
    vim.cmd "normal yi]"
    title = vim.fn.getreg '"0'
    title = title:gsub("^(%[)(.+)(%])$", "%2")
    title = RUtils.cmd.remove_alias(title)
  end

  if kind ~= nil then
    vim.fn.setreg('"0', saved_reg)

    local parts = vim.split(title, "#")

    -- if there is a #
    if #parts ~= 1 then
      title = parts[2]
      parts = vim.split(title, "%^")
      if #parts ~= 1 then
        title = parts[2]
      end
      -- local search = require "obsidian.search"
      -- search.find_notes_async(".", title .. ".md")
      local rg_opts =
        [[--column --line-number --hidden --no-heading --ignore-case --smart-case --color=always --colors match:fg:178 --max-columns=4096 -g "*.md" ]]

      fzf_lua.grep { cwd = RUtils.config.path.wiki_path, search = title, rg_opts = rg_opts }
    else
      if require("obsidian").util.cursor_on_markdown_link(nil, nil, true) then
        vim.cmd "ObsidianFollowLink"
      end
    end
  else
    local url = vim.fn.expand "<cWORD>"

    -- check jika terdapat `https` pada `url`
    local uri = vim.fn.matchstr(url, [[https\?:\/\/[A-Za-z0-9-_\.#\/=\?%]\+]])

    -- if not string.match(url, "[a-z]*://[^ >,;]*") and string.match(url, "[%w%p\\-]*/[%w%p\\-]*") then
    --   url = string.format("https://github.com/%s", url)
    if uri ~= "" then
      if vim.bo.filetype == "markdown" then
        if require("obsidian").util.cursor_on_markdown_link(nil, nil, true) then
          return vim.cmd "ObsidianFollowLink"
        end
      end
      url = uri
    else
      if not is_selection then
        url = string.format("https://google.com/search?q=%s", url)
      end

      vim.cmd "normal yy"
      title = vim.fn.getreg '"0'
      title = title:gsub("^(%[)(.+)(%])$", "%2")
      title = RUtils.cmd.remove_alias(title)

      local parts = vim.split(title, "#")
      if #parts > 0 then
        url = string.format("https://google.com/search?q=%s", parts[1])
      end
    end

    -- vim.fn.jobstart({ vim.fn.has "macunix" ~= 0 and "open" or "xdg-open", url }, { detach = true })
    local browser = os.getenv "NUBROWSER"
    local notif_msg = "Open with browser: "
    local cmds = { browser, url }

    vim.fn.jobstart(cmds, { detach = true })
    ---@diagnostic disable-next-line: undefined-field
    RUtils.info(notif_msg .. url, { title = "Open With" })
  end
end

function M.EditSnippet()
  local L = vim.log.levels
  local scan = require "plenary.scandir"

  local base_snippets = { "package", "global" }

  local ft, _ = RUtils.buf.get_bo_buft()

  if ft == "" then
    return vim.notify("Belum dibuat??", L.WARN, { title = "No snippets" })
  elseif ft == "typescript" then
    ft = "javascript"
  elseif ft == "sh" then
    ft = "shell"
  end

  local ft_snippet_path = RUtils.config.path.snippet_path .. "/snippets/"

  local snippets = {}
  local is_file = true

  if RUtils.file.is_dir(ft_snippet_path .. ft) then
    if not RUtils.file.exists(ft_snippet_path .. ft) then
      return vim.notify(ft_snippet_path .. ft .. ".json", L.WARN, { title = "Snippet file not exists" })
    end
    -- Untuk akses ke snippet khusus dir harus di tambahkan ext sama `ft` nya
    -- e.g path/ft-nya/<snippet.json>
    ft_snippet_path = ft_snippet_path .. ft .. "/"

    local dirs = scan.scan_dir(ft_snippet_path, { depth = 1, search_pattern = "json" })
    for _, sp in pairs(dirs) do
      local nm = sp:match "[^/]*.json$"
      local sp_e = nm:gsub(".json", "")
      table.insert(snippets, sp_e)
    end

    for _, sp in pairs(base_snippets) do
      table.insert(snippets, sp)
    end
  else
    snippets = { ft }

    if not RUtils.file.exists(ft_snippet_path .. ft .. ".json") then
      return vim.notify(ft_snippet_path .. ft .. ".json", L.WARN, { title = "Snippet file not exists" })
    end
    if not RUtils.file.exists(ft_snippet_path .. ft .. ".json") then
      return vim.notify(ft_snippet_path .. ft .. ".json", L.WARN, { title = "Snippet file not exists" })
    end

    for _, sp in pairs(base_snippets) do
      table.insert(snippets, sp)
    end
  end

  vim.ui.select(snippets, { prompt = "Edit snippet> " }, function(choice)
    if choice == nil then
      return
    end
    if is_file then
      if not RUtils.file.exists(ft_snippet_path .. choice .. ".json") then
        return vim.notify(ft_snippet_path .. choice .. ".json", L.WARN, { title = "Snippet file not exists" })
      end
      vim.cmd(":edit " .. ft_snippet_path .. choice .. ".json")
    end
  end)
end

function M.change_colors()
  local Highlight = require "r.settings.highlights"

  local KeywordNC_bg = Highlight.tint(Highlight.get("Keyword", "fg"), -0.5)
  local KeywordNC_fg = Highlight.get("Keyword", "fg") -- 17

  local tmux_bg = Highlight.get("Normal", "bg")
  local tmux_fg = Highlight.tint(Highlight.get("WinbarFilepath", "fg"), -0.1)

  local statusline_fg = Highlight.tint(Highlight.get("WinSeparator", "fg"), 0.7)

  local winseparator = Highlight.get("WinSeparator", "fg")

  local lazygit_selected_line_bg = Highlight.get("LazygitselectedLineBgColor", "bg")
  local lazygit_inactive_border = Highlight.get("LazygitInactiveBorderColor", "fg")
  local lazygit_active_border = KeywordNC_bg
  local lazygit_border_fg = Highlight.tint(Highlight.get("WinSeparator", "fg"), 0.2) --> colorline zshrc

  local gitadd = Highlight.get("diffAdd", "bg")
  local gitlinenumber_add = Highlight.darken(Highlight.get("GitSignsAdd", "fg"), 0.4, Highlight.get("Normal", "bg"))

  local gitdelete = Highlight.get("diffDelete", "bg")
  local gitlinenumber_delete =
    Highlight.darken(Highlight.get("GitSignsDelete", "fg"), 0.6, Highlight.get("Normal", "bg"))

  local sugest_highlight = Highlight.tint(Highlight.get("Comment", "fg"), -0.05)

  local yazi_cwd = Highlight.get("Comment", "fg")
  local yazi_hovered = Highlight.get("CursorLine", "bg")
  local yazi_tab_active_fg = KeywordNC_fg
  local yazi_tab_active_bg = KeywordNC_bg
  local yazi_tab_inactive_fg = Highlight.get("TabLine", "fg")
  local yazi_tab_inactive_bg = Highlight.get("TabLine", "bg")
  local yazi_statusline_bg = Highlight.get("StatusLine", "bg")
  local yazi_statusline_active_fg = Highlight.get("StatusLine", "fg")
  local yazi_statusline_active_bg = Highlight.tint(Highlight.get("StatusLine", "bg"), 0.2)
  local yazi_directory = Highlight.get("Directory", "fg")
  local yazi_filename_fg = Highlight.tint(Highlight.get("StatusLine", "fg"), 1.4)
  local yazi_which_bg = Highlight.get("Pmenu", "bg")

  local zsh_background_bg = yazi_statusline_active_bg

  local fzf_header = Highlight.get("FzfLuaHeaderText", "fg")

  if vim.tbl_contains(vim.g.lightthemes, vim.g.colorscheme) then
    tmux_fg = Highlight.tint(Highlight.get("WinbarFilepath", "fg"), 0.1)
    statusline_fg = Highlight.tint(Highlight.get("Comment", "fg"), 0)

    lazygit_active_border = Highlight.tint(Highlight.get("WinSeparator", "fg"), -0.5) -- 29
    lazygit_border_fg = Highlight.tint(Highlight.get("WinSeparator", "fg"), 0)
    lazygit_inactive_border = Highlight.tint(Highlight.get("Keyword", "fg"), 0) -- 30
    lazygit_selected_line_bg = Highlight.darken(Highlight.get("Keyword", "fg"), 0.8, Highlight.get("Normal", "bg"))

    yazi_hovered = Highlight.get("CursorLine", "bg")
    yazi_statusline_active_bg = Highlight.tint(Highlight.get("StatusLine", "bg"), 0)
    yazi_tab_inactive_fg = Highlight.tint(Highlight.get("TabLine", "fg"), -0.3)

    sugest_highlight = Highlight.tint(Highlight.get("Tabline", "bg"), -0.2)
  end

  if vim.g.colorscheme == "rose-pine-dawn" then
    yazi_filename_fg = Highlight.tint(Highlight.get("LineNr", "fg"), -0.5)
  end

  local master_colors = string.format(
    [[
%s
! -----------------------------

%s
*color16: %s
*color17: %s

%s
*color18: %s
*color19: %s

%s
*color20: %s
*color21: %s

%s
*color22: %s
*color23: %s
*color24: %s

%s
*color25: %s
*color26: %s
*color27: %s

%s
*color28: %s

%s
*color29: %s
*color30: %s
*color31: %s
*color32: %s

%s
*color33: %s
*color34: %s

%s
*color35: %s
*color36: %s

%s
*color37: %s

%s
*color38: %s
*color39: %s
*color40: %s
*color41: %s
*color42: %s
*color43: %s

%s
*color44: %s
*color45: %s
*color46: %s
*color47: %s
*color48: %s
*color49: %s

%s
*color50: %s

*color51: %s
]],
    string.format "! vim: foldmethod=marker foldlevel=0 ft=xdefaults",

    string.format "! State color: bg, fg",
    KeywordNC_bg, -- 16
    KeywordNC_fg, -- 17

    string.format "! TMUX: border_fg_nc, border_fg",
    winseparator, -- 19
    statusline_fg, -- 18

    string.format "! TMUX: tmux_bg, tmux_fg",
    tmux_bg, -- 20
    tmux_fg, -- 21

    string.format "! FZF-NORMAL: bg, fg, match",
    Highlight.get("FzfLuaNormal", "bg"), -- 22
    Highlight.get("FzfLuaFilePart", "fg"), -- 23
    Highlight.get("FzfLuaFzfMatchFuzzy", "fg"), --24

    string.format "! FZF-SELECTION: bg, fg, match",
    Highlight.get("FzfLuaSel", "bg"), -- 25
    Highlight.get("FzfLuaFilePart", "fg"), -- 26
    Highlight.get("FzfLuaFzfMatch", "fg"), --27

    string.format "! FZF: border",
    Highlight.get("FzfLuaBorder", "fg"), -- 28

    string.format "! LAZYGIT: active_border_color, inactive_border_color, options_text_color, selected_line_bg_color",
    lazygit_active_border, -- 29
    lazygit_inactive_border, -- 30
    lazygit_border_fg, -- 31
    lazygit_selected_line_bg, -- 32

    string.format "! DELTA: plus-style, plus-emph-style",
    gitadd, -- 33
    gitlinenumber_add, -- 34

    string.format "! DELTA: minus-style, minus-emph-style",
    gitdelete, -- 36
    gitlinenumber_delete, -- 35

    string.format "! zsh-autosuggestions: fg",
    sugest_highlight, -- 37

    string.format "! yazi: cwd, hovered, tab_active_fg, tab_active_bg, tab_inactive_bg, tab_inactive_fg",
    yazi_cwd, -- 38
    yazi_hovered, -- 39
    yazi_tab_active_fg, -- 40
    yazi_tab_active_bg, -- 41
    yazi_tab_inactive_fg, -- 42
    yazi_tab_inactive_bg, -- 43

    string.format "! yazi: col_statusline_fg, col_statusline_main_bg, col_statusline_main_alt_bg, directory, which_bg, filename_fg",
    yazi_statusline_bg, -- 44
    yazi_statusline_active_fg, -- 45
    yazi_statusline_active_bg, -- 46
    yazi_directory, -- 47
    yazi_which_bg, -- 48
    yazi_filename_fg, -- 49

    string.format "! zsh: zsh_background_bg",
    zsh_background_bg, -- 50

    fzf_header -- 51
  )

  local master_color_path = "/tmp/master-colors-themes"

  if RUtils.file.is_file(master_color_path) then
    vim.fn.system(string.format("rm %s", master_color_path))
  end

  local fp = io.open(master_color_path, "a")
  if fp then
    fp:write(master_colors)
    fp:close()
  end
end

function M.infoFoldPreview()
  vim.cmd "options"
end

return M
