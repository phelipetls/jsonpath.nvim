let g:sql_type_default = 'mysql'

setl omnifunc=syntaxcomplete#Complete

function! SqlAutoComplete()
  if v:char =~ "\k"
    call feedkeys("\<C-x>\<C-o>", "i")
  endif
endfunction

autocmd! InsertCharPre *.sql call SqlAutoComplete()

setl shiftwidth=2 softtabstop=2

if executable('sqlformat')
  setl formatprg=sqlformat\ -k\ upper\ -s\ -
endif
