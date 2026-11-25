local api = vim.api

local lazy = require("utils.plugin").require_lazy

local UtilKey = lazy "utils.map"

local function peek_item_orgagenda()
  local Overlook_win = lazy "overlook.window"
  local current_win = vim.api.nvim_get_current_win()
  if Overlook_win.instances[current_win] then
    Overlook_win.instances[current_win] = nil
  end

  local s = lazy "org.agenda.view"
  local item = s.item_at_cursor()
  if not item then
    return
  end

  local filename = item.filename
  local bufnr = lazy("utils.cmd").get_or_create_bufnr(filename)

  lazy("overlook.window").open_popup {
    target_bufnr = bufnr,
    lnum = item.lnum,
    col = item.col or 0,
    title = vim.fn.bufname(bufnr),
  }
end

local function peek_now()
  lazy("vim-pack").load_now "overlook.nvim"
  lazy("utils.monkeypatch.overlook").setup()
  peek_item_orgagenda()
end

UtilKey.nnoremap(
  "P",
  peek_now,
  { desc = "Action: peek qf item [overlook.nvim]", buffer = api.nvim_get_current_buf(), force = true }
)
UtilKey.nnoremap(
  "K",
  peek_now,
  { desc = "Action: peek qf item [overlook.nvim]", buffer = api.nvim_get_current_buf(), force = true }
)
UtilKey.nnoremap(
  "<C-x><C-k>",
  lazy("utils.note").filter_by_tags,
  { desc = "Org: match a tag or re-match tag", buffer = api.nvim_get_current_buf(), force = true }
)
UtilKey.nnoremap("<C-x>er", function()
  lazy("utils.note").remove_repeater_todo { match = "workout|habit|homework", by_time = true }
end, { desc = "Exec: automatically close repeater TODOs", buffer = api.nvim_get_current_buf(), force = true })

local whichkey = lazy "which-key"
whichkey.add {
  { "<Localleader>aF", group = "filter/sort", buffer = api.nvim_get_current_buf() },
  { "<Localleader>as", group = "set:deadline/schedule/clock", buffer = api.nvim_get_current_buf() },
  { "<Localleader>asc", group = "set:clock", buffer = api.nvim_get_current_buf() },
  { "<Localleader>ase", group = "set:effort", buffer = api.nvim_get_current_buf() },
  { "<Localleader>asm", group = "set:timer", buffer = api.nvim_get_current_buf() },
  { "<Localleader>asp", group = "set:property", buffer = api.nvim_get_current_buf() },
  { "<Localleader>au", group = "toggle", buffer = api.nvim_get_current_buf() },
  { "<Localleader>av", group = "view", buffer = api.nvim_get_current_buf() },
  { "<Localleader>ar", group = "refile", buffer = api.nvim_get_current_buf() },
  { "<Localleader>ail", group = "links", buffer = api.nvim_get_current_buf() },
}
