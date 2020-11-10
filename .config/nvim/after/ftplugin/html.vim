setl softtabstop=2 shiftwidth=2

let g:html_indent_script1 = "inc"
let g:html_indent_style1 = "inc"

if executable("prettier")
  set formatprg=prettier\ --parser\ html
endif

nnoremap <silent><buffer> <F5> :silent !firefox --new-window "%" &<CR>

setl omnifunc=emmet#completeTag

let b:completion_command = "\<C-x>\<C-o>"
let b:completion_length = 1

iabbr <buffer><silent> clog console.log();<Left><Left><C-R>=Eatchar('\s')<CR>
iabbr consoel console
iabbr lenght length
iabbr edf export default function
iabbr ireact import React from "react";

if executable("firefox")
  setlocal keywordprg=firefox\ https://developer.mozilla.org/search?topic=api\\&topic=html\\&q=\
endif
