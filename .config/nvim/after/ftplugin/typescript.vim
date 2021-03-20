source $HOME/.config/nvim/after/ftplugin/javascript.vim

setlocal suffixesadd+=.js,.tsx,.jsx

if executable("deno")
  nnoremap <buffer> <F5> :!deno run %<CR>
endif
