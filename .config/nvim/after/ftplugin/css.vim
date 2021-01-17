setlocal softtabstop=2 shiftwidth=2

setlocal formatprg=prettier\ --parser=css

" workaround css completion bug when writing media queries
let b:after = '"'
let b:completion_command = "\<C-x>\<C-o>"

if executable("firefox")
  setlocal keywordprg=firefox\ https://developer.mozilla.org/search?topic=api\\&topic=css\\&q=\
endif
