if vim.fn.exists("$TMUX") == 1 then
  vim.g.slime_target = "tmux"
  vim.g.slime_default_config = { socket_name = "default", target_pane = "{last}" }
  vim.g.slime_dont_ask_default = 1
  vim.g.slime_bracketed_paste = 1
elseif vim.fn.has("unix") == 1 and vim.fn.exists("$WAYLAND_DISPLAY") ~= 1 then
  vim.g.slime_target = "x11"
else
  vim.g.slime_target = "neovim"
end

vim.keymap.set("n", "<C-c><C-c>", "<Plug>SlimeRegionSend", { silent = true })
vim.keymap.set("n", "<C-c><C-w>", function()
  vim.cmd(string.format("SlimeSend1 %s<CR>", vim.fn.expand('<cword>')))
end, { silent = true })
vim.keymap.set("n", "<C-c>%", "<cmd>%SlimeSend<CR>", { silent = true })
