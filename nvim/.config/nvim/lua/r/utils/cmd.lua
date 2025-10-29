---@class r.utils.cmd
local M = {}

---@param link string
---@return string
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

---@param wins string|string[]
function M.windows_is_opened(wins)
  local ft_wins = { "incline" }

  if type(wins) == "table" then
    if #wins > 0 then
      for _, x in pairs(wins) do
        ft_wins[#ft_wins + 1] = x
      end
    end
  end

  if type(wins) == "string" then
    ft_wins[#ft_wins + 1] = wins
  end

  local outline_tbl = { found = false, winbufnr = 0, winnr = 0, winid = 0, ft = "" }
  for _, winnr in ipairs(vim.api.nvim_list_wins()) do
    local win_bufnr = vim.api.nvim_win_get_buf(winnr)

    if tonumber(win_bufnr) == 0 then
      return outline_tbl
    end

    local buf_ft = vim.api.nvim_get_option_value("filetype", { buf = win_bufnr })
    local buf_buftype = vim.api.nvim_get_option_value("buftype", { buf = win_bufnr })

    local winid = vim.fn.win_findbuf(win_bufnr)[1] -- example winid: 1004, 1005

    if vim.tbl_contains(ft_wins, buf_ft) or vim.tbl_contains(ft_wins, buf_buftype) then
      outline_tbl = { found = true, winbufnr = win_bufnr, winnr = winnr, winid = winid, ft = buf_ft }
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

---@param is_selection? boolean
function M.browse_this_error(is_selection)
  is_selection = is_selection or false

  vim.cmd "normal yy"
  local str_sel = vim.fn.getreg '"0'
  str_sel = str_sel:gsub("^(%[)(.+)(%])$", "%2")
  str_sel = M.remove_alias(str_sel)

  local open_search = {
    ["Search Error - Single Search (google, github, stackoverflow)"] = {
      google = "https://google.com/search?q=",
      github_issue = "https://github.com/search?q=",
      stackoverflow = "https://stackoverflow.com/search?q=",
    },
    ["Search Error - Targeted Google Blueprint"] = {
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
    ["Search Error - Nvim Footprint"] = {
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
    ["Search Error - Emacs Footprint"] = {
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

    ["Search - Reverse Engineering"] = {
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

      table.sort(cmds)

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
      height = 0.20,
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
  if str then
    return rstrip_whitespace(M.lstrip_whitespace(str))
  end
  return ""
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

local function open_image_with_sxiv(url)
  local filename = url:match "^.+/(.+)$" or "image.jpg"
  local download_path = vim.fn.expand("/tmp/" .. filename)

  -- Download file ke ~/Downloads/
  vim.system({ "wget", "-q", url, "-O", download_path }, {}, function(dl)
    if dl.code == 0 then
      vim.system({ "sxiv", download_path }, { detach = true })
    else
      RUtils.info(string.format("Downlaod failed: %s", dl.stderr))
    end
  end)
end

local function mvp_or_sxiv(url)
  local sel_open_with = {
    mpv = {
      cmd = { "tsp", "mpv", "--ontop", "--no-border", "--force-window", "--autofit=1000x500", "--geometry=-20-60" },
    },

    -- Kendala dengan sxiv ini, tidak bisa open image dengan URL
    ["image local"] = { cmd = { "tsp", "sxiv", "--ontop" } },

    -- Kalau dengan feh ini, bisa membuka image URL, tapi ga bisa di zoom
    ["image with feh"] = { cmd = { "tsp", "feh", "-.", "-x", "-B", "black", "-g", "900x600-15+60" } },

    -- Kalau cara ini kita download, check function open_image_with_sxiv
    ["image with DL"] = { cmd = {} },
  }

  if vim.bo.filetype == "git" then
    sel_open_with = { DiffviewOpen = { cmd = { "DiffviewOpen" } } }
  end

  local sel_fzf = function()
    local newtbl = {}
    for i, _ in pairs(sel_open_with) do
      newtbl[#newtbl + 1] = i
    end

    table.sort(newtbl)

    return newtbl
  end
  local contents = sel_fzf()

  local opts = RUtils.fzflua.open_lsp_code_action {
    winopts = {
      title = RUtils.fzflua.format_title("Select To Open With", RUtils.config.icons.documents.openfolder),
      height = #contents + 3,
    },
    actions = {
      ["default"] = function(selected)
        if not selected then
          return
        end

        local sel = selected[1]
        local notif_msg

        if sel == "image with DL" then
          open_image_with_sxiv(url)
          notif_msg = "DL and Sxiv: " .. url
        else
          local cmds
          for cmd_name, cmd_args in pairs(sel_open_with) do
            if cmd_name == sel then
              cmd_args.cmd[#cmd_args.cmd + 1] = url
              cmds = cmd_args.cmd
              notif_msg = cmd_name .. ": " .. url
            end
          end

          if vim.bo.filetype == "git" then
            vim.cmd(table.concat(cmds, " "))
            return
          end

          local outputs = vim.system(cmds, { text = true }):wait()
          if outputs.code ~= 0 then
            ---@diagnostic disable-next-line: undefined-field
            RUtils.error("Failed to run cmd:'" .. table.concat(cmds, " ") .. "'", { title = "Open With" })
            return
          end
        end

        ---@diagnostic disable-next-line: undefined-field
        RUtils.info(notif_msg, { title = "Open With" })
      end,
    },
  }

  require("fzf-lua").fzf_exec(contents, opts)
end

local function open_browser(url)
  -- vim.fn.jobstart({ vim.fn.has "macunix" ~= 0 and "open" or "xdg-open", url }, { detach = true })
  local browser = os.getenv "NUBROWSER"
  local notif_msg = "Open with browser: "
  local cmds = { browser, url }

  local outputs_cmd = vim.system(cmds, { text = true }):wait()
  if outputs_cmd.code ~= 0 then
    ---@diagnostic disable-next-line: undefined-field
    RUtils.error("Failed to run command: '" .. table.concat(cmds, " ") .. "'", { title = "Open With" })
    return
  end
  ---@diagnostic disable-next-line: undefined-field
  RUtils.info(notif_msg .. url, { title = "Open With" })
end

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
  return is_tag_or_link_at(line, col, {})
end

local function follow_link_markdown()
  local saved_reg = vim.fn.getreg '"0'
  local kind, _ = check_for_link_or_tag()
  if not kind then
    return
  end

  local title

  if kind == "link" then
    vim.cmd "normal yi]"
    title = vim.fn.getreg '"0'
    title = title:gsub("^(%[)(.+)(%])$", "%2")
    title = RUtils.cmd.remove_alias(title)
  end

  vim.fn.setreg('"0', saved_reg)

  local parts
  if title then
    parts = vim.split(title, "#")
  end

  -- if there is a #
  if parts and #parts ~= 1 then
    title = parts[2]
    parts = vim.split(title, "%^")
    if #parts ~= 1 then
      title = parts[2]
    end
    local rg_opts =
      [[--column --line-number --hidden --no-heading --ignore-case --smart-case --color=always --colors match:fg:178 --max-columns=4096 -g "*.md" ]]

    local fzf_lua = RUtils.cmd.reqcall "fzf-lua"
    fzf_lua.grep { cwd = RUtils.config.path.wiki_path, search = title, rg_opts = rg_opts }
    return
  end

  if require("obsidian.api").cursor_link() then
    vim.cmd "ObsidianFollowLink"
  end
end

function M.open_with(what_mode, is_selection)
  vim.validate { what_mode = { what_mode, "string" } }
  is_selection = is_selection or false

  local debug_what_mode = { "mpv or svix", "browser", "go to file" }
  if not vim.tbl_contains(debug_what_mode, what_mode) then
    ---@diagnostic disable-next-line: undefined-field
    RUtils.warn("Available mode: " .. table.concat(debug_what_mode, ", "))
    return
  end

  local url

  if is_selection then
    url = RUtils.map.getVisualSelection()
  else
    url = vim.fn.expand "<cWORD>"
  end

  if not url then
    RUtils.warn "Not continue"
    return
  end

  -- Check jika terdapat `https` pada `url`
  local uri = vim.fn.matchstr(url, [[https\?:\/\/[A-Za-z0-9-_\.#\/=\?%]\+]])
  -- if not string.match(url, "[a-z]*://[^ >,;]*") and string.match(url, "[%w%p\\-]*/[%w%p\\-]*") then

  if #uri > 0 then
    url = uri
  else
    url = string.format("https://google.com/search?q=%s", url)
  end

  if what_mode == "browser" then
    open_browser(url)
    return
  end

  if what_mode == "mpv or svix" then
    if vim.bo.filetype == "git" then
      -- local sha = line:match "^parent%s+([a-f0-9]+)$"
      url = url:match "([a-f0-9]+)$"
    end

    mvp_or_sxiv(url)
    return
  end

  if what_mode == "go to file" then
    if vim.bo.filetype == "markdown" then
      follow_link_markdown()
      return
    end
    return
  end
end

local function formatted_snippets(filetype, opts, snippets_global)
  local root_path = RUtils.config.path.snippet_path .. "/snippets/"

  local snippets = {}
  local frameworks = {}
  local ft = ""

  if #opts == 0 then
    snippets = { filetype }
    ft = filetype
  else
    ft = opts[1].ft

    if opts[1].snippets then
      for _, snip in pairs(opts[1].snippets) do
        snippets[#snippets + 1] = snip
      end
    end

    if opts[1].frameworks then
      frameworks = opts[1].frameworks
    end
  end

  -- Insert global snippets
  if #snippets_global > 0 then
    for _, snip in pairs(snippets_global) do
      snippets[#snippets + 1] = snip
    end
  end

  return {
    filetype = filetype,
    filetype_snippet = ft,
    root_path = root_path,
    snippets = snippets,
    frameworks = frameworks,
  }
end

function M.edit_snippet()
  local ft, _ = RUtils.buf.get_bo_buft()
  if ft == "" then
    return
  end

  local snippets_base = {}
  local snippets_global = {} --  { "package", "global" }

  -- Redifined filetype karena beberapa filetype itu ter-affiliasi dgn filetype
  -- yang lain, seperti contoh:
  -- typescript -> javascript
  -- typescriptreact -> javascript,
  local ft_alias = {
    typescriptreact = {
      ft = "javascript",
      snippets = { "javascript", "react", "html" },
      frameworks = { "react" },
    },

    htmldjango = {
      ft = "htmldjango",
      snippets = { "html", "css" },
      frameworks = { "djangohtml" },
    },
  }

  if ft_alias[ft] then
    snippets_base[#snippets_base + 1] = ft_alias[ft]
  end

  snippets_base = formatted_snippets(ft, snippets_base, snippets_global)
  -- RUtils.info(vim.inspect(snippets_base))

  local snippets_entry_tbl = {}

  -- is_framework
  local function update_snippets_entry(dirs, is_single, is_framework)
    is_framework = is_framework or false
    is_single = is_single or false

    for _, sp in pairs(dirs) do
      local nm = sp:match "[^/]*.json$"
      local sp_e = nm:gsub(".json", "")

      local entry = sp_e

      if is_framework then
        entry = "frameworks/" .. sp_e
      end

      if is_single then
        entry = "single/" .. sp_e
      end

      table.insert(snippets_entry_tbl, { item = entry, path = sp })
    end
  end

  local Scan = require "plenary.scandir"

  for _, snip in pairs(snippets_base.snippets) do
    local dirs = {}
    local is_single = false

    local path_snip = snippets_base.root_path .. snip
    if RUtils.file.is_dir(path_snip) then
      dirs = Scan.scan_dir(path_snip, { depth = 1, search_pattern = "json" })
    end

    local path_snip_json = path_snip .. ".json"
    if RUtils.file.is_file(path_snip_json) then
      dirs = { path_snip_json }
      is_single = true
    end

    update_snippets_entry(dirs, is_single)
  end

  if snippets_base.frameworks and #snippets_base.frameworks > 0 then
    for _, snip in pairs(snippets_base.frameworks) do
      local dirs =
        Scan.scan_dir(snippets_base.root_path .. "/frameworks/" .. snip, { depth = 1, search_pattern = "json" })
      update_snippets_entry(dirs, false, true)
    end
  end

  local entry_snippets = {}
  for _, sp in pairs(snippets_entry_tbl) do
    table.insert(entry_snippets, sp.item)
  end

  if #entry_snippets == 0 then
    ---@diagnostic disable-next-line: undefined-field
    RUtils.warn("Filetype untuk `" .. ft .. "`, belum dibuat?", { title = "Snippets" })
    --   RUtils.warn("file: `" .. snippet_path_file_json .. "`, not found?", { title = "Snippets" })
    --   RUtils.warn("directory: `" .. snippet_path_dir .. "`, not found?", { title = "Snippets" })
    return
  end

  local function open_with(open_mode, choice, is_auto_center)
    is_auto_center = is_auto_center or false
    for _, entry in pairs(snippets_entry_tbl) do
      if choice == entry.item then
        vim.cmd(open_mode .. " " .. entry.path)
        break
      end
    end

    if is_auto_center then
      vim.cmd "wincmd ="
    end
  end

  if #entry_snippets == 1 then
    open_with("vsplit", entry_snippets[1], true)
    return
  end

  vim.ui.select(entry_snippets, { prompt = "Edit snippet> " }, function(choice)
    if not choice then
      return
    end
    open_with("vsplit", choice, true)
  end)
end

function M.send_to_file(contents, path, is_theme)
  path = path or "/tmp/master-colors-themes"
  is_theme = is_theme or false

  if RUtils.file.is_file(path) then
    vim.system { "rm", path }
    vim.system { "touch", path }
  end

  local file = io.open(path, "w")

  local msg_notify_send

  local is_done = false

  if file and not is_done then
    file:write "! vim: foldmethod=marker foldlevel=0 ft=xdefaults\n\n"

    if type(contents) == "table" then
      for i, x in pairs(contents) do
        if is_theme then
          for idx, j in pairs(x) do
            file:write(i .. "_" .. idx .. ": " .. j .. "\n")
          end
        else
          -- file:write(tostring(x) .. "\n")
          file:write(vim.inspect(x) .. "\n")
          is_done = true
        end
      end

      if is_theme then
        msg_notify_send = "Theme changes detected. Don't forget to reload."
      else
        msg_notify_send = string.format("Something write in path: '%s'", path)
      end
    end

    if type(contents) == "string" then
      file:write(contents .. "\n")
      msg_notify_send = string.format("Something write in path: '%s'", path)
    end

    file:close()

    ---@diagnostic disable-next-line: undefined-field
    RUtils.warn(msg_notify_send)
  end
end

function M.change_colors()
  local H = require "r.settings.highlights"

  -- ─< TAB >────────────────────────────────────────────────────────────
  -- Active Tab
  local tab_session_fg = H.get("WinBarRightBlock", "fg")
  local tab_session_bg = H.get("WinBarRightBlock", "bg")

  local tab_active_fg = H.darken(H.get("WinBarRightBlock", "fg"), 0.6, H.get("Normal", "bg"))
  local tab_active_bg = H.darken(H.get("WinBarRightBlock", "bg"), 0.7, H.get("Normal", "bg"))

  -- Inactive Tab
  local tab_inactive_fg = H.tint(H.get("WinBar", "fg"), -0.23)
  local tab_inactive_bg = H.get("Normal", "bg")
  local tab_statusline_fg = H.tint(H.get("WinBar", "fg"), -0.23)

  -- Border Pane
  local __border_tmux_inactive_fg = 0.15
  if vim.g.colorscheme == "zenburn" then
    __border_tmux_inactive_fg = 0.05
  end
  local border_active = H.tint(H.get("Keyword", "fg"), -0.35)
  local border_inactive = H.tint(H.get("WinSeparator", "fg"), __border_tmux_inactive_fg)

  -- ─< ZSH >────────────────────────────────────────────────────────────
  local zsh_lines = H.tint(H.get("StatusLine", "fg"), -0.1)
  local zsh_sugest = H.tint(H.get("StatusLine", "fg"), -0.02)

  -- ─< YAZI >───────────────────────────────────────────────────────────
  local yazi_hovered_fg = 0
  local yazi_hovered = H.tint(H.get("HoveredCursorline", "bg"), yazi_hovered_fg)

  -- ─< LAZYGIT >────────────────────────────────────────────────────────
  local lazygit_inactive_border_fg = 0.3
  local lazygit_inactive_border = H.tint(H.get("WinSeparator", "fg"), lazygit_inactive_border_fg)

  -- ─< EWW >────────────────────────────────────────────────────────────
  local __eww_icon_fg = 0.6
  if vim.g.colorscheme == "base46-jellybeans" then
    __eww_icon_fg = 0.5
  end
  if vim.tbl_contains({ "base46-seoul256_dark", "base46-zenburn" }, vim.g.colorscheme) then
    __eww_icon_fg = 0.5
  end
  local eww_icon_fg = H.tint(H.get("WinSeparator", "fg"), __eww_icon_fg)

  local defined_cols = {
    fzf = {
      fg = H.get("FzfLuaFilePart", "fg"),
      bg = H.get("FzfLuaNormal", "bg"),

      -- selection_fg = H.get("FzfLuaFilePart", "fg"),
      -- selection_bg = H.get("FzfLuaSel", "bg"),
      -- match_fuzzy = H.get("FzfLuaFzfMatchFuzzy", "fg"),

      selection_fg = H.get("FzfLuaSel", "fg"),
      selection_sp = H.get("FzfLuaSel", "sp"),
      selection_bg = H.get("FzfLuaNormal", "bg"),

      match = H.get("FzfLuaFzfMatch", "fg"),
      match_fuzzy = H.get("FzfLuaFzfMatchFuzzy", "fg"),

      gutter = H.get("FzfLuaNormal", "bg"),

      pointer = H.get("diffDelete", "fg"),
      border = H.get("FzfLuaBorder", "fg"),
      header = H.get("FzfLuaHeaderText", "fg"),
    },
    tmux = {
      fg = H.get("Normal", "fg"),
      bg = H.get("Normal", "bg"),

      fm_bg = H.get("PanelSideBackground", "bg"),

      keyword = H.get("Keyword", "fg"),

      -- tab_active_fg = H.get("Normal", "bg"),
      -- tab_active_bg = H.tint(H.get("WinSeparator", "fg"), 5),

      tab_active_fg = tab_active_fg,
      tab_active_bg = tab_active_bg,

      statusline_fg = tab_statusline_fg,

      session_fg = tab_session_fg,
      session_bg = tab_session_bg,

      message_bg = H.tint(H.get("diffChange", "fg"), 0.6),

      border_active = border_active,
      border_inactive = border_inactive,
      border_inactive_status_fg = H.tint(border_inactive, 0.8),
    },
    kitty = {
      tab_active_fg = tab_active_fg,
      tab_active_bg = tab_active_bg,

      tab_inactive_fg = tab_inactive_fg,
      tab_inactive_bg = tab_inactive_bg,

      tab_bar_bg = H.get("Normal", "bg"),

      border_active = border_active,
      border_inactive = border_inactive,
    },
    lazygit = {
      active_border = tab_active_fg,
      inactive_border = lazygit_inactive_border,

      selected_bg = H.get("LazygitselectedLineBgColor", "bg"),

      option_txt = H.tint(H.get("WinSeparator", "fg"), 0.8),

      default_fg = H.tint(H.get("Normal", "fg"), 5),
    },
    dunst = {
      low_fg = H.tint(H.get("WinSeparator", "fg"), 2),
      low_bg = H.tint(H.get("WinSeparator", "fg"), 0.5),
      low_frame = H.tint(H.get("WinSeparator", "fg"), -0.1),

      normal_title_fg = H.tint(H.get("Keyword", "fg"), 0.5),

      normal_fg = H.tint(H.get("Keyword", "fg"), 0.1),
      normal_bg = H.tint(H.get("Keyword", "fg"), -0.45),
      normal_frame = H.tint(H.get("Keyword", "fg"), -0.45),

      critical_fg = H.tint(H.get("diffDelete", "fg"), 0.4),
      critical_bg = H.tint(H.get("diffDelete", "fg"), -0.25),
      critical_frame = H.tint(H.get("diffDelete", "fg"), -0.2),

      bg = H.tint(H.get("Normal", "bg"), 0.25),
      fg = H.tint(H.get("Normal", "bg"), 0.25),
      border = H.tint(H.get("Normal", "bg"), 0.25),
    },
    zshrc = {
      lines = zsh_lines,
      sugest = zsh_sugest,
    },
    btop = {
      fg = H.tint(H.get("Normal", "fg"), -0.2),
      bg = H.get("Normal", "bg"),

      yellow_alt = H.tint(H.get("diffChange", "fg"), -0.45),
      highlight_key = H.tint(H.get("diffDelete", "fg"), 0.1),

      cursorline_fg = H.tint(H.get("Keyword", "fg"), 1),
      cursorline_bg = H.tint(H.get("Keyword", "fg"), -0.5),

      border_fg = H.tint(H.get("WinSeparator", "fg"), 0.25),

      title = H.tint(H.get("Keyword", "fg"), -0.2),

      inactive_text = H.tint(H.get("Normal", "fg"), -0.6),

      darken_bg = H.tint(H.get("Normal", "bg"), -0.5),
    },
    delta = {
      file_fg = H.get("diffFile", "fg"),
      file_bg = H.get("diffFile", "bg"),

      hunk_header_bg = H.tint(H.get("FzfLuaNormal", "bg"), 0.2),

      line_number_fg = H.tint(H.get("Comment", "fg"), -0.05),

      line_number_plus = H.get("deltaPlus", "fg"),
      line_number_minus = H.get("deltaMinus", "fg"),

      hunk_plus_fg = H.get("diffAdd", "fg"),
      hunk_plus_bg = H.get("diffAdd", "bg"),
      hunk_emp_plus_fg = H.get("deltaPlus", "fg"),
      hunk_emp_plus_bg = H.get("deltaPlus", "bg"),

      hunk_minus_fg = H.get("diffDelete", "fg"),
      hunk_minus_bg = H.get("diffDelete", "bg"),
      hunk_emp_minus_fg = H.get("deltaMinus", "fg"),
      hunk_emp_minus_bg = H.get("deltaMinus", "bg"),
    },
    eww = {
      bg = H.get("Normal", "bg"),

      fg = H.tint(H.get("Normal", "fg"), -0.5),
      fg2 = H.tint(H.get("diffChange", "fg"), -0.3),

      bg_darken = H.tint(H.get("Normal", "fg"), -0.3),
      bg_alt = H.tint(H.get("Normal", "fg"), 0.3),

      red = H.tint(H.get("diffDelete", "fg"), 0.5),

      icon_fg = eww_icon_fg,

      keyword = H.get("Keyword", "fg"),

      -- add_fg = diff_add_fg,
      -- add_line_number = diff_add_line_number,
      -- change_bg = diff_change_bg,
      -- change_fg = diff_change_fg,
      -- change_line_number = diff_change_line_number,
    },
    yazi = {
      cwd = H.get("PanelSideRootName", "fg"),
      hovered = yazi_hovered,

      selected = H.tint(H.get("diffDelete", "fg"), 0.3),
      count_selected_bg = H.tint(H.get("diffDelete", "fg"), -0.5),

      copied = H.tint(H.get("diffChange", "fg"), 0.3),
      count_copied_bg = H.tint(H.get("diffChange", "fg"), -0.5),

      cut = H.tint(H.get("String", "fg"), 0.3),
      count_cut_bg = H.tint(H.get("String", "fg"), -0.5),

      marked_fg = H.tint(H.get("Function", "fg"), 0.1),
      marked_bg = H.tint(H.get("Function", "fg"), -0.5),

      tab_active_fg = H.get("Keyword", "fg"),
      tab_active_bg = H.get("NormalKeyword", "bg"),
      tab_inactive_fg = H.get("NormalKeyword", "bg"),
      tab_inactive_bg = H.tint(H.get("TabLine", "bg"), 0.66),

      statusline_normal_fg = H.tint(H.get("TabLine", "fg"), 0.4),
      statusline_normal_bg = H.tint(H.get("TabLine", "bg"), 0.2),
      statusline_normal_fg_alt = H.get("TabLine", "fg"),
      statusline_normal_bg_alt = H.get("TabLine", "bg"),

      statusline_select_fg = H.tint(H.get("Visual", "bg"), 2),
      statusline_select_bg = H.tint(H.get("Visual", "bg"), 0.4),
      statusline_select_fg_alt = H.tint(H.get("Visual", "bg"), 1),
      statusline_select_bg_alt = H.get("Visual", "bg"),

      statusline_unset_fg = H.tint(H.get("Function", "fg"), -0.5),
      statusline_unset_bg = H.tint(H.get("Function", "fg"), 0.4),
      statusline_unset_fg_alt = H.tint(H.get("Function", "fg"), -0.8),
      statusline_unset_bg_alt = H.get("Function", "fg"),

      directory = H.get("Directory", "fg"),

      menu_bg = H.get("Pmenu", "bg"),
      menu_fg = H.get("Pmenu", "fg"),
    },
    rofi = {
      foreground = H.get("Normal", "bg"),

      background = H.tint(H.get("Normal", "bg"), 0.25),
      background_alt = H.tint(H.get("Keyword", "fg"), -0.4),

      selected = H.get("Normal", "bg"),
      selected_alt = H.tint(H.get("Keyword", "fg"), -0.4),

      keyword = H.get("Keyword", "fg"),

      red = H.tint(H.get("diffDelete", "fg"), -0.3),
      green = H.tint(H.get("diffAdd", "fg"), -0.3),
    },
  }

  M.send_to_file(defined_cols, "/tmp/master-colors-themes", true)
end

function M.infoFoldPreview()
  vim.cmd "options"
end

return M
