if exists("current_compiler")
  finish
endif
let current_compiler = "pytest"

if exists(":CompilerSet") != 2		" older Vim always used :setlocal
  command -nargs=* CompilerSet setlocal <args>
endif

CompilerSet makeprg=pytest\ -s\ --tb=native\ %
CompilerSet errorformat=\%C\ %.%#,
      \%CE\ %\\{3}%p^,
      \%CE\ %\\{5}%.%#,
      \%EE\ %\\{5}File\ \"%f\"\\,\ line\ %l,
      \%ZE\ %\\{3}%m,
      \%A\ \ File\ \"%f\"\\,\ line\ %l\\,\ in\ %o,
      \%Z%\\C%[A-Z]%\\@=%m,
      \%C%f:%l:\ in\ %o,
      \%E%f:%l:\ in\ %o,
      \%+G\ %[+>-]%.%#,
      \%-G%.%#,
