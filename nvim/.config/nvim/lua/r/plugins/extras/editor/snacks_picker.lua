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

local qfbookmark

local function get_qfbookmark()
  if not qfbookmark then
    local ok, qfbook = pcall(require, "qfbookmark.qf")
    if ok then
      qfbookmark = qfbook
    end
  end
  return qfbookmark
end

local function jump_scope(scope, opts)
  local buf = vim.api.nvim_get_current_buf()
  local max_line = vim.api.nvim_buf_line_count(buf)

  while scope do
    local line = opts.bottom and scope.to or scope.from

    if line >= 1 and line <= max_line then
      local line_text = vim.api.nvim_buf_get_lines(buf, line - 1, line, false)[1] or ""
      local indent = vim.fn.indent(line)

      local col = math.min(indent, #line_text)

      local current = vim.api.nvim_win_get_cursor(0)
      local target = { line, col }

      if not vim.deep_equal(current, target) then
        vim.api.nvim_win_set_cursor(0, target)
        return
      end
    end

    scope = scope:parent()
  end
end

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
        -- actions = {
        --   ---@param p snacks.Picker
        --   toggle_cwd = function(p)
        --     local root = LazyVim.root { buf = p.input.filter.current_buf, normalize = true }
        --     local cwd = vim.fs.normalize((vim.uv or vim.loop).cwd() or ".")
        --     local current = p:cwd()
        --     p:set_cwd(current == root and cwd or root)
        --     p:find()
        --   end,
        -- },
        sources = {
          -- { "git_files", "git_files", "Git Files (Root Dir)" },
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
              -- layout = {
              --   box = "vertical",
              --   width = 0.50,
              --   min_width = 0.9,
              --   height = 0.50,
              --   -- border = "rounded",
              --   { win = "preview", title = "{preview}", border = "rounded" },
              --   {
              --     { win = "input", height = 1, border = "bottom" },
              --     box = "vertical",
              --     border = "rounded",
              --     title = "{title} {live} {flags}",
              --     { win = "list", border = "none" },
              --   },
              -- },
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
      -- { "<Leader>ff", LazyVim.pick("files"), desc = "Snackspicker: find files (root dir)" },
      -- { "<Leader>fF", LazyVim.pick("files", { root = false }), desc = "Snackspicker: find files (cwd)" },
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

      -- Buffers
      -- {
      --   "<Leader>sb",
      --   function()
      --     Snacks.picker.lines()
      --   end,
      --   desc = "Buffer: live grep current buffer [snackspicker]",
      -- },
      -- {
      --   "<Leader>sB",
      --   function()
      --     Snacks.picker.grep_buffers()
      --   end,
      --   desc = "Buffer: live grep across buffers [snackspicker]",
      -- },
      -- {
      --   "<Leader>bb",
      --   function()
      --     Snacks.picker.buffers { layout = "select" }
      --   end,
      --   desc = "Buffer: show buffers [snackspicker]",
      -- },
      -- { "<Leader>bF", function() Snacks.picker.buffers { hidden = true, nofile = true } end, desc = "Buffer: buffers (all) [snackspicker]", },
      -- { "<Leader>fO", RUtils.pick.config_files(), desc = "Snackspicker: find config File" },
      -- { "<Leader>fo", function() Snacks.picker.recent { filter = { cwd = false } } end, desc = "Snackspicker: recent (cwd)", },
      -- { "<Leader>fp", function() Snacks.picker.projects() end, desc = "Picker: projects [snackspicker]", },
      -- Git
      -- { "<Leader>gc", function() Snacks.picker.git_log() end, desc = "Git: git log [snackspicker]", },
      -- { "<Leader>gd", function() Snacks.picker.git_diff() end, desc = "Git: git diff (hunks) [snackspicker]", },
      -- { "<Leader>gs", function() Snacks.picker.git_status() end, desc = "Git: git status [snackspicker]", },
      -- Grep
      -- { "<Leader>fg", function() Snacks.picker.grep { hidden = true, layout = "ivy" } end, desc = "Snackspicker: grep open buffers", },
      { "<Localleader>sg", RUtils.pick "grep", desc = "Snackspicker: grep (root dir)" },
      -- { "<Leader>fg", function() Snacks.picker.live_grep({ hidden = true, }) end, desc = "Snackspicker: grep open buffers", },
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
      -- Search
      -- { '<Leader>s"', function() Snacks.picker.registers() end, desc = "Snackspicker: registers", },
      -- { "<Leader>sa", function() Snacks.picker.autocmds() end, desc = "Snackspicker: autocmds", },
      -- { "<Leader>fc", function() Snacks.picker.command_history() end, desc = "Snackspicker: command history", },
      -- { "<Leader><space>", LazyVim.pick("files"), desc = "Snackspicker: find files (root dir)" },
      -- { "<Leader>sp", function() Snacks.picker.lazy() end, desc = "Snackspicker: search for plugin spec", },
      -- { "<Leader>sC", function() Snacks.picker.commands() end, desc = "Snackspicker: commands", },
      -- { "<Leader>fd", function() Snacks.picker.diagnostics() end, desc = "Snackspicker: diagnostics", },
      -- { "<Leader>fH", function() Snacks.picker.help() end, desc = "Snackspicker: help pages", },
      -- { "<Leader>sH", function() Snacks.picker.highlights() end, desc = "Snackspicker: highlights", },
      {
        "<Leader>ii",
        function()
          Snacks.picker.icons()
        end,
        desc = "Picker: icons [snackspicker]",
      },
      -- { "<Leader>sj", function() Snacks.picker.jumps() end, desc = "Snackspicker: jumps", },
      -- {
      --   "<Leader>fk",
      --   function()
      --     Snacks.picker.keymaps {
      --       layout = {
      --         layout = {
      --           width = 0.80,
      --           height = 0.80,
      --           -- position = "bottom",
      --           box = "vertical",
      --           {
      --             win = "input",
      --             height = 1,
      --             border = "rounded",
      --             title = "{title} {live} {flags}",
      --             title_pos = "center",
      --           },
      --           { win = "list", border = "none" },
      --           { win = "preview", title = "{preview}", height = 0.50, border = "top" },
      --         },
      --       },
      --     }
      --   end,
      --   desc = "Snackspicker: keymaps",
      -- },
      -- { "<Leader>sM", function() Snacks.picker.man() end, desc = "Snackspicker: man pages", },
      -- { "<Leader>sm", function() Snacks.picker.marks() end, desc = "Snackspicker: marks", },
      {
        "<Localleader>sl",
        function()
          Snacks.picker.resume()
        end,
        desc = "Snackspicker: resume",
      },
      -- { "<Leader>sq", function() Snacks.picker.qflist() end, desc = "Snackspicker: quickfix (qf) ", },
      -- { "<Leader>fu", function() Snacks.picker.undo() end, desc = "Snackspicker: undotree [snackspicker]", },
      -- ui
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
          if vim.wo.diff then
            RUtils.warn "The current file is in diff mode. cannot continue."
            return
          end

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

          local qfbook = get_qfbookmark()
          if qfbook and qfbook.status_mark() then
            qfbook.next_mark()
            return
          end

          local opts = { bottom = true }
          Snacks.scope.get(function(scope)
            if not scope then
              return
            end
            jump_scope(scope, opts)
          end, opts)
        end,
        desc = "LSP: next snack scope, mark, word highlighter",
      },
      {
        "<c-p>",
        function()
          if vim.wo.diff then
            RUtils.warn "The current file is in diff mode. cannot continue."
            return
          end

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

          local qfbook = get_qfbookmark()
          if qfbook and qfbook.status_mark() then
            qfbook.prev_mark()
            return
          end

          local opts = { bottom = false }
          Snacks.scope.get(function(scope)
            if not scope then
              return
            end
            jump_scope(scope, opts)
          end, opts)
        end,
        desc = "LSP: prev snack scope, mark, word highlighter",
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
