---@class r.utils.fzflua
local M = {}

local function fzf_lua()
  return RUtils.cmd.reqcall "fzf-lua"
end

local dropdown = function(opts)
  opts = opts or {}
  local title = vim.tbl_get(opts, "winopts", "title") ---@type string?
  if title and type(title) == "string" then
    opts.winopts.title = M.format_title(title)
  end

  local v_backdrop = 60
  if vim.tbl_contains({ "base46-seoul256_dark", "base46-zenburn" }, vim.g.colorscheme) then
    v_backdrop = 90
  end

  return vim.tbl_deep_extend("force", {
    prompt = M.padding_prompt(),
    fzf_opts = { ["--layout"] = "reverse" },
    winopts = {
      border = RUtils.config.icons.border.rectangle,
      title_pos = opts.winopts.title and "center" or nil,
      height = 20,
      width = math.floor(vim.o.columns / 2 + 8),
      col = 0.50,
      backdrop = v_backdrop,
      fullscreen = false,
      preview = {
        hidden = "hidden",
        layout = "vertical",
        vertical = "up:50%",
      },
    },
  }, opts)
end

local layout_center = function(opts)
  return dropdown(vim.tbl_deep_extend("force", {
    winopts = {
      fullscreen = false,
      height = 20,
      width = 0.25,
      row = 0.50,
      col = 0.50,
    },
  }, opts))
end

local select_lsp = function()
  local lsp_kinds = { "all" }
  for key, icon in pairs(RUtils.config.icons.kinds) do
    table.insert(lsp_kinds, icon .. " " .. key)
  end
  return lsp_kinds
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

local __stripBeforeLastOccurrenceOf = function(str, sep)
  local idx = __lastIndexOf(str, sep) or 0
  return str:sub(idx + 1), idx
end

function M.layout_pojokan(opts)
  local lines = vim.api.nvim_get_option_value("lines", { scope = "global" })
  local win_height = math.ceil(lines * 0.5)
  return dropdown(vim.tbl_deep_extend("force", {
    winopts = {

      width = math.floor(math.min(60, vim.o.columns / 2)),
      height = win_height - 10,
      col = 0.85,
      row = 0.70,
    },
  }, opts))
end

function M.padding_prompt(is_expand)
  is_expand = is_expand or false
  local padding = "  "

  if is_expand then
    return padding .. " "
  end

  return padding
end

function M.format_title(str, icon, icon_hl)
  return {
    { " ", "FzfLuaTitle" },
    { (icon and icon .. " " or ""), icon_hl or "FzfLuaTitle" },
    { str, "FzfLuaTitle" },
    { " ", "FzfLuaTitle" },
  }
end

function M.open_cursor_dropdown(opts)
  local height = vim.o.lines - vim.o.cmdheight
  if vim.o.laststatus ~= 0 then
    height = height - 1
  end

  return dropdown(vim.tbl_deep_extend("force", {
    winopts = {
      width = math.floor(vim.o.columns / 2 + 8),
      height = math.floor(height / 2 - 5),
      col = 0.3,
      relative = "cursor",
    },
  }, opts))
end

function M.open_dock_bottom(opts)
  -- local lines = vim.api.nvim_get_option_value("lines", { scope = "local" })
  -- local columns = vim.api.nvim_get_option_value("columns", { scope = "local" })
  -- local win_height = math.ceil(lines * 0.5)
  -- local win_width = math.ceil(columns * 1)

  return dropdown(vim.tbl_deep_extend("force", {
    winopts = {
      fullscreen = false,
      width = 1,
      height = 0.55,
      row = 1,
      col = 0.50,
      preview = {
        hidden = false,
        layout = vertical,
        vertical = "right:50%",
      },
    },
  }, opts))
end

function M.open_center_big(opts)
  return dropdown(vim.tbl_deep_extend("force", {
    winopts = {
      title_pos = "center",
      width = 0.90,
      height = 0.90,
      row = 0.50,
      col = 0.50,
      fullscreen = false,
      preview = {
        hidden = false,
        layout = "horizontal",
        vertical = "down:50%",
        horizontal = "up:45%",
      },
    },
  }, opts))
end

function M.open_center_big_diagnostics(opts)
  return M.open_center_big(vim.tbl_deep_extend("force", {
    winopts = {
      preview = {
        horizontal = "up:60%",
      },
    },
  }, opts))
end

function M.open_center_big_vertical(opts)
  return M.open_center_big(vim.tbl_deep_extend("force", {
    winopts = {
      preview = {
        hidden = false,
        layout = "vertical",
        vertical = "right:50%",
        horizontal = "up:520",
      },
    },
  }, opts))
end

function M.open_center_medium(opts)
  return dropdown(vim.tbl_deep_extend("force", {
    winopts = {
      fullscreen = false,
      width = 0.6,
      height = 0.5,
      row = 0.5,
      col = 0.5,
      preview = { hidden = true },
    },
  }, opts))
end

function M.open_center_small_wide(opts)
  return M.open_center_medium(vim.tbl_deep_extend("force", {
    winopts = {
      height = 0.4,
      width = 0.8,
      preview = { hidden = false },
    },
  }, opts))
end

function M.open_fullscreen_vertical(opts)
  return M.open_center_big(vim.tbl_deep_extend("force", {
    winopts = {
      fullscreen = true,
      preview = {
        hidden = false,
        layout = "vertical",
        vertical = "up:60%",
        horizontal = "up:25%",
      },
    },
  }, opts))
end

function M.open_lsp_references(opts)
  return dropdown(vim.tbl_deep_extend("force", {
    winopts = {
      height = 0.70,
      width = 0.95,
      row = 0.50,
      col = 0.50,
      fullscreen = false,
      title_pos = "center",
      border = { "", "━", "", "", "", "━", "", "" },
      preview = {
        border = { "", "━", "", "", "", "━", "", "" },
        hidden = false,
        layout = "horizontal",
        vertical = "down:45%",
        horizontal = "left:55%",
      },
    },
  }, opts))
end

function M.open_lsp_code_action(opts)
  return dropdown(vim.tbl_deep_extend("force", {
    winopts = {
      relative = "cursor",
      width = 0.40,
      height = 0.30,
      row = 1,
      col = 2,
    },
  }, opts))
end

function M.open_cmd_bulk(opts, opts_cmds)
  local cmds = {}
  for idx, _ in pairs(opts) do
    table.insert(cmds, idx)
  end

  table.sort(cmds)

  fzf_lua().fzf_exec(
    cmds,
    M.layout_pojokan(vim.tbl_deep_extend("force", {
      winopts = { title = opts_cmds.title and opts_cmds.title or "" },
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

function M.open_cmd_filter_kind_lsp(opts)
  opts = opts or {}
  vim.validate {
    tilte = { opts.title, "string" },
    actions = { opts.actions, "table" },
  }

  local selected_lsp = select_lsp()

  fzf_lua().fzf_exec(
    selected_lsp,
    layout_center(vim.tbl_deep_extend("force", {
      no_esc = true,
      fzf_opts = { ["--layout"] = "reverse" },
      winopts = { title = M.format_title(string.format("%s Filter", opts.title), "󰈙") },
      actions = opts.actions,
    }, opts))
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
                cb(fzf_lua().make_entry.file(file, {}), function()
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

    fzf_lua().fzf_exec(contents, fzf_opts)
  end
end

function M.__strip_str(selected)
  local pth = M.strip_ansi_coloring(selected)
  if pth == nil then
    return
  end
  return __stripBeforeLastOccurrenceOf(pth, nbsp)
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
