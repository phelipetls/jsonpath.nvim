"{{{ indentation

setlocal softtabstop=2 shiftwidth=2

"}}}
"{{{ completion

let b:vsc_completion_command = "\<C-x>\<C-o>"

"}}}
"{{{ formatter

setlocal formatprg=prettier\ --parser=css

"}}}
"{{{ text objects

" css rule text object
" --------------------
function! SelectInnerCssRule()
  if getline(".") =~ "{$"
    norm v%
  else
    norm va%o^
  endif
endfunction

xmap ic :<C-u>call SelectInnerCssRule()<CR>
omap ic :<C-u>normal vic<CR>

function! SelectAroundCssRule()
  if getline(".") =~ "{$"
    norm 0v%
  else
    norm va%o0
  endif
endfunction

xmap ac :<C-u>call SelectAroundCssRule()<CR>
omap ac :<C-u>normal vic<CR>

" css property text object
" --------------------
xnoremap ip :<C-u>normal ^vf:<CR>
onoremap ip :<C-u>normal vip<CR>

" css value text object
" --------------------
xnoremap iv :<C-u>normal ^f:wvt;<CR>
onoremap iv :<C-u>normal viv<CR>

"}}}
