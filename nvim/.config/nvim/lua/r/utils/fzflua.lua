---@class r.utils.fzflua
local M = {}

local function get_option(name_opt)
  return vim.api.nvim_get_option_value(name_opt, { scope = "local" })
end

function M.rectangle_win_pojokan()
  local win_height = math.ceil(get_option "lines" * 0.5)
  local win_width = math.ceil(get_option "columns" * 1)

  local col = math.ceil((win_width / 2) * 1 + 20)
  local row = math.ceil((get_option "lines" - win_height) * 1 + 5)
  return col, row
end

function M.format_title(str, icon, icon_hl)
  return {
    { " ", "NormalFLoat" },
    { (icon and icon .. " " or ""), icon_hl or "FzfLuaTitle" },
    { str, "FzfLuaTitle" },
    { " ", "NormalFLoat" },
  }
end

function M.dropdown(opts)
  opts = opts or { winopts = {} }
  local title = vim.tbl_get(opts, "winopts", "title") ---@type string?
  if title and type(title) == "string" then
    opts.winopts.title = M.format_title(title)
  end
  return vim.tbl_deep_extend("force", {
    prompt = RUtils.config.icons.misc.dots,
    fzf_opts = { ["--layout"] = "reverse" },
    winopts = {
      title_pos = opts.winopts.title and "center" or nil,
      height = 0.70,
      width = 0.60,
      row = 0.1,
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

  local vim_width = vim.o.columns
  local vim_height = height

  local widthc = math.floor(vim_width / 2 + 8)
  local heightc = math.floor(vim_height / 2 - 5)

  return M.dropdown(vim.tbl_deep_extend("force", {
    winopts_fn = {
      width = widthc,
      height = heightc,
    },
    winopts = {
      row = 2,
      relative = "cursor",
      height = 0.33,
      width = widthc / (widthc + vim_width - 10),
    },
  }, opts))
end

function M.cursor_random(opts)
  local height = vim.o.lines - vim.o.cmdheight
  if vim.o.laststatus ~= 0 then
    height = height - 1
  end

  local vim_width = vim.o.columns
  local vim_height = height

  local widthc = math.floor(vim_width / 2 + 8)
  local heightc = math.floor(vim_height / 2 - 5)

  return M.dropdown(vim.tbl_deep_extend("force", {
    winopts_fn = {
      width = widthc,
      height = heightc,
    },
    winopts = {
      height = 0.33,
      width = widthc / (widthc + vim_width - 10),
    },
  }, opts))
end

function M.send_cmds(opts, opts_cmds)
  local cmds = {}
  for idx, _ in pairs(opts) do
    table.insert(cmds, idx)
  end

  require("fzf-lua").fzf_exec(
    cmds,
    M.cursor_random(vim.tbl_deep_extend("force", {
      prompt = "  ",
      -- winopts = { title = opts_cmds.title },
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
                print(file)
                cb(require("fzf-lua").make_entry.file(file, {}), function()
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

    require("fzf-lua").fzf_exec(contents, fzf_opts)
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

return M
