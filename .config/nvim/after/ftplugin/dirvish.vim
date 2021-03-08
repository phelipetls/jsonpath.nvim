nnoremap <silent><buffer>
        \ gh :silent keeppatterns g@\v/\.[^\/]+/?$@d _<cr>:setl cole=3<cr>

nmap <silent><buffer> st :call dirvishUtils#Sort("t")<CR>

nmap <silent><buffer> % :call dirvishUtils#CreateFile()<CR>
nmap <silent><nowait><buffer> d :call dirvishUtils#CreateDir()<CR>
nmap <silent><buffer> D :call dirvishUtils#Delete()<CR>
nmap <silent><buffer> R :call dirvishUtils#Rename()<CR>
