" unmap all default mappings
let g:dirvish_dovish_map_keys = 0

nnoremap <silent><buffer>
        \ gh :silent keeppatterns g@\v/\.[^\/]+/?$@d _<cr>:setl cole=3<cr>

nmap <silent><buffer> st :call Sort("t")<CR>

function! g:DovishDelete(target) abort
  if isdirectory(a:target)
    return printf('rmdir %s', a:target)
  else
    return printf('rm %s', a:target)
  endif
endfunction

function! g:DovishRename(old, new) abort
  call luaeval('require"tsserver_utils".rename_file(_A)', [a:old, a:new])
  return printf('mv %s %s', a:old, a:new)
endfunction

nmap <silent><buffer> % <Plug>(dovish_create_file)
nmap <silent><nowait><buffer> d <Plug>(dovish_create_directory)
nmap <silent><buffer> D <Plug>(dovish_delete)
nmap <silent><buffer> R <Plug>(dovish_rename)
nmap <silent><buffer> yy <Plug>(dovish_yank)
nmap <silent><buffer> p <Plug>(dovish_copy)
nmap <silent><buffer> P <Plug>(dovish_move)
