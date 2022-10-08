function! gitblame#BlameLine() abort
  if empty(FugitiveGitDir())
    echohl ErrorMsg
    echomsg 'not in a git repository'
    echohl None
    return
  endif

  let fullpath = expand('%:p')
  let revision = 'HEAD'

  if fullpath =~# '^fugitive://'
    let fullpath = FugitiveReal()

    let fugitive_parsed = FugitiveParse()

    if !empty(fugitive_parsed)
      let commitfile = fugitive_parsed[0]
      let revision = matchstr(commitfile, '\x\+')
    endif
  endif

  let diff_result = FugitiveExecute('diff', 'HEAD', '--exit-code', '--', fullpath)
  let is_different = diff_result.exit_status > 0

  let args = ['blame', '--porcelain', '-L', printf('%s,+1', line('.'))]

  if &modified || is_different
    let args += ['--contents', fullpath]
  else
    let args += [revision]
  endif

  let args += ['--', fullpath]

  let blame_result = call('FugitiveExecute', args)

  if blame_result.exit_status > 0
    echohl ErrorMsg
    echomsg 'git blame failed: ' blame_result.stderr[0]
    echohl None
    return
  endif

  let stdout = blame_result.stdout
  if empty(stdout)
    return
  endif

  let firstline = stdout[0]

  let commit = matchstr(firstline, '\x\+')
  if empty(commit)
    return
  endif

  if commit =~# '^0\+$'
    echomsg 'Not Commmitted Yet'
    return
  endif

  execute fugitive#Open('pedit', 0, '', commit, [])
endfunction
