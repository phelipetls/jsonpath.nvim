setl softtabstop=2 shiftwidth=2

let g:html_indent_script1 = "inc"
let g:html_indent_style1 = "inc"

if executable("prettier")
  set formatprg=prettier\ --parser\ html
endif

nnoremap <silent><buffer> <F5> :silent !firefox --new-window "%" &<CR>

setl omnifunc=emmet#completeTag
