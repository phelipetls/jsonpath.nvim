" minimal syntax highlighting
let g:tex_fast = ''

" set default tex flavor
let g:tex_flavor = 'latex'

" don't highlight errors
let g:tex_no_error=1

" faster syntax highlight
syn sync maxlines=200
syn sync minlines=50

" search included files when completing
setlocal complete+=i

setlocal textwidth=80

setlocal formatlistpat=^\\\s*\\\\item\\s*

setlocal spell spelllang=pt,en_us
let g:tex_comment_nospell=1

" activate latexmk compiler
compiler latexmk

if executable('zathura')
  " open document with zathura
  nnoremap <buffer><silent> <F5> :silent !zathura %<.pdf<CR>

  " synctex forward (go from line in vim to pdf)
  nnoremap <buffer><silent> <space><space> :execute ":silent !zathura --synctex-forward " .
        \ line(".") . ":" .
        \ col(".") . ":" .
        \ expand("%:t") . " " .
        \ expand("%:r") . ".pdf"<CR>
endif
