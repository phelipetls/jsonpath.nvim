if exists('current_compiler')
  finish
endif
let current_compiler = 'shellcheck'

if exists(':CompilerSet') != 2  " older Vim always used :setlocal
  command -nargs=* CompilerSet setlocal <args>
endif

CompilerSet makeprg=shellcheck\ --format\ gcc\ --external-sources
CompilerSet errorformat=%f:%l:%c:\ %t%n\ %m,%-G%.%#
