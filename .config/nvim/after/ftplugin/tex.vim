"{{{ general settings

" minimal syntax highlighting
let g:tex_fast = ""

" set default tex flavor
let g:tex_flavor = "latex"

" don't highlight errors
let g:tex_no_error=1

" faster syntax highlight
syn sync maxlines=200
syn sync minlines=50

" search included files when completing
setlocal complete+=i

" clean auxiliary files on exit
autocmd! VimLeavePre *.tex silent !latexmk -c %

" find .bib file
nnoremap gb :find *.bib<Tab><CR>

setlocal textwidth=80

compiler tex

"}}}
"{{{ list formatting

setlocal formatoptions+=n
setlocal formatlistpat=^\\\s*\\\\item\\s*

"}}}
"{{{ spell checking

setlocal spell spelllang=pt,en_us
let g:tex_comment_nospell=1

"}}}
"{{{ simple table of contents

nnoremap gO :vimgrep /\\[a-z]*section{/j %<CR>:cw 10<CR>

"}}}}
"{{{ start and stop compilation

nnoremap <space>ll :lua require'tex'.latexmk()<CR>
nnoremap <space>lc :lua require'tex'.close_latexmk()<CR>

if executable("latexmk")
  autocmd! VimLeavePre <buffer> lua require'tex'.close_latexmk()
endif

"}}}
"{{{ zathura / vimtex integration

if executable("zathura")
  nnoremap <buffer><silent> <space>op :silent !zathura %<.pdf<CR>

  nnoremap <silent> <space>lv :execute ":silent !zathura --synctex-forward " .
        \ line(".") . ":" .
        \ col(".") . ":" .
        \ expand("%:t") . " " .
        \ expand("%:r") . ".pdf"<CR>
endif

"}}}
"{{{ navigation

nnoremap <buffer><silent> ]] :call search("\\\\.*section{", 'w')<CR>
nnoremap <buffer><silent> [[ :call search("\\\\[a-z]*section{", 'wb')<CR>

"}}}
