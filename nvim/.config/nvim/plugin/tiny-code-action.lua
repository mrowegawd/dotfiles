local add_on_event = require("vim-pack").add_on_event

add_on_event("LspAttach", {
  {
    -- "rachartier/tiny-code-action.nvim",
    -- src = "nvim_plugins/tiny-code-action.nvim",
    src = "MadKuntilanak/tiny-code-action.nvim",
    version = "fix/fzflua",
    opts = {
      backend = "delta", -- delta, vim
      picker = "fzf-lua",
      backend_opts = {
        delta = { header_lines_to_remove = 4 },
        difftastic = {
          header_lines_to_remove = 1,
          args = {
            "--color=always",
            "--display=inline",
            "--syntax-highlight=on",
          },
        },
        diffsofancy = {
          header_lines_to_remove = 4,
        },
      },
      signs = {
        quickfix = { "", { link = "DiagnosticWarn" } },
        others = { "", { link = "DiagnosticWarn" } },
        refactor = { "", { link = "DiagnosticInfo" } },
        ["refactor.move"] = { "󰪹", { link = "DiagnosticInfo" } },
        ["refactor.extract"] = { "", { link = "DiagnosticError" } },
        ["source.organizeImports"] = { "", { link = "DiagnosticWarn" } },
        ["source.fixAll"] = { "󰃢", { link = "DiagnosticError" } },
        ["source"] = { "", { link = "DiagnosticError" } },
        ["rename"] = { "󰑕", { link = "DiagnosticWarn" } },
        ["codeAction"] = { "", { link = "DiagnosticWarn" } },
      },
    },
  },
})
