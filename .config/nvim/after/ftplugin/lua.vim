setlocal makeprg=luacheck\ --no-color
let &l:errorformat=&g:errorformat . ',%-G%.%#'

if executable('luafmt')
  let &l:formatprg = 'luafmt --stdin'
endif

if executable('stylua')
  let &l:formatprg = 'stylua -'
endif
