if exists("current_compiler")
  finish
endif
let current_compiler = "flake8"

if exists(":CompilerSet") != 2		" older Vim always used :setlocal
  command -nargs=* CompilerSet setlocal <args>
endif

CompilerSet makeprg=flake8\ %
CompilerSet errorformat=%f:%l:%c:\ %t%n\ %m
