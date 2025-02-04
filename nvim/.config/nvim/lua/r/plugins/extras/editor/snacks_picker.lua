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
              ["<a-c>"] = {
                "toggle_cwd",
                mode = { "n", "i" },
              },
            },
          },
        },
        actions = {
          ---@param p snacks.Picker
          -- toggle_cwd = function(p)
          --   local root = LazyVim.root { buf = p.input.filter.current_buf, normalize = true }
          --   local cwd = vim.fs.normalize((vim.uv or vim.loop).cwd() or ".")
          --   local current = p:cwd()
          --   p:set_cwd(current == root and cwd or root)
          --   p:find()
          -- end,
        },
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
          smart = { layout = { preset = "ivy" } },
          grep = { layout = { preset = "ivy_split" } },
        },
      },
    },
    -- stylua: ignore
    keys = {
      { "<leader>,", function() Snacks.picker.buffers() end, desc = "Buffers", },
      { "<leader>ff", function() Snacks.picker.smart() end, desc = "Files", },
      { "<leader>fF", RUtils.pick("files"), desc = "Find Files (Root Dir)" },

      -- { "<leader>/", LazyVim.pick("grep"), desc = "Grep (Root Dir)" },
      -- { "<leader><space>", LazyVim.pick("files"), desc = "Find Files (Root Dir)" },
      -- { "<leader>n", function() Snacks.picker.notifications() end, desc = "Notification History" },
      -- Buffers
      { "<leader>bg", function() Snacks.picker.lines() end, desc = "Buffer Lines", },
      { "<leader>bG", function() Snacks.picker.grep_buffers() end, desc = "Grep Open Buffers", },
      { "<leader>bf", function() Snacks.picker.buffers { layout = "select" } end, desc = "Buffers", },
      { "<leader>bF", function() Snacks.picker.buffers { hidden = true, nofile = true } end, desc = "Buffers (all)", },
      { "<leader>fO", RUtils.pick.config_files(), desc = "Find Config File" },
      -- { "<leader>ff", LazyVim.pick("files"), desc = "Find Files (Root Dir)" },
      -- { "<leader>fF", LazyVim.pick("files", { root = false }), desc = "Find Files (cwd)" },
      -- { "<leader>fg", function() Snacks.picker.git_files() end, desc = "Find Files (git-files)", },
      -- { "<leader>fr", RUtils.pick("oldfiles"), desc = "Recent" },
      { "<leader>fo", function() Snacks.picker.recent { filter = { cwd = false } } end, desc = "Recent (cwd)", },
      { "<leader>fp", function() Snacks.picker.projects() end, desc = "Projects", },
      -- git
      { "<leader>gc", function() Snacks.picker.git_log() end, desc = "Git Log", },
      { "<leader>gd", function() Snacks.picker.git_diff() end, desc = "Git Diff (hunks)", },
      { "<leader>gs", function() Snacks.picker.git_status() end, desc = "Git Status", },
      -- Grep
      -- { "<leader>fg", function() Snacks.picker.grep { hidden = true, layout = "ivy" } end, desc = "Grep Open Buffers", }, -- { "<leader>sg", LazyVim.pick("live_grep"), desc = "Grep (Root Dir)" },
      { "<leader>fg", RUtils.pick("grep"), desc = "Grep (Root Dir)" },
      -- { "<leader>fg", function() Snacks.picker.live_grep({ hidden = true, }) end, desc = "Grep Open Buffers", }, -- { "<leader>sg", LazyVim.pick("live_grep"), desc = "Grep (Root Dir)" },
      -- { "<leader>sp", function() Snacks.picker.lazy() end, desc = "Search for Plugin Spec", },
      -- { "<leader>sw", LazyVim.pick("grep_word"), desc = "Visual selection or word (Root Dir)", mode = { "n", "x" } },
      -- { "<leader>sW", LazyVim.pick("grep_word", { root = false }), desc = "Visual selection or word (cwd)", mode = { "n", "x" } },
      -- search
      -- { '<leader>s"', function() Snacks.picker.registers() end, desc = "Registers", },
      -- { "<leader>sa", function() Snacks.picker.autocmds() end, desc = "Autocmds", },
      { "<leader>fc", function() Snacks.picker.command_history() end, desc = "Command History", },
      -- { "<leader>sC", function() Snacks.picker.commands() end, desc = "Commands", },
      -- { "<leader>fd", function() Snacks.picker.diagnostics() end, desc = "Diagnostics", },
      { "<leader>fH", function() Snacks.picker.help() end, desc = "Help Pages", },
      -- { "<leader>sH", function() Snacks.picker.highlights() end, desc = "Highlights", },
      -- { "<leader>si", function() Snacks.picker.icons() end, desc = "Icons", },
      -- { "<leader>sj", function() Snacks.picker.jumps() end, desc = "Jumps", },
      {
        "<leader>fk",
        function()
          Snacks.picker.keymaps {
            layout = {
              preview = "main",
              layout = {
                backdrop = false,
                width = 20,
                min_width = 0,
                height = 0,
                position = "bottom",
                border = "none",
                box = "vertical",
                {
                  win = "input",
                  height = 1,
                  border = "rounded",
                  title = "{title} {live} {flags}",
                  title_pos = "center",
                },
                { win = "list", border = "none" },
                { win = "preview", title = "{preview}", height = 0.20, border = "top" },
              },
            },
          }
        end,
        desc = "Keymaps",
      },
      -- { "<leader>sl", function() Snacks.picker.loclist() end, desc = "Location List", },
      -- { "<leader>sM", function() Snacks.picker.man() end, desc = "Man Pages", },
      -- { "<leader>sm", function() Snacks.picker.marks() end, desc = "Marks", },
      -- { "<leader>sR", function() Snacks.picker.resume() end, desc = "Resume", },
      -- { "<leader>sq", function() Snacks.picker.qflist() end, desc = "Quickfix List", },
      -- { "<leader>su", function() Snacks.picker.undo() end, desc = "Undotree", },
      -- ui
      { "<leader>uC", function() Snacks.picker.colorschemes() end, desc = "Colorschemes", },
    },
  },
}
