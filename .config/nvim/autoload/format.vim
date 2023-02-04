function! s:HandleError() abort
  keepjumps silent undo
  echohl ErrorMsg
  echomsg 'formatprg "' . &formatprg . '" exited with status ' . v:shell_error
  echohl None
endfunction

function! format#operatorfunc(type, ...) abort
  silent noautocmd keepjumps normal! '[v']gq

  if v:shell_error > 0
    call <SID>HandleError()
  endif
endfunction

function! format#file() abort
  let w:view = winsaveview()
  keepjumps normal! gg

  let oldformatexpr = &l:formatexpr
  let &l:formatexpr = ''

  set operatorfunc=format#operatorfunc
  keepjumps normal! g@G

  if v:shell_error > 0
    call <SID>HandleError()
  endif

  let &l:formatexpr = oldformatexpr
  keepjumps call winrestview(w:view)
  unlet w:view
endfunction
