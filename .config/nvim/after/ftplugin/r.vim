"{{{ abbreviations

inoremap <buffer> >> %>%
inoremap <buffer> -- <-

"}}}
"{{{ indentation

setlocal softtabstop=2 shiftwidth=2

"}}}
"{{{ include-search

setlocal define=\\ze[A-Za-z_.]\\+\\s*\\\(<-\\\\|=\\)\\s*function.*

"}}}
"{{{ formatter

if executable("Rscript")
  setlocal formatprg=styler_stdin
endif

"}}}
"{{{ run

nnoremap <F5> :w !R -q --vanilla %<CR>

"}}}
