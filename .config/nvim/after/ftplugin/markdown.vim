setlocal spell spelllang=pt,en_us
setlocal iskeyword+='

let b:completion_command = "\<C-n>"

" allow syntax highlight inside code blocks for these languages
let g:markdown_fenced_languages = ['python', 'js=javascript']

" open pdf with the same filename - to use with pandoc
if executable("zathura")
  nnoremap <F5> :!zathura %<.pdf<CR>
endif

" format with markdown github style using pandoc
if executable("pandoc")
  setlocal formatprg=pandoc\ -f\ gfm\ -t\ gfm
endif

let b:surround_{char2nr("c")} = "```\r\n```"
let b:surround_{char2nr("l")} = "[\r](\1link: \1)"
let b:surround_{char2nr("s")} = "{{< \1shortcode: \1 >}}\r\n{{< /\1\1 >}}"
let b:surround_{char2nr("8")} = "*\r*"
let b:surround_{char2nr("*")} = "**\r**"

setl conceallevel=0

let b:match_words = b:match_words.'^```.\+$:^```$'

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
