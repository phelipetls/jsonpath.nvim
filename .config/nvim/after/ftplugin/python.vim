"{{{ indentation

set expandtab
set shiftwidth=4
set softtabstop=4

"}}}
"{{{ formatter

if executable("black")
  setlocal formatprg=black\ --quiet\ -\ 2>/dev/null
endif

"}}}
"{{{ code/test runners

if executable("python3")
  let filename = expand("%:p:t")
  if (filename[:3] == "test") || (filename[-4:] == "test")
    if executable("pytest") | compiler pytest | else | compiler pyunit | endif
  else
    compiler flake8
  endif
endif

if executable("python3")
  nnoremap <silent> <F5> :!python3 %<CR>
endif

"}}}
"{{{ include search

setlocal define=^\\s*\\(class\\\|def\\\)
setlocal path+=./tests,./templates,./tests/conftest.py

"}}}
"{{{ surround

let b:surround_{char2nr("p")} = "print(\r)"  " surround things with print

"}}}
"{{{ slime

command! -buffer -bang Ipy let g:slime_python_ipython = <bang>1

"}}}
"{{{ print word under cursor

nnoremap <buffer> ]<C-p> "zyiwoprint(z)<Esc>
nnoremap <buffer> [<C-p> "zyiwOprint(z)<Esc>

"}}}
