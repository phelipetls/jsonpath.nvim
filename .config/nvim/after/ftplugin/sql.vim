packadd! vim-dadbod

let g:sql_type_default = 'postgresql'

setlocal commentstring=--\ %s

setlocal omnifunc=syntaxcomplete#Complete

if executable('sqlformat')
  setlocal formatprg=sqlformat\ --reindent\ --keywords=upper\ --identifiers=lower\ -s\ -
endif

nnoremap <F5> :%DB<CR>
vnoremap <F5> :'<,'>DB<CR>
