---@class r.utils.todocomments
local M = {}

local tbl_dat_note = {}

if not RUtils.has "fzf-lua" then
  RUtils.warn("fzf-lua not found", { Title = "Todocomments" })
  return
end

local builtin = require "fzf-lua.previewer.builtin"
local Todopreviewer = builtin.buffer_or_file:extend()

local function get_extracted_entry(entry)
  if not entry then
    return {}
  end

  local entry_str_split = vim.split(entry, "|")
  local str__ = vim.split(entry_str_split[1], ":")

  local text = RUtils.fzflua.__strip_str(entry_str_split[2])
  local basename = RUtils.fzflua.__strip_str(str__[1])
  local lnum = RUtils.fzflua.__strip_str(str__[2])

  return { text = text, basename = basename, lnum = tonumber(lnum) }
end

local function open_with(mode, tbl_cts, sel, is_open_folded)
  vim.validate { mode = { mode, "string" } }
  is_open_folded = is_open_folded or false
  if not sel then
    return
  end

  for _, x in pairs(tbl_cts) do
    local data_sel = get_extracted_entry(sel)
    if x.text == data_sel.text and x.basename == data_sel.basename and x.lnum == data_sel.lnum then
      vim.cmd(mode .. " " .. x.filename)
      if is_open_folded then
        RUtils.map.feedkey("zO", "n")
      end
      vim.api.nvim_win_set_cursor(0, { tonumber(x.lnum), 1 })
    end
  end
end

local function load_item_todos(selected, tbl_cts)
  local items = {}

  if #selected > 1 then
    for _, sel in pairs(selected) do
      for _, x in pairs(tbl_cts) do
        local data_sel = get_extracted_entry(sel)
        if x.text == data_sel.text and x.basename == data_sel.basename and x.lnum == data_sel.lnum then
          items[#items + 1] = {
            filename = x.filename,
            lnum = x.lnum,
            col = x.col,
            text = x.text,
          }
        end
      end
    end
  end

  if #selected == 1 then
    local sel = selected[1]
    for _, x in pairs(tbl_cts) do
      local data_sel = get_extracted_entry(sel)
      if x.text == data_sel.text and x.basename == data_sel.basename and x.lnum == data_sel.lnum then
        items[#items + 1] = {
          filename = x.filename,
          lnum = x.lnum,
          col = x.col,
          text = x.text,
        }
      end
    end
  end

  if #items > 0 then
    return items
  end
end

local function picker(contents, tbl_cts, fzf_opts, is_open_folded)
  vim.validate {
    contents = { contents, "function" },
    fzf_opts = { fzf_opts, "table" },
    tbl_cts = { tbl_cts, "table" },
  }

  function Todopreviewer:new(o, opts, fzf_win)
    Todopreviewer.super.new(self, o, opts, fzf_win)
    setmetatable(self, Todopreviewer)
    return self
  end

  function Todopreviewer:gen_winopts()
    local winopts = {
      wrap = self.win.preview_wrap,
      -- cursorline = false,
      number = false,
    }
    return vim.tbl_extend("keep", winopts, self.winopts)
  end

  function Todopreviewer:parse_entry(entry_str)
    local data

    local extracted_entry = get_extracted_entry(entry_str)

    for _, x in pairs(tbl_cts) do
      if
        x.text == extracted_entry.text
        and x.basename == extracted_entry.basename
        and x.lnum == extracted_entry.lnum
      then
        data = {
          path = x.filename,
          line = x.lnum,
          col = x.col,
        }
      end
    end

    if data then
      return data
    end
    return {}
  end

  require("fzf-lua").fzf_exec(
    contents,
    RUtils.fzflua.open_center_big {
      previewer = {
        _ctor = function()
          return Todopreviewer
        end,
      },
      winopts = {
        title = RUtils.fzflua.format_title(
          "Todocomments > " .. fzf_opts.title,
          RUtils.cmd.strip_whitespace(RUtils.config.icons.misc.check_big)
        ),
      },
      prompt = RUtils.fzflua.padding_prompt(),
      actions = {
        ["default"] = function(selected, _)
          if not selected then
            return
          end
          open_with("edit", tbl_cts, selected[1], is_open_folded)
        end,

        ["ctrl-v"] = function(selected, _)
          if not selected then
            return
          end
          open_with("vsplit", tbl_cts, selected[1], is_open_folded)
        end,

        ["ctrl-s"] = function(selected, _)
          if not selected then
            return
          end
          open_with("split", tbl_cts, selected[1], is_open_folded)
        end,

        ["ctrl-t"] = function(selected, _)
          if not selected then
            return
          end
          open_with("tabnew", tbl_cts, selected[1], is_open_folded)
        end,

        ["alt-v"] = function(selected, _)
          if not selected then
            return
          end

          local items = load_item_todos(selected, tbl_cts)
          if not items then
            return
          end

          RUtils.qf.save_to_qf_and_auto_open_qf(items, "TODO Comments Note", true)
        end,
        ["alt-V"] = {
          prefix = "toggle-all",
          fn = function(selected, _)
            if not selected then
              return
            end

            local items = load_item_todos(selected, tbl_cts)
            if not items then
              return
            end

            RUtils.qf.save_to_qf_and_auto_open_qf(items, "TODO Comments Note All", true)
          end,
        },

        ["alt-q"] = function(selected, _)
          if not selected then
            return
          end

          local items = load_item_todos(selected, tbl_cts)
          if not items then
            return
          end

          RUtils.qf.save_to_qf_and_auto_open_qf(items, "TODO Comments Note")
        end,
        ["alt-Q"] = {
          prefix = "toggle-all",
          fn = function(selected, _)
            if not selected then
              return
            end

            local items = load_item_todos(selected, tbl_cts)
            if not items then
              return
            end

            RUtils.qf.save_to_qf_and_auto_open_qf(items, "TODO Comments Note All")
          end,
        },
      },
    }
  )
end

local function todocomments(path, is_global, is_note)
  vim.validate { path = { path, "string" } }
  is_note = is_note or false
  is_global = is_global or false

  return function()
    local Search = require "todo-comments.search"
    local opts_todo_comments = RUtils.opts "todo-comments.nvim"
    if is_note then
      opts_todo_comments.search.args[#opts_todo_comments.search.args + 1] = "--type=md"
    end
    require("todo-comments").setup(opts_todo_comments)

    local contents = function(cb)
      Search.search(function(results)
        for _, item in pairs(results) do
          local pathtodo = RUtils.file.basename(item.filename)
          item.basename = pathtodo
          tbl_dat_note[#tbl_dat_note + 1] = item
        end

        local width_entry = 1

        for _, item in pairs(tbl_dat_note) do
          local len_basename = #item.basename + 1 + #tostring(item.lnum)
          if len_basename > width_entry then
            width_entry = len_basename
          end
        end

        for _, item in pairs(tbl_dat_note) do
          cb(
            require("fzf-lua").make_entry.file(
              item.basename
                .. ":"
                .. item.lnum
                .. (" "):rep((width_entry + 1) - (#item.basename + 1 + #tostring(item.lnum)))
                .. "|"
                .. item.text,
              {}
            ),
            function() end
          )
        end
      end, { cwd = path })
    end
    return contents
  end
end

function M.search_global(opts)
  opts = opts or {}
  tbl_dat_note = {}
  local cts = todocomments(vim.uv.cwd(), true)
  picker(cts(), tbl_dat_note, opts, true)
end

function M.search_global_note(opts)
  opts = opts or {}
  tbl_dat_note = {}
  local cts = todocomments(RUtils.config.path.wiki_path, true, true)
  picker(cts(), tbl_dat_note, opts, true)
end

function M.search_local(opts)
  opts = opts or {}
  tbl_dat_note = {}
  local cts = todocomments(vim.fn.fnameescape(vim.fn.expand "%:p"))
  picker(cts(), tbl_dat_note, opts, true)
end

return M
