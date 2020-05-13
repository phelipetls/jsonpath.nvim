if exists("current_compiler")
  finish
endif
let current_compiler = "latex"

if exists(":CompilerSet") != 2		" older Vim always used :setlocal
  command -nargs=* CompilerSet setlocal <args>
endif

CompilerSet makeprg=latexmk\ -pv\ %
CompilerSet errorformat+=%f:%l:\ %m,%-G%.%#,
    \%E!\ LaTeX\ %trror:\ %m,
    \%W!\ LaTeX\ %tarning:\ %m,
    \%+WLaTeX\ %.%#Warning:\ %.%#line\ %l%.%#,
    \%+W%.%#\ at\ lines\ %l--%*\\d,
    \%W!Package\ %.%#\ Warning:\ %m,
    \%E!Package\ %.%#\ Warning:\ %m
