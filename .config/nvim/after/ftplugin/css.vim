setlocal softtabstop=2 shiftwidth=2

let b:completion_command = "\<C-x>\<C-o>"

setlocal formatprg=prettier\ --parser=css

" workaround css completion bug when writing media queries
let b:after = '"'

if executable("firefox")
  setlocal keywordprg=firefox\ https://developer.mozilla.org/search?topic=api\\&topic=css\\&q=\
endif
