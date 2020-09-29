if exists("current_compiler")
  finish
endif
let current_compiler = "jest"

if exists(":CompilerSet") != 2		" older Vim always used :setlocal
  command -nargs=* CompilerSet setlocal <args>
endif

CompilerSet makeprg=npm\ run\ test\ %

CompilerSet errorformat=
      \%A%.%#●\ %o,
      \%C\ %\\+at\ %s\ (%f:%l:%c),
      \%C\ %\\+>\ %l\ \|%m,
      \%C%.%#,
      \%-G%.%#

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
