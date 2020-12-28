setlocal shiftwidth=2 softtabstop=2

if executable("jest") && match(expand("%:p:t"), "test.js") != -1
  compiler jest
elseif executable("eslint_d")
  compiler eslint_d
elseif executable("eslint")
  compiler eslint
endif

if executable("node")
  noremap <buffer> <F5> :w !node<CR>
endif

if executable("prettier")
  let &l:formatprg='prettier --parser typescript'
endif

" if executable("eslint_d")
"   let &l:formatprg='eslint_d --stdin --fix-to-stdout'
" endif

let b:surround_{char2nr("c")} = "console.log(\r)"
let b:surround_{char2nr("e")} = "${\r}"
let b:surround_{char2nr("i")} = 'import { \r } from "./\r"'

iabbr <buffer><silent> clog console.log();<Left><Left><C-R>=Eatchar('\s')<CR>
iabbr consoel console
iabbr lenght length
iabbr edf export default function
iabbr improt import
iabbr Obejct Object
iabbr entires entries
iabbr mui import { } from "@material-ui/";<Left><Left>
iabbr ireact import React from "react";

nnoremap <buffer> [<C-c> "zyiwOconsole.log(z);<Esc>
nnoremap <buffer> ]<C-c> "zyiwoconsole.log(z);<Esc>

if executable("firefox")
  setlocal keywordprg=firefox\ https://developer.mozilla.org/search?topic=api\\&topic=js\\&q=\
endif

function! RemoveFileExtension()
  let info = complete_info(['mode', 'items', 'selected'])
  if info.mode != "files"
    return
  endif
  if empty(v:completed_item)
    return
  endif
  if info.selected == -1
    return
  endif
  let fname = info.items[info.selected].word
  if fname !~ '.*.[jt]sx\?$'
    return
  endif
  let fname_without_extension = substitute(fname, '\.[jt]sx\?$', "", "")
  call setline(".", substitute(getline("."), fname, fname_without_extension, ''))
endfunction

autocmd! CompleteDonePre <buffer> call RemoveFileExtension()
