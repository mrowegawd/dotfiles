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
        "<leader>ct",
        function()
          require("ansible").run()
        end,
        ft = "yaml.ansible",
        desc = "Ansible Run Playbook/Role",
        silent = true,
      },
    },
  },
}
