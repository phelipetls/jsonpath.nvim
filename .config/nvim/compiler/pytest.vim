if exists("current_compiler")
  finish
endif
let current_compiler = "pytest"

if exists(":CompilerSet") != 2		" older Vim always used :setlocal
  command -nargs=* CompilerSet setlocal <args>
endif

CompilerSet makeprg=pytest\ -s\ --tb=native\ %
CompilerSet errorformat=\%C\ %.%#,
      \%EE\ %\\{5}File\ \"%f\"\\,\ line\ %l,
      \%CE\ %\\{3}%p^,
      \%CE\ %\\{5}%.%#,
      \%A\ \ File\ \"%f\"\\,\ line\ %l\\,\ in\ %o,
      \%+Z%[%^\/]%\\+:%m,
      \%+G\ %[+>-]%.%#,
      \%-G%.%#,
