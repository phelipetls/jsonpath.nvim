if exists("current_compiler")
  finish
endif
let current_compiler = "latex"

if exists(":CompilerSet") != 2		" older Vim always used :setlocal
  command -nargs=* CompilerSet setlocal <args>
endif

CompilerSet makeprg=latexmk\ -pv
CompilerSet errorformat=%f:%l:\ %m,%-G%.%#
