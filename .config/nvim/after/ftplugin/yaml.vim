if executable("yamllint")
  compiler yamllint
endif

if expand("%:r") == ".gitlab-ci" && executable("gitlab-ci-lint")
  nnoremap <F5> :!gitlab-ci-lint %<CR>
endif
