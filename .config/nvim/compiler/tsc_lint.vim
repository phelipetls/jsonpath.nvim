if exists("current_compiler")
  finish
endif
let current_compiler = "tsc_lint"

if exists(":CompilerSet") != 2		" older Vim always used :setlocal
  command -nargs=* CompilerSet setlocal <args>
endif

CompilerSet makeprg=npx\ tsc\ --noEmit\ --skipLibCheck\ -p\ .
CompilerSet errorformat=%A%f(%l\\,%c):\ %trror\ TS%n:\ %m,%C%m

" src/components/common/StyledKeyboardDatePicker.tsx(5,42): error TS7006: Parameter 'props' implicitly has an 'any' type.
