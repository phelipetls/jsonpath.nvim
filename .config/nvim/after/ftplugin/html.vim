"{{{ indentation

setl softtabstop=2 shiftwidth=2

let g:html_indent_script1 = "inc"
let g:html_indent_style1 = "inc"

"}}}
"{{{ surround

" got from https://code.djangoproject.com/wiki/UsingVimWithDjango
let b:surround_{char2nr("{")} = "{{ \r }}"
let b:surround_{char2nr("%")} = "{% \r %}"
let b:surround_{char2nr("f")} = "{% for \1for loop: \1 %}\r{% endfor %}"
let b:surround_{char2nr("c")} = "{% comment %}\r{% endcomment %}"

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

let b:vsc_completion_command="\<C-x>\<C-o>"

"}}}
