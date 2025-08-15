return {
  recommended = function()
    return RUtils.extras.wants {
      ft = "cmake",
      root = { "CMakePresets.json", "CTestConfig.cmake", "cmake" },
    }
  end,
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "cmake", "make" } },
  },
  {
    "mfussenegger/nvim-lint",
    optional = true,
    opts = {
      linters_by_ft = {
        cmake = { "cmakelint" },
      },
    },
  },
  {
    "mason.nvim",
    opts = { ensure_installed = { "cmakelang", "cmakelint" } },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        neocmake = {},
      },
    },
  },

  {
    "mason-org/mason.nvim",
    optional = true,
    opts = { ensure_installed = { "neocmakelsp", "clangd" } },
  },

  {
    "Civitasv/cmake-tools.nvim",
    lazy = true,
    init = function()
      local loaded = false
      local function check()
        local cwd = vim.uv.cwd()
        if vim.fn.filereadable(cwd .. "/CMakeLists.txt") == 1 then
          require("lazy").load { plugins = { "cmake-tools.nvim" } }
          loaded = true
        end
      end
      check()
      vim.api.nvim_create_autocmd("DirChanged", {
        callback = function()
          if not loaded then
            check()
          end
        end,
      })
    end,
    opts = {},
  },
}
