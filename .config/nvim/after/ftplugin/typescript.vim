source $HOME/.config/nvim/after/ftplugin/javascript.vim

let b:dsf_function_pattern = '\(new\s*\)\?\k\+\(<.*>\)\?'

let $NO_COLOR='true'

if executable("deno")
  nnoremap <buffer> <F5> :!deno run %<CR>
endif
