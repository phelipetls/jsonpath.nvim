vim.api.nvim_create_user_command("E", "e<bang>", { bang = true, complete = "file_in_path", nargs = "*" })
vim.api.nvim_create_user_command("W", "w<bang>", { bang = true })
vim.api.nvim_create_user_command("Q", "q<bang>", { bang = true })
vim.api.nvim_create_user_command("Qall", "qall<bang>", { bang = true })

vim.api.nvim_create_user_command("Hi", function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))

  local syn_id = vim.fn.synID(line, col, 0)
  local highlight_name = vim.fn.synIDattr(syn_id, "name")

  vim.cmd.hi(highlight_name ~= "" and highlight_name or nil)
end, { desc = "Show information about highlight group under cursor" })

vim.api.nvim_create_user_command("Browse", function(opts)
  local file = opts.args
  require("helpers.os").open(file)
end, { nargs = 1, desc = "Open file/URL with the operating system" })

vim.api.nvim_create_user_command("FormatPrg", "call format#file(<bang>0)", { bang = true })
