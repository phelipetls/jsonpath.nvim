if exists('current_compiler')
  finish
endif
let current_compiler = 'playwright'

if exists(':CompilerSet') != 2  " older Vim always used :setlocal
  command -nargs=* CompilerSet setlocal <args>
endif

CompilerSet makeprg=FORCE_COLOR=0\ npx\ playwright\ test\ $*
" CompilerSet makeprg=playwright
CompilerSet errorformat=\
  \%E%.%#\ \ %*\\d)\ %.%#\ ›\ %*\\f:%*\\d:%*\\d%.%#\ ›\ %o,
  \%C%*[\ ]Error:\ %m,
  \%+C%*[\ ]Expected%.%#,
  \%+C%*[\ ]Received%.%#,
  \%Z%*[\ ]at\ %f:%l:%c,
  \%C%.%#,
  \%-G%.%#
