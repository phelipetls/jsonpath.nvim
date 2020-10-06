" create file with %
nnoremap <buffer> % :e %/

" create directory with d
if !exists("*CreateDirectory")
  function! CreateDirectory()
    let input_opts = {"prompt": "Directory: ", "completion": "dir"}
    let dir = input(input_opts)
    call mkdir(expand("%").dir, "p")
    norm R
  endfunction
endif

nnoremap <nowait><buffer> d :call CreateDirectory()<CR>

" keep folders at the top
sort ,^.*[\/],
