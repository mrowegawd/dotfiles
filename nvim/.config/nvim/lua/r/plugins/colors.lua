return {
  -- NVIM-COLORIZER (disabled)
  {
    "NvChad/nvim-colorizer.lua",
    enabled = false,
    opts = {},
    cmd = {
      "ColorizerToggle",
      "ColorizerAttachToBuffer",
      "ColorizerDetachFromBuffer",
      "ColorizerReloadAllBuffers",
    },
  },
  -- CCC
  {
    "uga-rosa/ccc.nvim",
    cmd = { "CccPick", "CccConvert", "CccHighlighterToggle" },
    keys = {
      {
        "<Leader>rc",
        "<CMD>CccPick<CR>",
        desc = "Misc(ccc): open CCCpick",
      },
      {
        "<Localleader>tc",
        "<CMD>CccHighlighterToggle<CR>",
        desc = "Misc(ccc): toggle color",
      },
    },
    opts = function()
      local ccc = require "ccc"
      local p = ccc.picker
      p.hex.pattern = {
        [=[\v%(^|[^[:keyword:]])\zs#(\x\x)(\x\x)(\x\x)>]=],
        [=[\v%(^|[^[:keyword:]])\zs#(\x\x)(\x\x)(\x\x)(\x\x)>]=],
      }
      ccc.setup {
        win_opts = { border = as.ui.border.line },
        pickers = {
          p.hex,
          p.css_rgb,
          p.css_hsl,
          p.css_hwb,
          p.css_lab,
          p.css_lch,
          p.css_oklab,
          p.css_oklch,
        },
        highlighter = {
          auto_enable = true,
          excludes = {
            "dart",
            "lazy",
            "orgagenda",
            "org",
            "NeogitStatus",
            "toggleterm",
          },
        },
      }
    end,
  },
}
