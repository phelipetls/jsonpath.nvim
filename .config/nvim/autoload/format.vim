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

function! format#file(forceformatprg) abort
  let bang = get(a:, 0, 0)

  let w:view = winsaveview()
  keepjumps normal! gg

  if a:forceformatprg
    let oldformatexpr = &l:formatexpr
    let &l:formatexpr = ''

    keepjumps normal! gqG

    let &l:formatexpr = oldformatexpr
  else
    set operatorfunc=format#operatorfunc
    keepjumps normal! g@G
  end

  if v:shell_error > 0
    call <SID>HandleError()
  endif

  keepjumps call winrestview(w:view)
  unlet w:view
endfunction
