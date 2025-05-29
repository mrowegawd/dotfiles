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
              ["<a-u>"] = { "toggle_hidden", mode = { "i", "n" } },
              ["<F5>"] = { "toggle_preview", mode = { "i", "n" } },
              ["<F4>"] = { "cycle_win", mode = { "i", "n" } },
              ["<F3>"] = { "toggle_maximize", mode = { "i", "n" } },

              ["<c-d>"] = { "preview_scroll_down", mode = { "i", "n" } },
              ["<c-u>"] = { "preview_scroll_up", mode = { "i", "n" } },
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
                width = 0.50,
                min_width = 0.9,
                height = 0.50,
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
    --stylua: ignore
    keys = {
      -- { "<Leader>ff", LazyVim.pick("files"), desc = "Snackspicker: find files (root dir)" },
      -- { "<Leader>fF", LazyVim.pick("files", { root = false }), desc = "Snackspicker: find files (cwd)" },
      { "<Localleader>sf", function() Snacks.picker.smart() end, desc = "Snackspicker: smart", },
      { "<Localleader>sF", RUtils.pick "files", desc = "Snackspicker: find files (root Dir)" },

      -- Buffers
      { "<Leader>bg", function() Snacks.picker.lines() end, desc = "Buffer: buffer lines [snackspicker]", },
      { "<Leader>bG", function() Snacks.picker.grep_buffers() end, desc = "Buffer: grep open buffers [snackspicker]", },
      { "<Leader>bf", function() Snacks.picker.buffers { layout = "select" } end, desc = "Buffer: buffers [snackspicker]", },
      { "<Leader>bF", function() Snacks.picker.buffers { hidden = true, nofile = true } end, desc = "Buffer: buffers (all) [snackspicker]", },
      { "<Leader>fO", RUtils.pick.config_files(), desc = "Snackspicker: find config File" },
      { "<Leader>fo", function() Snacks.picker.recent { filter = { cwd = false } } end, desc = "Snackspicker: recent (cwd)", },
      { "<Leader>fp", function() Snacks.picker.projects() end, desc = "Picker: projects [snackspicker]", },
      -- Git
      { "<Leader>gc", function() Snacks.picker.git_log() end, desc = "Git: git log [snackspicker]", },
      { "<Leader>gd", function() Snacks.picker.git_diff() end, desc = "Git: git diff (hunks) [snackspicker]", },
      { "<Leader>gs", function() Snacks.picker.git_status() end, desc = "Git: git status [snackspicker]", },
      -- Grep
      -- { "<Leader>fg", function() Snacks.picker.grep { hidden = true, layout = "ivy" } end, desc = "Snackspicker: grep open buffers", },
      { "<leader>fg", RUtils.pick "grep", desc = "Snackspicker: grep (root dir)" },
      -- { "<Leader>fg", function() Snacks.picker.live_grep({ hidden = true, }) end, desc = "Snackspicker: grep open buffers", },
      { "<Localleader>sw", RUtils.pick "grep_word", desc = "Snackspicker: visual selection or word (root dir)", mode = { "n", "x" }, },
      { "<Localleader>sW", RUtils.pick("grep_word", { root = false }), desc = "Snackspicker: visual selection or word (cwd) [snackspicker]", mode = { "n", "x" }, },
      -- Search
      -- { '<Leader>s"', function() Snacks.picker.registers() end, desc = "Snackspicker: registers", },
      -- { "<Leader>sa", function() Snacks.picker.autocmds() end, desc = "Snackspicker: autocmds", },
      { "<Leader>fc", function() Snacks.picker.command_history() end, desc = "Snackspicker: command history", },
      -- { "<Leader><space>", LazyVim.pick("files"), desc = "Snackspicker: find files (root dir)" },
      -- { "<Leader>n", function() Snacks.picker.notifications() end, desc = "Snackspicker: notification history" },
      -- { "<Leader>sp", function() Snacks.picker.lazy() end, desc = "Snackspicker: search for plugin spec", },
      -- { "<Leader>sC", function() Snacks.picker.commands() end, desc = "Snackspicker: commands", },
      -- { "<Leader>fd", function() Snacks.picker.diagnostics() end, desc = "Snackspicker: diagnostics", },
      { "<Leader>fH", function() Snacks.picker.help() end, desc = "Snackspicker: help pages", },
      -- { "<Leader>sH", function() Snacks.picker.highlights() end, desc = "Snackspicker: highlights", },
      { "<Leader>fi", function() Snacks.picker.icons() end, desc = "Picker: icons [snackspicker]", },
      -- { "<Leader>sj", function() Snacks.picker.jumps() end, desc = "Snackspicker: jumps", },
      {
        "<Leader>fk",
        function()
          Snacks.picker.keymaps {
            layout = {
              layout = {
                width = 0.80,
                height = 0.80,
                -- position = "bottom",
                box = "vertical",
                {
                  win = "input",
                  height = 1,
                  border = "rounded",
                  title = "{title} {live} {flags}",
                  title_pos = "center",
                },
                { win = "list", border = "none" },
                { win = "preview", title = "{preview}", height = 0.50, border = "top" },
              },
            },
          }
        end,
        desc = "Snackspicker: keymaps",
      },
      -- { "<Leader>sl", function() Snacks.picker.loclist() end, desc = "Snackspicker: location list", },
      -- { "<Leader>sM", function() Snacks.picker.man() end, desc = "Snackspicker: man pages", },
      -- { "<Leader>sm", function() Snacks.picker.marks() end, desc = "Snackspicker: marks", },
      { "<Localleader>sL", function() Snacks.picker.resume() end, desc = "Snackspicker: resume", },
      -- { "<Leader>sq", function() Snacks.picker.qflist() end, desc = "Snackspicker: Quickfix List", },
      { "<Localleader>su", function() Snacks.picker.undo() end, desc = "Snackspicker: undotree [snackspicker]", },
      -- ui
      { "<Localleader>sc", function() Snacks.picker.colorschemes() end, desc = "Snackspicker: colorschemes [snackspicker]", },

      -- LSP
      { "gs", function() Snacks.picker.lsp_symbols({ filter=RUtils.config.icons.kinds }) end, desc = "LSP Symbols" },
      { "gS", function() Snacks.picker.lsp_workspace_symbols({ filter=RUtils.config.icons.kinds }) end, desc = "LSP Workspace Symbols" },
    },
  },
}
