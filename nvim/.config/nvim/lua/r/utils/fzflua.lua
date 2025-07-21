---@class r.utils.fzflua
local M = {}

function M.default_title_prompt()
  return "  "
end

local fzf_lua = RUtils.cmd.reqcall "fzf-lua"

function M.rectangle_win_pojokan()
  local win_height = math.ceil(RUtils.cmd.get_option "lines" * 0.5)
  local win_width = math.ceil(RUtils.cmd.get_option "columns" * 1)

  local col = math.ceil((win_width / 2) * 1 + 20)
  local row = math.ceil((RUtils.cmd.get_option "lines" - win_height) * 1 + 5)
  return col, row
end

function M.format_title(str, icon, icon_hl)
  return {
    { " ", "FzfLuaPreviewTitle" },
    { (icon and icon .. " " or ""), icon_hl or "FzfLuaPreviewTitle" },
    { str, "FzfLuaPreviewTitle" },
    { " ", "FzfLuaPreviewTitle" },
  }
end

function M.dropdown(opts)
  opts = opts or { winopts = {} }
  local title = vim.tbl_get(opts, "winopts", "title") ---@type string?
  if title and type(title) == "string" then
    opts.winopts.title = M.format_title(title)
  end
  return vim.tbl_deep_extend("force", {
    prompt = M.default_title_prompt(),
    fzf_opts = { ["--layout"] = "reverse" },
    winopts = {
      title_pos = opts.winopts.title and "center" or nil,
      height = 20,
      width = math.floor(vim.o.columns / 2 + 8),
      col = 0.50,
      fullscreen = false,
      preview = {
        hidden = "hidden",
        layout = "vertical",
        vertical = "up:50%",
      },
    },
  }, opts)
end

function M.cursor_dropdown(opts)
  local height = vim.o.lines - vim.o.cmdheight
  if vim.o.laststatus ~= 0 then
    height = height - 1
  end

  return M.dropdown(vim.tbl_deep_extend("force", {
    winopts = {
      width = math.floor(vim.o.columns / 2 + 8),
      height = math.floor(height / 2 - 5),
      row = 2,
      relative = "cursor",
    },
  }, opts))
end

function M.cursor_random(opts)
  local height = vim.o.lines - vim.o.cmdheight
  if vim.o.laststatus ~= 0 then
    height = math.floor(math.min(99, height / 3))
  end

  return M.dropdown(vim.tbl_deep_extend("force", {
    winopts = {
      width = math.floor(math.min(60, vim.o.columns / 2)),
      border = RUtils.config.icons.border.rectangle,
      height = height,
    },
  }, opts))
end

function M.send_cmds(opts, opts_cmds)
  local cmds = {}
  for idx, _ in pairs(opts) do
    table.insert(cmds, idx)
  end

  fzf_lua.fzf_exec(
    cmds,
    M.cursor_random(vim.tbl_deep_extend("force", {
      prompt = RUtils.fzflua.default_title_prompt(),
      winopts = {
        title = opts_cmds.title and opts_cmds.title or "",
      },
      actions = {
        ["default"] = function(selected, _)
          local sel = selected[1]
          if opts[sel] then
            opts[sel]()
          end
        end,
      },
    }, opts_cmds))
  )
end

function M.has_ansi_coloring(str)
  return str:match "%[[%d;]-m"
end

function M.replace_refs(s)
  local out, _ = string.gsub(s, "%[%[[^%|%]]+%|([^%]]+)%]%]", "%1")
  out, _ = out:gsub("%[%[([^%]]+)%]%]", "%1")
  out, _ = out:gsub("%[([^%]]+)%]%([^%)]+%)", "%1")
  return out
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

function M.ansi_escseq_len(str)
  local stripped = M.strip_ansi_coloring(str)
  return #str - #stripped
end

function M.exec_fzf_cmd_async(str_cmds, fzf_opts)
  vim.validate {
    str_cmds = { str_cmds, "string" },
    fzf_opts = { fzf_opts, "table" },
  }
  return function()
    local contents = function(cb)
      coroutine.wrap(function()
        local co = coroutine.running()

        local function on_event(_, data, event)
          if event == "stdout" then
            for _, file in ipairs(data) do
              if #file > 0 then
                -- print(file)
                cb(fzf_lua.make_entry.file(file, {}), function()
                  coroutine.resume(co, 0)
                end)
              end
            end
          elseif event == "stderr" then
            vim.cmd "echohl Error"
            vim.cmd('echomsg "' .. table.concat(data, "") .. '"')
            vim.cmd "echohl None"
            coroutine.resume(co, 2)
          elseif event == "exit" then
            coroutine.resume(co, 1)
          end
        end

        vim.fn.jobstart(str_cmds, {
          on_stderr = on_event,
          on_stdout = on_event,
          on_exit = on_event,
          -- cwd = cwd,
        })

        repeat
          -- waiting for a call to 'resume'
          local ret = coroutine.yield()
        -- print("yielded", ret)
        until ret ~= 0

        -- process oldfiles

        -- only when done procesing we call EOF once
        cb(nil)
      end)()
    end

    fzf_lua.fzf_exec(contents, fzf_opts)
  end
end

local nbsp = "\xe2\x80\x82" -- "\u{2002}"

local function __lastIndexOf(haystack, needle)
  local i = haystack:match(".*" .. needle .. "()")
  if i == nil then
    return nil
  else
    return i - 1
  end
end

local function __stripBeforeLastOccurrenceOf(str, sep)
  local idx = __lastIndexOf(str, sep) or 0
  return str:sub(idx + 1), idx
end

function M.__strip_str(selected)
  local pth = M.strip_ansi_coloring(selected)
  if pth == nil then
    return
  end
  return __stripBeforeLastOccurrenceOf(pth, nbsp)
end

function M.select_lsp()
  local lsp_kinds = { "all" }
  for key, icon in pairs(RUtils.config.icons.kinds) do
    table.insert(lsp_kinds, icon .. " " .. key)
  end
  return lsp_kinds
end

function M.cmd_filter_kind_lsp(opts)
  opts = opts or {}
  vim.validate {
    tilte = { opts.title, "string" },
    actions = { opts.actions, "table" },
  }

  local selected_lsp = M.select_lsp()

  fzf_lua.fzf_exec(selected_lsp, {
    prompt = RUtils.fzflua.default_title_prompt(),
    no_esc = true,
    fzf_opts = { ["--layout"] = "reverse" },
    winopts = {
      border = RUtils.config.icons.border.rectangle,
      title = M.format_title(string.format("%s Filter", opts.title), "󰈙"),
      fullscreen = false,
      col = 0.50,
      row = 0.50,
      width = 0.20,
      height = 20,
    },
    actions = opts.actions,
  })
end

function M.extend_title_fzf(opts, extend_title)
  extend_title = extend_title or "Symbols"
  opts = opts or {}

  vim.validate {
    cwd = { opts.cwd, "string" },
  }

  if #opts.cwd == 0 then
    opts.cwd = ""
  else
    opts.cwd = string.format(": %s", opts.cwd)
  end

  local title = RUtils.fzflua.format_title(
    string.format("%s%s", extend_title, opts.cwd),
    RUtils.cmd.strip_whitespace(RUtils.config.icons.misc.gear)
  )

  return {
    title = title,
  }
end

return M
