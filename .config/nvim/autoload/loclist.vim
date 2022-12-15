function! loclist#jump(cmd) abort
  try
    execute a:cmd
  catch /E553/
    execute a:cmd ==# 'lnext' ? 'lfirst' : 'llast'
  endtry
  normal! zz
endfunction

function! loclist#open() abort
  try
    botright lwindow 5
  catch /E776/
  endtry
  if &buftype ==# 'quickfix'
    wincmd p
  endif
endfunction

function! s:isLocListOpen() abort
  return !empty(filter(getwininfo(), {_, win -> win.tabnr == tabpagenr() && win.quickfix == 1 && win.loclist == 1}))
endfunction

function! loclist#toggle() abort
  if <SID>isLocListOpen()
    lclose
    return
  endif
  call loclist#open()
endfunction
