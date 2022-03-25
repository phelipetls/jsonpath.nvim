if exists('current_compiler')
  finish
endif
let current_compiler = 'jshint'

if exists(':CompilerSet') != 2  " older Vim always used :setlocal
  command -nargs=* CompilerSet setlocal <args>
endif

CompilerSet makeprg=jshint
CompilerSet errorformat=%f:\ line\ %l\\,\ col\ %c\\,\ %m,%-G%.%#

" app.js: line 2, col 1, 'const' is available in ES6 (use 'esversion: 6') or Mozilla JS extensions (use moz).
