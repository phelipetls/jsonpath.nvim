if exists("current_compiler")
  finish
endif
let current_compiler = "pytest"

if exists(":CompilerSet") != 2		" older Vim always used :setlocal
  command -nargs=* CompilerSet setlocal <args>
endif

CompilerSet makeprg=jest\ --no-cache\ -t\ ./*
CompilerSet errorformat=%C\ \ \%m,%A\ \ \ \ \ at\ %.%#\ (%f:%l:%c)


  " ● Test suite failed to run

  "   ReferenceError: operator_description is not defined

  "     18 |   question = question.replace("?", "")
  "     19 |
  "   > 20 |   for ([operator_description, math_operator] of Object.entries(OPERATORS)) {
  "        |         ^
  "     21 |     question = question.replace(operator_description, math_operator)
  "     22 |   }
  "     23 |

  "     at answer (wordy.js:20:9)
  "     at Object.<anonymous> (wordy.js:27:13)
  "     at Object.<anonymous> (wordy.spec.js:1:1)

" Test Suites: 1 failed, 1 total
" Tests:       0 total
" Snapshots:   0 total
" Time:        0.825s
" Ran all test suites with tests matching "wordy.js".

