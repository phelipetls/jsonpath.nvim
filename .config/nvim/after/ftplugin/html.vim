let g:html_indent_script1 = 'inc'
let g:html_indent_style1 = 'inc'

if executable('npx')
  set formatprg=npx\ prettier\ --stdin-filepath\ %
endif

if has('darwin')
  nnoremap <silent><buffer> <F5> :silent !open "%" &<CR>
elseif has('unix')
  nnoremap <silent><buffer> <F5> :silent !xdg-open "%" &<CR>
elseif has('wsl')
  nnoremap <silent><buffer> <F5> :silent !wslview "%" &<CR>
endif
