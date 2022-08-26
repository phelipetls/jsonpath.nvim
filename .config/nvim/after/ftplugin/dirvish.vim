scriptencoding utf-8

if has('nvim')
lua << EOF
vim.api.nvim_buf_set_keymap(0, "n", "%", ":lua require'dirvish'.create_file()<CR>", { silent = true })
vim.api.nvim_buf_set_keymap(0, "n", "d", ":lua require'dirvish'.create_dir()<CR>", { silent = true, nowait = true })
vim.api.nvim_buf_set_keymap(0, "n", "D", ":lua require'dirvish'.delete()<CR>", { silent = true })
vim.api.nvim_buf_set_keymap(0, "n", "R", ":lua require'dirvish'.rename()<CR>", { silent = true })
vim.api.nvim_buf_set_keymap(0, "n", "X", ":lua require'dirvish'.clear_arglist()<CR>", { silent = true })
vim.api.nvim_buf_set_keymap(0, "n", "<F5>", ":lua require'dirvish'.explore()<CR>", { silent = true })
EOF
endif
