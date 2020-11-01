"{{{ indentation

setlocal softtabstop=2 shiftwidth=2

"}}}
"{{{ completion

let b:completion_command = "\<C-x>\<C-o>"

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

"}}}
"{{{ mdn

if executable("firefox")
  setlocal keywordprg=firefox\ https://developer.mozilla.org/search?topic=api\\&topic=css\\&q=\
endif

"}}}
