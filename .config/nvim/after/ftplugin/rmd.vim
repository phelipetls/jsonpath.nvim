"{{{ general config

inoremap <buffer> >> %>%
inoremap <buffer> << <-

" indentation
setlocal expandtab
setlocal tabstop=2
setlocal softtabstop=2
setlocal shiftwidth=2

" enable syntax highlighting for python also
let g:markdown_fenced_languages = ['r', 'python']
let g:rmd_fenced_languages = ['r', 'python']

let &l:keywordprg="silent !tmux send-keys -t {last} 'help(" . expand('<cword>') . ")'"

"}}}
"{{{ R

" formatter
setlocal formatprg=Rscript\ --slave\ -e\ \"formatR::tidy_source(file(\'stdin\'),arrow=T)\"

setlocal path+=~/R/x86_64-pc-linux-gnu-library/3.6/
setlocal include=library(
setlocal define=\\ze[A-z_.]\\+\\s*\\\(<-\\\\|=\\)\\s*function.*

"}}}
"{{{ compile and open pdf 

if executable("Rscript")
  " async r markdown rendering on save
  command! Compile call jobstart('Rscript -e "rmarkdown::render(' . expand("%:p:S") . ')"',
        \ {'on_exit': function('RmdExitCode')})
endif

function! RmdExitCode(job_id, data, event) dict
  if a:data > 0
    echo "Rmarkdown compiler failed"
  else
    echo "Rmarkdown compiler succeded"
  endif
endfunction

if executable("zathura")
  nmap <buffer><silent> <F5> :silent !zathura %<.pdf<CR>
endif

"}}}
"{{{ surround

let b:surround_{char2nr("r")} = "```{r}\r```"

"}}}
"{{{ movement

nnoremap <silent><buffer> ]] :call search("^```{r.*}$", "W")<CR>
nnoremap <silent><buffer> [[ :call search("^```{r.*}$", "b")<CR>

function! EvalChunk(flags)
  let l:start = search("^```{r.*}$", a:flags) + 1
  let l:end = search("^```$", "n") - 1
  execute ":".l:start.",".l:end."SlimeSend"
endfunction

nnoremap <buffer><silent> <C-c><C-c> :call EvalChunk("bcn")<CR>
nmap <buffer><silent> <C-c><C-d> <C-c><C-c>]]

"}}}
