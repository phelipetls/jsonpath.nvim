if exists("current_compiler")
  finish
endif
let current_compiler = "cscript"

if exists(":CompilerSet") != 2		" older Vim always used :setlocal
  command -nargs=* CompilerSet setlocal <args>
endif

CompilerSet makeprg=cscript\ %
CompilerSet errorformat=%f(%l\\,\ %c)\ %m,%-G%.%#
