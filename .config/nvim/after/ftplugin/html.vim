let g:html_indent_script1 = 'inc'
let g:html_indent_style1 = 'inc'

if executable('prettier')
  set formatprg=prettier\ --parser\ html
endif

if has('darwin')
  nnoremap <silent><buffer> <F5> :silent !open "%" &<CR>
elseif has('unix')
  nnoremap <silent><buffer> <F5> :silent !xdg-open "%" &<CR>
endif
