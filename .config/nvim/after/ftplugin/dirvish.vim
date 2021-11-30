nnoremap <silent><buffer>
        \ zh :silent keeppatterns g@\v/\.[^\/]+/?$@d _<cr>:setl cole=3<cr>

setlocal signcolumn=yes

execute 'sign unplace *'

lua << EOF
for lnum = 1, vim.fn.line('$') do
  local line = vim.fn.getline(lnum)
  local fname = vim.fn.fnamemodify(line, ':t')
  local extension = vim.fn.fnamemodify(line, ':e')
  local name = extension == '' and 'default' or extension
  local icon = require'nvim-web-devicons'.get_icon(fname, extension, {default=true})
  vim.fn.sign_define(name, { text=icon })
  vim.fn.sign_place(lnum, '', name, vim.fn.bufnr(), {
    lnum=lnum
  })
end
EOF

if has("nvim")
lua << EOF
vim.api.nvim_buf_set_keymap(0, "n", "%", ":lua require'dirvish'.create_file()<CR>", { silent = true })
vim.api.nvim_buf_set_keymap(0, "n", "d", ":lua require'dirvish'.create_dir()<CR>", { silent = true, nowait = true })
vim.api.nvim_buf_set_keymap(0, "n", "D", ":lua require'dirvish'.delete()<CR>", { silent = true })
vim.api.nvim_buf_set_keymap(0, "n", "R", ":lua require'dirvish'.rename()<CR>", { silent = true })
EOF
endif
