setlocal makeprg=luacheck\ --no-color
let &l:errorformat=&g:errorformat . ',%-G%.%#'

if executable('stylua')
  let &l:formatprg = 'stylua --search-parent-directories -'
endif
