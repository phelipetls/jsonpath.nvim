if exists("current_compiler")
  finish
endif
let current_compiler = "pytest"

if exists(":CompilerSet") != 2		" older Vim always used :setlocal
  command -nargs=* CompilerSet setlocal <args>
endif

CompilerSet makeprg=pytest\ --tb=short\ -s\ -vv\ %
CompilerSet errorformat=
      \%-G=%\\+\ ERRORS\ =%\\+,
      \%-G_%\\+\ ERROR%.%#\ _%\\+,
      \%EE\ \ \ \ \ File\ \"%f\"\\,\ line\ %l,
      \%CE\ \ \ %p^,
      \%ZE\ \ \ %[%^\ ]%\\@=%m,
      \%CE\ %.%#,
      \%A_%\\+\ %o\ _%\\+,
      \%C%f:%l:\ in\ %o,
      \%C\ %.%#,
      \%ZE\ %\\{3}%m,
      \%EImportError%.%#\'%f\'\.,
      \%CE%\\@!%.%#,
      \%+G%[=]%\\+\ %*\\d\ passed%.%#,
      \%-G%[%^E!>]%.%#,
      \%-G

function! FixColumnNumber()
  if b:current_compiler != "pytest"
    return
  endif

  let qflist = getqflist()
  for i in qflist
    let i.col = i.col - 4
  endfor
  call setqflist(qflist)
endfunction

augroup FixPytestQuickFix
  au!
  autocmd QuickFixCmdPost <buffer> call FixColumnNumber()
augroup END
