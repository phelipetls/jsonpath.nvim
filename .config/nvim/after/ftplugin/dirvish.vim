" create file with %
nnoremap <buffer> % :e %

" keep folders at the top
let g:dirvish_mode = ':sort ,^.*[\/],'

nnoremap <silent><buffer>
        \ gh :silent keeppatterns g@\v/\.[^\/]+/?$@d _<cr>:setl cole=3<cr>

nnoremap <silent><buffer>
        \ gr :<C-U>Dirvish %<CR>

