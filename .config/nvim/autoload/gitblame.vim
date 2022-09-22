function! gitblame#BlameLine() abort
  let l:line = line('.')
  let l:fullpath = expand('%:p')
  let l:result = FugitiveExecute('blame', '--porcelain', printf('-L %s,%s', l:line, l:line), l:fullpath)

  if l:result.exit_status > 0
    echohl ErrorMsg
    echomsg 'Failed to run git blame: ' l:result.stderr[0]
    echohl None
    return
  endif

  let l:stdout = l:result.stdout
  if empty(l:stdout)
    return
  endif

  let l:firstline = l:stdout[0]

  let l:commit = matchstr(l:firstline, '\x\+')
  if empty(l:commit)
    return
  endif

  if l:commit =~# '^0\+$'
    echomsg 'Not Commmitted Yet'
    return
  endif

  execute fugitive#Open('pedit', 0, '', l:commit, [])
endfunction
