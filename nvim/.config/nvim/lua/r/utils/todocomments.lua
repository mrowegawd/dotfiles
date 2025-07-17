---@class r.utils.todocomments
local M = {}

local tbl_dat = {}
local tbl_dat_note = {}

if not RUtils.has "fzf-lua" then
  RUtils.warn("[markdown] fzf-lua not found", { Title = "Navigations" })
  return
end

local builtin = require "fzf-lua.previewer.builtin"
local Todopreviewer = builtin.buffer_or_file:extend()

local function picker(contents, tbl_cts, fzf_opts)
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
    for _, x in pairs(tbl_cts) do
      if x.text == entry_str then
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

  require("fzf-lua").fzf_exec(contents, {
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
    prompt = RUtils.fzflua.default_title_prompt(),
    actions = {
      ["default"] = function(selected, _)
        local sel = selected[1]
        for _, x in pairs(tbl_cts) do
          if x.text == sel then
            vim.cmd("e " .. x.filename)

            RUtils.map.feedkey("zO", "n")
            vim.api.nvim_win_set_cursor(0, { tonumber(x.lnum), 1 })
          end
        end
      end,

      ["ctrl-v"] = function(selected, _)
        local sel = selected[1]
        for _, x in pairs(tbl_cts) do
          if x.text == sel then
            vim.cmd("vsplit " .. x.filename)
            RUtils.map.feedkey("zO", "n")
            vim.api.nvim_win_set_cursor(0, { tonumber(x.lnum), 1 })
          end
        end
      end,

      ["ctrl-s"] = function(selected, _)
        local sel = selected[1]
        for _, x in pairs(tbl_cts) do
          if x.text == sel then
            vim.cmd("split " .. x.filename)
            RUtils.map.feedkey("zO", "n")
            vim.api.nvim_win_set_cursor(0, { tonumber(x.lnum), 1 })
          end
        end
      end,

      ["ctrl-t"] = function(selected, _)
        local sel = selected[1]
        for _, x in pairs(tbl_cts) do
          if x.text == sel then
            vim.cmd("tabnew " .. x.filename)
            RUtils.map.feedkey("zO", "n")
            vim.api.nvim_win_set_cursor(0, { tonumber(x.lnum), 1 })
          end
        end
      end,

      ["alt-L"] = function(selected, _)
        RUtils.warn "Not implemented yet"
      end,
      ["alt-l"] = function(selected, _)
        local items = {}

        if #selected > 1 then
          for _, sel in pairs(selected) do
            for _, x in pairs(tbl_cts) do
              if x.text == sel then
                items[#items + 1] = {
                  filename = x.filename,
                  lnum = x.lnum,
                  col = x.col,
                  text = x.text,
                }
              end
            end
          end
        else
          local sel = selected[1]
          for _, x in pairs(tbl_cts) do
            if x.text == sel then
              items[#items + 1] = {
                filename = x.filename,
                lnum = x.lnum,
                col = x.col,
                text = x.text,
              }
            end
          end
        end

        vim.fn.setloclist(0, {}, " ", {
          nr = "$",
          items = items,
          title = "TODO Comments Note",
        })
        vim.cmd "lopen"
      end,

      ["alt-G"] = function()
        RUtils.warn "Not implemented yet"
      end,
      ["alt-q"] = function(selected, _)
        local items = {}

        if #selected > 1 then
          for _, sel in pairs(selected) do
            for _, x in pairs(tbl_cts) do
              if x.text == sel then
                items[#items + 1] = {
                  filename = x.filename,
                  lnum = x.lnum,
                  col = x.col,
                  text = x.text,
                }
              end
            end
          end
        else
          local sel = selected[1]
          for _, x in pairs(tbl_cts) do
            if x.text == sel then
              items[#items + 1] = {
                filename = x.filename,
                lnum = x.lnum,
                col = x.col,
                text = x.text,
              }
            end
          end
        end

        local what = {
          idx = "$",
          items = items,
          title = "TODO Comments Note",
        }

        vim.fn.setqflist({}, "r", what)
        vim.cmd "copen"
      end,
    },
  })
end

local function todo(path)
  vim.validate { path = { path, "string" } }

  return function()
    local Search = require "todo-comments.search"
    local opts_todo_comments = RUtils.opts "todo-comments.nvim"
    opts_todo_comments.search.args = {
      "--color=never",
      "--no-heading",
      "--follow",
      "--hidden",
      "--with-filename",
      "--line-number",
      "--column",
      "-g",
      "!node_modules/**",
      "-g",
      "!.git/**",
    }
    require("todo-comments").setup(opts_todo_comments)

    local contents = function(cb)
      Search.search(function(results)
        for _, item in pairs(results) do
          cb(require("fzf-lua").make_entry.file(item.text, {}), function() end)
          tbl_dat[#tbl_dat + 1] = item
        end
      end, { cwd = path })
    end
    return contents
  end
end

local function todo_note(path)
  vim.validate { path = { path, "string" } }

  return function()
    local Search = require "todo-comments.search"
    local opts_todo_comments = RUtils.opts "todo-comments.nvim"
    opts_todo_comments.search.args[#opts_todo_comments.search.args + 1] = "--type=md"
    require("todo-comments").setup(opts_todo_comments)

    local contents = function(cb)
      Search.search(function(results)
        for _, item in pairs(results) do
          cb(require("fzf-lua").make_entry.file(item.text, {}), function() end)
          tbl_dat_note[#tbl_dat_note + 1] = item
        end

        opts_todo_comments.search.args = {
          "--color=never",
          "--no-heading",
          "--follow",
          "--hidden",
          "--with-filename",
          "--line-number",
          "--column",
          "-g",
          "!node_modules/**",
          "-g",
          "!.git/**",
        }
        require("todo-comments").setup(opts_todo_comments)
      end, { cwd = path })
    end
    return contents
  end
end

function M.search_global(opts)
  opts = opts or {}
  tbl_dat = {}
  local cts = todo(vim.uv.cwd())
  picker(cts(), tbl_dat, opts)
end

function M.search_global_note(opts)
  opts = opts or {}
  tbl_dat_note = {}
  local cts = todo_note(RUtils.config.path.wiki_path)
  picker(cts(), tbl_dat_note, opts)
end

function M.search_local(opts)
  opts = opts or {}
  tbl_dat = {}

  local cts = todo(vim.fn.fnameescape(vim.fn.expand "%:p"))
  picker(cts(), tbl_dat, opts)
end

return M
