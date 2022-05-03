if exists('current_compiler')
  finish
endif
let current_compiler = 'jest'

if exists(':CompilerSet') != 2  " older Vim always used :setlocal
  command -nargs=* CompilerSet setlocal <args>
endif

CompilerSet makeprg=CI=true\ npx\ jest\ $*

CompilerSet errorformat=
      \%E\ \ ●\ %m,
      \%Z\ \ \ \ \ \ at\ %s\ (%f:%l:%c),
      \%Z\ \ \ \ %.%#Error:\ %f:\ %m\ (%l:%c):%\\=,
      \%+C\ \ \ \ Expected:\ %m,
      \%+C\ \ \ \ Received:\ %m,
      \%C%.%#,
      \%-G%.%#

" errorformat in upstream Vim, not yet in Neovim
" %E\ \ ●\ %m,
" \%Z\ %\\{4}%.%#Error:\ %f:\ %m\ (%l:%c):%\\=,
" \%Z\ %\\{6}at\ %\\S%#\ (%f:%l:%c),
" \%+C\ %\\{4}%\\w%.%#,
" \%+C\ %\\{4}%[-+]%.%#,
" \%-C%.%#,
" \%-G%.%#

" FAIL src/api/utils.test.js
"   ✓ handling offsetting by days (3ms)
"   ✓ handling offsetting by months
"   ✕ handling offsetting by quarters (2ms)

"   ● handling offsetting by quarters

"     expect(received).toStrictEqual(expected) // deep equality

"     Expected: 2020-01-01T00:00:00.000Z
"     Received: 2020-01-01T03:00:00.000Z

"       20 |
"       21 | test("handling offsetting by quarters", () => {
"     > 22 |   expect(getDateOffset(DATE, -1, "Trimestral")).toStrictEqual(
"          |                                                 ^
"       23 |     new Date("2020-01-01")
"       24 |   );
"       25 |

"       at Object.<anonymous> (src/api/utils.test.js:22:49)
