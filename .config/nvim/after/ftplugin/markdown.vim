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
  nnoremap <F5> :!zathura %<.pdf<CR>
endif

"}}}
"{{{ formatting

" format with markdown github style using pandoc
if executable("pandoc")
  setlocal formatprg=pandoc\ -f\ gfm\ -t\ gfm
endif

"}}}
"{{{ surround

let b:surround_{char2nr("P")} = "```python\n\r\n```"
let b:surround_{char2nr("R")} = "```r\n\r\n```"
let b:surround_{char2nr("l")} = "[\r](\1link: \1)"

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
"{{{ completion

let b:completion_command = "\<C-n>"

"}}}
