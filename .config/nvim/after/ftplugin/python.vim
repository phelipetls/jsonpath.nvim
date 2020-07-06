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
"{{{ run

if executable("python3")
  if expand("%:p:t")[:3] == "test"
    if executable("pytest")
      compiler pytest
    else
      compiler pyunit
    endif
  else
    compiler flake8
  endif
endif

if executable("python")
  nnoremap <silent> <F5> :!python3 %<CR>
  vnoremap <silent> <F5> :!python3 %<CR>

  if executable("tmux")
    nnoremap <silent> <F11> :execute "!tmux split-window -v 'python3 -m pdb ". expand("%") ."' &"<CR>
  endif

  command! -bang Test if <bang>1 | compiler pyunit | else | compiler pyunit_dir | endif | make!

  command! Pytest compiler pytest | make!
  nnoremap <silent> <F8> :Pytest<CR>
endif

"}}}
"{{{ include search

setlocal define=^\\s*\\(class\\\|def\\\)
setlocal path+=./tests,./templates

"}}}
"{{{ abbreviations

iabbrev <buffer> pdbtrace import pdb; pdb.set_trace()
iabbrev <buffer> pdbbreak breakpoint()

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
