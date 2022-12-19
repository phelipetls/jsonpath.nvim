function! format#operatorfunc(type, ...) abort
  if CocHasProvider('formatRange')
    call CocAction('formatSelected', a:type)
    return
  endif

  silent noautocmd keepjumps normal! '[v']gq

  if v:shell_error > 0
    keepjumps silent undo
    echohl ErrorMsg
    echomsg 'formatprg "' . &formatprg . '" exited with status ' . v:shell_error
    echohl None
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

  keepjumps call winrestview(w:view)
  unlet w:view
endfunction
