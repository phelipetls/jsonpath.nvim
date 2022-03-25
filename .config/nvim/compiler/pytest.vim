if exists('current_compiler')
  finish
endif
let current_compiler = 'pytest'

if exists(':CompilerSet') != 2  " older Vim always used :setlocal
  command -nargs=* CompilerSet setlocal <args>
endif

CompilerSet makeprg=pytest\ --tb=short\ -vv\ $*
CompilerSet errorformat=
      \%EE\ \ \ \ \ File\ \"%f\"\\,\ line\ %l,
      \%CE\ \ \ %p^,
      \%ZE\ \ \ %[%^\ ]%\\@=%m,
      \%Afile\ %f\\,\ line\ %l,
      \%+ZE\ %mnot\ found,
      \%CE\ %.%#,
      \%-G_%\\+\ ERROR%.%#\ _%\\+,
      \%A_%\\+\ %o\ _%\\+,
      \%C%f:%l:\ in\ %o,
      \%ZE\ %\\{3}%m,
      \%EImportError%.%#\'%f\'\.,
      \%C%.%#,
      \%+G%[=]%\\+\ %*\\d\ passed%.%#,
      \%-G%[%^E]%.%#,
      \%-G

function! FixColumnNumber()
  if b:current_compiler !=? 'pytest'
    return
  endif

  let qflist = getqflist()
  for i in qflist
    let i.col = i.col + 1
  endfor
  call setqflist(qflist)
endfunction

augroup FixPytestQuickFix
  au!
  autocmd QuickFixCmdPost <buffer> call FixColumnNumber()
augroup END
