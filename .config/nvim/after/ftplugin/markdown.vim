"{{{ settings

setlocal spell spelllang=pt,en_us

"}}}
"{{{ syntax highlighting

" allow syntax highlight inside code blocks for these languages
let g:markdown_fenced_languages = ['r', 'python', 'vim', 'js=javascript', 'lua', 'vb']

"}}}
"{{{ pdf

" open pdf with the same filename - to use with pandoc
if executable("zathura")
  nnoremap <space>op :!zathura %<.pdf<CR>
endif

"}}}
"{{{ formatting

" format with markdown github style using pandoc
if executable("pandoc")
  setlocal formatprg=pandoc\ -f\ gfm\ -t\ gfm
endif

"}}}
"{{{ surround

let b:surround_{char2nr("p")} = "``` python\r```"
let b:surround_{char2nr("r")} = "``` r\r```"

"}}}
"{{{ conceal

setl conceallevel=0

"}}}
"{{{ matchit

let b:match_words = '^```.\+$:^```$'

"}}}
"{{{ text objects

" code block text object
" ----------------------
function! SelectCodeBlock()
  call search('^```.\+', "bcW")
  normal jv
  call search('^```$', "cW")
  normal k$
endfunction

xnoremap ic :<C-u>call SelectCodeBlock()<CR>
onoremap ic :<C-u>normal vic<CR>

"}}}
