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

function! s:HandleOpenFileError(fname, open_command, job, status, event) abort
  if a:status > 0
    echohl ErrorMsg
    echo 'Failed to open ' . fnamemodify(a:fname, ':.') . ' with ' . a:open_command
    echohl None
  endif
endfunction

function! os#open_file(fname) abort
  let s:open_command = os#get_open_command()

  if !executable(s:open_command)
    echohl ErrorMsg
    echo 'The program ' . s:open_command . ' is not executable'
    echohl None
    return
  endif

  call jobstart(s:open_command . ' ' . shellescape(a:fname), {
        \ 'on_exit': function('s:HandleOpenFileError', [a:fname, s:open_command])
        \ })
endfunction

function! os#open_file_under_cursor(is_visual_mode) abort
  if &ft ==? 'dirvish'
    let s:fname = getline('.')
  elseif a:is_visual_mode
    let s:fname = utils#get_visual_selection()
  else
    let s:fname = expand('<cfile>')
  endif

  call os#open_file(s:fname)
endfunction
