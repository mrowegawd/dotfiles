local M = {}

local Log = require "utils.log"

---@param tbl table
---@param element any
---@return boolean
function M.check_tbl_element(tbl, element)
  for _, x in pairs(tbl) do
    if x == element then
      return true
    end
  end
  return false
end

--- Executes a command and returns the output
--- @param command string
--- @return string -- returns empty string upon error
function M.execute_io_open(command)
  local handle = io.popen(command)

  if handle == nil then
    return ""
  end

  local output = handle:read "*a"
  handle:close()

  return output
end

---@return table
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

---@param old_tbl table
---@return table
function M.remove_duplicates_table(old_tbl)
  local new_tbl = {}
  for _, element in pairs(old_tbl) do
    if not M.check_tbl_element(new_tbl, element) then
      table.insert(new_tbl, element)
    end
  end

  return new_tbl
end

---@param name string
---@param rhs string | function
---@param opts? vim.api.keyset.user_command
function M.create_command(name, rhs, opts)
  opts = opts or {}
  vim.api.nvim_create_user_command(name, rhs, opts)
end

---@return string
function M.get_lines_under_cusor()
  return vim.fn.expand "<cWORD>"
end

---@param name_opt string
---@param scope? string
function M.get_option(name_opt, scope)
  scope = scope or "local"
  return vim.api.nvim_get_option_value(name_opt, { scope = scope })
end

---@param opts? { strict: boolean, exit_from_visual: boolean }
---@return { line: string, selection: string, csrow: integer, cscol: integer, cerow:integer, cecol: integer } | nil
function M.get_visual_selection(opts)
  -- vim.cmd 'noau normal! "vy"'
  -- local text = vim.fn.getreg "v"
  -- vim.fn.setreg("v", {})
  -- text = string.gsub(text, "\n", "")
  -- if #text > 0 then
  --   return text
  -- else
  --   return ""
  -- end

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
    if not opts.exit_from_visual then
      -- exit visual mode
      require("utils.map").feedkey "<Esc>"
    end
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

---@param str string
---@return string
function M.rstrip_whitespace(str)
  str = string.gsub(str, "%s+$", "")
  return str
end

---@param str string
---@param limit? integer
---@return string
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

---@param str string
---@return string
function M.strip_whitespaces(str)
  if str then
    return M.rstrip_whitespace(M.lstrip_whitespace(str))
  end
  return ""
end

-- ┏╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┓
-- ╏                               OPEN IN BROWSE                                ╏
-- ┗╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┛

---@param context_mode string
---@return string?
local function get_target_from_selection(context_mode)
  local mode = vim.fn.mode()

  if mode == "v" or mode == "V" then
    local exit_visual = context_mode == "mpv or svix"

    local line = M.get_visual_selection {
      exit_from_visual = exit_visual,
    }

    return line and line.selection or nil
  end

  return M.get_lines_under_cusor()
end

---@param line_str string
---@return boolean
local function open_image_with_sxiv(line_str)
  local filename = line_str:match "^.+/(.+)$" or "image.jpg"
  local download_path = vim.fn.expand("/tmp/" .. filename)
  local is_success = false

  -- Download file ke ~/Downloads/
  vim.system({ "wget", "-q", line_str, "-O", download_path }, {}, function(dl)
    if dl.code == 0 then
      vim.system({ "sxiv", download_path }, { detach = true })
      is_success = true
    end
  end)

  return is_success
end

---@param line_str string
---@return boolean
---@return string | nil
local function open_media_or_git(line_str)
  if vim.bo.filetype == "git" then
    line_str = line_str:match "([a-f0-9]+)$" or line_str
  end

  local git_ft_relatives = {
    "NeogitStatus",
    "NeogitCommitView",
    --
    "git",
    --
    "DiffviewFiles",
    "DiffviewFileHistory",
  }

  local sel_open_with = {
    ["Open MPV - Download/Open local/http video"] = {
      prefix_cmd = {
        "tsp",
        "mpv",
        "--ontop",
        "--no-border",
        "--force-window",
        "--autofit=1000x500",
        "--geometry=-20-60",
      },
      -- prefix_cmd = { -- broken monitor
      --   "tsp",
      --   "mpv",
      --   "--ontop",
      --   "--no-border",
      --   "--force-window",
      --   "--autofit=600x500",
      --   "--geometry=95%:40%",
      -- },
    },

    -- Kendala dengan sxiv ini, tidak bisa open image dengan line_str
    ["Open Local Sxiv - Open local image with sxiv"] = { prefix_cmd = { "tsp", "sxiv", "--ontop" } },

    -- Kalau dengan feh ini, bisa membuka image line_str, tapi ga bisa di zoom
    ["Open Feh - Open/Download image with Feh"] = {
      prefix_cmd = { "tsp", "feh", "-.", "-x", "-B", "black", "-g", "900x600-15+60" },
    },

    -- Kalau cara ini kita download, check function open_image_with_sxiv
    ["DL IMG Open Sxiv - Open/Download image with Sxiv"] = { prefix_cmd = {} },
  }

  if vim.tbl_contains(git_ft_relatives, vim.bo.filetype) then
    local git_stuff = {
      ["Diffview - Open specific commit"] = {
        prefix_cmd = { "DiffviewOpen" },
        end_cmd = { "^!" },
      },
      ["Diffview - Open working diff against specific commit"] = { prefix_cmd = { "DiffviewOpen" } },
      ["Fugitive - Open specific commit with gedit"] = { prefix_cmd = { "Gedit" } },
      ["Fugitive - Compare this commit with selected commit"] = { prefix_cmd = { "DiffviewOpen" } },
      ["Fugitive - Explore this log commit"] = { prefix_cmd = { "DiffviewOpen" } },
      ["Fugitive - Drop this commit and compare"] = { prefix_cmd = { "DiffviewOpen" } },
      ["Git - Checkout this commit"] = { prefix_cmd = { "DiffviewOpen" } },
      ["Git - Cherry pick this commit"] = { prefix_cmd = { "DiffviewOpen" } },
      ["Git - Collect files and send to QF"] = { prefix_cmd = { "DiffviewOpen" } },
      ["Octo - Open this PR"] = { prefix_cmd = { "Octo pr edit " } },
      ["Octo - Open this Issue"] = { prefix_cmd = { "Octo issue edit " } },
    }

    sel_open_with = vim.tbl_extend("force", {}, sel_open_with, git_stuff)
  end

  if vim.bo.filetype == "octo" then
    sel_open_with["Octo - Open this PR"] = { prefix_cmd = { "Octo pr edit " } }
    sel_open_with["Octo - Open this Issue"] = { prefix_cmd = { "Octo issue edit " } }
  end

  local width_all_text = 30
  local sel_opens = {}

  ---@return table
  local sel_fzf = function()
    local width_prefix_text = 1
    for i, _ in pairs(sel_open_with) do
      local str_split = vim.split(i, "-")[1]
      if width_prefix_text < #str_split then
        width_prefix_text = #str_split
      end

      if width_all_text < #i then
        width_all_text = #i
      end
    end

    local newtbl = {}
    for i, val in pairs(sel_open_with) do
      local str_split = vim.split(i, "-")
      local title = string.format("%-" .. width_prefix_text .. "s - %s", str_split[1], str_split[2])
      newtbl[#newtbl + 1] = title
      sel_opens[title] = val
    end
    table.sort(newtbl)
    return newtbl
  end

  local contents = sel_fzf()
  -- local prefix_notify = "Media or Git"

  local width = tonumber("0." .. width_all_text)
  if not width then
    return false, "define `width` error"
  end

  Log.info(tostring(#contents))

  local opts = {
    winopts = {
      -- title = RUtils.fzflua.format_title("Select To Open With", RUtils.config.icons.documents.openfolder),
      height = #contents + #contents,
      -- height = 0.6,
      width = width,
    },
    actions = {
      ["default"] = function(selected)
        if not selected then
          return
        end

        local sel = selected[1]
        local notif_msg, warn_msg

        local sel_split = vim.split(sel, " - ")

        if sel_split[1] == "DL IMG Open Sxiv" then
          local is_success = open_image_with_sxiv(line_str)
          if is_success then
            notif_msg = "Download and Open Image: " .. line_str
          else
            warn_msg = string.format("Failed download image HTTP: %s", line_str)
          end
        else
          local cmds
          for key_open, open in pairs(sel_opens) do
            if key_open == sel then
              if open.end_cmd then
                if type(open.end_cmd) == "table" then
                  line_str = line_str .. open.end_cmd[1]
                end
              end

              open.prefix_cmd[#open.prefix_cmd + 1] = line_str
              cmds = open.prefix_cmd

              key_open = vim.split(tostring(key_open), "-")

              local msg = require("utils.cmd").strip_whitespaces(key_open[1])
              notif_msg = msg .. ": " .. line_str
            end
          end

          if vim.tbl_contains(git_ft_relatives, vim.bo.filetype) then
            if sel == "Open PR with Octo" then
              vim.cmd "tabnew e"
            end
            vim.cmd(table.concat(cmds, " "))
            return
          end

          local outputs = vim.system(cmds, { text = true }):wait()
          if outputs.code ~= 0 then
            -- Log.error("Failed run command: `" .. table.concat(cmds, " ") .. "`")
            return false, "Failed run command: `" .. table.concat(cmds, " ") .. "`"
          end
        end

        if notif_msg then
          ---@diagnostic disable-next-line: undefined-field
          Log.info(notif_msg)
          return true, nil
        end

        if warn_msg then
          ---@diagnostic disable-next-line: undefined-field
          return false, warn_msg
        end
      end,
    },
  }

  -- RUtils.fzflua.setup_fzflua().fzf_exec(contents, opts)
  require("fzf-lua").fzf_exec(contents, opts)
end

---@param line_str string
---@return boolean
---@return string | nil
local function open_in_browser(line_str)
  local uri = vim.fn.matchstr(line_str, [[https\?:\/\/[A-Za-z0-9-_\.#\/=\?%]\+]])
  -- local search_msg = "Search: "

  local url
  if #uri > 0 then
    -- search_msg = "Open: "
    url = uri
  else
    url = string.format("https://google.com/search?q=%s", line_str)
  end

  -- vim.fn.jobstart({ vim.fn.has "macunix" ~= 0 and "open" or "xdg-open", url }, { detach = true })
  local browser = os.getenv "NUBROWSER"
  local cmds = { browser, url }

  local outputs_cmd = vim.system(cmds, { text = true }):wait()
  if outputs_cmd.code ~= 0 then
    return false, "Failed search command: `" .. table.concat(cmds, " ") .. "`"
  end
  return true, nil
end

---@param url string
---@param mode_open string
---@return boolean, string|nil
local function goto_file(url, mode_open)
  local ok, _ = require("utils.window").call_stack_peek()
  if not ok then
    require("utils.window").arange_wins "vsplit"()
    return true, nil
  end

  local filepath, line_nr, col_nr = url:match "([^%s:]+):(%d+):(%d+)"

  if not filepath or not line_nr then
    filepath, line_nr = url:match "^(.+):(%d+)"
  end

  if not filepath then
    local success, err = pcall(vim.cmd.normal, {
      "gf",
      bang = true,
    })

    if not success then
      return false, "Use fallback `qf` Go to file" .. err .. "warn"
    end
  end

  filepath = vim.fn.expand(filepath)

  local target_line = tonumber(line_nr) or 1
  local target_col = tonumber(col_nr) or 0

  vim.cmd(mode_open .. " " .. filepath)

  vim.defer_fn(function()
    vim.api.nvim_win_set_cursor(0, {
      target_line,
      target_col,
    })
  end, 1)
end

---@param context_mode "mpv or svix" | "browser" | "go to file"
---@param mode_open? "vsplit" | "split" | "edit"
function M.open_with(context_mode, mode_open)
  mode_open = mode_open or "edit"

  local available_modes = { "mpv or svix", "browser", "go to file" }

  if not vim.tbl_contains(available_modes, context_mode) then
    Log.error("Available mode: " .. table.concat(available_modes, ", "))
    return
  end

  local url = get_target_from_selection(context_mode)

  if not url or url == "" then
    Log.info "Failed to extract string under cursor, abort"
    return
  end

  if context_mode == "browser" then
    local ok, msg = open_in_browser(url)
    if not ok and msg then
      Log.warn(msg)
      return
    end
  end

  if context_mode == "mpv or svix" then
    local ok, msg = open_media_or_git(url)
    if not ok and msg then
      Log.warn(msg)
      return
    end
  end

  if context_mode == "go to file" then
    local ok, msg = goto_file(url, mode_open)
    if not ok and msg then
      Log.warn(msg)
      return
    end
  end
end

-- ┏╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┓
-- ╏                             BROWSE THIS ERRORS                              ╏
-- ┗╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┛

---@param link string
---@return string
local function remove_alias(link)
  local split_index = string.find(link, "%s*|")
  if split_index ~= nil and type(split_index) == "number" then
    return string.sub(link, 0, split_index - 1)
  end
  return link
end

---@param is_selection? boolean
function M.browse_this_error(is_selection)
  is_selection = is_selection or false

  vim.cmd "normal yy"
  local str_sel = vim.fn.getreg '"0'
  str_sel = str_sel:gsub("^(%[)(.+)(%])$", "%2")
  str_sel = remove_alias(str_sel)

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
      Log.info(vim.inspect(cmds))
    end
  end

  local fzfopts = {
    prompt = "  ",
    cwd_prompt = false,
    cwd_header = false,
    no_header = true,
    no_header_i = true,
    winopts = {
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

-- ┏╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┓
-- ╏                                FZFLUA HELPER                                ╏
-- ┗╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┛

function M.has_ansi_coloring(str)
  return str:match "%[[%d;]-m"
end

local nbsp = "\xe2\x80\x82" -- "\u{2002}"

local __lastIndexOf = function(haystack, needle)
  local i = haystack:match(".*" .. needle .. "()")
  if i == nil then
    return nil
  else
    return i - 1
  end
end

function M.strip_ansi_coloring(str)
  if not str then
    return str
  end
  -- remove escape sequences of the following formats:
  -- 1. ^[[34m
  -- 2. ^[[0;34m
  -- 3. ^[[m
  return str:gsub("%[[%d;]-m", "")
end

---@return string, number
local __stripBeforeLastOccurrenceOf = function(str, sep)
  local idx = __lastIndexOf(str, sep) or 0
  return str:sub(idx + 1), idx
end

---@return string|nil, number|nil
function M.__strip_str(selected)
  local pth = M.strip_ansi_coloring(selected)
  if pth == nil then
    return nil, nil
  end
  return __stripBeforeLastOccurrenceOf(pth, nbsp)
end

return M
