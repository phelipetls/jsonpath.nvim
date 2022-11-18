if exists('current_compiler')
  finish
endif
let current_compiler = 'eslint_d'

if exists(':CompilerSet') != 2  " older Vim always used :setlocal
  command -nargs=* CompilerSet setlocal <args>
endif

CompilerSet makeprg=eslint_d\ --format=unix
CompilerSet errorformat=%f:%l:%c:\ %m,%-G%.%#
