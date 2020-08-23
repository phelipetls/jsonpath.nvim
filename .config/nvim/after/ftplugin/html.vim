"{{{ indentation

setl softtabstop=2 shiftwidth=2

let g:html_indent_script1 = "inc"
let g:html_indent_style1 = "inc"

"}}}
"{{{ formatprg

if executable("prettier")
  set formatprg=prettier\ --parser\ html
endif

"}}}
"{{{ firefox

nnoremap <silent><buffer> <F5> :silent !firefox --new-window "%"<CR>

"}}}
"{{{ completion

setl omnifunc=emmet#completeTag

let b:completion_command = "\<C-x>\<C-o>"
let b:completion_length = 1

"}}}
"{{{ close tag

function! CloseTag()
  let b:old_omnifunc = &l:omnifunc
  set omnifunc=htmlcomplete#CompleteTags
  return "\<C-x>\<C-o>\<C-n>\<C-y>"
endfunction

function! Reindent()
  if (len(&indentexpr) || &cindent)
    return "\<C-F>"
  endif
  return ""
endfunction

function! Clean()
  let &l:omnifunc = b:old_omnifunc
  return ""
endfunction

inoremap <silent><buffer> <C-X>/ <Lt>/<C-r>=CloseTag()<CR><C-r>=Reindent()<CR><C-r>=Clean()<CR>

"}}}
