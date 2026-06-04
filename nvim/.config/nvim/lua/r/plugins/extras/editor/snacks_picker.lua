---@type LazyPicker
local picker = {
  name = "snacks",
  commands = {
    files = "files",
    live_grep = "grep",
    oldfiles = "recent",
  },

  ---@param source string
  ---@param opts? snacks.picker.Config
  open = function(source, opts)
    return Snacks.picker.pick(source, opts)
  end,
}
if not RUtils.pick.register(picker) then
  return {}
end

-- local qfbookmark

-- local function get_qfbookmark()
--   if not qfbookmark then
--     local ok, qfbook = pcall(require, "qfbookmark.qf")
--     if ok then
--       qfbookmark = qfbook
--     end
--   end
--   return qfbookmark
-- end
--
-- local function jump_scope(scope, opts)
--   local buf = vim.api.nvim_get_current_buf()
--   local max_line = vim.api.nvim_buf_line_count(buf)
--
--   while scope do
--     local line = opts.bottom and scope.to or scope.from
--
--     if line >= 1 and line <= max_line then
--       local line_text = vim.api.nvim_buf_get_lines(buf, line - 1, line, false)[1] or ""
--       local indent = vim.fn.indent(line)
--
--       local col = math.min(indent, #line_text)
--
--       local current = vim.api.nvim_win_get_cursor(0)
--       local target = { line, col }
--
--       if not vim.deep_equal(current, target) then
--         vim.api.nvim_win_set_cursor(0, target)
--         return
--       end
--     end
--
--     scope = scope:parent()
--   end
-- end

return {
  {
    "folke/snacks.nvim",
    opts = {
      picker = {
        layout = "ivy",
        hidden = "true",
        win = {
          input = {
            keys = {
              ["<a-c>"] = { "toggle_cwd", mode = { "n", "i" } },
              ["<c-o>"] = { "toggle_hidden", mode = { "i", "n" } },
              ["<F5>"] = { "toggle_preview", mode = { "i", "n" } },
              ["<F4>"] = { "cycle_win", mode = { "i", "n" } },
              ["<F3>"] = { "toggle_maximize", mode = { "i", "n" } },

              ["<c-d>"] = { "preview_scroll_down", mode = { "i", "n" } },
              ["<c-u>"] = { "preview_scroll_up", mode = { "i", "n" } },
              ["<a-q>"] = { "qflist", mode = { "i", "n" } },
            },
          },
          list = {
            keys = {
              ["<F4>"] = "cycle_win",
              ["<F3>"] = "toggle_maximize",

              ["<c-d>"] = { "preview_scroll_down", mode = { "i", "n" } },
              ["<c-u>"] = { "preview_scroll_up", mode = { "i", "n" } },
            },
          },
          preview = {
            keys = {
              ["<F4>"] = "cycle_win",
            },
          },
        },
        sources = {
          files = {
            finder = "files",
            format = "file",
            show_empty = true,
            hidden = true,
            ignored = false,
            follow = false,
            supports_live = true,
          },
          command_history = { layout = { preset = "ivy" } },
          smart = {
            layout = {
              preset = "ivy",
            },
          },
          grep = {
            layout = {
              layout = {
                box = "vertical",
                width = 0.85,
                min_width = 0.6,
                height = 0.85,
                -- border = "rounded",
                { win = "preview", title = "{preview}", border = "rounded" },
                {
                  { win = "input", height = 1, border = "bottom" },
                  box = "vertical",
                  border = "rounded",
                  title = "{title} {live} {flags}",
                  { win = "list", border = "none" },
                },
              },
            },
          },
        },
      },
    },
    keys = {
      {
        "<Localleader>ss",
        function()
          Snacks.picker.smart()
        end,
        desc = "Snackspicker: smart",
      },
      { "<Localleader>sf", RUtils.pick "files", desc = "Snackspicker: find files (root Dir)" },
      {
        "<Localleader>sN",
        function()
          Snacks.win {
            file = vim.api.nvim_get_runtime_file("doc/news.txt", false)[1],
            width = 0.6,
            height = 0.6,
            wo = {
              spell = false,
              wrap = false,
              signcolumn = "yes",
              statuscolumn = " ",
              conceallevel = 3,
            },
          }
        end,
        desc = "Snackspicker: neovim news [snackspicker]",
      },

      { "<Localleader>sg", RUtils.pick "grep", desc = "Snackspicker: grep (root dir)" },
      {
        "<Localleader>sw",
        RUtils.pick "grep_word",
        desc = "Snackspicker: visual selection or word (root dir)",
        mode = { "n", "x" },
      },
      {
        "<Localleader>sW",
        RUtils.pick("grep_word", { root = false }),
        desc = "Snackspicker: visual selection or word (cwd) [snackspicker]",
        mode = { "n", "x" },
      },
      {
        "<Leader>ii",
        function()
          Snacks.picker.icons()
        end,
        desc = "Picker: icons [snackspicker]",
      },
      {
        "<Localleader>sl",
        function()
          Snacks.picker.resume()
        end,
        desc = "Snackspicker: resume",
      },
      {
        "<Localleader>sc",
        function()
          Snacks.picker.colorschemes()
        end,
        desc = "Snackspicker: colorschemes [snackspicker]",
      },

      -- LSP
      --  +----------------------------------------------------------+
      --  Jump to Word References
      --  +----------------------------------------------------------+
      {
        "<c-n>",
        function()
          local ok, _ = pcall(vim.fn.HiList)
          if ok then
            local hilist = vim.fn.HiList()
            if hilist and #hilist > 0 then
              return vim.cmd "Hi}"
            end
          end

          if vim.g.snacks_jump_scope then
            Snacks.words.jump(vim.v.count1, true)
            return
          end

          if vim.wo.diff then
            vim.cmd.normal { "]c", bang = true }
          else
            local gs = package.loaded.gitsigns
            vim.schedule(function()
              gs.nav_hunk("next", { navigation_message = false, foldopen = true })
            end)
          end
        end,
        desc = "LSP: next -> snack scope, mark, githunk, highlighter",
      },
      {
        "<c-p>",
        function()
          local ok, _ = pcall(vim.fn.HiList)
          if ok then
            local hilist = vim.fn.HiList()
            if hilist and #hilist > 0 then
              return vim.cmd "Hi{"
            end
          end

          if vim.g.snacks_jump_scope then
            Snacks.words.jump(-vim.v.count1, true)
            return
          end

          if vim.wo.diff then
            vim.cmd.normal { "[c", bang = true }
          else
            local gs = package.loaded.gitsigns
            vim.schedule(function()
              gs.nav_hunk("prev", { navigation_message = false, foldopen = true })
            end)
          end
        end,
        desc = "LSP: prev -> snack scope, mark, githunk, highlighter",
      },
    },
  },

  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        ["*"] = {
        -- stylua: ignore
        keys = {
          { "<Leader>li", function() Snacks.picker.lsp_incoming_calls() end, desc = "LSP: incoming calls [Snacks]", has = "callHierarchy/incomingCalls" },
          { "<Leader>lo", function() Snacks.picker.lsp_outgoing_calls() end, desc = "LSP: outgoing calls [Snacks]", has = "callHierarchy/outgoingCalls" },
        },
        },
      },
    },
  },
}
