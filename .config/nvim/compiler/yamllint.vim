if exists("current_compiler")
  finish
endif
let current_compiler = "yamllint"

if exists(":CompilerSet") != 2		" older Vim always used :setlocal
  command -nargs=* CompilerSet setlocal <args>
endif

CompilerSet makeprg=yamllint\ --format\ parsable
CompilerSet errorformat=%f:%l:%c:\ [%tarning]\ %m,%f:%l:%c:\ [%trror]\ %m,%-G%.%#

" .gitlab-ci.yml:1:1: [warning] missing document start "---" (document-start)
" .gitlab-ci.yml:145:81: [error] line too long (97 > 80 characters) (line-length)
" .gitlab-ci.yml:147:81: [error] line too long (126 > 80 characters) (line-length)
" .gitlab-ci.yml:170:81: [error] line too long (93 > 80 characters) (line-length)
