nnoremap <silent><buffer>
        \ zh :silent keeppatterns g@\v/\.[^\/]+/?$@d _<cr>:setl cole=3<cr>

if has("nvim")
lua << EOF
local dirvish = require'utils/dirvish'
vim.api.nvim_buf_set_keymap(0, "n", "%", ":lua require'utils/dirvish'.create_file()<CR>", { silent = true })
vim.api.nvim_buf_set_keymap(0, "n", "d", ":lua require'utils/dirvish'.create_dir()<CR>", { silent = true, nowait = true })
vim.api.nvim_buf_set_keymap(0, "n", "D", ":lua require'utils/dirvish'.delete()<CR>", { silent = true })
vim.api.nvim_buf_set_keymap(0, "n", "R", ":lua require'utils/dirvish'.rename()<CR>", { silent = true })
vim.api.nvim_buf_set_keymap(0, "n", "p", ":lua require'utils/dirvish'.copy()<CR>", { silent = true })
vim.api.nvim_buf_set_keymap(0, "n", "gp", ":lua require'utils/dirvish'.move()<CR>", { silent = true })
vim.api.nvim_buf_set_keymap(0, "n", "X", ":lua require'utils/dirvish'.clear_arglist()<CR>", { silent = true })
EOF
endif
