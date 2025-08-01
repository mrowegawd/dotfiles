vim.filetype.add {
  pattern = {
    [".*/host_vars/.*%.ya?ml"] = "yaml.ansible",
    [".*/group_vars/.*%.ya?ml"] = "yaml.ansible",
    [".*/group_vars/.*/.*%.ya?ml"] = "yaml.ansible",
    [".*/playbook.*%.ya?ml"] = "yaml.ansible",
    [".*/playbooks/.*%.ya?ml"] = "yaml.ansible",
    [".*/roles/.*/tasks/.*%.ya?ml"] = "yaml.ansible",
    [".*/roles/.*/handlers/.*%.ya?ml"] = "yaml.ansible",
    [".*/tasks/.*%.ya?ml"] = "yaml.ansible",

    -- [".*/playbooks/.*%.ya?ml"] = "yaml.ansible",
    -- [".*/roles/.*/tasks/.*%.ya?ml"] = "yaml.ansible",
    [".*/roles/.*/molecule/*.*%.ya?ml"] = "yaml.ansible",
    -- [".*/roles/.*/handlers/.*%.ya?ml"] = "yaml.ansible",
    [".*/inventory/.*%.ini"] = "ansible_hosts",
  },
}
