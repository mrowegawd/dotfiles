if vim.g.colorscheme ~= "gruvbox" then
  return
end

local add = require("vim-pack").add

add {
  {
    src = "motaz-shokry/gruvbox.nvim",
    opts = function()
      return {
        variant = "hard",
        dim_inactive_windows = false,

        styles = {
          bold = true,
          italic = true,
          transparency = false,
        },

        groups = {
          border = "bg3",
          link = "blue_lite",
          panel = "bg_second",

          error = "red_lite",
          warn = "yellow_lite",
          info = "blue_lite",
          hint = "aqua_lite",
          ok = "green_lite",
          note = "blue_lite",
          todo = "orange_lite",

          git_add = "green_lite",
          git_change = "yellow_lite",
          git_delete = "red_lite",
          git_dirty = "orange_lite",
          git_ignore = "bg3",
          git_merge = "purple_lite",
          git_rename = "blue_lite",
          git_stage = "aqua_lite",
          git_text = "yellow_lite",
          git_untracked = "aqua_dark",
        },

        -- hanya key yang diganti, sisanya otomatis tetap bawaan plugin
        palette = {
          hard = {
            -- background: gelap, sedikit hangat, bertingkat jelas
            bg_main = "#181818",
            bg_second = "#1f1e1d", -- panel, float, trouble, fzf
            bg_third = "#272524",
            bg1 = "#302d2b",
            bg2 = "#443f3b",
            bg3 = "#5d554e",
            bg4 = "#776d63",

            -- foreground: krem hangat, tidak terlalu putih
            fg = "#f2e5bc",
            fg1 = "#e4d4a8",
            fg2 = "#cdbf9a",
            fg3 = "#b3a583",
            fg4 = "#9a8d74",
            gray = "#8a7f70", -- warna comment

            -- aksen terang (dipakai syntax)
            red_lite = "#f9564a",
            green_lite = "#b5cc2e",
            yellow_lite = "#ffc133",
            blue_lite = "#7db4c9",
            purple_lite = "#e08ba5",
            aqua_lite = "#87d19a",
            orange_lite = "#ff8a2b",

            -- aksen gelap (dipakai UI, badge, git)
            red_dark = "#d13b30",
            green_dark = "#8fa21f",
            yellow_dark = "#d9a02a",
            blue_dark = "#4f8f9e",
            purple_dark = "#b5668a",
            aqua_dark = "#5fa37a",
            orange_dark = "#d9640f",

            highlight_low = "#302d2b",
            highlight_med = "#443f3b",
            highlight_high = "#5d554e",
          },
        },

        highlight_groups = {
          -- editor
          Comment = { fg = "gray", italic = true },
          CursorLine = { bg = "bg_second" },
          CursorLineNr = { fg = "yellow_lite", bold = true },
          LineNr = { fg = "bg3" },
          Visual = { bg = "bg2", inherit = false },
          Search = { fg = "bg_main", bg = "yellow_lite" },
          IncSearch = { fg = "bg_main", bg = "orange_lite" },
          MatchParen = { fg = "orange_lite", bg = "bg2", bold = true },
          WinSeparator = { fg = "bg2" },
          ColorColumn = { bg = "bg_second" },

          -- popup dan float
          NormalFloat = { fg = "fg1", bg = "bg_second" },
          FloatBorder = { fg = "bg3", bg = "bg_second" },
          Pmenu = { fg = "fg1", bg = "bg_second" },
          PmenuSel = { fg = "fg", bg = "bg2", bold = true },

          -- syntax (treesitter)
          ["@keyword"] = { fg = "red_lite", italic = true },
          ["@keyword.return"] = { fg = "red_lite", italic = true, bold = true },
          ["@keyword.function"] = { fg = "red_lite", italic = true },
          ["@function"] = { fg = "aqua_lite" },
          ["@function.call"] = { fg = "aqua_lite" },
          ["@function.method"] = { fg = "aqua_lite" },
          ["@function.builtin"] = { fg = "blue_lite" },
          ["@type"] = { fg = "yellow_lite" },
          ["@type.builtin"] = { fg = "yellow_dark", italic = true },
          ["@string"] = { fg = "green_lite" },
          ["@number"] = { fg = "purple_lite" },
          ["@boolean"] = { fg = "orange_lite", bold = true },
          ["@constant"] = { fg = "orange_lite" },
          ["@variable"] = { fg = "fg1" },
          ["@variable.parameter"] = { fg = "blue_lite", italic = true },
          ["@variable.member"] = { fg = "fg2" },
          ["@property"] = { fg = "fg2" },
          ["@operator"] = { fg = "fg4" },
          ["@punctuation"] = { fg = "fg4" },
          ["@constructor"] = { fg = "yellow_lite" },
          ["@tag"] = { fg = "red_lite" },
          ["@tag.attribute"] = { fg = "yellow_lite", italic = true },

          -- diagnostic
          DiagnosticUnderlineError = { sp = "red_lite", undercurl = true },
          DiagnosticUnderlineWarn = { sp = "yellow_lite", undercurl = true },
          DiagnosticUnderlineInfo = { sp = "blue_lite", undercurl = true },
          DiagnosticUnderlineHint = { sp = "aqua_lite", undercurl = true },

          -- trouble.nvim (sesuai pembahasan sebelumnya)
          TroubleNormal = { fg = "fg1", bg = "bg_second" },
          TroubleNormalNC = { fg = "fg1", bg = "bg_second" },
          TroubleText = { fg = "fg1" },
          TroubleFilename = { fg = "aqua_lite", bold = true },
          TroubleBasename = { fg = "aqua_lite", bold = true },
          TroubleDirectory = { fg = "fg4" },
          TroubleSource = { fg = "fg4", italic = true },
          TroublePos = { fg = "fg4" },
          TroubleCode = { fg = "fg4" },
          TroubleCount = { fg = "yellow_lite", bg = "bg2" },
          TroubleFileCount = { fg = "yellow_lite", bg = "bg2" },
          TroubleIndent = { fg = "bg2" },
          TroublePreview = { bg = "bg1" },

          -- fzf-lua
          FzfLuaNormal = { fg = "fg1", bg = "bg_second" },
          FzfLuaBorder = { fg = "bg3", bg = "bg_second" },
          FzfLuaTitle = { fg = "yellow_lite", bold = true },
          FzfLuaCursorLine = { bg = "bg2" },
          FzfLuaSearch = { fg = "bg_main", bg = "yellow_lite" },
        },
      }
    end,
  },
}

vim.cmd.colorscheme "gruvbox"
