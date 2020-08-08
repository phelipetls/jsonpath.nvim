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

let b:vsc_completion_command = "\<C-x>\<C-o>"
let b:vsc_type_complete_length = 1

function! RunEmmetAfterCompletion()
  if complete_info(["mode"]).mode == "omni" &&
        \ complete_info(["pum_visible"]).pum_visible &&
        \ &omnifunc == "emmet#completeTag"
    call feedkeys("\<C-c>\<C-e>,", "i")
  endif
endfunction

inoremap <silent><expr> <space> pumvisible() ? "\<C-y>" : "\<space>"

autocmd! CompleteDonePre *.html call RunEmmetAfterCompletion()

"}}}
