nnoremap <silent><buffer>
        \ zh :silent keeppatterns g@\v/\.[^\/]+/?$@d _<cr>:setl cole=3<cr>

setlocal signcolumn=yes

execute 'sign unplace *'

for lnum in range(1, line('$'))
  let line = getline(lnum)
  let fname = fnamemodify(line, ':t')
  let extension = fnamemodify(line, ':e')
  let signname = empty(extension) ? 'default' : extension
  let icon = luaeval("require'nvim-web-devicons'.get_icon(_A[1], _A[2], {default=true})", [fname, extension])
  exe printf('sign define %s text=%s', signname, icon)
  exe printf('sign place %d line=%d name=%s', lnum, lnum, signname)
endfor

if has("nvim")
lua << EOF
vim.api.nvim_buf_set_keymap(0, "n", "%", ":lua require'dirvish'.create_file()<CR>", { silent = true })
vim.api.nvim_buf_set_keymap(0, "n", "d", ":lua require'dirvish'.create_dir()<CR>", { silent = true, nowait = true })
vim.api.nvim_buf_set_keymap(0, "n", "D", ":lua require'dirvish'.delete()<CR>", { silent = true })
vim.api.nvim_buf_set_keymap(0, "n", "R", ":lua require'dirvish'.rename()<CR>", { silent = true })
EOF
endif
