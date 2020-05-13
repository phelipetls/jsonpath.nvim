let python_no_doctest_highlight = 1
let python_no_doctest_code_highlight = 1

hi link pythonBuiltin Identifier

syn region pythonfString matchgroup=pythonQuotes start=+[fF]\z(['"]\)+ end="\z1" skip="\\\\\|\\\z1" contains=@Spell,pythonInterpolation
syn region pythonfString matchgroup=pythonQuotes start=+[fF]\z(['"]\{3}\)+ end="\z1" skip="\\\\\|\\\z1" contains=@Spell,pythonInterpolation,pythonDoctestValue,pythonDoctest

hi def link pythonfString String

hi pythonBraces ctermfg=6
syn region pythonInterpolation contained
      \ matchgroup=Delimiter
      \ start=/{/ end=/}/
      \ extend
      \ contains=ALLBUT,pythonDecoratorName,pythonDecorator,pythonFunction,pythonDoctestValue,pythonDoctest

hi pythonInterpolation ctermfg=NONE

hi link pythonDecorator Comment
hi link pythonDecoratorName Function

" syn keyword pythonSelf self
" hi link pythonSelf Identifier

" syn match pythonAsterisks /\*\{1,2}/
" hi link pythonAsterisks SpecialChar
