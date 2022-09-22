function! gitblame#BlameLine() abort
  let l:fullpath = expand('%:p')
  let l:revision = 'HEAD'

  if l:fullpath =~# '^fugitive://'
    let l:fullpath = FugitiveReal()

    let l:fugitive_parsed = FugitiveParse()

    if !empty(l:fugitive_parsed)
      let l:commitfile = l:fugitive_parsed[0]
      let l:revision = matchstr(l:commitfile, '\x\+')
    else
      echohl ErrorMsg
      echomsg 'Unexpected empty list returned by FugitiveParse'
      echohl None
      return
    endif
  endif

  let l:result = FugitiveExecute(
        \ 'blame',
        \ '--porcelain',
        \ '-L', printf('%s,+1', line('.')),
        \ l:revision,
        \ '--',
        \ l:fullpath
        \ )

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
