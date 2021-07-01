inoremap <buffer> >> %>%
inoremap <buffer> -- <-

setlocal define=\\ze[A-Za-z_.]\\+\\s*\\\(<-\\\\|=\\)\\s*function.*

if executable("Rscript")
  setlocal formatprg=styler_stdin
endif

nnoremap <F5> :w !R -q --vanilla %<CR>
