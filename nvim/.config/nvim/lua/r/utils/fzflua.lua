local M = {}

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
    opts.winopts.title = M.format_title(" " .. title)
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
      row = 1,
      relative = "cursor",
      height = 0.33,
      width = widthc / (widthc + vim_width - 10),
    },
  }, opts))
end

function M.send_cmds(opts)
  opts = opts or {}

  -- local fn_cmds = {
  --   toggle_diagnostics = function()
  --     Util.toggle.diagnostics()
  --   end,
  --   toggle_codelens = function()
  --     Util.toggle.codelens()
  --   end,
  --   toggle_semantic_tokens = function()
  --     Util.toggle.semantic_tokens()
  --   end,
  --   toggle_number = function()
  --     Util.format.number()
  --   end,
  --   toggle_format_lspbuffer = function()
  --     Util.format.toggle(true)
  --   end,
  --   toggle_format_lspallbuf = function()
  --     Util.format.toggle()
  --   end,
  --   format_lspinfo = function()
  --     vim.cmd [[LazyFormatInfo]]
  --   end,
  --   format_run = function()
  --     vim.cmd [[LazyFormat]]
  --   end,
  -- }

  local cmds = {}
  for idx, _ in pairs(opts) do
    table.insert(cmds, idx)
  end

  require("fzf-lua").fzf_exec(
    cmds,
    M.cursor_dropdown {
      actions = {
        ["default"] = function(selected, _)
          local sel = selected[1]
          opts[sel]()
        end,
      },
    }
  )
end

return M
