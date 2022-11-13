setlocal spell spelllang=pt,en_us
setlocal iskeyword+='

" allow syntax highlight inside code blocks for these languages
let g:markdown_fenced_languages = [
      \ 'vim',
      \ 'python',
      \ 'javascript',
      \ 'js=javascript',
      \ 'jsx=javascriptreact',
      \ 'typescript',
      \ 'ts=typescript',
      \ 'tsx=typescriptreact',
      \ ]

let b:surround_{char2nr('c')} = "```\r\n```"
let b:surround_{char2nr('l')} = "[\r](\1link: \1)"
let b:surround_{char2nr('8')} = "*\r*"
let b:surround_{char2nr('*')} = "**\r**"

setl conceallevel=0

let b:match_words = get(b:, 'match_words', '') . ',^```.\+$:^```$'

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
