" directories first
let g:dirvish_mode = ':sort ,^.*[\/],'

let s:DEFAULT_LS_FLAGS = "--directory --indicator-style=slash"

function! Sort(flag)
  if &filetype != "dirvish" || !executable("ls")
    return
  endif
  let dir = shellescape(expand("%:h"))
  let cmd = printf("ls %s -%s %s/*", s:DEFAULT_LS_FLAGS, a:flag, dir)
  execute printf("%%!%s", cmd)
endfunction
