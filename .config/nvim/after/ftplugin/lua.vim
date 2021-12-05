setlocal makeprg=luacheck\ --no-color
let &l:errorformat=&g:errorformat . ',%-G%.%#'

if executable('luafmt')
  let &l:formatprg = 'luafmt --stdin'
endif
