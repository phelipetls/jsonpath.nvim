function! iwhite#toggle() abort
  if &diffopt =~# 'iwhite'
    set diffopt-=iwhite
  else
    set diffopt+=iwhite
  endif
endfunction
