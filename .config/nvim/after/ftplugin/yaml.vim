if executable("yamllint")
  compiler yamllint
endif

if expand("%:r") == ".gitlab-ci" && executable("gitlab-ci-lint")
  nnoremap <F5> :!gitlab-ci-lint %<CR>

  function! OnStdout(_, data, __)
    let json = json_decode(join(a:data, ''))
    if json.status == 'valid'
      echomsg 'Configuration is valid'
    else
      echomsg 'Configuration is invalid!\n' .. join(json.errors, '\n')
    endif
  endfunction

  function! GitlabCILint()
    call jobstart(expandcmd("gitlab-ci-lint %"), {
        \ 'on_stdout': function("OnStdout"),
        \ 'stdout_buffered': 1
        \ })
  endfunction

  autocmd BufWritePre <buffer> call GitlabCILint()
endif
