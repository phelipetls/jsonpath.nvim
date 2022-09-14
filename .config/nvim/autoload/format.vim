function! format#operatorfunc(type, ...) abort
  if CocHasProvider('formatRange')
    call CocAction('formatSelected', a:type)
    return
  endif

  let motions = #{line: "'[V']", char: '`[v`]', block: '`[\<c-v>`]'}
  silent execute 'noautocmd keepjumps normal! ' . get(motions, a:type, '') . 'gq'

  if v:shell_error > 0
    keepjumps silent undo
    echohl ErrorMsg
    echomsg 'formatprg "' . &formatprg . '" exited with status ' . v:shell_error
    echohl None
  endif
endfunction

function! format#file() abort
  let w:view = winsaveview()
  keepjumps normal! gg
  set operatorfunc=format#operatorfunc
  keepjumps normal! g@G
  keepjumps call winrestview(w:view)
  unlet w:view
endfunction
