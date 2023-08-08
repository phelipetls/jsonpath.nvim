require("fzf-lua").setup({
  files = {
    previewer = false,
  },
  buffers = {
    previewer = false,
  },
})

vim.keymap.set("n", "<space>b", "<cmd>FzfLua buffers<CR>")
vim.keymap.set("n", "<space>f", "<cmd>FzfLua files<CR>")
vim.keymap.set("n", "<space>h", "<cmd>FzfLua help_tags<CR>")
vim.keymap.set("n", "<space>r", "<cmd>FzfLua oldfiles<CR>")
vim.keymap.set("n", "<space>p", "<cmd>FzfLua commands<CR>")
vim.keymap.set("n", "<space>gb", "<cmd>FzfLua git_branches<CR>")
vim.keymap.set("n", "<space>gs", "<cmd>FzfLua git_stash<CR>")

vim.keymap.set("n", "<space>gr", "<cmd>FzfLua live_grep_native<CR>")
vim.api.nvim_create_user_command("Rg", "FzfLua live_grep_native", {})
