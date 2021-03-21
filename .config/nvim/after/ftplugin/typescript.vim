source $HOME/.config/nvim/after/ftplugin/javascript.vim

if executable("deno")
  nnoremap <buffer> <F5> :!deno run %<CR>
endif
