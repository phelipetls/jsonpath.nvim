function! tsserver#Rename(old, new) abort
  call luaeval('require"tsserver_utils".rename_file(_A)', [a:old, a:new])
endfunction
