let s:DEFAULT_LS_FLAGS = "--directory --indicator-style=slash"

function! dirvishUtils#Sort(flag) abort
  if &filetype != "dirvish" || !executable("ls")
    return
  endif
  let dir = shellescape(expand("%:h"))
  let cmd = printf("ls %s -%s %s/*", s:DEFAULT_LS_FLAGS, a:flag, dir)
  execute printf("%%!%s", cmd)
endfunction

function! dirvishUtils#Delete() abort
  let target = trim(getline("."))
  if confirm(printf("Delete %s?", target), "&Yes\n&No", 2) != 1
    return
  endif
  let result = delete(target, isdirectory(target) ? "d" : "")
  if result == -1
    echoerr printf("Failed to remove %s", target)
  endif
  let altfile = expand("#")
  if !isdirectory(altfile) && buflisted(target)
    exe "bd " . bufnr(target)
  endif
  Dirvish %
endfunction

function! dirvishUtils#CreateFile() abort
  let filename = input("File: ")
  if trim(filename) == ""
    return
  endif
  let filepath = expand("%") . filename
  if !executable("touch")
    return
  endif
  let output = system("touch " . filepath)
  if v:shell_error
    echoerr output
  endif
  Dirvish %
endfunction

function! dirvishUtils#CreateDir() abort
  let filename = input("Directory: ")
  if trim(filename) == ""
    return
  endif
  let filepath = expand("%") . filename
  if !executable("mkdir")
    return
  endif
  let output = system("mkdir " . filepath)
  if v:shell_error
    echoerr output
  endif
  Dirvish %
endfunction

function! dirvishUtils#Rename() abort
  let oldpath = trim(getline('.'))
  if isdirectory(oldpath)
    let oldname = fnamemodify(oldpath, ':h:t')
  else
    let oldname = fnamemodify(oldpath, ':t')
  endif
  let newname = input('Rename: ', oldname)
  if trim(newname) == "" || empty(newname) || newname == oldname
    return
  endif
  let newpath = expand("%") . newname
  let output = rename(oldpath, newpath)
  if output == -1
    echoerr "Failed to rename"
  else
    let Hook = get(g:, "AfterRenameHook")
    if !empty(Hook)
      call Hook(oldpath, newpath)
    endif
    if !isdirectory(oldpath) && buflisted(oldpath)
      exe "bd " . bufnr(oldpath)
    endif
  endif
  Dirvish %
endfunction
