if exists("current_compiler")
  finish
endif
let current_compiler = "eslint_d"

if exists(":CompilerSet") != 2		" older Vim always used :setlocal
  command -nargs=* CompilerSet setlocal <args>
endif

CompilerSet makeprg=eslint_d\ --format=unix
CompilerSet errorformat=%f:%l:%c:\ %m,%-G%.%#

" /home/phelipe/snap/exercism/5/exercism/javascript/wordy/wordy.js: line 81, col 3, Error - Parsing error: Unexpected token, expected "{"
