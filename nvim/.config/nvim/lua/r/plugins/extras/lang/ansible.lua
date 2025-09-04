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
    ft = {},
    -- keys = {
    --   {
    --     "<leader>ta",
    --     function()
    --       require("ansible").run()
    --     end,
    --     desc = "Ansible Run Playbook/Role",
    --     silent = true,
    --   },
    -- },
  },
}
