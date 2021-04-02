function! tsserver#Rename(old, new) abort
  call luaeval('require"tsserver_utils".rename_file(_A[1],_A[2])', [a:old, a:new])
endfunction
