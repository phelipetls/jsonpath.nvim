if exists("current_compiler")
  finish
endif
let current_compiler = "mypy"

if exists(":CompilerSet") != 2		" older Vim always used :setlocal
  command -nargs=* CompilerSet setlocal <args>
endif

CompilerSet makeprg=mypy\ --show-column-numbers\ --show-absolute-path
CompilerSet errorformat=%f:%l:%c:\ %t%s:\ %m,%-G%.%#

" seriesbr/ipea/series.py:49: note:     error message
