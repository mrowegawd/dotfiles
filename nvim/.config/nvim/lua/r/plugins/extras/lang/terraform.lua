return {
  recommended = function()
    return RUtils.extras.wants {
      ft = { "terraform", "hcl" },
      root = ".terraform",
    }
  end,

  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "terraform", "hcl" } },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        terraformls = {},
      },
    },
  },
  -- ensure terraform tools are installed
  {
    "mason-org/mason.nvim",
    opts = { ensure_installed = { "tflint" } },
  },
  {
    "mfussenegger/nvim-lint",
    optional = true,
    opts = {
      linters_by_ft = {
        terraform = { "terraform_validate" },
        tf = { "terraform_validate" },
      },
    },
  },
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        terraform = { "terraform_fmt" },
        tf = { "terraform_fmt" },
        ["terraform-vars"] = { "terraform_fmt" },
      },
    },
  },
  {
    "nvim-telescope/telescope.nvim",
    optional = true,
    dependencies = {
      {
        "ANGkeith/telescope-terraform-doc.nvim",
        config = function()
          RUtils.on_load("telescope.nvim", function()
            require("telescope").load_extension "terraform_doc"
          end)
        end,
      },
      {
        "cappyzawa/telescope-terraform.nvim",
        config = function()
          RUtils.on_load("telescope.nvim", function()
            require("telescope").load_extension "terraform"
          end)
        end,
      },
    },
  },
}
