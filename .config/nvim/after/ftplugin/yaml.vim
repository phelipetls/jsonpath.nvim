if executable("yamllint")
  compiler yamllint
endif

if expand("%:r") == ".gitlab-ci" && executable("gitlab-ci-lint")
  function! OnStdout(_, data, __)
    let json = json_decode(join(a:data, ''))
    if json.status == 'valid'
      echomsg 'Configuration is valid'
    else
      echohl WarningMsg
      echomsg join(json.errors)
      echohl None
    endif
  endfunction

  function! GitlabCILint()
    call jobstart(expandcmd("gitlab-ci-lint %"), {
        \ 'on_stdout': function("OnStdout"),
        \ 'stdout_buffered': 1
        \ })
  endfunction

  nnoremap <silent> <F5> :call GitlabCILint()<CR>
endif
