if exists("current_compiler")
  finish
endif
let current_compiler = "hugo"

if exists(":CompilerSet") != 2		" older Vim always used :setlocal
  command -nargs=* CompilerSet setlocal <args>
endif

CompilerSet makeprg=hugo
CompilerSet errorformat=%.%#file\ \"%f\"\\,\ line\ %l\\,\ col\ %c:%m,
      \ERROR%.%#\"%f:%l:%c\":\ %m,
      \ERROR.....................%m,
      \%-G,
      \%-G%.%#
