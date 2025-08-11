---@type string
local xdg_config = vim.env.XDG_CONFIG_HOME or vim.env.HOME .. "/.config"

---@param path string
local function have(path)
  return vim.uv.fs_stat(xdg_config .. "/" .. path) ~= nil
end

RUtils.on_very_lazy(function()
  vim.filetype.add {
    extension = {
      rasi = "rasi",
      rofi = "rasi",
      wofi = "rasi",
      http = "http",
      task = "json",
      -- zsh = "sh",
      -- sh = "sh", -- force sh-files with zsh-shebang to still get sh as filetype
    },
    filename = {
      ["vifmrc"] = "vim",
      -- [".zshrc"] = "zsh",
      -- [".zshenv"] = "sh",
    },
    pattern = {
      [".*/waybar/config"] = "jsonc",
      ["%.vscode/tasks.json"] = "task",
      [".*/mako/config"] = "dosini",
      [".*/kitty/.+%.conf"] = "kitty",
      [".*/hypr/.+%.conf"] = "hyprlang",
      ["%.env%.[%w_.-]+"] = "sh",
    },
  }
end)

vim.treesitter.language.register("bash", "kitty")

return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        bashls = {},
      },
    },
  },
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      table.insert(opts.ensure_installed, "bash-language-server")
    end,
  },
  {
    "mason-org/mason.nvim",
    opts = { ensure_installed = { "shellcheck" } },
  },
  -- add some stuff to treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      local function add(lang)
        if type(opts.ensure_installed) == "table" then
          table.insert(opts.ensure_installed, lang)
        end
      end

      add "git_config"

      if have "hypr" then
        add "hyprlang"
      end

      if have "fish" then
        add "fish"
      end

      if have "rofi" or have "wofi" then
        add "rasi"
      end
    end,
  },
}
