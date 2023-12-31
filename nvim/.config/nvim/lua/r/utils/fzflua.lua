local M = {}

function M.rectangle_win_pojokan()
  local win_height = math.ceil(vim.api.nvim_get_option "lines" * 0.5)
  local win_width = math.ceil(vim.api.nvim_get_option "columns" * 1)
  -- local columns = vim.api.nvim_get_option "columns"

  local col = math.ceil((win_width / 2) * 1 + 20)
  local row = math.ceil((vim.api.nvim_get_option "lines" - win_height) * 1 + 5)
  return col, row
end

function M.format_title(str, icon, icon_hl)
  return {
    { " " },
    { (icon and icon .. " " or ""), icon_hl or "Boolean" },
    { str, "FzfLuaTitle" },
    { " " },
  }
end

function M.dropdown(opts)
  opts = opts or { winopts = {} }
  local title = vim.tbl_get(opts, "winopts", "title") ---@type string?
  if title and type(title) == "string" then
    opts.winopts.title = M.format_title(title)
  end
  return vim.tbl_deep_extend("force", {
    prompt = require("r.config").icons.misc.dots,
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
          opts[sel]()
        end,
      },
    }, opts_cmds))
  )
end

local function callgrep(opts, callfn)
  local fzflua = require "fzf-lua"
  opts = opts or {}

  opts.cwd_header = true

  if not opts.cwd then
    opts.cwd = vim.t.cwd or vim.uv.cwd()
  end

  opts.no_header = false
  opts.fullscreen = true
  opts.rg_opts = [[--column --hidden --line-number --no-heading --color=always --smart-case --max-columns=4096 -e]]

  opts.actions = {
    -- press ctrl-e in fzf picker to switch to rgflow.
    ["ctrl-e"] = function()
      -- bring up rgflow ui to change rg args.
      require("rgflow").open(fzflua.config.__resume_data.last_query, opts.rg_opts, opts.cwd, {
        custom_start = function(pattern, flags, path)
          opts.cwd = path
          opts.rg_opts = flags
          opts.query = pattern
          return callfn(opts)
        end,
      })
    end,
    -- ["ctrl-h"] = function()
    --   --- toggle hidden files search.
    --   opts.rg_opts = libutils.toggle_cmd_option(opts.rg_opts, "--hidden")
    --   return callfn(opts)
    -- end,
    ["ctrl-a"] = function()
      --- toggle rg_glob
      opts.rg_glob = not opts.rg_glob
      if opts.rg_glob then
        opts.prompt = opts.prompt .. "(G): "
      else
        -- remove (G): from prompt
        opts.prompt = string.gsub(opts.prompt, "%(G%): ", "")
      end
      -- usage: {search_query} --{glob pattern}
      -- hello --*.md *.js
      return callfn(opts)
    end,
  }

  return callfn(opts)
end

function M.grep(opts, is_live)
  opts = opts or {}
  if is_live == nil then
    is_live = true
  end
  local fzflua = require "fzf-lua"
  if is_live then
    opts.prompt = "󱙓  Live Grep❯ "
  else
    opts.input_prompt = "󱙓  Grep❯ "
  end
  return callgrep(opts, function(opts_local)
    if is_live then
      return fzflua.live_grep(opts_local)
    else
      return fzflua.grep(opts_local)
    end
  end)
end

return M
