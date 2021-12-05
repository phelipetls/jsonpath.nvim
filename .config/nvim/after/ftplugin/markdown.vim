setlocal spell spelllang=pt,en_us
setlocal iskeyword+='

" allow syntax highlight inside code blocks for these languages
let g:markdown_fenced_languages = ['python', 'js=javascript']

" open pdf with the same filename - to use with pandoc
if executable('zathura')
  nnoremap <space>op :!zathura %<.pdf<CR>
  nnoremap <space>oh :!firefox %<.html<CR>
endif

" format with markdown github style using pandoc
if executable('pandoc')
  setlocal formatprg=pandoc\ -f\ gfm\ -t\ gfm
endif

let b:surround_{char2nr("c")} = "```\r\n```"
let b:surround_{char2nr("l")} = "[\r](\1link: \1)"
let b:surround_{char2nr("s")} = "{{< \1shortcode: \1 >}}\r\n{{< /\1\1 >}}"
let b:surround_{char2nr("8")} = "*\r*"
let b:surround_{char2nr("*")} = "**\r**"

setl conceallevel=0

let b:match_words = b:match_words . ',^```.\+$:^```$'

" code block text object
" ----------------------
function! SelectCodeBlock(inner)
  call search('^```.\+', 'bcW')
  execute 'normal ' . (a:inner ==# 'i' ? 'jv' : 'v')
  call search('^```$', 'cW')
  execute 'normal ' . (a:inner ==# 'i' ? 'k$' : '$')
endfunction

xnoremap <silent> ac :<C-u>call SelectCodeBlock("a")<CR>
onoremap <silent> ac :<C-u>normal vac<CR>
xnoremap <silent> ic :<C-u>call SelectCodeBlock("i")<CR>
onoremap <silent> ic :<C-u>normal vic<CR>
