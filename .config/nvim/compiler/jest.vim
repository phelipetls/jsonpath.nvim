if exists("current_compiler")
  finish
endif
let current_compiler = "jest"

if exists(":CompilerSet") != 2		" older Vim always used :setlocal
  command -nargs=* CompilerSet setlocal <args>
endif

CompilerSet makeprg=jest\ --no-cache
CompilerSet errorformat=%E%.%#SyntaxError:\ %f:\ %m\ (%l:%c),
      \%E%.%#●\ %m,
      \%Z%.%[\ ]at\ %.%#\ (%f:%l:%c),
      \%C%.%#,
      \%-G%.%#

" let &efm = '%-G%[%^ ]%.%#,' .
"       \ '%-G%.%#Test suite failed to run,' .
"       \ '%E%.%#SyntaxError: %f: %m (%l:%c),' .
"       \ '%E%.%#● %m,' .
"       \ '%Z%.%#at %.%# (%f:%l:%c),' .
"       \ '%C%.%#,' .
"       \ '%-G%.%#'

" FAIL ./sum.test.js
"   ● adds 1 + 2 to equal 3

"     expect(received).toBe(expected) // Object.is equality

"     Expected: 3
"     Received: -1

"       2 |
"       3 | test('adds 1 + 2 to equal 3', () => {
"     > 4 |   expect(sum(1, 2)).toBe(3);
"         |                     ^
"       5 | });
"       6 |
"       7 |

"       at Object.<anonymous> (sum.test.js:4:21)

" Test Suites: 1 failed, 1 total
" Tests:       1 failed, 1 total
" Snapshots:   0 total
" Time:        0.664 s
