local Plugin = require "lazy.core.plugin"
local fmt, cmd = string.format, vim.cmd

local L = vim.log.levels

local Highlight = require "r.settings.highlights"

---@class r.utils.plugin
local M = {}

M.lazy_file_events = { "BufReadPost", "BufNewFile", "BufWritePre" }

---@type table<string, string>
M.deprecated_extras = {
  ["r.plugins.extras.formatting.conform"] = "`conform.nvim` is now the default **LazyVim** formatter.",
  ["r.plugins.extras.linting.nvim-lint"] = "`nvim-lint` is now the default **LazyVim** linter.",
  ["r.plugins.extras.ui.dashboard"] = "`dashboard.nvim` is now the default **LazyVim** starter.",
}

M.deprecated_modules = {
  ["nvim-navic.lib"] = "editor.navic",
  ["nvim-navic"] = "editor.navic",
}

---@type table<string, string>
M.renames = {
  ["windwp/nvim-spectre"] = "nvim-pack/nvim-spectre",
  ["romgrk/nvim-treesitter-context"] = "nvim-treesitter/nvim-treesitter-context",
  ["glepnir/dashboard-nvim"] = "nvimdev/dashboard-nvim",
}

function M.save_core()
  if vim.v.vim_did_enter == 1 then
    return
  end
  M.core_imports = vim.deepcopy(require("lazy.core.config").spec.modules)
end

function M.setup()
  M.fix_imports()
  M.fix_renames()
  M.lazy_file()
  ---@diagnostic disable-next-line: deprecated
  table.insert(package.loaders, function(module)
    if M.deprecated_modules[module] then
      RUtils.warn(
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
  -- This autocmd will only trigger when a file was loaded from the cmdline.
  -- It will render the file as quickly as possible.
  vim.api.nvim_create_autocmd("BufReadPost", {
    once = true,
    callback = function(event)
      -- Skip if we already entered vim
      if vim.v.vim_did_enter == 1 then
        return
      end

      -- Try to guess the filetype (may change later on during Neovim startup)
      local ft = vim.filetype.match { buf = event.buf }
      if ft then
        -- Add treesitter highlights and fallback to syntax
        local lang = vim.treesitter.language.get_lang(ft)
        if not (lang and pcall(vim.treesitter.start, event.buf, lang)) then
          vim.bo[event.buf].syntax = ft
        end

        -- Trigger early redraw
        vim.cmd [[redraw]]
      end
    end,
  })

  -- Add support for the LazyFile event
  local Event = require "lazy.core.handler.event"

  Event.mappings.LazyFile = { id = "LazyFile", event = M.lazy_file_events }
  Event.mappings["User LazyFile"] = Event.mappings.LazyFile
end

function M.fix_imports()
  Plugin.Spec.import = RUtils.inject.args(Plugin.Spec.import, function(_, spec)
    local dep = M.deprecated_extras[spec and spec.import]
    if dep then
      dep = dep .. "\n" .. "Please remove the extra to hide this warning."
      RUtils.warn(dep, { title = "LazyVim", once = true, stacktrace = true, stacklevel = 6 })
      return false
    end
  end)
end

function M.fix_renames()
  Plugin.Spec.add = RUtils.inject.args(Plugin.Spec.add, function(self, plugin)
    if type(plugin) == "table" then
      if M.renames[plugin[1]] then
        RUtils.warn(
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
      cmd(":edit " .. ft_snippet_path .. choice .. ".json")
    end
  end)
end

function M.change_colors()
  local master_colors = fmt(
    [[
! -----------------------------
! -----------------------------

! State Mode color: fg, bg
*color16: %s
*color17: %s

-- BORDER/SEPARATOR/STATUSLINE: statusline fg, fg_nc,
*color18: %s
*color19: %s

! TMUX: Bg active, Bg_nc
*color20: %s
*color21: %s

! FZF: bg, fg and match
*color22: %s
*color23: %s
*color24: %s

! FZF selection: bg, fg, match
*color25: %s
*color26: %s
*color27: %s

! FZF Border
*color28: %s
]],
    -- State Mode Color
    Highlight.tint(Highlight.get("Keyword", "fg"), -0.2), -- 16
    Highlight.get("WinSeparator", "fg"), -- 17

    -- BORDER/SEPARATOR/STATUSLINE: statusline fg, fg_nc,
    Highlight.tint(Highlight.get("WinSeparator", "fg"), 0.8), -- 18
    Highlight.tint(Highlight.get("WinSeparator", "fg"), -0.1), -- 19

    -- TMUX: Bg_active, Bg_nc
    Highlight.get("Normal", "bg"), -- 20
    Highlight.get("Normal", "bg"), -- 21

    -- FZF: bg, fg dan match
    Highlight.get("NormalFloat", "bg"), -- 22
    Highlight.get("CmpItemAbbr", "fg"), -- 23
    Highlight.get("CmpItemAbbrMatch", "fg"), --24

    -- FZF selection: bg, fg
    Highlight.get("FzfLuaSel", "bg"), -- 25
    Highlight.get("CmpItemAbbr", "fg"), -- 26
    Highlight.get("CmpItemAbbrMatchFuzzy", "fg"), --27

    -- FZF: border
    Highlight.get("FzfLuaBorder", "fg") -- 28
  )

  local master_color_path = "/tmp/master-colors-themes"

  if RUtils.file.is_file(master_color_path) then
    vim.fn.system(fmt("rm %s", master_color_path))
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
