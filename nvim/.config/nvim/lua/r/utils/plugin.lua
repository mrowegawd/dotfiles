local Plugin = require "lazy.core.plugin"
local fmt, cmd = string.format, vim.cmd

local L = vim.log.levels

local highlight = require "r.config.highlights"

local Util = require "r.utils"

local M = {}

M.use_lazy_file = true
M.lazy_file_events = { "BufReadPost", "BufNewFile", "BufWritePre" }

---@type table<string, string>
M.deprecated_extras = {
  ["r.plugins.extras.formatting.conform"] = "`conform.nvim` is now the default **LazyVim** formatter.",
  ["r.plugins.extras.linting.nvim-lint"] = "`nvim-lint` is now the default **LazyVim** linter.",
  ["r.plugins.extras.ui.dashboard"] = "`dashboard.nvim` is now the default **LazyVim** starter.",
}

M.deprecated_modules = {
  ["null-ls"] = "lsp.none-ls",
  ["nvim-navic.lib"] = "editor.navic",
  ["nvim-navic"] = "editor.navic",
}

---@type table<string, string>
M.renames = {
  ["windwp/nvim-spectre"] = "nvim-pack/nvim-spectre",
  ["jose-elias-alvarez/null-ls.nvim"] = "nvimtools/none-ls.nvim",
  ["null-ls.nvim"] = "none-ls.nvim",
  ["romgrk/nvim-treesitter-context"] = "nvim-treesitter/nvim-treesitter-context",
  ["glepnir/dashboard-nvim"] = "nvimdev/dashboard-nvim",
}

function M.setup()
  M.fix_imports()
  M.fix_renames()
  M.lazy_file()
  table.insert(package.loaders, function(module)
    if M.deprecated_modules[module] then
      Util.warn(
        ("`%s` is no longer included by default in **LazyVim**.\nPlease install the `%s` extra if you still want to use it."):format(
          module,
          M.deprecated_modules[module]
        ),
        { title = "LazyVim" }
      )
      return function() end
    end
  end)
end

function M.extra_idx(name)
  local Config = require "lazy.core.config"
  for i, extra in ipairs(Config.spec.modules) do
    if extra == "r.plugins.extras." .. name then
      return i
    end
  end
end

-- Properly load file based plugins without blocking the UI
function M.lazy_file()
  M.use_lazy_file = M.use_lazy_file and vim.fn.argc(-1) > 0

  -- Add support for the LazyFile event
  local Event = require "lazy.core.handler.event"

  if M.use_lazy_file then
    -- We'll handle delayed execution of events ourselves
    Event.mappings.LazyFile = { id = "LazyFile", event = "User", pattern = "LazyFile" }
    Event.mappings["User LazyFile"] = Event.mappings.LazyFile
  else
    -- Don't delay execution of LazyFile events, but let lazy know about the mapping
    Event.mappings.LazyFile = { id = "LazyFile", event = { "BufReadPost", "BufNewFile", "BufWritePre" } }
    Event.mappings["User LazyFile"] = Event.mappings.LazyFile
    return
  end

  local events = {} ---@type {event: string, buf: number, data?: any}[]

  local done = false
  local function load()
    if #events == 0 or done then
      return
    end
    done = true
    vim.api.nvim_del_augroup_by_name "lazy_file"

    ---@type table<string,string[]>
    local skips = {}
    for _, event in ipairs(events) do
      skips[event.event] = skips[event.event] or Event.get_augroups(event.event)
    end

    vim.api.nvim_exec_autocmds("User", { pattern = "LazyFile", modeline = false })
    for _, event in ipairs(events) do
      Event.trigger {
        event = event.event,
        exclude = skips[event.event],
        data = event.data,
        buf = event.buf,
      }
      if vim.bo[event.buf].filetype then
        Event.trigger {
          event = "FileType",
          buf = event.buf,
        }
      end
    end
    vim.api.nvim_exec_autocmds("CursorMoved", { modeline = false })
    events = {}
  end

  -- schedule wrap so that nested autocmds are executed
  -- and the UI can continue rendering without blocking
  load = vim.schedule_wrap(load)

  vim.api.nvim_create_autocmd(M.lazy_file_events, {
    group = vim.api.nvim_create_augroup("lazy_file", { clear = true }),
    callback = function(event)
      table.insert(events, event)
      load()
    end,
  })
end

function M.fix_imports()
  Plugin.Spec.import = Util.inject.args(Plugin.Spec.import, function(_, spec)
    local dep = M.deprecated_extras[spec and spec.import]
    if dep then
      dep = dep .. "\n" .. "Please remove the extra to hide this warning."
      Util.warn(dep, { title = "LazyVim", once = true, stacktrace = true, stacklevel = 6 })
      return false
    end
  end)
end

function M.fix_renames()
  Plugin.Spec.add = Util.inject.args(Plugin.Spec.add, function(self, plugin)
    if type(plugin) == "table" then
      if M.renames[plugin[1]] then
        Util.warn(
          ("Plugin `%s` was renamed to `%s`.\nPlease update your config for `%s`"):format(
            plugin[1],
            M.renames[plugin[1]],
            self.importing or "LazyVim"
          ),
          { title = "LazyVim" }
        )
        plugin[1] = M.renames[plugin[1]]
      end
    end
  end)
end

--  ┏╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┓
--  ╏                           test                           ╏
--  ┗╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┛

--- Opens the given url in the default browser.
---@param url string: The url to open.
function M.open_in_browser(url)
  local open_cmd
  if vim.fn.executable "xdg-open" == 1 then
    open_cmd = "xdg-open"
  elseif vim.fn.executable "explorer" == 1 then
    open_cmd = "explorer"
  elseif vim.fn.executable "open" == 1 then
    open_cmd = "open"
  elseif vim.fn.executable "wslview" == 1 then
    open_cmd = "wslview"
  end

  local ret = vim.fn.jobstart({ open_cmd, url }, { detach = true })
  if ret <= 0 then
    vim.notify(
      string.format("[utils]: Failed to open '%s'\nwith command: '%s' (ret: '%d')", url, open_cmd, ret),
      vim.log.levels.ERROR,
      { title = "[tt.utils]" }
    )
  end
end

function M.EditSnippet()
  local scan = require "plenary.scandir"

  local base_snippets = { "package", "global" }

  local ft, _ = Util.buf.get_bo_buft()

  if ft == "" then
    return vim.notify("Belum dibuat??", L.WARN, { title = "No snippets" })
  elseif ft == "typescript" then
    ft = "javascript"
  elseif ft == "sh" then
    ft = "shell"
  end

  local ft_snippet_path = require("r.config").path.snippet_path .. "/snippets/"

  local snippets = {}
  local is_file = true

  if Util.file.is_dir(ft_snippet_path .. ft) then
    if not Util.file.exists(ft_snippet_path .. ft) then
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

    if not Util.file.exists(ft_snippet_path .. ft .. ".json") then
      return vim.notify(ft_snippet_path .. ft .. ".json", L.WARN, { title = "Snippet file not exists" })
    end
    if not Util.file.exists(ft_snippet_path .. ft .. ".json") then
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
      if not Util.file.exists(ft_snippet_path .. choice .. ".json") then
        return vim.notify(ft_snippet_path .. choice .. ".json", L.WARN, { title = "Snippet file not exists" })
      end
      cmd(":edit " .. ft_snippet_path .. choice .. ".json")
    end
  end)
end

function M.infoBaseColorsTheme()
  local normal = "Normal"
  local colorcolumn = "ColorColumn"
  local pmenusel = "PmenuSel"
  -- local pmenu = "Pmenu"
  local cmpitemabbr = "CmpItemAbbr"
  local cmpmatchabbr = "CmpItemAbbrMatch"
  local fzfluaborder = "FzfLuaBorder"
  local cmpmatchabbrFuzzy = "CmpItemAbbrMatchFuzzy"
  local winseparator = "WinSeparator"

  local normal_fg = "Normal color_fg: " .. highlight.get(normal, "fg")
  local normal_bg = "Normal color_bg: " .. highlight.get(normal, "bg")

  local colorcolumn_bg = "ColorColumn: " .. highlight.get(colorcolumn, "bg")

  -- fzf selection
  local fzf_selection_fg = "Fzf selection fg: " .. highlight.get(pmenusel, "fg")
  local fzf_selection_bg = "fzf selection bg: " .. highlight.get(pmenusel, "bg")

  -- fzf non selection
  local fzf_non_sel_fg = "Fzf default fg: " .. highlight.get(cmpitemabbr, "fg")

  -- fzf match matching
  local fzf_matching = "Fzf matching: " .. highlight.get(cmpmatchabbr, "fg")
  local fzf_matching_fuzzy = "Fzf matching fuzzy: " .. highlight.get(cmpmatchabbrFuzzy, "fg")

  -- fzf match matching
  local fzf_border_fg = "Fzf border fg: " .. highlight.get(fzfluaborder, "fg")

  local tmux_fg = "Tmux fg: " .. highlight.tint(highlight.get(colorcolumn, "bg"), 0.8)
  local tmux_border_fg = "Tmux border fg: " .. highlight.get(winseparator, "fg")

  print(
    fmt(
      [[
  %s
  %s

  %s

  #--- FUZZY
  %s
  %s

  %s

  %s
  %s

  %s

  %s
  %s
  ]],
      normal_fg,
      normal_bg,
      colorcolumn_bg,

      fzf_selection_bg,
      fzf_selection_fg,
      fzf_non_sel_fg,
      fzf_matching,
      fzf_matching_fuzzy,

      fzf_border_fg,

      tmux_fg,
      tmux_border_fg
    )
  )

  -- local pmenu_bg = highlight.get(pmenu, "bg")
  -- local cmpmatchabbr_fg = highlight.get(cmpmatchabbr, "fg")
  -- local cmpitemabbr_fg = highlight.get(cmpitemabbr, "fg")
  -- local cmpmatchabbrfuzzy_fg = highlight.get(cmpitemabbrmatchfuzzy, "fg")

  --   print(
  --     fmt(
  --       [[
  -- BG_ACTIVE_WINDOW (Normal) bg: %s
  -- BG_ACTIVE_WINDOW (Normal) fg: %s

  -- BACKGROUND_ACTIVE_STATUSLINE (ColorColumn) bg: %s

  -- # fzf selection
  -- FZF_BG (Pmenu) bg: %s
  -- FZF_FG (Pmenu) fg: %s
  -- FZF_BG_SELECTION (PmenuSel) bg: %s

  -- # fzf normal
  -- FZF_BG_SELECTION (PmenuSel) bg: %s

  -- FZF_BG_MATCH (CmpItemAbbrMatch) fg: %s
  -- FZF_FG_ITEM (CmpItemAbbr) fg: %s
  -- FZF_FG_ITEM_FUZZY (CmpItemAbbrMatchFuzzy) fg: %s ]],
  --       normal_bg,
  --       normal_fg,

  --       colorcolumn_bg,
  --       pmenu_bg,
  --       pmenu_fg,
  --       pmenusel_bg,
  --       cmpmatchabbr_fg,
  --       cmpitemabbr_fg,
  --       cmpmatchabbrfuzzy_fg
  --     )
  --   )
end

function M.infoFoldPreview()
  vim.cmd "options"
end

local reference = nil

function M.nui_select(opts, on_choice)
  local userChoice = function(choiceIndex)
    on_choice(choiceIndex["text"])
  end
  reference = select(opts.opts, {
    lines = opts.formatted_entries,
    on_close = function()
      reference = nil
    end,
    on_submit = function(item)
      userChoice(item)
      reference = nil
    end,
  })
  pcall(function()
    reference:mount()
    reference:on(event.BufLeave, reference.menu_props.on_close, { once = true })
  end)
end

-- local event = require("nui.utils.autocmd").event

local format_select_entries = function(entries, formatter)
  local select = require "nui.menu"

  local formatItem = formatter or tostring
  local results = {
    select.separator("", {
      char = " ",
    }),
  }
  for _, entry in pairs(entries) do
    table.insert(results, select.item(string.format("%s", formatItem(entry))))
  end
  return results
end

local calculate_select_width = function(entries, prompt)
  local result = 6
  for _, entry in pairs(entries) do
    if #entry.text + 6 > result then
      result = #entry.text + 6
    end
  end
  if #prompt ~= nil then
    if #prompt + 6 > result then
      result = #prompt + 6
    end
  end
  return result + 6
end

local concat = function(t1, t2)
  for i = 1, #t2 do
    table.insert(t1, t2[i])
  end
  return t1
end

local is_array = function(t)
  local i = 0
  for _ in pairs(t) do
    i = i + 1
    if t[i] == nil then
      return false
    end
  end
  return true
end

local merge = function(t1, t2)
  for k, v in pairs(t2) do
    if (type(v) == "table") and (type(t1[k] or false) == "table") then
      if is_array(t1[k]) then
        t1[k] = concat(t1[k], v)
      else
        merge(t1[k], t2[k])
      end
    else
      t1[k] = v
    end
  end
  return t1
end

function M.select(entries, stuff, opts)
  local text = require "nui.text"

  local formatted_entries = format_select_entries(entries, stuff.format_item)
  local default_opts = {
    relative = "editor",
    position = "50%",
    size = {
      width = calculate_select_width(formatted_entries, stuff.prompt or "Choice:"),
      height = #formatted_entries,
    },
    border = {
      highlight = "FloatBorder:Pmenu",
      style = { " ", " ", " ", " ", " ", " ", " ", " " },
      text = {
        top = text(stuff.prompt or "Choice:", "FloatBorder"),
        top_align = "center",
      },
    },
    win_options = {
      winhighlight = "Normal:Normal",
    },
  }
  opts = merge(default_opts, opts)
  return {
    opts = opts,
    formatted_entries = formatted_entries,
  }
end

return M
