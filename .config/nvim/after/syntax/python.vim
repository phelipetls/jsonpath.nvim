let python_no_doctest_highlight = 1
let python_no_doctest_code_highlight = 1

syn region pythonfString matchgroup=pythonQuotes start=+[fF]\z(['"]\)+ end="\z1" skip="\\\\\|\\\z1" contains=@Spell,pythonInterpolation
syn region pythonfString matchgroup=pythonQuotes start=+[fF]\z(['"]\{3}\)+ end="\z1" skip="\\\\\|\\\z1" contains=@Spell,pythonInterpolation,pythonDoctestValue,pythonDoctest

hi def link pythonfString String

hi pythonBraces ctermfg=6
syn region pythonInterpolation contained
      \ matchgroup=SpecialChar
      \ start=/{/ end=/}/
      \ extend
      \ contains=ALLBUT,pythonDecoratorName,pythonDecorator,pythonFunction,pythonDoctestValue,pythonDoctest

hi link pythonDecorator Comment
hi link pythonDecoratorName Function
