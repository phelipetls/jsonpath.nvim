if exists('current_compiler')
  finish
endif
let current_compiler = 'astro'

if exists(':CompilerSet') != 2  " older Vim always used :setlocal
  command -nargs=* CompilerSet setlocal <args>
endif

CompilerSet makeprg=npx\ astro\ check
CompilerSet errorformat=%f:%l:%c\ %trror:\ %m,%-G%.%#

" /home/phelipe/Projetos/astro/src/components/BlogPostDate.astro:10:5 Error: This condition will always return 'false' since the types '(pathname: string) => Language' and 'string' have no overlap.
