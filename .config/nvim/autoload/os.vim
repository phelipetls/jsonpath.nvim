function! os#get_open_command() abort
  let s:open_command = ''

  if has('mac')
    let s:open_command = 'open'
  elseif has('wsl')
    let s:open_command = 'wslview'
  elseif has('unix')
    let s:open_command = 'xdg-open'
  endif

  if empty(s:open_command)
    echohl ErrorMsg
    echo 'Could not determine a command to open file'
    echohl None
    return ''
  endif

  return s:open_command
endfunction
