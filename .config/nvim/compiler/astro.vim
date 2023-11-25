if exists('current_compiler')
  finish
endif
let current_compiler = 'astro'

if exists(':CompilerSet') != 2  " older Vim always used :setlocal
  command -nargs=* CompilerSet setlocal <args>
endif

CompilerSet makeprg=npx\ astro\ check\ \\\|\ strip-ansi
CompilerSet errorformat=
      \%f:%l:%c\ -\ %trror\ %m,
      \%f:%l:%c\ -\ %tarning\ %m,
      \%-G%.%#
