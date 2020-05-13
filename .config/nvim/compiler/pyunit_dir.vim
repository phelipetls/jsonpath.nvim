if exists("current_compiler")
  finish
endif
let current_compiler = "pyunit"

if exists(":CompilerSet") != 2		" older Vim always used :setlocal
  command -nargs=* CompilerSet setlocal <args>
endif

CompilerSet makeprg=python3\ -m\ unittest\ discover\ -s\ tests\ -p\ \"test_*.py\"
CompilerSet errorformat=%C\ %.%#,%A\ \ File\ \"%f\"\\,\ line\ %l%.%#,%Z%[%^\ ]%\\@=%m
