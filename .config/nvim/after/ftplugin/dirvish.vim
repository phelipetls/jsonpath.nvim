nnoremap <silent><buffer>
        \ gh :silent keeppatterns g@\v/\.[^\/]+/?$@d _<cr>:setl cole=3<cr>

nmap <silent><buffer> st :call dirvishUtils#Sort("t")<CR>

nmap <silent><buffer> % :lua require'dirvish_utils'.create_file()<CR>
nmap <silent><nowait><buffer> d :lua require'dirvish_utils'.create_dir()<CR>
nmap <silent><buffer> D :lua require'dirvish_utils'.delete()<CR>
nmap <silent><buffer> R :lua require'dirvish_utils'.rename()<CR>
nmap <silent><buffer> pp :lua require'dirvish_utils'.move()<CR>
nmap <silent><buffer> X :lua require'dirvish_utils'.clear_arglist()<CR>
