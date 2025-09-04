return {
  recommended = function()
    return RUtils.extras.wants {
      ft = "dockerfile",
      root = {
        "Dockerfile",
        "Containerfile",
        "docker-compose.yml",
        "compose.yml",
        "docker-compose.yaml",
        "compose.yaml",
      },
    }
  end,
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "dockerfile" } },
  },
  {
    "mason-org/mason.nvim",
    optional = true,
    opts = { ensure_installed = { "hadolint" } },
  },
  {
    "mfussenegger/nvim-lint",
    optional = true,
    opts = {
      linters_by_ft = {
        dockerfile = { "hadolint" },
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        dockerls = {}, -- TODO: line ini dockerls
        docker_compose_language_service = {},
      },
    },
  },
}
