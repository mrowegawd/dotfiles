return {
  recommended = function()
    return RUtils.extras.wants {
      ft = "yaml.ansible",
      root = { "ansible.cfg", ".ansible-lint" },
    }
  end,
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        ansiblels = {},
      },
    },
  },
  {
    "mfussenegger/nvim-ansible",
    ft = { "yaml" },
    keys = {
      {
        "<Leader>clr",
        function()
          require("ansible").run()
        end,
        ft = "yaml.ansible",
        desc = "ActionLSP: ansible run playbook/role",
        silent = true,
      },
    },
  },
}
