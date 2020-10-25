" create file with %
nnoremap <buffer> % :e %

" keep folders at the top
let g:dirvish_mode = ':sort ,^.*[\/],'

nnoremap <silent><buffer>
        \ gh :silent keeppatterns g@\v/\.[^\/]+/?$@d _<cr>:setl cole=3<cr>

nnoremap <silent><buffer>
        \ gr :<C-U>Dirvish %<CR>

" create directory with d
if !exists("*CreateDirectory")
  function! CreateDirectory()
    let input_opts = {"prompt": "Directory: ", "completion": "dir"}
    let dir = input(input_opts)
    call mkdir(expand("%").dir, "p")
    norm gr
  endfunction
endif

nnoremap <nowait><buffer> d :call CreateDirectory()<CR>

if !exists("*Rename")
  function! Rename()
    let full_path = expand("<cWORD>")
    let dir = fnamemodify(full_path, ":h") . "/"
    let old_name = fnamemodify(full_path, ":t")
    let input_opts = {"prompt": "New name: ", "completion": "file", "default": old_name}
    let new_name = input(input_opts)
    if new_name =~ "^\s*$"
      return
    endif
    call rename(full_path, dir . new_name)
    norm gr
  endfunction
endif

nnoremap <buffer> R :call Rename()<CR>
