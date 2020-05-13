if exists("current_compiler")
  finish
endif
let current_compiler = "run"

if exists(":CompilerSet") != 2		" older Vim always used :setlocal
  command -nargs=* CompilerSet setlocal <args>
endif

CompilerSet makeprg=Rscript\ -e\ \"rmarkdown::render\(%:S\)\"
CompilerSet errorformat=%AQuitting\ from\ lines\ %l-%*\\d\ %.%#,
CompilerSet errorformat+=%CError\ in\ %[%^:]%#:\ %m,\%+C\ \ %m
CompilerSet errorformat+=%Z\ \ %m
CompilerSet errorformat+=%-G%.%#

" Quitting from lines 10-27 (testes_de_raiz_unitaria.rmd)
" Error in eval(parse_only(code), envir = envir) :
"   objeto 'series' não encontrado
" Calls: <Anonymous> ... inline_exec -> hook_eval -> withVisible -> eval -> eval
