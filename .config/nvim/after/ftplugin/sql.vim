let g:sql_type_default = 'mysql'

setl omnifunc=syntaxcomplete#Complete

setl shiftwidth=2 softtabstop=2

if executable('sqlformat')
  setl formatprg=sqlformat\ -k\ upper\ -s\ -
endif
