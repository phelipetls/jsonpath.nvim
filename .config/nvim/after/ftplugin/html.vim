let g:html_indent_script1 = 'inc'
let g:html_indent_style1 = 'inc'

if executable('npx')
  set formatprg=npx\ prettier\ --stdin-filepath\ %
endif
