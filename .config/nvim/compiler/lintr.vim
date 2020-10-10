if exists("current_compiler")
  finish
endif
let current_compiler = "lintr"

if exists(":CompilerSet") != 2		" older Vim always used :setlocal
  command -nargs=* CompilerSet setlocal <args>
endif

" FIXME: create a script for that
CompilerSet makeprg=Rscript\ -e\ \"lintr::lint(%:S)\"
CompilerSet errorformat=%W%f:%l:%c:\ warning:\ %m " start of warning message
CompilerSet errorformat+=%E%f:%l:%c:\ error:\ %m  " error message
CompilerSet errorformat+=%I%f:%l:%c:\ style:\ %m  " style message (as info)
CompilerSet errorformat+=%-G%.%#                  " ignore anything else
