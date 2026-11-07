local add_local_or_remote = require("vim-pack").add_local_or_remote

local lazy = require("utils.plugin").require_lazy

local UtilKey = lazy "utils.map"
local UtilWindow = lazy "utils.window"
local IconsLSP = lazy("icons").kinds

local function auto_close_qf_win()
  local qf_win = UtilWindow.windows_is_opened "qf"
  if qf_win.found then
    vim.cmd [[cclose]]
  end
end

add_local_or_remote {
  {
    src = "nvim_plugins/trouble.nvim",
    lazy = true,
    opts = {
      focus = true,
      auto_refresh = false, -- use `R` to refresh it
      win = { position = "bottom", relative = "win" },
      preview = {
        type = "main",
        scratch = false,
      },
      icons = {
        kinds = {
          Array = IconsLSP.Array,
          Boolean = IconsLSP.Boolean,
          Class = IconsLSP.Classs,
          Constant = IconsLSP.Constant,
          Constructor = IconsLSP.Constructor,
          Enum = IconsLSP.Enum,
          EnumMember = IconsLSP.EnumMember,
          Event = IconsLSP.Event,
          Field = IconsLSP.Field,
          File = IconsLSP.File,
          Function = IconsLSP.Function,
          Interface = IconsLSP.Interface,
          Key = IconsLSP.Interface,
          Method = IconsLSP.Key,
          Module = IconsLSP.Method,
          Namespace = IconsLSP.Namespace,
          Null = IconsLSP.Null,
          Number = IconsLSP.Number,
          Object = IconsLSP.Object,
          Operator = IconsLSP.Operator,
          Package = IconsLSP.Package,
          Property = IconsLSP.Property,
          String = IconsLSP.String,
          Struct = IconsLSP.Struct,
          TypeParameter = IconsLSP.TypeParameter,
          Variable = IconsLSP.Variable,
        },
      },
      keys = {
        ["<esc>"] = "cancel",

        q = "close",
        ["<Leader>bk"] = "close",

        r = "refresh",
        R = "toggle_refresh",

        ["<c-s>"] = "jump_split_aboveleft_close",
        -- ["<c-v>"] = "jump_vsplit",

        o = "jump",

        P = "toggle_preview",

        ["<C-a>"] = "fold_toggle",
        ["<TAB>"] = "fold_toggle",

        ["<a-n>"] = "next",
        ["<c-n>"] = "next",
        ["<a-p>"] = "prev",
        ["<c-p>"] = "prev",
      },
    },
  },
}

local load_trouble = function()
  lazy("vim-pack").load_now "trouble.nvim"
end

local cmds = {
  --stylua: ignore
  { "<Leader>xr", function() vim.cmd "Trouble resume" end, "resume" },
  --stylua: ignore
  { "<Leader>xT", function() UtilKey.plugin_load_now "todo-comments.nvim" auto_close_qf_win() vim.cmd.TodoTrouble() end, "todo-trouble global" },
  --stylua: ignore
  { "<Leader>xD", function() auto_close_qf_win() vim.cmd [[Trouble diagnostics toggle]] end, "workspace diagnostics (global project)" },
  --stylua: ignore
  { "<Leader>xd", function() auto_close_qf_win() vim.cmd [[Trouble diagnostics toggle filter.buf=0]] end, "document diagnostics (on curbuf)" },
}

for _, cmd in ipairs(cmds) do
  UtilKey.nnoremap(cmd[1], function()
    load_trouble()
    cmd[2]()
  end, { desc = ("Exec: %s [trouble]"):format(cmd[3]) })
end

--stylua: ignore
UtilKey.nnoremap("<Leader>xF", function() load_trouble() vim.cmd.Trouble() end, { desc = "Bulk: list trouble builtin" })
