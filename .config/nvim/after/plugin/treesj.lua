require("treesj").setup({
  use_default_keymaps = false,
})
vim.keymap.set("n", "gJ", "<cmd>TSJJoin<CR>")
vim.keymap.set("n", "gS", "<cmd>TSJSplit<CR>")
