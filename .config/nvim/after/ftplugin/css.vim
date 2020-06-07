setlocal softtabstop=2 shiftwidth=2
let b:vsc_completion_command = "\<C-x>\<C-o>"

setlocal formatprg=prettier\ --parser=css

nnoremap <buffer><silent> ]] :call search("^.*{$")<CR>
nnoremap <buffer><silent> [[ :call search("^.*{$", "b")<CR>
