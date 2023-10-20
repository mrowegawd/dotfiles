return {
  -- CODEIUM (disabled)
  {
    "Exafunction/codeium.vim",
    enabled = false,
    event = "InsertEnter",

    config = function()
      vim.g.codeium_disable_bindings = 1
      vim.keymap.set("i", "<leader>aa", function()
        return vim.fn["codeium#Accept"]()
      end, { expr = true })
      vim.keymap.set("i", "<leader>ac", function()
        return vim.fn["codeium#CycleCompletions"](1)
      end, { expr = true })
      vim.keymap.set("i", "<leader>aR", function()
        return vim.fn["codeium#CycleCompletions"](-1)
      end, { expr = true })
      vim.keymap.set("i", "<leader>al", function()
        return vim.fn["codeium#Clear"]()
      end, { expr = true })
      vim.keymap.set("i", "<leader>aC", function()
        return vim.fn["codeium#Complete"]()
      end, { expr = true })
    end,
  },
}
