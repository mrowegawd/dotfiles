---@diagnostic disable: undefined-field
---@class r.utils.cmd
local M = {}

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

---@param wins string|string[]
---@return { found: boolean, winbufnr: integer, winnr: integer, winid: integer, ft: string }
function M.windows_is_opened(wins)
  local QfbookmarkUtils = require "qfbookmark.utils"
  local qf_wins = QfbookmarkUtils.windows_is_opened(wins)
  return qf_wins
end

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

---@param str string
---@return string
function M.normalize_return(str)
  ---@diagnostic disable-next-line: redefined-local
  local str_slice = string.gsub(str, "\n", "")
  local res = vim.split(str_slice, "\n")
  if res[1] then
    return res[1]
  end

  return str_slice
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

---@param prefix string
---@param mode? "info" | "warn" | "error"
local function notifysend(prefix, msg, mode)
  local title = "Open With " .. (#prefix > 0 and prefix:sub(1, 1):upper()) .. (#prefix > 0 and prefix:sub(2):lower())
  mode = mode or "info"

  if mode == "info" then
    RUtils.info(msg, { title = title })
  end

  if mode == "error" then
    RUtils.error(msg, { title = title })
  end

  if mode == "warn" then
    RUtils.error(msg, { title = title })
  end
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
local function open_media_or_git(line_str)
  if vim.bo.filetype == "git" then
    line_str = line_str:match "([a-f0-9]+)$" or line_str
  end

  local git_ft_relatives = { "NeogitCommitView", "git" }

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
    sel_open_with = {
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
  local prefix_notify = "Media or Git"

  local width = tonumber("0." .. width_all_text)
  if not width then
    return
  end

  local opts = RUtils.fzflua.open_lsp_code_action {
    winopts = {
      title = RUtils.fzflua.format_title("Select To Open With", RUtils.config.icons.documents.openfolder),
      height = #contents + 3,
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

              local msg = RUtils.strip_whitespaces(key_open[1])
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
            ---@diagnostic disable-next-line: undefined-field
            notifysend(prefix_notify, "Failed run command: `" .. table.concat(cmds, " ") .. "`", "error")
            return
          end
        end

        if notif_msg then
          ---@diagnostic disable-next-line: undefined-field
          notifysend(prefix_notify, notif_msg)
        end

        if warn_msg then
          ---@diagnostic disable-next-line: undefined-field
          notifysend(prefix_notify, warn_msg, "warn")
        end
      end,
    },
  }

  require("fzf-lua").fzf_exec(contents, opts)
end

---@param line_str string
local function open_in_browser(line_str)
  local uri = vim.fn.matchstr(line_str, [[https\?:\/\/[A-Za-z0-9-_\.#\/=\?%]\+]])
  local search_msg = "Search: "

  local url
  if #uri > 0 then
    search_msg = "Open: "
    url = uri
  else
    url = string.format("https://google.com/search?q=%s", line_str)
  end

  -- vim.fn.jobstart({ vim.fn.has "macunix" ~= 0 and "open" or "xdg-open", url }, { detach = true })
  local browser = os.getenv "NUBROWSER"
  local cmds = { browser, url }

  local outputs_cmd = vim.system(cmds, { text = true }):wait()
  if outputs_cmd.code ~= 0 then
    ---@diagnostic disable-next-line: undefined-field
    notifysend("browser", "Failed search command: `" .. table.concat(cmds, " ") .. "`", "error")
    return
  end
  ---@diagnostic disable-next-line: undefined-field
  notifysend("browser", search_msg .. "`" .. line_str .. "`")
end

---@param url string
---@param mode_open string
local function goto_file(url, mode_open)
  local ok = RUtils.buf.window.call_stack_peek()

  if ok then
    RUtils.buf.window.arange_wins "vsplit"()
    return
  end

  local filepath, line_nr, col_nr = url:match "([^%s:]+):(%d+):(%d+)"

  if not filepath or not line_nr then
    filepath, line_nr = url:match "^(.+):(%d+)"
  end

  if not filepath then
    notifysend("Go To File", "use fallback `gf` key")

    vim.cmd(mode_open)

    local success, err = pcall(vim.cmd.normal, {
      "gf",
      bang = true,
    })

    if not success then
      RUtils.error(err)
    end

    return
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

---@param context_mode string
---@return string?
local function get_target_from_selection(context_mode)
  local mode = vim.fn.mode()

  if mode == "v" or mode == "V" then
    local exit_visual = context_mode == "mpv or svix"

    local line = RUtils.get_visual_selection {
      exit_from_visual = exit_visual,
    }

    return line and line.selection or nil
  end

  return RUtils.get_lines_under_cusor()
end

---@param context_mode "mpv or svix" | "browser" | "go to file"
---@param mode_open? "vsplit" | "split" | "edit"
function M.open_with(context_mode, mode_open)
  mode_open = mode_open or "edit"

  local available_modes = { "mpv or svix", "browser", "go to file" }

  if not vim.tbl_contains(available_modes, context_mode) then
    ---@diagnostic disable-next-line: undefined-field
    notifysend("", "Available mode: " .. table.concat(available_modes, ", "))
    return
  end

  local url = get_target_from_selection(context_mode)

  if not url or url == "" then
    notifysend("", "Failed to extract string under cursor, abort")
    return
  end

  if context_mode == "browser" then
    open_in_browser(url)
    return
  end

  if context_mode == "mpv or svix" then
    open_media_or_git(url)
    return
  end

  if context_mode == "go to file" then
    goto_file(url, mode_open)
  end
end

---@param filetype string
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

---@param contents string | table
---@param path? string
---@param is_theme? boolean
function M.send_contents_to_file(contents, path, is_theme)
  path = path or "/tmp/isi_contents_dari_nvim"
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
  local tab_session_fg = H.get("Winbar", "fg")
  local tab_session_bg = H.get("Winbar", "bg")

  local tab_active_fg = H.get("Winbar", "bg")
  local tab_active_bg = H.get("Winbar", "fg")

  -- Inactive Tab
  -- local tab_inactive_fg = H.tint(H.get("Comment", "fg"), 0.4)
  -- local tab_inactive_bg = H.get("NormalNote", "bg")

  local tab_inactive_fg = H.get("Winbar", "fg")
  local tab_inactive_bg = H.get("Winbar", "bg")

  -- Border Pane
  local border_active, border_inactive
  if vim.g.colorscheme == "rose-pine" then
    border_active = H.tint(H.get("WinSeparator", "fg"), -0.6)
    border_inactive = H.tint(H.get("WinSeparator", "fg"), -0.1)
  else
    border_active = H.get("WinSeparator", "fg")
    border_inactive = H.tint(H.get("Normal", "bg"), 0.2)
  end

  -- ─< ZSH >────────────────────────────────────────────────────────────
  local zsh_lines = H.get("Zshlines", "fg")
  local zsh_sugest = H.get("Zshlines", "bg")

  -- ─< YAZI >───────────────────────────────────────────────────────────
  local yazi_hovered = H.get("HoveredCursorline", "bg")

  -- ─< LAZYGIT >────────────────────────────────────────────────────────
  local lazygit_inactive_border = H.tint(H.get("WinSeparator", "fg"), 0.5)
  local lazygit_inactive_text = H.tint(H.get("WinSeparator", "fg"), 4)
  local lazygit_option_text = H.tint(H.get("Normal", "bg"), 4)

  -- ─< EWW >────────────────────────────────────────────────────────────
  local __eww_icon_fg = 1
  if vim.g.colorscheme == "base46-jellybeans" then
    __eww_icon_fg = 0.5
  end
  if vim.tbl_contains({ "base46-seoul256_dark", "base46-zenburn" }, vim.g.colorscheme) then
    __eww_icon_fg = 0.5
  end
  local eww_icon_fg = H.tint(H.get("WinSeparator", "fg"), __eww_icon_fg)

  local defined_cols = {
    fzf = {
      -- Normal
      fg = H.get("FzfLuaFilePart", "fg"),
      bg = H.get("FzfLuaNormal", "bg"),
      match_fuzzy = H.get("FzfLuaFzfMatchFuzzy", "fg"),

      -- Selection
      selection_fg = H.get("FzfLuaSel", "fg"),
      selection_bg = H.get("FzfLuaSel", "bg"),
      match = H.get("FzfLuaFzfMatch", "fg"),

      marker = H.get("MarkerFzflua", "fg"),

      gutter = H.get("FzfLuaNormal", "bg"),
      pointer = H.get("Keyword", "fg"),
      border = H.get("FzfLuaBorder", "fg"),
      header = H.get("FzfLuaHeaderText", "fg"),
    },
    tmux = {
      fg = H.tint(H.get("Normal", "fg"), -0.2),
      bg = H.get("Normal", "bg"),

      -- file manager bg ex: yazi, nnn, etc
      fm_bg = H.get("PanelSideBackground", "bg"),

      keyword = H.get("Keyword", "fg"),

      tab_active_fg = tab_active_fg,
      tab_active_bg = tab_active_bg,

      statusline_fg = H.get("Winbar", "fg"),
      statusline_bg = H.get("Winbar", "bg"),

      session_fg = tab_session_fg,
      session_bg = tab_session_bg,

      message_bg = H.tint(H.darken(H.get("Function", "fg"), 0.6, H.get("Normal", "bg")), 0.7),

      visual_bg = H.get("CurSearch", "bg"),

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
      active_border = H.get("Keyword", "fg"),

      inactive_border = lazygit_inactive_border,
      default_fg = lazygit_inactive_text,

      selected_bg = H.get("LazygitselectedLineBgColor", "bg"),

      option_txt = lazygit_option_text,
    },
    dunst = {
      low_fg = H.tint(H.get("WinSeparator", "fg"), 2.2),
      low_bg = H.tint(H.get("WinSeparator", "fg"), 0.1),
      low_frame = H.tint(H.get("WinSeparator", "fg"), 0.1),

      normal_title_fg = H.tint(H.get("Keyword", "fg"), 0.5),

      normal_fg = H.tint(H.get("WinSeparator", "fg"), 4),
      normal_bg = H.tint(H.get("WinSeparator", "fg"), 0.7),
      normal_frame = H.tint(H.get("WinSeparator", "fg"), 0.7),

      critical_fg = H.tint(H.get("diffRemoved", "fg"), 0.4),
      critical_bg = H.tint(H.get("diffRemoved", "fg"), -0.25),
      critical_frame = H.tint(H.get("diffRemoved", "fg"), -0.2),

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

      yellow_alt = H.tint(H.get("diffChanged", "fg"), -0.45),
      highlight_key = H.tint(H.get("diffRemoved", "fg"), 0.1),

      cursorline_fg = H.tint(H.get("Keyword", "fg"), 1),
      cursorline_bg = H.tint(H.get("Keyword", "fg"), -0.5),

      border_fg = H.tint(H.get("WinSeparator", "fg"), 0.25),

      title = H.tint(H.get("Keyword", "fg"), -0.2),

      inactive_text = H.tint(H.get("Normal", "fg"), -0.6),

      darken_bg = H.tint(H.get("Normal", "bg"), -0.5),
    },
    delta = {
      hunk_header_fg = H.get("diffFile", "fg"),
      hunk_header_bg = H.get("diffFile", "bg"),

      line_number_fg = H.tint(H.get("Normal", "bg"), 0.5),

      line_number_plus = H.get("NeogitDiffAdd", "fg"),
      line_number_minus = H.get("NeogitDiffDelete", "fg"),

      hunk_plus_fg = H.get("NeogitDiffAdd", "fg"),
      hunk_plus_bg = H.get("NeogitDiffAdd", "bg"),
      hunk_emp_plus_fg = H.get("NeogitDiffAddInline", "fg"),
      hunk_emp_plus_bg = H.get("NeogitDiffAddInline", "bg"),

      hunk_minus_fg = H.get("NeogitDiffDelete", "fg"),
      hunk_minus_bg = H.get("NeogitDiffDelete", "bg"),
      hunk_emp_minus_fg = H.get("NeogitDiffDeleteInline", "fg"),
      hunk_emp_minus_bg = H.get("NeogitDiffDeleteInline", "bg"),
    },
    eww = {
      bg = H.get("Normal", "bg"),

      fg = H.tint(H.get("Normal", "fg"), -0.5),
      fg2 = H.tint(H.get("diffChanged", "fg"), -0.3),

      bg_darken = H.tint(H.get("Normal", "fg"), -0.3),
      bg_alt = H.tint(H.get("Normal", "fg"), 0.3),

      red = H.darken(H.get("diffRemoved", "fg"), 0.8, H.get("Normal", "bg")),

      icon_fg = eww_icon_fg,

      keyword = H.get("Keyword", "fg"),
    },
    yazi = {
      cwd = H.get("PanelSideRootName", "fg"),
      hovered = yazi_hovered,

      selected = H.darken(H.get("diffRemoved", "fg"), 0.8, H.get("Normal", "bg")),
      count_selected_bg = H.darken(H.get("diffRemoved", "fg"), 0.8, H.get("Normal", "bg")),

      find_keyword_fg = H.get("CurSearch", "fg"),
      find_keyword_bg = H.get("CurSearch", "bg"),

      copied = H.tint(H.get("diffChanged", "fg"), 0.3),
      count_copied_bg = H.tint(H.get("diffChanged", "fg"), -0.5),

      cut = H.tint(H.get("String", "fg"), 0.3),
      count_cut_bg = H.tint(H.get("String", "fg"), -0.5),

      marked_fg = H.tint(H.get("Function", "fg"), 0.1),
      marked_bg = H.tint(H.get("Function", "fg"), -0.5),

      tab_active_fg = H.get("Keyword", "fg"),
      tab_active_bg = H.get("NormalKeyword", "bg"),
      tab_inactive_fg = H.get("NormalKeyword", "bg"),
      tab_inactive_bg = H.tint(H.get("TabLine", "bg"), 0.66),

      -- statusline_normal_fg = H.get("StatusLineRightBlock", "fg"),
      -- statusline_normal_bg = H.get("StatusLineRightBlock", "bg"),
      -- statusline_normal_fg_alt = H.darken(H.get("StatusLineRightBlock", "fg"), 0.7, H.get("Normal", "bg")),
      -- statusline_normal_bg_alt = H.darken(H.get("StatusLineRightBlock", "bg"), 0.6, H.get("Normal", "bg")),

      statusline_normal_fg = H.get("Statusline", "fg"),
      statusline_normal_bg = H.get("Statusline", "bg"),
      statusline_normal_fg_alt = H.darken(H.get("Statusline", "fg"), 0.7, H.get("Normal", "bg")),
      statusline_normal_bg_alt = H.darken(H.get("Statusline", "bg"), 0.6, H.get("Normal", "bg")),

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

      red = H.tint(H.get("diffRemoved", "fg"), -0.3),
      green = H.tint(H.get("diffAdded", "bg"), -0.3),
    },
  }

  M.send_contents_to_file(defined_cols, "/tmp/master-colors-themes", true)
end

---@param bufnr integer
local function is_line_fold(bufnr)
  local pos = vim.api.nvim_win_get_cursor(bufnr)
  local line = pos[1]
  return vim.fn.foldclosed(line)
end

---@param is_only_check? boolean
---@param bufnr? integer
function M.force_foldopen(is_only_check, bufnr)
  bufnr = bufnr or 0
  is_only_check = is_only_check or false

  local fold_start = is_line_fold(bufnr)

  if is_only_check then
    if fold_start ~= -1 then
      return true
    end
    return false
  end

  if fold_start ~= -1 then
    vim.cmd "silent! foldopen!"
  end
end

return M
