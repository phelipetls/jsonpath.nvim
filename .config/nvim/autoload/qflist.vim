function! qflist#jump(cmd) abort
  try
    execute a:cmd
  catch /E553/
    execute a:cmd ==# 'cnext' ? 'cfirst' : 'clast'
  endtry
  normal! zz
endfunction

function! qflist#open() abort
  botright cwindow 5
  if &buftype ==# 'quickfix'
    wincmd p
  endif
endfunction

function! s:isQfListOpen() abort
  return !empty(filter(getwininfo(), {_, win -> win.tabnr == tabpagenr() && win.quickfix == 1 && win.loclist == 0}))
endfunction

function! qflist#toggle() abort
  if <SID>isQfListOpen()
    cclose
    return
  endif
  call qflist#open()
endfunction
