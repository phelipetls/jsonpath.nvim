if exists('current_compiler')
  finish
endif
let current_compiler = 'flake8'

if exists(':CompilerSet') != 2  " older Vim always used :setlocal
  command -nargs=* CompilerSet setlocal <args>
endif

CompilerSet makeprg=npx\ playwright\ test\ $*\ \\\|\ strip-ansi
CompilerSet errorformat=%E\ \ %*\\d)\ %.%#\ ›\ %o:%l:%c%.%#,%C\ \ \ \ Error:\ %m,%Z%*[\ ]at\ %f:%*\\d:%*\\d,%+C%*[\ ]Expected%.%#,%+C%*[\ ]Received%.%#,%C%.%#,%-G%.%#

" Running 2 tests using 2 workers

" [1/2] [chromium] › copy-code.spec.ts:9:9 › Copy code › With permission to write to clipboard › should copy code block on button click
" [2/2] [firefox] › copy-code.spec.ts:9:9 › Copy code › With permission to write to clipboard › should copy code block on button click
"   1) [chromium] › copy-code.spec.ts:9:9 › Copy code › With permission to write to clipboard › should copy code block on button click 

"     Error: Timed out 5000ms waiting for expect(received).toHaveAttribute(expected)

"     Expected string: "Copied!"
"     Received string: "Copy code"
"     Call log:
"       - expect.toHaveAttribute with timeout 5000ms
"       - waiting for locator('[data-copy-codeblock-button]').first()
"       -   locator resolved to <button type="button" aria-label="Copy code" data-copy-c…>…</button>
"       -   unexpected value "Copy code"
"       -   locator resolved to <button type="button" aria-label="Copy code" data-copy-c…>…</button>
"       -   unexpected value "Copy code"
"       -   locator resolved to <button type="button" aria-label="Copy code" data-copy-c…>…</button>
"       -   unexpected value "Copy code"
"       -   locator resolved to <button type="button" aria-label="Copy code" data-copy-c…>…</button>
"       -   unexpected value "Copy code"
"       -   locator resolved to <button type="button" aria-label="Copy code" data-copy-c…>…</button>
"       -   unexpected value "Copy code"
"       -   locator resolved to <button type="button" aria-label="Copy code" data-copy-c…>…</button>
"       -   unexpected value "Copy code"
"       -   locator resolved to <button type="button" aria-label="Copy code" data-copy-c…>…</button>
"       -   unexpected value "Copy code"
"       -   locator resolved to <button type="button" aria-label="Copy code" data-copy-c…>…</button>
"       -   unexpected value "Copy code"
"       -   locator resolved to <button type="button" aria-label="Copy code" data-copy-c…>…</button>
"       -   unexpected value "Copy code"


"       13 |       await expect(
"       14 |         page.locator('[data-copy-codeblock-button]').first()
"     > 15 |       ).toHaveAttribute('aria-label', 'Copied!')
"          |         ^
"       16 |     })
"       17 |   })
"       18 |

"         at /home/phelipe/Projetos/blog/tests/copy-code.spec.ts:15:9


"   1 failed
"     [chromium] › copy-code.spec.ts:9:9 › Copy code › With permission to write to clipboard › should copy code block on button click 
"   1 skipped
