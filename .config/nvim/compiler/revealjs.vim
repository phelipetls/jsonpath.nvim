
if exists("current_compiler")
  finish
endif
let current_compiler = "chktex"

if exists(":CompilerSet") != 2		" older Vim always used :setlocal
  command -nargs=* CompilerSet setlocal <args>
endif

CompilerSet makeprg=pandoc\ -f\ markdown\ -t\ revealjs\ -s\ -o\ %<.html\ %
